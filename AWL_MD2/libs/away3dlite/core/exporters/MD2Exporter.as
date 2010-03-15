package away3dlite.core.exporters
{
	import away3dlite.core.base.Object3D;
	import away3dlite.events.Loader3DEvent;
	import away3dlite.loaders.Loader3D;
	import away3dlite.loaders.MD2Builder;
	import away3dlite.materials.BitmapFileMaterial;
	
	import flash.events.EventDispatcher;
	
    public class MD2Exporter extends EventDispatcher
    {
        public function MD2Exporter(object3D:Object3D)
        {
        	parse(object3D);
        }
        
        private function parse(object3D:Object3D):void
        {
        	var md2:MD2Builder = new MD2Builder(object3D);
			md2.scaling = 5;
			md2.material = new BitmapFileMaterial("assets/yellow.jpg");
			
			var loader:Loader3D = new Loader3D();
			loader.addEventListener(Loader3DEvent.LOAD_SUCCESS, onSuccess);
			loader.loadGeometry("assets/box.md2", md2);
        }
        
        private function onSuccess(event:Loader3DEvent):void
		{
			dispatchEvent(new Loader3DEvent(Loader3DEvent.LOAD_SUCCESS, event.target as Loader3D));
		}
    }
}