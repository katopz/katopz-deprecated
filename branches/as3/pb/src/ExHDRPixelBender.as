package {
	import flash.display.Bitmap;
	import flash.display.BlendMode;
	import flash.display.Shader;
	import flash.display.Sprite;
	import flash.filters.BlurFilter;
	import flash.filters.ShaderFilter;
	
	[SWF(backgroundColor="#999999", frameRate="30", width="640", height="480")]
	public class ExHDRPixelBender extends Sprite
	{
    	//pixel bender filter for HDR effect
    	[Embed(source="../pbj/BloomBrightness.pbj", mimeType="application/octet-stream")]
		private var BloomBrightness:Class;
		
		[Embed(source="assets/earth.jpg")]
		private var HubTexture:Class;
		
		public function ExHDRPixelBender()
		{
            //add filters
            var bloomShader:Shader = new Shader(new BloomBrightness());
            bloomShader.data.threshold.value = [0.99];
            bloomShader.data.exposure.value = [1];
            
            var hubBMP:Bitmap = Bitmap(new HubTexture());
            addChild(hubBMP);
            
			var bloomFilter:ShaderFilter = new ShaderFilter(bloomShader);
			var bloomBitmap:Bitmap = new HubTexture();
			bloomBitmap.filters = [bloomFilter, new BlurFilter(20, 20, 3)];
			bloomBitmap.blendMode = BlendMode.ADD;
			addChild(bloomBitmap);
		}
	}
}
