package com.cutecoma.playground.core
{
	import com.cutecoma.game.core.IEngine3D;
	import com.cutecoma.playground.data.AreaData;
	import com.sleepydesign.net.LoaderUtil;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.utils.ByteArray;
	import flash.utils.IExternalizable;
	
	public class World
	{
		protected var _engine3D:IEngine3D;
		
		protected var area:Area;
		
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
			LoaderUtil.loadBinary(uri, onAreaLoad);
		}
		
		protected function onAreaLoad(event:Event):void
		{
			var areaData:AreaData;
			if (event.type == "complete")
				readArea(event.target.data);
			else if (event.type == IOErrorEvent.IO_ERROR)
				newArea();
		}
		
		protected function newArea():void
		{
			// new area
			var areaData:AreaData = new AreaData(area.data.id, area.data.id + "_bg.swf", 40, 40);
			//TODEV//SDApplication.getInstance()["gotoArea"](areaData);
		}
		
		protected function readArea(rawAreaData:ByteArray):void
		{
			if (!rawAreaData)
				return;
			
			var areaData:AreaData = new AreaData();
			IExternalizable(areaData).readExternal(rawAreaData);
			updateArea(areaData);
			//SDApplication.getInstance()["gotoArea"](areaData);
		}
		
		protected function updateArea(areaData:AreaData):void
		{
			if(!area)
				area = new Area(_engine3D, areaData);
			else
				area.update(areaData);
		}
	}
}