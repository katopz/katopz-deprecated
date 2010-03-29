package
{
	import away3dlite.core.utils.Debug;
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

		// TODO : add women
		private var _currentPath:String = "chars/man/";

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

		private var collada:XML;

		private function buildFromXML(xmlData:XML):void
		{
			//
			_loaders = new SDGroup();
			_xmls = new SDGroup();
			_models = new SDGroup();

			// get total 
			_totalModel = xmlData.man.length();
			_loadedModel = 0;

			for each (var _node:XML in xmlData.man)
			{
				var _id:String = _node.@id.toString();
				var _path:String = _node.@path.toString();
				var _src:String = _node.@src.toString();

				_loaders.addItem(LoaderUtil.loadXML(_path + _src, onLoadXML), _id);
			}
		}

		private function onLoadXML(event:Event):void
		{
			if (event.type != "complete")
				return;

			_loadedModel++;

			var _loader:URLLoader = event.target as URLLoader;
			var _id:String = _loaders.getItemByValue(_loader);

			_xmls.addItem(event.target.data, _id);

			if (_loadedModel == _totalModel)
			{
				for (_id in _xmls.items)
				{
					var _xml:XML = _xmls.getItem(_id);
					var _loader3D:Loader3D = parseXML(_xml, _id);
					_models.addItem(new ModelData(_id, _xml, _loader3D, _currentPath), _loader3D);
				}

				_loaders.destroy();
				_loaders = null;

				_xmls.destroy();
				_xmls = null;

				_loadedModel = 0;
			}
		}

		private function parseXML(colladaXML:XML, id:String):Loader3D
		{
			collada = colladaXML;
			default xml namespace = collada.namespace();

			var _test:XML = colladaXML.copy();

			if (id == "man_1")
			{
				var _xml1:XML = _xmls.getItem("man_1");
				var _xml2:XML = _xmls.getItem("man_2");

				_test = _xml1.copy();

				// replace mesh
				var _geometrys1:XMLList = _test.library_geometries.geometry;
				var _geometrys2:XMLList = _xml2.library_geometries.geometry;

				_geometrys1[3] = _geometrys2[3];

				// replace material
				var _images1:XMLList = _test.library_images.image;
				var _images2:XMLList = _xml2.library_images.image;
				
				_images1[3] = _images2[3];

				// replace controller
				/*
				var _controller1:XMLList = _test.library_controllers.controller;
				var _controller2:XMLList = _xml2.library_controllers.controller;
				
				_controller1[3] = _controller2[3];
				*/
				
				// try parse collada
				var _collada:Collada = new Collada();
				_collada.bothsides = false;
				_collada.scaling = 10;

				var _loader3D:Loader3D = new Loader3D();
				_loader3D.parseXML(_test, _collada, _currentPath);
				_loader3D.addEventListener(Loader3DEvent.LOAD_SUCCESS, onSuccess);

				return _loader3D;
			}
			else
			{
				return null;
			}
		}

		private function onSuccess(event:Loader3DEvent):void
		{
			var _loader3D:Loader3D = Loader3D(event.target);

			var _modelData:ModelData = _models.getItem(_loader3D);
			_modelData.model = _loader3D.handle;

			if (++_loadedModel == _totalModel)
			{

			}
			else
			{
				trace(" ! Complete!");
				signal.dispatch(_modelData);
			}
		}
	}
}