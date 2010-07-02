package com.cutecoma.playground.core
{
	import com.adobe.images.PNGEncoder;
	import com.cutecoma.game.core.*;
	import com.cutecoma.game.data.*;
	import com.cutecoma.playground.core.*;
	import com.cutecoma.playground.data.*;
	import com.cutecoma.playground.events.AreaEditorEvent;
	import com.sleepydesign.components.*;
	import com.sleepydesign.events.*;
	import com.sleepydesign.net.FileUtil;
	import com.sleepydesign.net.LoaderUtil;
	import com.sleepydesign.system.SystemUtil;
	import com.sleepydesign.utils.*;

	import flash.display.*;
	import flash.events.*;
	import flash.filters.*;
	import flash.ui.ContextMenuItem;
	import flash.utils.*;

	import org.osflash.signals.Signal;

	public class World
	{
		protected var _engine3D:IEngine3D;

		protected var _area:Area;
		public var areaPath:String = "";

		public function get area():Area
		{
			return _area;
		}

		public var completeSignal:Signal = new Signal(AreaData);

		public var areaCompleteSignal:Signal = new Signal(AreaData);

		public function World(engine3D:IEngine3D)
		{
			_engine3D = engine3D;

			_area = new Area(_engine3D, areaPath);
		}

		public function gotoAreaID(id:String):void
		{
			//LoaderUtil.load(_world.areaPath + id + ".ara", onAreaLoad);
			openArea(id + ".ara");
		}

		public function openArea(uri:String):void
		{
			LoaderUtil.loadBinary(areaPath + uri, onAreaLoad);
		}

		private var _areaData:AreaData;

		private var isInit:Boolean = false;

		protected function onAreaLoad(event:Event):void
		{
			if (event.type == "complete")
			{
				IExternalizable(_areaData = new AreaData).readExternal(event.target.data);
				updateArea();
			}
			else if (event.type == IOErrorEvent.IO_ERROR)
			{
				_areaData = new AreaData(_area.data.id, _area.data.id + "_bg.swf", 40, 40);
				updateArea();
			}
		}

		protected function updateArea():void
		{
			_area.update(_areaData);
			if (!isInit)
			{
				isInit = true;
				completeSignal.dispatch(_areaData);
			}
			areaCompleteSignal.dispatch(_areaData);
		}
	}
}