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
	
	// 2nd render engine for flat phong
	public class EngineFaceBasedRender extends Shape
	{
		public var matrix:Matrix3D;

		private var _vertexOnWorld:Vector.<Number>=new Vector.<Number>();
		private var _vout:Vector.<Number>=new Vector.<Number>();

		private var _projector:PerspectiveProjection;
		private var _projectionMatrix:Matrix3D;
		private var _matrixStac:Vector.<Matrix3D>;

		function EngineFaceBasedRender(focus:Number=300)
		{
			_projector=new PerspectiveProjection();
			_matrixStac=new Vector.<Matrix3D>();
			initialize(focus);
		}

		public function initialize(focus:Number):EngineFaceBasedRender
		{
			_projector.focalLength=focus;
			_projectionMatrix=_projector.toMatrix3D();
			matrix=new Matrix3D();
			_matrixStac.length=1;
			_matrixStac[0]=matrix;
			return this;
		}

		public function clearMatrix():EngineFaceBasedRender
		{
			matrix=_matrixStac[0];
			_matrixStac.length=1;
			return this;
		}

		public function pushMatrix():EngineFaceBasedRender
		{
			_matrixStac.push(matrix.clone());
			return this;
		}

		public function popMatrix():EngineFaceBasedRender
		{
			if (_matrixStac.length == 1)
				return this;
			matrix=_matrixStac.pop();
			return this;
		}

		public function project(model:Model):EngineFaceBasedRender
		{
			var i0x3:int, i1x3:int, i2x3:int, x01:Number, x02:Number, y01:Number, y02:Number, z01:Number, z02:Number;
			matrix.transformVectors(model.vertices, _vertexOnWorld);
			var vertices:Vector.<Number>=_vertexOnWorld;
			for each (var face:Face in model.faces)
			{
				i0x3=(face.i0 << 1) + face.i0;
				i1x3=(face.i1 << 1) + face.i1;
				i2x3=(face.i2 << 1) + face.i2;
				x01=vertices[i1x3] - vertices[i0x3];
				x02=vertices[i2x3] - vertices[i0x3];
				i0x3++;
				i1x3++;
				i2x3++;
				y01=vertices[i1x3] - vertices[i0x3];
				y02=vertices[i2x3] - vertices[i0x3];
				i0x3++;
				i1x3++;
				i2x3++;
				z01=vertices[i1x3] - vertices[i0x3];
				z02=vertices[i2x3] - vertices[i0x3];
				face.z=vertices[i0x3] + vertices[i1x3] + vertices[i2x3];
				face.normal.x=y01 * z02 - y02 * z01;
				face.normal.y=z01 * x02 - z02 * x01;
				face.normal.z=x01 * y02 - x02 * y01;
				face.normal.normalize();
			}
			model.faces.sort(function(f1:Face, f2:Face):Number
				{
					return f2.z - f1.z;
				});
			return this;
		}

		public function render(model:Model, light:Light, material:*, type:String="phong"):EngineFaceBasedRender
		{
			Utils3D.projectVectors(_projectionMatrix, _vertexOnWorld, _vout, model.texCoord);
			graphics.clear();
			if (type == "flat")
			{
				for each (var face:Face in model.faces)
				{
					graphics.beginFill(material.getColor(light, face.normal), material.alpha);
					graphics.moveTo(_vout[face.i0 << 1], _vout[(face.i0 << 1) + 1]);
					graphics.lineTo(_vout[face.i1 << 1], _vout[(face.i1 << 1) + 1]);
					graphics.lineTo(_vout[face.i2 << 1], _vout[(face.i2 << 1) + 1]);
					graphics.endFill();
				}
			}
			else
			{
				graphics.beginBitmapFill(material, null, false, true);
				graphics.drawTriangles(_vout, model.indices, model.texCoord);
				graphics.endFill();
			}

			return this;
		}
	}
}