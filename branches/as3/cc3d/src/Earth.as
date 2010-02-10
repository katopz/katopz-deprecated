package
{
	import com.cutecoma.engine3d.*;
	import com.cutecoma.engine3d.api.*;
	import com.cutecoma.engine3d.engine.*;
	import com.cutecoma.engine3d.ui.KeyboardInput;
	import com.cutecoma.engine3d.ui.MouseInput;
	
	import debug.Stats;
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	
	import graphics.*;
	
	import gs.*;
	
	import map.*;

	[SWF(width=720, height=400, backgroundColor=0x666666, frameRate=30)]
	public class Earth extends Sprite
	{
		private var _gFX:EarthEngine;
		private var _sky:SkyBox;
		private var _mouse:MouseInput;
		private var _earth:Planisphere;
		private var _earth2:Planisphere;
		private var _keyboard:KeyboardInput;
		private var _currentMarker:Marker;
		private var _map:Map;

		public function Earth()
		{
			_earth = new Planisphere();
			_earth2 = new Planisphere();
			_earth2.position.z = 1;
			_sky = new SkyBox();
			_map = new Map();

			stage.quality = StageQuality.MEDIUM;
			_gFX = new EarthEngine(new Viewport(stage.stageWidth, stage.stageHeight));
			addChildAt(_gFX, 0);
			_mouse = new MouseInput(this, _gFX);
			_keyboard = new KeyboardInput(this, _gFX);
			_map.addEventListener(Event.COMPLETE, mapCompleteHandler);
			addEventListener(Event.ENTER_FRAME, enterFrameHandler);

			addChild(new Stats());
		}

		private function markerClickHandler(event:Event):void
		{
			var _loc_2:* = event.target as Marker;
			var _loc_3:* = _loc_2.thumbnail.position;
			var _loc_4:* = _loc_2.thumbnail.rotation;
			var _loc_5:* = _gFX.camera;
			if (_loc_2 != _currentMarker)
			{
				_currentMarker = _loc_2;
				_mouse.disable();
				_keyboard.disable();
				TweenLite.to(_loc_5, 1, {yaw: _loc_2.longitude, pitch: -_loc_2.latitude, distance: 4.7});
				TweenLite.to(_loc_3, 1, {x: _loc_2.position.x * 4.3, y: _loc_2.position.y * 4.3, z: _loc_2.position.z * 4.3});
				TweenLite.to(_loc_4, 1, {x: _loc_2.rotation.x - Math.PI * 2});
			}
			else
			{
				_currentMarker = null;
				_mouse.enable();
				_keyboard.enable();
				TweenLite.to(_loc_3, 1, {x: _loc_2.position.x, y: _loc_2.position.y, z: _loc_2.position.z});
				TweenLite.to(_loc_4, 1, {x: _loc_2.rotation.x});
			}
		}

		private function mapCompleteHandler(event:Event):void
		{
			var _loc_2:Marker;
			for each (_loc_2 in _map.markers)
				_loc_2.addEventListener(MouseEvent.CLICK, markerClickHandler);
		}

		private function enterFrameHandler(event:Event):void
		{
			var _loc_2:Marker;
			_gFX.draw(_sky, GraphicsEngine.DRAW_STATIC);
			_gFX.draw(_earth);
			_gFX.draw(_earth2);
			for each (_loc_2 in _map.markers)
			{

				_gFX.draw(_loc_2.thumbnail);
			}
			_gFX.renderFrame();
		}

		private function logoCompleteHandler(event:Event):void
		{
			var _loc_2:* = (event.target as LoaderInfo).loader;
			_loc_2.x = stage.width - _loc_2.width;
			_loc_2.y = stage.height - _loc_2.height;
		}
	}
}