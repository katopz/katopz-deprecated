package
{
	import com.sleepydesign.display.AssetsUtil;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;

	[SWF(backgroundColor="#FFFFFF", frameRate="30", width="800", height="600")]
	public class TestAssetsUtil extends Sprite
	{
		public function TestAssetsUtil()
		{
			[Embed(source="assets/simple-authen.swf", mimeType="application/octet-stream")]
			var Assets:Class;

			/*
			// load any class
			AssetsUtil.loadDefinition(Assets).addOnce(function():void
			{
				var formClip:Class = AssetsUtil.getAsset("FormClip") as Class;
				addChild(new formClip as DisplayObject);
			});
			*/

			// load any DisplayObject
			AssetsUtil.loadDisplayObject(Assets, "FormClip").addOnce(function(displayObject:DisplayObject):void
			{
				addChild(displayObject);
			});
		}
	}
}
