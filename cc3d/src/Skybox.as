package
{
	import debug.Stats;

	import flash.events.*;
	import flash.geom.*;
	import flash.ui.*;

	import com.cutecoma.engine3d.api.texture.*;
	import com.cutecoma.engine3d.templates.*;
	import com.cutecoma.engine3d.engine.*;

	[SWF(width=720, height=400, backgroundColor=0x666666, frameRate=30)]
	public class Skybox extends CCTemplate
	{
		[Embed(source="assets/image10.jpg")]
		private var ASSET_TEXTURE_BACK:Class;

		[Embed(source="assets/image11.jpg")]
		private var ASSET_TEXTURE_DOWN:Class;

		[Embed(source="assets/image12.jpg")]
		private var ASSET_TEXTURE_FRONT:Class;

		[Embed(source="assets/image8.jpg")]
		private var ASSET_TEXTURE_LEFT:Class;

		[Embed(source="assets/image7.jpg")]
		private var ASSET_TEXTURE_RIGHT:Class;

		[Embed(source="assets/image9.jpg")]
		private var ASSET_TEXTURE_UP:Class;

		private var _SkyBox:Vector.<Sprite3D>;
		private static const LEFT:int = 3;
		private static const FRONT:int = 0;
		private static const UP:int = 4;
		private static const BACK:int = 2;
		private static const DOWN:int = 5;
		private static const SCALE:Vector3D = new Vector3D(5, 5, 5);
		private var TEXTURES:Array = [Texture.fromAsset(ASSET_TEXTURE_FRONT), Texture.fromAsset(ASSET_TEXTURE_RIGHT), Texture.fromAsset(ASSET_TEXTURE_BACK), Texture.fromAsset(ASSET_TEXTURE_LEFT), Texture.fromAsset(ASSET_TEXTURE_UP), Texture.fromAsset(ASSET_TEXTURE_DOWN)];
		private static const RIGHT:int = 1;

		public function Skybox()
		{
			_SkyBox = new Vector.<Sprite3D>(6, true);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			super();
			addChild(new Stats());
		}

		override protected function initialize():void
		{
			_SkyBox[FRONT] = new Sprite3D();
			_SkyBox[FRONT].texture = TEXTURES[FRONT];
			_SkyBox[FRONT].scale = SCALE;
			_SkyBox[FRONT].position.z = SCALE.z / 2;
			_SkyBox[FRONT].rotation.x = (-Math.PI) / 2;
			_SkyBox[RIGHT] = new Sprite3D();
			_SkyBox[RIGHT].texture = TEXTURES[RIGHT];
			_SkyBox[RIGHT].scale = SCALE;
			_SkyBox[RIGHT].position.x = SCALE.x / 2;
			_SkyBox[RIGHT].rotation.x = (-Math.PI) / 2;
			_SkyBox[RIGHT].rotation.y = Math.PI / 2;
			_SkyBox[BACK] = new Sprite3D();
			_SkyBox[BACK].texture = TEXTURES[BACK];
			_SkyBox[BACK].scale = SCALE;
			_SkyBox[BACK].position.z = (-SCALE.z) / 2;
			_SkyBox[BACK].rotation.x = (-Math.PI) / 2;
			_SkyBox[BACK].rotation.y = Math.PI;
			_SkyBox[LEFT] = new Sprite3D();
			_SkyBox[LEFT].texture = TEXTURES[LEFT];
			_SkyBox[LEFT].scale = SCALE;
			_SkyBox[LEFT].position.x = (-SCALE.x) / 2;
			_SkyBox[LEFT].rotation.x = (-Math.PI) / 2;
			_SkyBox[LEFT].rotation.y = (-Math.PI) / 2;
			_SkyBox[UP] = new Sprite3D();
			_SkyBox[UP].texture = TEXTURES[UP];
			_SkyBox[UP].scale = SCALE;
			_SkyBox[UP].position.y = SCALE.y / 2;
			_SkyBox[UP].rotation.x = Math.PI;
			//_SkyBox[UP].rotation.y = (-Math.PI) / 2;
			_SkyBox[DOWN] = new Sprite3D();
			_SkyBox[DOWN].texture = TEXTURES[DOWN];
			_SkyBox[DOWN].scale = SCALE;
			_SkyBox[DOWN].position.y = (-SCALE.y) / 2;
			//_SkyBox[DOWN].rotation.y = (-Math.PI) / 2;
		}

		override public function draw():void
		{
			var _loc_1:Sprite3D = null;
			super.draw();
			for each (_loc_1 in _SkyBox)
				gfx.draw(_loc_1, GraphicsEngine.DRAW_STATIC);
		}

		private function keyDownHandler(event:KeyboardEvent):void
		{
			var _loc_2:* = event.keyCode;
			if (_loc_2 == Keyboard.LEFT)
			{
				gfx.camera.yaw = gfx.camera.yaw + 0.01;
			}
			else if (_loc_2 == Keyboard.RIGHT)
			{
				gfx.camera.yaw = gfx.camera.yaw - 0.01;
			}
			else if (_loc_2 == Keyboard.UP)
			{
				gfx.camera.pitch = gfx.camera.pitch + 0.01;
			}
			else if (_loc_2 == Keyboard.DOWN)
			{
				gfx.camera.pitch = gfx.camera.pitch - 0.01;
			}
		}
	}
}