package
{
	import away3dlite.core.base.Object3D;
	import away3dlite.core.utils.Debug;
	import away3dlite.events.Loader3DEvent;
	import away3dlite.loaders.Loader3D;
	import away3dlite.loaders.MDJ;
	
	import com.cutecoma.playground.data.ModelData;
	import com.sleepydesign.components.SDDialog;
	import com.sleepydesign.core.SDGroup;
	import com.sleepydesign.events.RemovableEventDispatcher;
	import com.sleepydesign.net.LoaderUtil;
	
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

		private var _loader3Ds:Array;

		// complete
		public static var signalModel:Signal = new Signal(ModelData);

		public function ModelPool()
		{
		}

		public function initXML(xmlList:XMLList):void
		{
			reset();
			initModel(xmlList);
		}

		private function reset():void
		{
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
		}

		private function initModel(prototypeData:XMLList):void
		{
			_loaders = new SDGroup();
			_xmls = new SDGroup();
			_models = new SDGroup();

			// get total 
			_totalModel = prototypeData.model.length();
			_loadedModel = 0;

			_loader3Ds = [];
			for each (var _model:XML in prototypeData..model)
			{
				var _id:String = _model.@id.toString();
				var _src:String = _model.@src.toString();

				var _mdj:MDJ = new MDJ();
				_mdj.autoPlay = false;
				_mdj.scaling = 4;

				var _loader3D:Loader3D = new Loader3D();
				_loader3D.ignoreParentURL = true;
				_loader3D.addEventListener(Loader3DEvent.LOAD_SUCCESS, onSuccess);
				_loader3D.loadGeometry(_src, _mdj);

				_loader3Ds.push(_loader3D);

				_models.addItem(new ModelData(_id, _loader3D, _src.slice(0, _src.lastIndexOf("/"))), _loader3D);
			}
		}

		private function onSuccess(event:Loader3DEvent):void
		{
			var _loader3D:Loader3D = Loader3D(event.target);

			var _modelData:ModelData = _models.getItem(_loader3D);
			_modelData.model = _loader3D.handle;
			_modelData.model.visible = false;
			_modelData.model.rotationY = 180;

			if (++_loadedModel == _totalModel)
			{
				Debug.trace(" ! All Complete.");
				signalModel.dispatch(_modelData);
			}
			else
			{
				Debug.trace(" ! Complete.");
				signalModel.dispatch(_modelData);
			}
		}
	}
}