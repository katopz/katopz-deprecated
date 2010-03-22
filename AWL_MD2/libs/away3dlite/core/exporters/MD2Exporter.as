package away3dlite.core.exporters
{
	import away3dlite.animators.MovieMesh;
	import away3dlite.core.base.Object3D;
	import away3dlite.events.Loader3DEvent;
	import away3dlite.loaders.Loader3D;
	import away3dlite.loaders.MD2Builder;
	import away3dlite.materials.BitmapFileMaterial;
	
	import com.sleepydesign.net.FileUtil;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.ByteArray;

	public class MD2Exporter extends EventDispatcher
	{
		private var _md2Builder:MD2Builder;
		private var _callback:Function;
		
		public function MD2Exporter(object3D:Object3D, callback:Function)
		{
			_callback = callback;
			
			parse(object3D);
		}

		private function parse(object3D:Object3D):void
		{
			_md2Builder = new MD2Builder();
			_md2Builder.scaling = 5;
			_md2Builder.material = new BitmapFileMaterial("assets/yellow.jpg");
			_callback(_md2Builder.convert(object3D));
			/*
			var loader3D:Loader3D = new Loader3D();
			loader3D.addEventListener(Loader3DEvent.LOAD_SUCCESS, onSuccess);
			loader3D.loadGeometry("assets/tri.md2", md2);
			*/
			var _data:ByteArray = _md2Builder.export();
			FileUtil.save(_data);
			
		}

		private function onSuccess(event:Loader3DEvent):void
		{
			dispatchEvent(new Loader3DEvent(Loader3DEvent.LOAD_SUCCESS, event.target as Loader3D));
			
			trace("export...");
			
			MovieMesh(event.target.handle).bothsides = true;
			//md2.convert(event.target.handle);
			
			var _data:ByteArray = _md2Builder.export();
			FileUtil.save(_data);
		}
	}
}