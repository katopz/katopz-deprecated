package com.sleepydesign.utils
{
	import flash.display.Bitmap;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.external.ExternalInterface;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	import flash.utils.IExternalizable;
	
	public class FileUtil
	{
		public static var UPLOAD_URL:String = "http://127.0.0.1/serverside/upload.php";
		
		public static function openImageTo(container:DisplayObjectContainer):FileReference
		{
			return openImage(function onGetImage(event:Event):void{container.addChild(event.target["content"] as Bitmap).name="bitmap";});
		}
		
		public static function openImage(completeHandler:Function):FileReference
		{
			return open(["*.jpg", "*.jpeg", "*.gif", "*.png"], function (event:*):void
			{
				var loader:Loader = new Loader();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler, false, 0, true);
				try{
					//FP10 just get data
					if(event is Event)
						loader.loadBytes(event.target["data"] as ByteArray);
				}catch(e:*){
					//FP9 need to reload ;p
					if(event is DataEvent)
					{
						trace(" ! FP9 : load "+String(event["data"]));
						loader.load(new URLRequest(String(event["data"])), new LoaderContext(false, ApplicationDomain.currentDomain));
					}
				}
			});
		}
			
		public static function open(fileTypes:Array = null, completeHandler:Function=null):FileReference
		{
			fileTypes = fileTypes ? fileTypes : ["*.*"];
			
			var file:FileReference = new FileReference();
			var typeFilter:Array = [new FileFilter(fileTypes.join(",").toString(), fileTypes.join(";").toString())];
			file.addEventListener(Event.SELECT, function (event:Event):void
			{
				trace(" ^ Select : " + file.name + " | " + file.size);
				file = FileReference(event.target);
				
				if(completeHandler is Function)
					file.addEventListener(Event.COMPLETE, completeHandler);
				
				try{
					//FP10
					file["load"]();
				}catch(e:*){
					//FP9
		            var request:URLRequest = new URLRequest();
		            request.url = UPLOAD_URL;
					
					if (file.size < 200000) {
						trace(" * Uploading : "+ file.size);
						file.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA, completeHandler);
						file.upload(request);
					}else {
						trace("File is too large : "+ int(file.size/1024) +"KB");
					}
				}
			});
			
			file.browse(typeFilter);
			
			return file;
		}
		
		public static function save(data:*, defaultFileName:String = "undefined"):void
		{
			var rawBytes:ByteArray = new ByteArray();
			if(data is IExternalizable)
			{
				IExternalizable(data).writeExternal(rawBytes);
			}else{
				rawBytes = data;
			}

			var fileReference:FileReference = new FileReference();
			fileReference["save"](rawBytes, defaultFileName);
		}
	}
}