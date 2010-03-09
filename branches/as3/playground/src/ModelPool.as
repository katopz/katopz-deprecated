package
{
	import away3dlite.core.base.Object3D;
	import away3dlite.events.Loader3DEvent;
	import away3dlite.loaders.Collada;
	import away3dlite.loaders.Loader3D;
	
	import com.sleepydesign.events.RemovableEventDispatcher;
	import com.sleepydesign.utils.LoaderUtil;
	
	import flash.events.Event;
	import flash.utils.*;

	public class ModelPool extends RemovableEventDispatcher
	{
		private var _loadedModel:int = 0;
		private var _totalModel:int;
		
		public function ModelPool():void
		{
			//Debug.active = true;
		}

		public function initXML(src:String):void
		{
			LoaderUtil.loadXML(src, function(event:Event):void
				{
					if (event.type == "complete")
						buildFromXML(event.target.data)
				});
		}

		private function buildFromXML(xml:XML):void
		{
			// get total 
			_totalModel = xml.man.length();
			
			for each (var _node:XML in xml.man)
			{
				loadModel(_node.@path.toString(), _node.@src.toString());
			}
		}

		private function loadModel(_path:String, _src:String):void
		{
			LoaderUtil.loadXML(_path + _src, function(event:Event):void
			{
				if (event.type == "complete")
					pool(event.target.data, _path)
			});
		}
		
		private function pool(xml:XML, texturePath:String):void
		{
			trace("pool:" + texturePath);

			var _collada:Collada = new Collada();
			_collada.bothsides = false;

			var _loader:Loader3D = new Loader3D();
			_loader.loadXML(xml, _collada, texturePath);
			_loader.addEventListener(Loader3DEvent.LOAD_SUCCESS, onSuccess);
		}

		private function onSuccess(event:Loader3DEvent):void
		{
			var model:Object3D = Loader3D(event.target).handle;
			trace("model:" + model);
			
			if(++_loadedModel==_totalModel)
				trace("all done");
		}
	}
}