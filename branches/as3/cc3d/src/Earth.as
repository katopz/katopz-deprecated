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
		private var _GFX:EarthEngine = null;
		private var _Sky:SkyBox;
		private var _Mouse:MouseInput = null;
		private var _Earth:Planisphere;
		private var _Earth2:Planisphere;
		private var _Keyboard:KeyboardInput = null;
		private var _CurrentMarker:Marker = null;
		private var _Map:Map;

		public function Earth()
		{
			_Earth = new Planisphere();
			_Earth2 = new Planisphere();
			_Earth2.position.z = 1;
			_Sky = new SkyBox();
			_Map = new Map();

			stage.quality = StageQuality.MEDIUM;
			_GFX = new EarthEngine(new Viewport(stage.stageWidth, stage.stageHeight));
			addChildAt(_GFX, 0);
			_Mouse = new MouseInput(this, _GFX);
			_Keyboard = new KeyboardInput(this, _GFX);
			_Map.addEventListener(Event.COMPLETE, mapCompleteHandler);
			addEventListener(Event.ENTER_FRAME, enterFrameHandler);

			addChild(new Stats());
		}

		private function markerClickHandler(event:Event):void
		{
			var _loc_2:* = event.target as Marker;
			var _loc_3:* = _loc_2.thumbnail.position;
			var _loc_4:* = _loc_2.thumbnail.rotation;
			var _loc_5:* = _GFX.camera;
			if (_loc_2 != _CurrentMarker)
			{
				_CurrentMarker = _loc_2;
				_Mouse.disable();
				_Keyboard.disable();
				TweenLite.to(_loc_5, 1, {yaw: _loc_2.longitude, pitch: -_loc_2.latitude, distance: 4.7});
				TweenLite.to(_loc_3, 1, {x: _loc_2.position.x * 4.3, y: _loc_2.position.y * 4.3, z: _loc_2.position.z * 4.3});
				TweenLite.to(_loc_4, 1, {x: _loc_2.rotation.x - Math.PI * 2});
			}
			else
			{
				_CurrentMarker = null;
				_Mouse.enable();
				_Keyboard.enable();
				TweenLite.to(_loc_3, 1, {x: _loc_2.position.x, y: _loc_2.position.y, z: _loc_2.position.z});
				TweenLite.to(_loc_4, 1, {x: _loc_2.rotation.x});
			}
		}

		private function mapCompleteHandler(event:Event):void
		{
			var _loc_2:Marker = null;
			for each (_loc_2 in _Map.markers)
				_loc_2.addEventListener(MouseEvent.CLICK, markerClickHandler);
		}

		private function enterFrameHandler(event:Event):void
		{
			var _loc_2:Marker = null;
			_GFX.draw(_Sky, GraphicsEngine.DRAW_STATIC);
			_GFX.draw(_Earth);
			_GFX.draw(_Earth2);
			for each (_loc_2 in _Map.markers)
			{

				_GFX.draw(_loc_2.thumbnail);
			}
			_GFX.renderFrame();
		}

		private function logoCompleteHandler(event:Event):void
		{
			var _loc_2:* = (event.target as LoaderInfo).loader;
			_loc_2.x = stage.width - _loc_2.width;
			_loc_2.y = stage.height - _loc_2.height;
		}
	}
}