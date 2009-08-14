// forked from keim_at_Si's ABC ground
// The gradation colors are refered from psyrak's BumpyPlanet and nemu90kWw's 水平線.
// arrows or [wasd] to move, [shift/x/m] to accel.
//--------------------------------------------------------------------------------
package
{
	import com.si3d.lights.*;
	import com.si3d.materials.*;
	import com.si3d.objects.*;
	import com.si3d.render.*;
	import com.si3d.ui.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.filters.*;
	import flash.geom.*;
	
	[SWF(width='465', height='465', backgroundColor='#103860', frameRate='30')]
	public class ExABCflyer extends Sprite
	{
		private var _shape3d:Shape3D=new Shape3D();
		private var _flyer:Flyer;

		private var _key:KeyMapper;
		private var _landscape:Landscape=new Landscape(256, 256);
		private var _sky:Sky=new Sky();
		private var _base:Sprite=new Sprite();

		private var _light:Light=new Light(-1, -1, -1);

		private var _screen:BitmapData=new BitmapData(465, 465, true, 0);
		private var _mat2d:Matrix=new Matrix(1, 0, 0, 1, 232, 232);
		private var _pitch:Number, _roll:Number, _globalVel:Vector3D=new Vector3D();
		private var _homingAbility:Number=0.1;

		function ExABCflyer()
		{
			stage.scaleMode = "noScale";
			
			// keyboard mapper
			_key=new KeyMapper(stage);
			_key.map(0, 37, 65).map(1, 38, 87).map(2, 39, 68).map(3, 40, 83).map(4, 17, 90, 78).map(5, 16, 88, 77);

			// rendering engine
			_shape3d.visible=false;
			addChild(_shape3d);

			// background
			_base.x=232.5;
			_base.y=232.5;
			_landscape.rotationX=-85;
			_landscape.scaleX=10;
			_landscape.scaleY=8;
			_landscape.x=-1024 - _base.x;
			_landscape.y=280 - _base.y;
			_landscape.z=1800;
			_sky.scaleX=5;
			_sky.scaleY=5;
			_sky.x=-1520 - _base.x;
			_sky.y=-1400 - _base.y;
			_sky.z=1800;
			_base.addChild(_landscape);
			_base.addChild(_sky);
			addChild(_base);

			// rendering layer
			addChild(new Bitmap(_screen));

			// initialize
			_flyer=new Flyer(0, 0, 100);
			_pitch=0;
			_roll=0;

			// event listener
			addEventListener("enterFrame", _onEnterFrame);
		}

		private function _onEnterFrame(e:Event):void
		{
			// move
			var inkey:int=_key.flag;
			_roll+=((inkey & 1) - ((inkey & 4) >> 2)) * 5 - _roll * 0.1;
			_pitch+=(((inkey & 2) >> 1) - ((inkey & 8) >> 3)) * 2 - _pitch * 0.1;
			_globalVel.z+=0.5 - _globalVel.z * ((inkey & 32) ? 0.03 : 0.06);
			_globalVel.x=(_roll) * 0.1 - 0.5;
			_base.rotationX=_pitch;
			_base.rotationZ=_roll;

			// update
			_landscape.update(_globalVel);
			_flyer.update(_key);

			// rendering
			_screen.fillRect(_screen.rect, 0);
			_flyer.render(_shape3d, _screen, _light, _mat2d, _roll);
		}
	}
}