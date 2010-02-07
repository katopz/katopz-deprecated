package com.sleepydesign.utils
{
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
	
	/**
	 * @example
	 * 
	 * 	Browse image and add to container	: FileUtil.openImageTo(this);
	 * 	Browse image and trace				: FileUtil.openImage(trace);
	 * 	Browse jpg and listen				: FileUtil.open(["*.jpg"], eventHandler);
	 * 
	 * @author	katopz
	 */	
	public class FileUtil
	{
		/**
		 * Your upload path
		 */
		public static var UPLOAD_URL:String = "http://127.0.0.1/serverside/upload.php";
		
		public static const DEFAULT_ASSETS:Array = ["*.jpg", "*.jpeg", "*.gif", "*.png"];
		
		/**
		 * Limit your upload size
		 */		
		public static var UPLOAD_LIMIT:Number = 200000;
		
		public static function openXML(eventHandler:Function):FileReference
		{
			return open(["*.xml", "*.dae"], function(event:Event):void
			{
				if (event.type == Event.COMPLETE || event.type == DataEvent.UPLOAD_COMPLETE_DATA)
				{
					// complete event
					//try
					//{
						//FP10 just get data
						//LoaderUtil.loadBytes(event.target["data"], eventHandler);
						var _byte:ByteArray = event.target["data"] as ByteArray;
						eventHandler(new DataEvent(Event.COMPLETE, false, false, _byte.readUTFBytes(_byte.length)));
					//}
					/*catch (e:*)
					{
						trace(e);
						//FP9 need to reload ;p
						if (event.type == DataEvent.UPLOAD_COMPLETE_DATA)
							LoaderUtil.loadAsset(event["data"], eventHandler);
					}*/
				}
				else
				{
					// other event
					trace(" ^ event : "+event);
					eventHandler(event);
				}
			});
		}
		
		public static function openCompress(eventHandler:Function):FileReference
		{
			return open(["*.bin"], function(event:Event):void
			{
				if (event.type == Event.COMPLETE || event.type == DataEvent.UPLOAD_COMPLETE_DATA)
				{
						var _byte:ByteArray = event.target["data"] as ByteArray;
						_byte.uncompress();
						eventHandler(new DataEvent(Event.COMPLETE, false, false, _byte.readUTFBytes(_byte.length)));
				}
				else
				{
					// other event
					trace(" ^ event : "+event);
					eventHandler(event);
				}
			});
		}
		
		/**
		 * Browse image and add to container
		 * @param container
		 * @return FileReference
		 */		
		public static function openAssetTo(container:DisplayObjectContainer, filters:Array = null):FileReference
		{
			return openAsset(function onGetImage(event:Event):void
			{
				if(event.type != Event.COMPLETE)
					return;
				container.addChild(event.target["content"]);
			}, filters);
		}

		/**
		 * Browse image and listen
		 * @param eventHandler
		 * @return FileReference
		 */		
		public static function openAsset(eventHandler:Function, filters:Array = null):FileReference
		{
			return open(filters || DEFAULT_ASSETS, function(event:Event):void
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
						trace(e);
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
		
		/**
		 * Browse with any file type and listen
		 * @param eventHandler
		 * @return FileReference
		 */	
		public static function open(fileTypes:Array = null, eventHandler:Function = null):FileReference
		{
			fileTypes = fileTypes ? fileTypes : ["*.*"];
			eventHandler = eventHandler = eventHandler is Function?eventHandler:trace;

			var file:FileReference = new FileReference();
			var typeFilter:Array = [new FileFilter(fileTypes.join(",").toString(), fileTypes.join(";").toString())];
			file.addEventListener(Event.COMPLETE, eventHandler);
			file.addEventListener(Event.CANCEL, eventHandler);
			file.addEventListener(Event.SELECT, eventHandler);
			var _onCompleteFunction:Function;
			file.addEventListener(Event.SELECT, _onCompleteFunction = function(event:Event):void
			{
				trace(" ^ Select : " + file.name + " | " + file.size);
				try
				{
					//FP10
					file["load"]();
				}
				catch (e:*)
				{
					trace(e);
					//FP9
					var request:URLRequest = new URLRequest();
					request.url = UPLOAD_URL;

					if (file.size < UPLOAD_LIMIT)
					{
						trace(" * Uploading : " + file.size);
						file.addEventListener(Event.CANCEL, eventHandler);
						file.addEventListener(HTTPStatusEvent.HTTP_STATUS, eventHandler);
						file.addEventListener(IOErrorEvent.IO_ERROR, eventHandler);
						file.addEventListener(Event.OPEN, eventHandler);
						file.addEventListener(ProgressEvent.PROGRESS, eventHandler);
						file.addEventListener(SecurityErrorEvent.SECURITY_ERROR, eventHandler);
						file.addEventListener(Event.SELECT, eventHandler);
						file.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA, eventHandler);
						
						// TODO : gc

						file.upload(request);
					}
					else
					{
						trace("File is too large : " + int(file.size / 1024) + "KB");
					}
				}
			});
			
			//gc
			file.addEventListener(Event.COMPLETE, function(event:Event):void
			{
				file.removeEventListener(Event.COMPLETE, eventHandler);
				file.removeEventListener(Event.CANCEL, eventHandler);
				file.removeEventListener(Event.SELECT, eventHandler);
				
				file.removeEventListener(Event.SELECT, _onCompleteFunction);
			});

			file.browse(typeFilter);

			return file;
		}

		/**
		 * Save image to local
		 * @param eventHandler
		 * @return FileReference
		 */	
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
		
		public static function saveCompress(data:*, defaultFileName:String = "undefined"):void
		{
			var rawBytes:ByteArray = new ByteArray();
			rawBytes.writeUTFBytes(data);
			rawBytes.compress();
			
			save(rawBytes, defaultFileName);
		}
	}
}