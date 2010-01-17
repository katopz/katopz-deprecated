package
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	
	import net.badimon.five3D.display.Bitmap3D;
	import net.badimon.five3D.display.Sprite3D;
	import net.badimon.five3D.templates.Five3DTemplate;

	[SWF(width="1132", height="654", frameRate="30", backgroundColor="#000000")]
	public class TestEffect extends Five3DTemplate
	{
		// assets
		[Embed(source="assets/ThaiMap.swf",symbol="ThaiMap")]
		private static var ThaiMapSWF:Class;
		private static var _mapSprite:Sprite = new ThaiMapSWF() as Sprite;
		
		private var _canvas3D:Sprite3D;
		private var _mapCanvas3D:Sprite3D;
		
		private var _mapBitmapData:BitmapData;
		private var _mapBitmap3D:Bitmap3D;

		override protected function onInit():void
		{
			_canvas3D = new Sprite3D();
			_scene.addChild(_canvas3D);
			_canvas3D.singleSided = true;
			_canvas3D.mouseEnabled = false;
			_canvas3D.x = -50;
			_canvas3D.y = 0;
			_canvas3D.z = 830;
			_canvas3D.rotationX = -60;
			
			_mapCanvas3D = new Sprite3D();
			_mapCanvas3D.singleSided = true;
			_mapCanvas3D.mouseEnabled = false;
			
			_mapBitmapData = new BitmapData(_mapSprite.width, _mapSprite.height, true, 0x000000);
			_mapBitmapData.draw(_mapSprite);
			
			_mapBitmap3D = new Bitmap3D(_mapBitmapData, true);
			_mapBitmap3D.x = -_mapBitmapData.width/2;
			_mapBitmap3D.y = -_mapBitmapData.height/2;
			_mapBitmap3D.singleSided = true;
			_mapCanvas3D.addChild(_mapBitmap3D);
			_canvas3D.addChild(_mapCanvas3D);
		}
		
		override protected function onPreRender():void
		{
			_mapCanvas3D.rotationZ++;
		}
	}
}