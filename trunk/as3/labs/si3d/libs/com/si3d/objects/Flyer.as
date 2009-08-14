package com.si3d.objects
{
	import com.si3d.render.*;
	
	import flash.display.*;
	import flash.geom.*;
	
	public class Flyer
	{
		private var _models:ModelManager=new ModelManager();
		
		public var p:Vector3D, v:Vector3D, a:Vector3D, mdlFlyer:Model, mdlFire:Model;
		private var _afterBurner:Boolean=false;
        
		function Flyer(x:Number, y:Number, z:Number):void
		{
			p=new Vector3D(x, y, z);
			v=new Vector3D();
			a=new Vector3D();
			mdlFlyer=_models.mdlFlyer;
			mdlFire=_models.mdlFire;
		}

		public function update(_key:*):void
		{
			var inkey:int=_key.flag;
			a.x=((inkey & 1) - ((inkey & 4) >> 2)) * 1.2;
			a.y=(((inkey & 2) >> 1) - ((inkey & 8) >> 3)) * 0.8;
			v.x=v.x * 0.8 - p.x * 0.05;
			v.y=v.y * 0.8 - p.y * 0.05;
			_afterBurner=Boolean(inkey & 32);
			p.x+=v.x + a.x * 0.5;
			p.y+=v.y + a.y * 0.5;
			v.x+=a.x;
			v.y+=a.y;
		}

		public function render(_shape3d:*, _screen:*, _light:*, _mat2d:*, _roll:*):void
		{
			_shape3d.pushMatrix().translate(p.x, p.y + 10, p.z).rotateZ(v.x * 6 - _roll * 0.5).rotateY(v.x * 3).rotateX(v.y * -4).project(mdlFlyer).renderSolid(_light);
			_screen.draw(_shape3d, _mat2d);
			var scale:Number=(_afterBurner) ? 1.7 : 1.5, length:Number=(_afterBurner) ? 1.5 : 1.0, rand:Number;
			for (var i:int=0; i < 8; ++i)
			{
				rand=scale * (0.9 + Math.random() * 0.1);
				_shape3d.pushMatrix().translate(-4.8, -0.9, -18.1 - i * length).scale(rand, rand, 1).project(mdlFire).renderTexture(_models.texFire[i]);
				_screen.draw(_shape3d, _mat2d, null, "add");
				_shape3d.popMatrix().pushMatrix().translate(4.8, -0.9, -18.1 - i * length).scale(rand, rand, 1).project(mdlFire).renderTexture(_models.texFire[i]);
				_screen.draw(_shape3d, _mat2d, null, "add");
				_shape3d.popMatrix();
			}
			_shape3d.popMatrix();
		}
		
		/*
		try Render3D and fail ;p
		public function render(_shape3d:Render3D, _screen:*, _light:*, _mat2d:*, _roll:*):void
		{
			var pmFlyer:ProjectionMesh=new ProjectionMesh(mdlFlyer);
			var pmFire:ProjectionMesh=new ProjectionMesh(mdlFire);
			
			_shape3d.push().t(p.x, p.y + 10, p.z).rz(v.x * 6 - _roll * 0.5).ry(v.x * 3).rx(v.y * -4).project(pmFlyer).renderSolid(pmFlyer,_light);
			_screen.draw(_shape3d, _mat2d);
			var scale:Number=(_afterBurner) ? 1.7 : 1.5, length:Number=(_afterBurner) ? 1.5 : 1.0, rand:Number;
			for (var i:int=0; i < 8; ++i)
			{
				rand=scale * (0.9 + Math.random() * 0.1);
				_shape3d.push().t(-4.8, -0.9, -18.1 - i * length).s(rand, rand, 1).project(pmFire).renderTexture(pmFire,_models.texFire[i]);
				_screen.draw(_shape3d, _mat2d, null, "add");
				_shape3d.pop().push().t(4.8, -0.9, -18.1 - i * length).s(rand, rand, 1).project(pmFire).renderTexture(pmFire,_models.texFire[i]);
				_screen.draw(_shape3d, _mat2d, null, "add");
				_shape3d.pop();
			}
			_shape3d.pop();
		}
		*/
	}
}