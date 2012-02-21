/**
* ...
* @author katopz@sleepydesign.com
* @version 0.1
*/

package com.sleepydesign.site
{

	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.system.*;

	import com.sleepydesign.SleepyDesign;
	import com.sleepydesign.utils.*;
	import com.sleepydesign.site.*;

	import caurina.transitions.Tweener;

	public class Content extends Sprite
	{

		var loader:Loader
		public var content;
		var context
		var url
		public var config;
		public var _this;
		public var extra;

		//var contentParent

		public function Content(iParent:Sprite = null, iName:String = null)
		{
			//if(iParent!=null)contentParent = iParent else contentParent = this

			if (iParent != null)
			{
				iParent.addChild(this);
					//contentParent = iParent;
			}

			if (iName != null)
			{
				name = iName
			}

		}

		public function create(iURL:String)
		{
			load(iURL);
		}

		public function remove()
		{
			if (content)
			{
				//SleepyDesign.log("parent : "+content.parent)
				removeChild(content);
				content = null;
			}
			//parent.removeChild(this);
		}

		/*
		public function hide(iTarget,time:Number=1) {
			Tweener.addTween(iTarget, {onStart:function(){iTarget.alpha =1;iTarget.visible = true},onComplete:function(){iTarget.visible = false}, alpha:0, time:time, delay:0});
		}

		public function show(iTarget,time:Number=1) {
			Tweener.addTween(iTarget, {onStart:function(){iTarget.alpha =0;iTarget.visible = false},onComplete:function(){iTarget.visible = true}, alpha:1, time:time, delay:0});
		}
		*/

		public function onUpdate(event:ContentEvent):void
		{
			//
		}

		//_________________________________________________________________ Content

		public function load(iURL:String)
		{

			//TODO transition
			url = iURL

			//SleepyDesign.log(" > load : "+iURL);

			loader = new Loader();

			loader.contentLoaderInfo.addEventListener(Event.INIT, onContentInit);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onContentComplete);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onContentError);

			try
			{

				//SleepyDesign.log("try : "+iURL);
				loader.load(new URLRequest(iURL));

			}
			catch (error:*)
			{

				SleepyDesign.log("catch : " + error);

			}

		}

		public function ready():void
		{
			dispatchEvent(new ContentEvent(ContentEvent.READY, this));
		}

		public function onContentInit(event:Event):void
		{
			dispatchEvent(new ContentEvent(ContentEvent.INIT, content));
		}

		public function onContentComplete(event:Event):void
		{

			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onContentComplete);

			//SleepyDesign.log(" ^ "+event.type+" : "+url);

			remove();

			content = event.target.content;
			try
			{
				content.config = config;
				content.extra = extra;
			}
			catch (e:*)
			{
				//trace(e)
			}
			addChild(content);
			/*
			trace(content.parent)
			trace(content.parent.parent)
			trace(content.parent.parent.parent)
			*/
			dispatchEvent(new ContentEvent(ContentEvent.COMPLETE, content));

		}

		public function onContentError(event:Event):void
		{
			//SleepyDesign.log("onContentError : "+event);

			loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onContentError);

			dispatchEvent(new ContentEvent(ContentEvent.ERROR, content));
		}

		//_________________________________________________________________ Config

		public function getConfig(iURL:String)
		{

			var loader:URLLoader = new URLLoader();
			var urlRequest = new URLRequest(iURL);

			loader.addEventListener(Event.COMPLETE, onConfigComplete);
			loader.load(urlRequest);

		}

		public function onConfigComplete(event:Event):void
		{

			var loader:URLLoader = event.target as URLLoader;
			var xml:XML = new XML(loader.data);

			config = xml;

			dispatchEvent(new ContentEvent(ContentEvent.GETCONFIG, content));
		}

		//_________________________________________________________________ Transition

		public function hide(time:Number = 0.5)
		{
			Tweener.addTween(this, {onComplete: function()
			{
				this.visible = false
			}, alpha: 0, time: time, delay: 0, transition: "easeoutquad"});
		}

		public function show(time:Number = 0.5)
		{
			Tweener.addTween(this, {onStart: function()
			{
				this.visible = true
			}, alpha: 1, time: time, delay: 0, transition: "easeoutquad"});
		}
	}

}
