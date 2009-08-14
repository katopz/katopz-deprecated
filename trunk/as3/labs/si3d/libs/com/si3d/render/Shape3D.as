package com.si3d.render
{
	import __AS3__.vec.Vector;
	
	import com.si3d.*;
	import com.si3d.geom.*;
	import com.si3d.materials.Material;
	import com.si3d.objects.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.filters.*;
	import flash.geom.*;

	public class Shape3D extends Shape
	{
		/** model view matrix */
		public var matrix:Matrix3D;
		private var _modelProjected:Model=null;
		private var _facesProjected:Vector.<Face>=new Vector.<Face>();
		private var _vertexOnWorld:Vector.<Number>=new Vector.<Number>();
		private var _vout:Vector.<Number>=new Vector.<Number>();
		private var _projectionMatrix:Matrix3D;
		private var _matrixStac:Vector.<Matrix3D>=new Vector.<Matrix3D>();
		private var _cmdTriangle:Vector.<int>=Vector.<int>([1, 2, 2]);
		private var _cmdQuadrangle:Vector.<int>=Vector.<int>([1, 2, 2, 2]);
		private var _data:Vector.<Number>=new Vector.<Number>(8, true);

		/** constructor */
		function Shape3D(focus:Number=300)
		{
			var projector:PerspectiveProjection=new PerspectiveProjection()
			projector.focalLength=focus;
			_projectionMatrix=projector.toMatrix3D();
			matrix=new Matrix3D();
			_matrixStac.length=1;
			_matrixStac[0]=matrix;
		}

		/** push matrix */
		public function pushMatrix():Shape3D
		{
			_matrixStac.push(matrix.clone());
			return this;
		}

		/** pop matrix */
		public function popMatrix():Shape3D
		{
			matrix=(_matrixStac.length == 1) ? matrix : _matrixStac.pop();
			return this;
		}

		/** translate */
		public function translate(x:Number, y:Number, z:Number):Shape3D
		{
			matrix.prependTranslation(x, y, z);
			return this;
		}

		/** scale */
		public function scale(x:Number, y:Number, z:Number):Shape3D
		{
			matrix.prependScale(x, y, z);
			return this;
		}

		/** rotate */
		public function rotate(angle:Number, axis:Vector3D):Shape3D
		{
			matrix.prependRotation(angle, axis);
			return this;
		}

		public function rotateX(angle:Number):Shape3D
		{
			matrix.prependRotation(angle, Vector3D.X_AXIS);
			return this;
		}

		public function rotateY(angle:Number):Shape3D
		{
			matrix.prependRotation(angle, Vector3D.Y_AXIS);
			return this;
		}

		public function rotateZ(angle:Number):Shape3D
		{
			matrix.prependRotation(angle, Vector3D.Z_AXIS);
			return this;
		}

		/** project */
		public function project(model:Model):Shape3D
		{
			var i0x3:int, i1x3:int, i2x3:int, x01:Number, x02:Number, y01:Number, y02:Number, z01:Number, z02:Number, viewx:Number, viewy:Number, viewz:Number;
			matrix.transformVectors(model.vertices, _vertexOnWorld);
			_facesProjected.length=0;
			var vertices:Vector.<Number>=_vertexOnWorld;
			for each (var face:Face in model.faces)
			{
				i0x3=(face.i0 << 1) + face.i0;
				i1x3=(face.i1 << 1) + face.i1;
				i2x3=(face.i2 << 1) + face.i2;
				face.x=(vertices[i0x3] + vertices[i1x3] + vertices[i2x3]) * 0.333333333333;
				x01=vertices[i1x3] - vertices[i0x3];
				x02=vertices[i2x3] - vertices[i0x3];
				i0x3++;
				i1x3++;
				i2x3++;
				face.y=(vertices[i0x3] + vertices[i1x3] + vertices[i2x3]) * 0.333333333333;
				y01=vertices[i1x3] - vertices[i0x3];
				y02=vertices[i2x3] - vertices[i0x3];
				i0x3++;
				i1x3++;
				i2x3++;
				face.z=(vertices[i0x3] + vertices[i1x3] + vertices[i2x3]) * 0.333333333333;
				z01=vertices[i1x3] - vertices[i0x3];
				z02=vertices[i2x3] - vertices[i0x3];
				face.normal.z=x02 * y01 - x01 * y02;
				face.normal.x=y02 * z01 - y01 * z02;
				face.normal.y=z02 * x01 - z01 * x02;
				if (face.x * face.normal.x + face.y * face.normal.y + face.z * face.normal.z <= 0)
				{
					face.normal.normalize();
					_facesProjected.push(face);
				}
			}
			_facesProjected.sort(function(f1:Face, f2:Face):Number
				{
					return f2.z - f1.z;
				});
			_modelProjected=model;
			return this;
		}

		/** render solid */
		public function renderSolid(light:*):Shape3D
		{
			var idx:int, mat:Material, materials:*=_modelProjected.materials;
			Utils3D.projectVectors(_projectionMatrix, _vertexOnWorld, _vout, _modelProjected.texCoord);
			graphics.clear();
			for each (var face:Face in _facesProjected)
			{
				mat=materials[face.mat];
				graphics.beginFill(mat.getColor3(light, face.normal), mat.alpha);
				idx=face.i0 << 1;
				_data[0]=_vout[idx];
				idx++;
				_data[1]=_vout[idx];
				idx=face.i1 << 1;
				_data[2]=_vout[idx];
				idx++;
				_data[3]=_vout[idx];
				idx=face.i2 << 1;
				_data[4]=_vout[idx];
				idx++;
				_data[5]=_vout[idx];
				graphics.drawPath(_cmdTriangle, _data);
				graphics.endFill();
			}
			return this;
		}

		/** render with texture */
		public function renderTexture(texture:BitmapData):Shape3D
		{
			var idx:int, mat:Material;
			Utils3D.projectVectors(_projectionMatrix, _vertexOnWorld, _vout, _modelProjected.texCoord);
			graphics.clear();
			graphics.beginBitmapFill(texture, null, false, true);
			graphics.drawTriangles(_vout, _modelProjected.indices, _modelProjected.texCoord);
			graphics.endFill();
			return this;
		}
	}
}