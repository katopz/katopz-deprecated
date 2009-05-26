package open3d.materials
{
	import flash.display.Bitmap;	
	import flash.display.BitmapData;
	import flash.display.GraphicsSolidFill;
	import flash.display.GraphicsStroke;
	import flash.display.GraphicsTrianglePath;
	import flash.display.IGraphicsData;
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
		public function BitmapFileMaterial(uri:String, color:uint=0xFFFFFF, alpha:Number = 1) 
		{
			var bitmapData:BitmapData = new BitmapData(100, 100, (alpha<1), color);
			super(bitmapData);
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
			texture = Bitmap(event.target.content).bitmapData;
		}
	}
}
