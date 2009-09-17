package
{
	import away3dlite.cameras.*;
	import away3dlite.containers.*;
	import away3dlite.core.clip.*;
	import away3dlite.core.utils.*;
	import away3dlite.materials.*;
	import away3dlite.primitives.*;
	import away3dlite.templates.SkyTemplate;
	
	import flash.display.*;
	import flash.events.*;
	
	[SWF(backgroundColor="#000000", frameRate="30", quality="MEDIUM", width="800", height="600")]
	/**
	 * Example : SkyScape
	 * @author katopz
	 */
	public class ExSkyScape extends SkyTemplate
	{
		[Embed(source="assets/peterskybox2.jpg")]
    	public var SkyImage2:Class;
    	
		override protected function initMaterials():void
		{
			//material = new BitmapFileMaterial("assets/peterskybox2.jpg");
			material = new WireframeMaterial();
		}
		/*
		override protected function onInit():void
		{
			super.onInit();
			
			var segments:uint = 74;
			
			title += " : Sphere "+segments+"x"+segments+" segments"; 
			
			var sphere:Sphere = new Sphere().create(new BitmapFileMaterial("assets/earth.jpg"), 100, segments, segments);

			scene.addChild(sphere);
		}

		override protected function onPreRender():void
		{
			scene.rotationY+=Math.PI/10;
		}
		*/
	}
}