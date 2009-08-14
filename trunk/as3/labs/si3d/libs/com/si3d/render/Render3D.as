package com.si3d.render
{
	import __AS3__.vec.Vector;

	import com.si3d.geom.*;
	import com.si3d.lights.*;
	import com.si3d.materials.*;
	import com.si3d.objects.*;
	import com.si3d.ui.*;

	import flash.display.*;
	import flash.geom.*;

	// 3rd render engine : ScreenSpaceAmbientOcclusion
	public class Render3D extends Shape
	{
		/** model view matrix */
		public var matrix:Matrix3D;
		private var _projectionMatrix:Matrix3D; // projection matrix
		private var _matrixStac:Vector.<Matrix3D> = new Vector.<Matrix3D>(); // matrix stac
		private var _cmdWire:Vector.<int> = Vector.<int>([1, 2]); // commands to draw wire
		private var _cmdTriangle:Vector.<int> = Vector.<int>([1, 2, 2]); // commands to draw triangle
		private var _cmdQuadrangle:Vector.<int> = Vector.<int>([1, 2, 2, 2]); // commands to draw quadrangle
		private var _data:Vector.<Number> = new Vector.<Number>(8, true); // data to draw shape
		private var _clippingZ:Number; // clipping z value
		private var _depthMap:BitmapData = new BitmapData(256, 256, false); // texture for depth buffer rendering

		/** constructor */
		function Render3D(focus:Number = 100, clippingZ:Number = -0.1)
		{
			var projector:PerspectiveProjection = new PerspectiveProjection()
			projector.focalLength = focus;
			_projectionMatrix = projector.toMatrix3D();
			_clippingZ = -clippingZ;
			matrix = this.transform.matrix3D = new Matrix3D();
			_matrixStac.length = 1;
			_matrixStac[0] = matrix;
			var u:int, v:int;
			for (v = 0; v < 256; v++)
				for (u = 0; u < 256; u++)
					//_depthMap.setPixel(255-u, 255-v, (v<<8)|u);
					_depthMap.setPixel(255 - u, 255 - v, (u << 16) | (u << 8) | u);
		}

		// control matrix
		//--------------------------------------------------
		public function clear():Render3D
		{
			matrix = _matrixStac[0];
			_matrixStac.length = 1;
			return this;
		}

		public function push():Render3D
		{
			_matrixStac.push(matrix.clone());
			return this;
		}

		public function pop():Render3D
		{
			matrix = (_matrixStac.length == 1) ? matrix : _matrixStac.pop();
			return this;
		}

		public function id():Render3D
		{
			matrix.identity();
			return this;
		}

		public function t(x:Number, y:Number, z:Number):Render3D
		{
			matrix.prependTranslation(x, y, z);
			return this;
		}

		public function tv(v:Vector3D):Render3D
		{
			matrix.prependTranslation(v.x, v.y, v.z);
			return this;
		}

		public function s(x:Number, y:Number, z:Number):Render3D
		{
			matrix.prependScale(x, y, z);
			return this;
		}

		public function sv(v:Vector3D):Render3D
		{
			matrix.prependScale(v.x, v.y, v.z);
			return this;
		}

		public function r(angle:Number, axis:Vector3D):Render3D
		{
			matrix.prependRotation(angle, axis);
			return this;
		}

		public function rv(v:Vector3D):Render3D
		{
			matrix.prependRotation(v.w, v);
			return this;
		}

		public function rx(angle:Number):Render3D
		{
			matrix.prependRotation(angle, Vector3D.X_AXIS);
			return this;
		}

		public function ry(angle:Number):Render3D
		{
			matrix.prependRotation(angle, Vector3D.Y_AXIS);
			return this;
		}

		public function rz(angle:Number):Render3D
		{
			matrix.prependRotation(angle, Vector3D.Z_AXIS);
			return this;
		}

		public function mult(mat:Matrix3D):Render3D
		{
			matrix.prepend(mat);
			return this;
		}

		// projections
		//--------------------------------------------------
		/** project */
		public function project(mesh:ProjectionMesh):Render3D
		{
			matrix.transformVectors(mesh.base.vertices, mesh.verticesOnWorld);
			var fn:Vector3D, fnw:Vector3D, vs:Vector.<Number> = mesh.verticesOnWorld, nearZ:Number = -Number.MAX_VALUE, farZ:Number = _clippingZ, flist:Vector.<Face> = mesh.base.faces;
			var m:Vector.<Number> = matrix.rawData, m00:Number = m[0], m01:Number = m[1], m02:Number = m[2], m10:Number = m[4], m11:Number = m[5], m12:Number = m[6], m20:Number = m[8], m21:Number = m[9], m22:Number = m[10];
			mesh.facesProjected.length = 0;
			for each (var f:Face in flist)
			{
				var i0:int = (f.i0 << 1) + f.i0, i1:int = (f.i1 << 1) + f.i1, i2:int = (f.i2 << 1) + f.i2, x0:Number = vs[i0++], x1:Number = vs[i1++], x2:Number = vs[i2++], y0:Number = vs[i0++], y1:Number = vs[i1++], y2:Number = vs[i2++], z0:Number = vs[i0], z1:Number = vs[i1], z2:Number = vs[i2];
				if (z0 < _clippingZ && z1 < _clippingZ && z2 < _clippingZ)
				{
					fn = f.normal;
					fnw = mesh.normalsProjected[f.index];
					fnw.x = fn.x * m00 + fn.y * m10 + fn.z * m20;
					fnw.y = fn.x * m01 + fn.y * m11 + fn.z * m21;
					fnw.z = fn.x * m02 + fn.y * m12 + fn.z * m22;
					if (vs[f.gpi - 2] * fnw.x + vs[f.gpi - 1] * fnw.y + vs[f.gpi] * fnw.z <= 0)
					{
						if (nearZ < z0)
							nearZ = z0;
						if (nearZ < z1)
							nearZ = z1;
						if (nearZ < z2)
							nearZ = z2;
						if (farZ > z0)
							farZ = z0;
						if (farZ > z1)
							farZ = z1;
						if (farZ > z2)
							farZ = z2;
						mesh.facesProjected.push(f);
					}
				}
			}
			mesh.nearZ = nearZ;
			mesh.farZ = farZ;
			mesh.facesProjected.sort(function(f1:Face, f2:Face):Number
				{
					return vs[f1.gpi] - vs[f2.gpi];
				});
			mesh.indexDirty = true;
			mesh.screenProjected = false;
			return this;
		}

		/** project slower than transformVectors() but Vector3D.w considerable. */
		public function projectPoint3D(points:Vector.<Point3D>):Render3D
		{
			var m:Vector.<Number> = matrix.rawData, p:Point3D, m00:Number = m[0], m01:Number = m[1], m02:Number = m[2], m10:Number = m[4], m11:Number = m[5], m12:Number = m[6], m20:Number = m[8], m21:Number = m[9], m22:Number = m[10], m30:Number = m[12], m31:Number = m[13], m32:Number = m[14];
			for each (p in points)
			{
				p.world.x = p.x * m00 + p.y * m10 + p.z * m20 + p.w * m30;
				p.world.y = p.x * m01 + p.y * m11 + p.z * m21 + p.w * m31;
				p.world.z = p.x * m02 + p.y * m12 + p.z * m22 + p.w * m32;
			}
			return this;
		}

		// rendering
		//--------------------------------------------------
		/** render solid */
		public function renderSolid(mesh:ProjectionMesh, light:Light):Render3D
		{
			var idx:int, mat:Material, materials:Vector.<Material> = mesh.base.materials, vout:Vector.<Number> = mesh.verticesOnScreen;
			if (!mesh.screenProjected)
			{
				Utils3D.projectVectors(_projectionMatrix, mesh.verticesOnWorld, vout, mesh.base.texCoord);
				mesh.screenProjected = true;
			}
			graphics.clear();
			//graphics.lineStyle(1, 0xFF0000);
			for each (var face:Face in mesh.facesProjected)
			{
				mat = materials[face.mat];
				graphics.beginFill(mat.getColor(light, mesh.normalsProjected[face.index]), mat.alpha);
				idx = face.i0 << 1;
				_data[0] = vout[idx];
				idx++;
				_data[1] = vout[idx];
				idx = face.i1 << 1;
				_data[2] = vout[idx];
				idx++;
				_data[3] = vout[idx];
				idx = face.i2 << 1;
				_data[4] = vout[idx];
				idx++;
				_data[5] = vout[idx];
				if (face.i3 == -1)
				{
					graphics.drawPath(_cmdTriangle, _data);
				}
				else
				{
					graphics.drawPath(_cmdTriangle, _data);
				}
			}

			graphics.endFill();

			return this;
		}

		/** render wireframe */
		public function renderWire(mesh:ProjectionMesh, color:uint, alpha:Number = 1, width:Number = 1):Render3D
		{
			var idx:int, vout:Vector.<Number> = mesh.verticesOnScreen;
			if (!mesh.screenProjected)
			{
				Utils3D.projectVectors(_projectionMatrix, mesh.verticesOnWorld, vout, mesh.base.texCoord);
				mesh.screenProjected = true;
			}
			graphics.clear();
			graphics.lineStyle(width, color, alpha);
			for each (var wire:Wire in mesh.base.wires)
			{
				idx = wire.i0 << 1;
				_data[0] = vout[idx];
				idx++;
				_data[1] = vout[idx];
				idx = wire.i1 << 1;
				_data[2] = vout[idx];
				idx++;
				_data[3] = vout[idx];
				graphics.drawPath(_cmdWire, _data);
			}
			graphics.endFill();
			return this;
		}

		/** render with texture */
		public function renderTexture(mesh:ProjectionMesh, texture:BitmapData):Render3D
		{
			var vout:Vector.<Number> = mesh.verticesOnScreen;

			if (!mesh.screenProjected)
			{
				Utils3D.projectVectors(_projectionMatrix, mesh.verticesOnWorld, vout, mesh.base.texCoord);
				mesh.screenProjected = true;
			}

			graphics.clear();
			graphics.beginBitmapFill(texture, null, true, true);

			graphics.drawTriangles(vout, mesh.indicesProjected, mesh.base.texCoord);
			graphics.endFill();
			return this;
		}

		/** render depth buffer */
		public function renderDepth(mesh:ProjectionMesh):Render3D
		{
			var i:int, imax:int = mesh.vertexImax, nearZ:Number = (_clippingZ < mesh.nearZ) ? _clippingZ : mesh.nearZ, r:Number = 1 / (mesh.farZ - nearZ), duvt:Vector.<Number> = _depthUVT;
			duvt.length = 0;
			for (i = 2; i < imax; i += 3)
				duvt.push((mesh.verticesOnWorld[i] - nearZ) * r, 0, 0);
			Utils3D.projectVectors(_projectionMatrix, mesh.verticesOnWorld, mesh.verticesOnScreen, duvt);
			graphics.clear();
			graphics.beginBitmapFill(_depthMap, null, false, true);
			graphics.drawTriangles(mesh.verticesOnScreen, mesh.indicesProjected, duvt);
			graphics.endFill();
			return this;
		}
		private var _depthUVT:Vector.<Number> = new Vector.<Number>();
	}
}