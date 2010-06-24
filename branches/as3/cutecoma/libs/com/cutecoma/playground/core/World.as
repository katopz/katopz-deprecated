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
	
	public class World
	{
		protected var _engine3D:IEngine3D;
		
		protected var _area:Area;
		public var areaPath:String = "";

		public function get area():Area
		{
			return _area;
		}
		
		public function World(engine3D:IEngine3D)
		{
			_engine3D = engine3D;
			
			init();
		}
		
		protected function init():void
		{
			onInit();
		}
		
		protected function onInit():void
		{
			
		}
		
		public function openArea(uri:String):void
		{
			LoaderUtil.loadBinary(areaPath + uri, onAreaLoad);
		}
		
		protected function onAreaLoad(event:Event):void
		{
			var areaData:AreaData;
			if (event.type == "complete")
				readArea(event.target.data);
			else if (event.type == IOErrorEvent.IO_ERROR)
				createArea(new AreaData(_area.data.id, _area.data.id + "_bg.swf", 40, 40), areaPath);
		}
		
		public function createArea(areaData:AreaData, areaPath:String):void
		{
			_area = new Area(_engine3D, areaData, areaPath);
			//TODEV//SDApplication.getInstance()["gotoArea"](areaData);
		}
		
		protected function readArea(rawAreaData:ByteArray):void
		{
			if (!rawAreaData)
				return;
			
			var areaData:AreaData = new AreaData();
			IExternalizable(areaData).readExternal(rawAreaData);
			updateArea(areaData, areaPath);
			//SDApplication.getInstance()["gotoArea"](areaData);
		}
		
		protected function updateArea(areaData:AreaData, areaPath:String):void
		{
			if(!_area)
				createArea(areaData, areaPath);
			else
				_area.update(areaData);
		}
	}
}