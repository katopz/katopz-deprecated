package com.sleepydesign.utils
{
	import flash.display.Bitmap;
	import flash.display.DisplayObjectContainer;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.utils.IExternalizable;

	public class FileUtil
	{
		// config here
		public static var UPLOAD_URL:String = "http://127.0.0.1/serverside/upload.php";
		public static var UPLOAD_LIMIT:Number = 200000;

		public static function openImageTo(container:DisplayObjectContainer):FileReference
		{
			return openImage(function onGetImage(event:Event):void
			{
				if(event.type == Event.COMPLETE)
					container.addChild(event.target["content"] as Bitmap).name = "bitmap";
			});
		}

		public static function openImage(eventHandler:Function):FileReference
		{
			return open(["*.jpg", "*.jpeg", "*.gif", "*.png"], function(event:Event):void
			{
				if (event.type == Event.COMPLETE || event.type == DataEvent.UPLOAD_COMPLETE_DATA)
				{
					// complete event
					try
					{
						//FP10 just get data
						LoaderUtil.loadBytes(event.target["data"], eventHandler);
					}
					catch (e:*)
					{
						//FP9 need to reload ;p
						if (event.type == DataEvent.UPLOAD_COMPLETE_DATA)
							LoaderUtil.loadAsset(event["data"], eventHandler);
					}
				}
				else
				{
					// other event
					trace(" ^ event : "+event);
					eventHandler(event);
				}
			});
		}

		public static function open(fileTypes:Array = null, eventHandler:Function = null):FileReference
		{
			fileTypes = fileTypes ? fileTypes : ["*.*"];

			var file:FileReference = new FileReference();
			var typeFilter:Array = [new FileFilter(fileTypes.join(",").toString(), fileTypes.join(";").toString())];
			file.addEventListener(Event.CANCEL, eventHandler);
			file.addEventListener(Event.SELECT, function(event:Event):void
			{
				trace(" ^ Select : " + file.name + " | " + file.size);
				file = FileReference(event.target);

				if (eventHandler is Function)
					file.addEventListener(Event.COMPLETE, eventHandler, false, 0, true);

				try
				{
					//FP10
					file["load"]();
				}
				catch (e:*)
				{
					//FP9
					var request:URLRequest = new URLRequest();
					request.url = UPLOAD_URL;

					if (file.size < UPLOAD_LIMIT)
					{
						trace(" * Uploading : " + file.size);
						file.addEventListener(Event.CANCEL, eventHandler, false, 0, true);
						file.addEventListener(HTTPStatusEvent.HTTP_STATUS, eventHandler, false, 0, true);
						file.addEventListener(IOErrorEvent.IO_ERROR, eventHandler, false, 0, true);
						file.addEventListener(Event.OPEN, eventHandler, false, 0, true);
						file.addEventListener(ProgressEvent.PROGRESS, eventHandler, false, 0, true);
						file.addEventListener(SecurityErrorEvent.SECURITY_ERROR, eventHandler, false, 0, true);
						file.addEventListener(Event.SELECT, eventHandler, false, 0, true);
						file.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA, eventHandler, false, 0, true);

						file.upload(request);
					}
					else
					{
						trace("File is too large : " + int(file.size / 1024) + "KB");
					}
				}
			});

			file.browse(typeFilter);

			return file;
		}

		public static function save(data:*, defaultFileName:String = "undefined"):void
		{
			var rawBytes:ByteArray = new ByteArray();
			if (data is IExternalizable)
			{
				IExternalizable(data).writeExternal(rawBytes);
			}
			else
			{
				rawBytes = data;
			}

			var fileReference:FileReference = new FileReference();
			fileReference["save"](rawBytes, defaultFileName);
		}
	}
}