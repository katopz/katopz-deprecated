package open3d.materials
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	
	/**
	 * BitmapFileMaterial : load external image as texture
	 * @author katopz
	 */	
	public class BitmapFileMaterial extends BitmapMaterial
	{
		public function BitmapFileMaterial(uri:String, smoothed:Boolean = false, color:uint=0xFFFFFF, alpha:Number = 1, doubleSided:Boolean = false) 
		{
			var bitmapData:BitmapData = new BitmapData(100, 100, (alpha<1), 0x000000);
			super(bitmapData, smoothed, color, alpha, doubleSided);
			loadTexture(uri);
		}
		
		private function loadTexture(uri:String):void 
		{
			var textureLoader:Loader = new Loader();
			textureLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onTextureLoaded, false, 0, true);
			
			textureLoader.load(new URLRequest(uri), new LoaderContext( false, ApplicationDomain.currentDomain ));
		}
		
		private function onTextureLoaded(event:Event):void 
		{
			event.target.removeEventListener(Event.COMPLETE, onTextureLoaded);
			stroke = null;
			texture = Bitmap(event.target.content).bitmapData;
		}
	}
}
