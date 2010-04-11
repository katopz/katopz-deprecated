package
{
	import away3dlite.core.base.Object3D;
	import away3dlite.events.Loader3DEvent;
	import away3dlite.loaders.Loader3D;
	import away3dlite.loaders.MDZ;
	
	import com.cutecoma.playground.data.ModelData;
	import com.sleepydesign.components.SDDialog;
	import com.sleepydesign.core.SDGroup;
	import com.sleepydesign.events.RemovableEventDispatcher;
	import com.sleepydesign.utils.LoaderUtil;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.*;
	
	import org.osflash.signals.Signal;

	public class ModelPool extends RemovableEventDispatcher
	{
		private var _loadedModel:int = 0;
		private var _totalModel:int;

		private var _loaders:SDGroup; /*loader*/
		private var _xmls:SDGroup; /*xml*/
		private var _models:SDGroup; /*ModelData*/

		private var _currentModelType:String;
		private var _xmlData:XML;
		private var _container:Sprite;

		// complete
		public static var signal:Signal = new Signal(ModelData);
		
		public static var resetSignal:Signal = new Signal();

		public function ModelPool(container:Sprite)
		{
			//Debug.active = true;
			_container = container;
		}

		public function initXML(src:String):void
		{
			LoaderUtil.loadXML(src, function(event:Event):void
				{
					if (event.type == "complete")
						buildFromXML(event.target.data)
				});
		}

		private function buildFromXML(xmlData:XML):void
		{
			_xmlData = xmlData;
			var _menuCharactor:SDDialog = new SDDialog(<question><![CDATA[Select Charactor]]>
					<answer src="as:onSelectCharactor('man')"><![CDATA[Man]]></answer>
					<answer src="as:onSelectCharactor('woman')"><![CDATA[Women]]></answer>
				</question>, this);
			_container.addChild(_menuCharactor);
		}

		public function onSelectCharactor(action:String):void
		{
			_currentModelType = action;
			var _xmlPrototype:XML = _xmlData.prototype.(@id == _currentModelType)[0];

			// destroy
			if (_loaders)
				_loaders.destroy();

			if (_xmls)
				_xmls.destroy();

			if (_models)
			{
				for each (var _modelData:ModelData in _models.items)
				{
					_modelData.model.destroy();
					_modelData.model = null;
				}

				_models.destroy();
			}

			_loaders = null;
			_xmls = null;
			_models = null;
			
			resetSignal.dispatch();

			buildFromXML2(_xmlPrototype);
		}

		private function buildFromXML2(prototypeData:XML):void
		{
			_loaders = new SDGroup();
			_xmls = new SDGroup();
			_models = new SDGroup();

			// get total 
			_totalModel = XMLList(prototypeData.model).length();
			_loadedModel = 0;

			var _path:String = prototypeData.@path.toString();

			for each (var _model:XML in prototypeData.model)
			{
				var _id:String = _model.@id.toString();
				var _src:String = _model.@src.toString();

				var _mdz:MDZ = new MDZ();
				_mdz.autoPlay = false;
				_mdz.scaling = 5;

				var _loader3D:Loader3D = new Loader3D();
				_loader3D.addEventListener(Loader3DEvent.LOAD_SUCCESS, onSuccess);
				_loader3D.loadGeometry(_path + _src, _mdz);

				_models.addItem(new ModelData(_id, _loader3D, _path), _loader3D);
			}
		}

		private function onSuccess(event:Loader3DEvent):void
		{
			var _loader3D:Loader3D = Loader3D(event.target);

			var _modelData:ModelData = _models.getItem(_loader3D);
			_modelData.model = _loader3D.handle;

			if (++_loadedModel == _totalModel)
			{
				trace(" ! All Complete!");
				signal.dispatch(_modelData);
			}
			else
			{
				trace(" ! Complete!");
				signal.dispatch(_modelData);
			}
		}
	}
}