package
{
	import away3dlite.events.Loader3DEvent;
	import away3dlite.loaders.Loader3D;
	import away3dlite.loaders.MDZ;
	
	import com.cutecoma.playground.data.ModelData;
	import com.sleepydesign.core.SDGroup;
	import com.sleepydesign.events.RemovableEventDispatcher;
	import com.sleepydesign.utils.LoaderUtil;
	
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

				var _mdz:MDZ = new MDZ();
				_mdz.autoPlay = false;
				_mdz.scaling = 5;

				var _loader3D:Loader3D = new Loader3D();
				_loader3D.addEventListener(Loader3DEvent.LOAD_SUCCESS, onSuccess);
				_loader3D.loadGeometry(_path + _src, _mdz);

				_models.addItem(new ModelData(_id, _loader3D, _currentPath), _loader3D);
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