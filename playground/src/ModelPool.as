package
{
	import away3dlite.events.Loader3DEvent;
	import away3dlite.loaders.Collada;
	import away3dlite.loaders.Loader3D;
	
	import com.cutecoma.playground.data.ModelData;
	import com.sleepydesign.core.SDGroup;
	import com.sleepydesign.events.RemovableEventDispatcher;
	import com.sleepydesign.utils.LoaderUtil;
	
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.utils.*;
	
	import org.osflash.signals.Signal;

	public class ModelPool extends RemovableEventDispatcher
	{
		private var _loadedModel:int = 0;
		private var _totalModel:int;

		private var _loaders:SDGroup; /*loader*/
		private var _xmls:SDGroup; /*xml*/
		private var _models:SDGroup; /*ModelData*/

		// complete
		public static var signal:Signal = new Signal(ModelData);

		public function ModelPool()
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
			//
			_loaders = new SDGroup();
			_xmls = new SDGroup();
			_models = new SDGroup();

			// get total 
			_totalModel = xml.man.length();
			_loadedModel = 0;

			for each (var _node:XML in xml.man)
			{
				var _path:String = _node.@path.toString();
				var _src:String = _node.@src.toString();

				_loaders.addItem(LoaderUtil.loadXML(_path + _src, onLoadXML), _path);
			}
		}

		private function onLoadXML(event:Event):void
		{
			if (event.type != "complete")
				return;

			_loadedModel++;

			var _loader:URLLoader = event.target as URLLoader;
			var _path:String = _loaders.getItemByValue(_loader);

			_xmls.addItem(event.target.data, _path)

			if (_loadedModel == _totalModel)
			{
				for (_path in _xmls.items)
				{
					var _xml:XML = _xmls.getItem(_path);
					var _loader3D:Loader3D = parseXML(_xml, _path);
					_models.addItem(new ModelData(_path, _xml, _loader3D, _path), _loader3D);
				}
				
				_loaders.destroy();
				_loaders = null;
				
				_xmls.destroy();
				_xmls = null;
				
				_loadedModel = 0;
			}
		}

		private function parseXML(xml:XML, path:String):Loader3D
		{
			var _collada:Collada = new Collada();
			_collada.bothsides = false;

			var _loader3D:Loader3D = new Loader3D();
			_loader3D.loadXML(xml, _collada, path);
			_loader3D.addEventListener(Loader3DEvent.LOAD_SUCCESS, onSuccess);

			return _loader3D;
		}

		private function onSuccess(event:Loader3DEvent):void
		{
			var _loader3D:Loader3D = Loader3D(event.target);

			var _modelData:ModelData = _models.getItem(_loader3D);
			_modelData.model = _loader3D.handle;

			if (++_loadedModel == _totalModel)
			{
				trace(" ! Complete!");
				signal.dispatch(_modelData);
			}
		}
	}
}