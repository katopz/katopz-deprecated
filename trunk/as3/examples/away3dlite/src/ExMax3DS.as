package
{
	import away3dlite.core.base.*;
	import away3dlite.events.*;
	import away3dlite.loaders.*;
	import away3dlite.templates.*;
	
	import flash.display.*;

	[SWF(backgroundColor="#000000", frameRate="60", quality="MEDIUM", width="800", height="600")]

	/**
	 * Metasequoia example.
	 */
	public class ExMax3DS extends BasicTemplate
	{
		override protected function onInit():void
		{
			var max:Max3DS = new Max3DS();
			max.scaling = 20;
			
			var loader:Loader3D = new Loader3D();
			loader.loadGeometry("pueblo_store-3.3DS", max);
			scene.addChild(loader);
		}
		
		override protected function onPreRender():void
		{
			scene.rotationY+=.2;
		}
	}
}