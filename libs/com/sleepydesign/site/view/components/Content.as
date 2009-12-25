package com.sleepydesign.site.view.components
{
	import com.greensock.plugins.AutoAlphaPlugin;
	import com.greensock.plugins.FramePlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.sleepydesign.application.core.SDApplication;
	import com.sleepydesign.core.SDContainer;
	import com.sleepydesign.core.SDForm;
	import com.sleepydesign.core.SDGroup;
	import com.sleepydesign.events.SDEvent;
	import com.sleepydesign.site.model.vo.ContentVO;
	import com.sleepydesign.utils.DataUtil;
	import com.sleepydesign.utils.LoaderUtil;
	import com.sleepydesign.utils.ProxyUtil;
	import com.sleepydesign.utils.StringUtil;
	import com.sleepydesign.utils.SystemUtil;
	import com.sleepydesign.utils.URLUtil;
	import com.sleepydesign.utils.XMLUtil;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLVariables;
	import flash.text.TextField;
	import flash.utils.*;
	
	/* ---------------------------------------------------------------
	
	[Content] ( id, source, xml ) : act like file please :P
		+ content : defined object, core object
	
	* parse
		1. init : prepare abstract content, collection
		2. parse : build from internal/external
		3. create : publish from internal/external
		4. destroy : remove from stage and collection

	
	--------------------------------------------------------------- */
	
	/**
	 * 1. Suppose to 've id for referer
	 * 2. Configurable by <content id="contentID" src="source" type="contentType"/>
	 * 
	 * @author Todsaporn.Banjerdkit
	 * 
	 */
	public class Content extends SDContainer
	{
		protected var _clip:MovieClip;
		
		public var content:DisplayObject;
		
		protected var configURI:String;
		protected var dataURI:String;
		
		//protected var loader:SDLoader;
		
		protected var links:SDGroup;
		
		protected var type:String;
		
		protected var _source:String;
		
		protected var destroyable:Boolean = true;
		
		protected var dirty:Boolean = true;
		
		/**
		 * 
		 * @param id	Need for collector, all content need name 
		 * @param xml	Need for parse content config also element
		 * 
		 */		
		public function Content(id:String=null, source:*=null, xml:XML=null)
		{
			TweenPlugin.activate([FramePlugin, AutoAlphaPlugin]);
			
			trace(" ! source\t: "+ source);
			// loader for load external assete only!
			//loader = SDApplication.getLoader();
			super( id );
			
			// autorun
			if(source)
			{
				trace(" ! Autorun\t: "+ source);
				if(source is DisplayObject)
				{
					if(!source.parent)
						addChild(source);
					content = source;
				}
					
				update(new ContentVO(id, source, xml));
			}
			
			// dependency call
			if(stage && parent==stage)
			{
				trace(" ! Dependency call : "+this)
				getConfig(configURI?configURI:SDApplication.configURI);
			}
		}
		
		// ______________________________ Data ____________________________
		
		/*
		public function getConfig(configURI:Object=null):void
		{
			//
		}
		
		public function getData(dataURI:Object=null):void
		{
			//
		}
		*/
		/*
		public function onGetXMLData(event:SDEvent):void
		{
			trace(" ^ onGetXMLData");
			event.target.removeEventListener(SDEvent.COMPLETE, onGetXMLData);
			dispatchEvent(event.clone());
			
			update(new ContentVO(xml.@id, config.source, 
		}
		*/
		
		public function getData(dataURI:String):void
		{
			if(StringUtil.isNull(dataURI))return;
			
			this.dataURI = dataURI;
			LoaderUtil.loadXML(dataURI, onGetData);
			
			//loader.load(dataURI);
			//loader.removeEventListener(SDEvent.COMPLETE, onGetData);
			//loader.addEventListener(SDEvent.COMPLETE, onGetData, false, 0, true);
		}
		
		public function getConfig(configURI:String):void
		{
			this.configURI = configURI;
			/*
			loader.load(configURI);
			loader.removeEventListener(SDEvent.COMPLETE, onGetConfig);
			loader.addEventListener(SDEvent.COMPLETE, onGetConfig, false, 0, true);
			*/
			LoaderUtil.loadXML(configURI, onGetConfigHandler);
		}
		
		// external config -> * update
		protected function onGetConfigHandler(event:Event):void
		{
			if(event.type!="complete")return;
			
			trace(" ^ onGetConfig\t : "+event);
			
			//if(!loader.isContent(configURI))return;
			
			//loader.removeEventListener(SDEvent.COMPLETE, onGetConfig);
			var xml:XML = event.target["data"];//new XML(loader.getContent(configURI));
			//trace(xml.toXMLString())

			// dependency self update data
			if(stage && parent==stage)
			{
				var _xml:XML = XMLUtil.getXMLById(xml, id);
				if(!StringUtil.isNull(_xml))xml = _xml;
			}
			
			update(new ContentVO(xml.@id, content, xml));
			
		}
		
		// form data
		protected function onLoadData(event:SDEvent):void
		{
			// TODO : global freeze+load
			visible = false;
		}
		
		/*
		protected function onFormDataComplete(event:Event):void
		{
			trace(" ^ onFormDataComplete\t:"+event);
		}
		*/

		//DataEvent.DATA came from SDForm
		protected function onGetData(event:Event):void
		{
			var _event:* = event;
			
			var xml:XML;
			if(event.type==DataEvent.DATA)
			{
				xml = new XML(event["data"]);
			}
			else if(event.type==Event.COMPLETE)
			{
				xml = event.target["data"];
				
				_event = new DataEvent(DataEvent.DATA, false, false, event.target.data);
				ProxyUtil.dispatchEvent(_event);
				
			}else{
				return;
			}
			
			trace(" ^ onGetData\t:"+_event);
			
			// Form data :P
			//if(event.target is SDForm)
			//{
				//do not remove just yet!! i still need it in case form is Flash MovieClip
				//event.target.removeEventListener(SDEvent.COMPLETE, onGetData);
				//loader.removeEventListener(SDEvent.COMPLETE, onGetData);
				
				//todo//var xml:XML = new XML(loader.getContent(dataURI));
				//var xml:XML = new XML(event["data"]);
				//trace(xml.toXMLString())
				
				if(xml.@id == id)
				{
					// it's my data let's update!
					update(new ContentVO(xml.@id, this, xml));
				}else{
					// it's not my data let's tell someone else especialy my mom
					dispatchEvent(_event);
					//dispatchEvent(new SDEvent(SDEvent.DATA, {xml:xml}));
					
					//throw to global ;(
					ProxyUtil.dispatchEvent(_event);
				}
				
				//throw to global ;(
				//ProxyUtil.dispatchEvent(event);
				
				//dispatchEvent(new SDEvent(SDEvent.DATA, {xml:xml}));
			//}
		}
		
		// ______________________________ Update ____________________________
		
		//setData????
		
		// Global 	:	Site[config.xml] -> update
		// Internal :	Self[config.xml] -> update
		
		private var _data_xml:XML;
		public function update(data:Object=null):void
		{
			// no need to update old xml data
			//if(data.xml==_data_xml)return;
			
			//parse?
			if(data.xml)
			{
				// dependency self update data
				if(parent && parent!=stage)
				{
					var xml:XML = XMLUtil.getXMLById(data.xml, data.id);
					if(!StringUtil.isNull(xml))data.xml = xml;
				}
				
				// mem last xml 
				_data_xml = data.xml;
				
				type = !StringUtil.isNull(data.xml.@type)?String(data.xml.@type):null;
				
				destroyable = !StringUtil.isNull(data.xml.@destroyable)?Boolean(String(data.xml.@destroyable)=="true"):true;
				
				if(!data.source)data.source = String(data.xml.@src);
			}

			trace("\n / [Content.update:"+id+"] --------------------------------------");
			trace(" ! Data\t\t: " + data);
			
			// ContentVO?
			//super.update(data);
			_data = data;
			
			/*
			// destroy load Queue
			for each(var uri:String in queues)
			{
				loader.remove(uri);
			}
			
			//queues = [];
			*/
			
			// Inner Elements
			if(data.xml && data.xml is XML)
			{
				// TODO : Resource Manager
				//for each(var content:XML in data.xml)
				var sourceString:String = data.xml.@src;
				
				if(URLUtil.isURL(sourceString))
				{
					// browser eh?
					URLUtil.getURL(sourceString);
				}
				else
				{
					// internal flash scope
					switch(URLUtil.getType(sourceString))
					{
						// internal : clip
						case sourceString:
							if(sourceString.length>0)
							{
								// need parent clip before parse element(s)
								if(data.source is MovieClip) 
								{	
									content = data.source;
								}
								
								if(dirty)
									initContent();
							}
							
							// bypass load = publish
							if(dirty)
								initContent();
						break;
						// external source : swf, jpg, png
						case "swf":
						case "jpg":
						case "png":
							// old sake
							if(_source == sourceString)
							{ 
								// mark as not dirty
								dirty = false;
								
								// just apply config
								initContent();
							}else{
								// mark as dirty
								dirty = true;
								
								// mem new source
								_source = sourceString;
								
								/*
								loader.add(data.source);
								
								// load
								loader.addEventListener(SDEvent.COMPLETE, onGetContent, false, 0, true);
								loader.start();
								*/
								//trace("parent:"+parent)
								//trace("stage:"+stage)
								if(stage && parent==stage)
								{
									_content = this;
									initContent();
								}else{
									LoaderUtil.loadAsset(data.source, onGetContent);
								}
							}
						break;
						// unsupported type : htm ,html, php, asp, ....
						default:
							URLUtil.getURL(String(sourceString));
						break;
					}
				}
			}else{
				// direct load
				LoaderUtil.loadAsset(data.source, onGetContent);
				//loader.addEventListener(SDEvent.COMPLETE, onGetContent, false, 0, true);
				//loader.load(data.source);
			}
			trace(" -------------------------------------- [Content.update:"+id+"] /\n");
		}
		
		protected var _content:*;
		
		protected function onGetContent(event:Event):void
		{
			if(event.type!="complete")return;
			
			_content = event.target["content"];
			
			initContent();
		}
		
		protected function initContent():void
		{
			// direct load
			if(!_data || !_data.xml)
			{
				//by pass
				trace(" ! No XML config");
				
				create(_data);
				dispatchEvent(new SDEvent(SDEvent.COMPLETE, {content:content}));
				return;
			}
			
			// create base asset
			parse(_data);
			
			// internal config element
			applyConfig();
			
			// external config
			if(_config && _config.xml && !StringUtil.isNull(_config.xml.@config))
			{
				trace(" ! External config\t: "+ _config.xml.@config);
				getConfig(_config.xml.@config);
			}else{
				dispatchEvent(new SDEvent(SDEvent.COMPLETE, {content:content}));
			}
			
			onInitContent();
			/*
			// loaded content
			try{
			//if(_content["content"] && _content["content"] is Content)
				_content["content"].onInitContent();
			}catch(e:*){trace(e)};
			*/
			//TODO:move up
			if(this.content is Content && content!= this)
				Content(content).onInitContent();
  		}
  		
  		protected function onInitContent():void
  		{

  		}
  		
  		// element(s) on stage state from SDMovieClip need parse config to element(s) 
  		protected function onContentOnStage(event:SDEvent):void	
  		{
			trace(" ! onContentOnStage");
			//if(event && event.target)
			//	event.target.removeEventListener(SDEvent.ON_STAGE, onContentOnStage);
			
			// ready from event, not manual call
			if(event)
				applyConfig();
  		}
  		
  		// element(s) on ready state from SDMovieClip need parse config to element(s) 
		protected function onContentReady(event:SDEvent=null):void	
		{
			trace(" ! onContentReady");
			if(event && event.target)
				event.target.removeEventListener(SDEvent.READY, onContentReady);
			
			// ready from event, not manual call
			if(event && _data)// && _data.xml!=_data_xml)
				applyConfig();
		}
		
		protected function applyConfig():void
		{		
			trace(" ! Content.applyConfig");
			
            if(!elements)elements = new SDGroup(id+"_elements");
			
			// apply config -> content(s)
			var xmlList:XMLList = _data.xml.children();
			for (var i:uint = 0; i < xmlList.length(); i++ )
			{
				var itemXML:XML = xmlList[i];
				var name:String = String(itemXML.name());
				var item:* = {};
				
				elements.insert(parseItem(itemXML), String(itemXML.@id) );
			}
		}
		
		// element magic
		protected function parseItem(itemXML:XML):DisplayObject
		{
			//try{
			var clip:DisplayObjectContainer;
			if(_config.source is DisplayObjectContainer)
			{
				// specified source from caller
				clip = DisplayObjectContainer(_config.source);
			}else{
				// direct export
				clip = this;
			}
			
			//export for Content
			if(clip is Content && clip["content"] && clip["content"] is DisplayObjectContainer)
				clip = clip["content"];
			
			//TODO:move up
			if(clip is Content && clip["content"] && clip["content"] is DisplayObjectContainer)
				clip = clip["content"];
				
			var child:* = clip.getChildByName(String(_data.xml.@id));
			
			try{
				// cloaked source
				if(child && child.content && child.content is DisplayObjectContainer)
					clip = child.content;
			}catch(e:*){trace(e)}
			
			var idString:String = String(itemXML.@id);
			var sourceString:String = !StringUtil.isNull(itemXML.@src)?String(itemXML.@src):idString;
			/*
			if(!StringUtil.isNull(itemXML.@alpha))
			{
				var _alpha:Number= !StringUtil.isNull(itemXML.@alpha)?Number(itemXML.@alpha):1;
			
				trace(" ! Clip\t: "+clip, idString, _alpha);
				//TweenLite.to(clip, 1, {delay:4, alphaTo:_alpha});
				clip.alpha = _alpha;
			} 
			*/
			
			trace(" ! itemXML : "+String(itemXML.name()));
			
			switch(String(itemXML.name()))
			{
				case "textfield" : //labelText
					var textfield:TextField = TextField(clip.getChildByName(sourceString));
					textfield.htmlText = itemXML.valueOf();
					return textfield;
				break;
				case "form" :
					// do not re init existing element
					if(!elements.findBy(idString))
					{
						var form:SDForm = new SDForm(sourceString, clip, itemXML);
						dataURI = form.action;
						
						//TODO:rip to 1 handler
						
						//incomplete
						form.removeEventListener(SDEvent.INCOMPLETE, onInComplete);
						form.addEventListener(SDEvent.INCOMPLETE, onInComplete);
						
						//invaild
						form.removeEventListener(SDEvent.INVALID, onInvalid);
						form.addEventListener(SDEvent.INVALID, onInvalid);
						
						//valid
						//form.removeEventListener(SDEvent.COMPLETE, onGetData);
						//form.addEventListener(SDEvent.COMPLETE, onGetData);
						
						// hide while submitting
						form.removeEventListener(SDEvent.LOAD, onLoadData);
						form.addEventListener(SDEvent.LOAD, onLoadData);
						
						//data
						form.removeEventListener(DataEvent.DATA, onGetData);
						form.addEventListener(DataEvent.DATA, onGetData);
						
						/*
						form.removeEventListener(Event.COMPLETE, onFormDataComplete);
						form.addEventListener(Event.COMPLETE, onFormDataComplete);
						*/
						
						return form;
					}
				break;
				case "button" :
					
					//Navigation.getInstance().removeEventListener(MouseEvent.CLICK, onContentClick);
					//if(!Site.getInstance().hasEventListener(MouseEvent.CLICK))
					//	Site.getInstance().addEventListener(MouseEvent.CLICK, onContentClick);
					
					removeEventListener(MouseEvent.CLICK, onContentClick);
					addEventListener(MouseEvent.CLICK, onContentClick);
					/*
					trace(itemXML.@visible);
					
					if(String(itemXML.@visible)=="false")
						clip.visible = false;
					*/
					
					/*
					if(!elements.findBy(idString))
					{
						var button:* = clip.getChildByName(sourceString) as SimpleButton;
						
						// TODO : deeper
						if(!button && sourceString.indexOf(".")>-1)
						{
							//trace("-------------------------------");
							var sourceStrings:Array = sourceString.split(".");
							//trace(clip);
							var buttonParent:DisplayObjectContainer = DisplayObjectContainer(clip.getChildByName(sourceStrings[0])); 
							button = SimpleButton(clip.getChildByName(sourceStrings[1]));
							//trace("button:"+button);
							//trace("-------------------------------");
						}
						
						if(!button)
						{
							button = MovieClip(clip.getChildByName(sourceString));
						}
						
						if(button)
						{
							button.removeEventListener(MouseEvent.CLICK, onButtonClick);
							button.addEventListener(MouseEvent.CLICK, onButtonClick);
							
							button.removeEventListener(MouseEvent.ROLL_OVER, onMouseRollOver);
							button.addEventListener(MouseEvent.ROLL_OVER, onMouseRollOver);
							
							if(!links)links = new SDGroup();
							links.insert(itemXML, button);
							return button;
						}
					}*/
				break;
				case "asset" :
					if(!elements.findBy(idString))
					{
						var asset:DisplayObject = clip.getChildByName(sourceString);
						if(asset)
						{
							var _alpha:Number= !StringUtil.isNull(itemXML.@alpha)?Number(itemXML.@alpha):1;
							asset.alpha = _alpha;
						}
					}
				break;
			}
			//}catch(e:*){};
			return null;
		}
		
		// must parse to ContentVO 1st
		public function parse(raw:Object=null):void
		{
			//super.parse(raw);
			
			// try to parse string -> content.MovieClip
			if(_data && _data.xml)
			{
				var itemXML:XML = _data.xml;
				switch(URLUtil.getType(itemXML.@src))
				{
					// internal : source is MovieClip but itemXML.@src is String
					case String(itemXML.@src):
						
						// config.source -> MovieClip
						if(raw.source is MovieClip)
						{
							content = raw.source;
							trace(" ! Internal\t: "+ content);
						}
					break;
					// external : swf, jpg, png
					default:
						//destruction(content);
					break;
				}
			}
			
			create(raw);
		}
		
		// create element(s) in content
		override public function create(config:Object=null):void
		{
			if(!config)return;
			
			// ================================ Phase 1 : Initialize ================================
			super.create(config);
			
			//destroy
			if(content)
				content.removeEventListener(SDEvent.READY, onContentReady);
			
			// external : this content is belong to me?
		
			//if(parent && parent!=stage)
			//{
			if(stage && parent==stage)
			{
				content = _content;
				trace(" ! Internal\t: "+ content);
			}else{
				if(_content)
				{
					// only one single source allow in content layer
					// can be destroy or dirty
					if(destroyable || dirty)
					{
						kill(content);
					}
					
					content = _content//loader.getContent(_config.source);
					
					// DIRTY
					if(content is Bitmap)
						Bitmap(content).smoothing = true;
					
					// add new content
					addContent(content);
					
					// remove listener after thing created
					//loader.removeEventListener(SDEvent.COMPLETE, onGetContent);
					
					trace(" ! External\t: "+ content);
				}
			}

			// ================================ Phase 2 : Config ================================
			
			if(!content)
			{
				// bad case it's nothing
				return;
			}
			else if(content is Bitmap)
			{
				// smooth?
			}
			else if(content is MovieClip )//&& MovieClip(content).currentLabels.length>0)
			{		
				/*
				// bad boy cloak it!
				var _content_MovieClip:SDMovieClip = new SDMovieClip();//id+"_MovieClip", MovieClip(content));
				_content_MovieClip.init({id:id+"_MovieClip", source:content});
				
				// add base content
				addContent(_content_MovieClip);

				// child ON_STAGE
				content.addEventListener(SDEvent.ON_STAGE, onContentOnStage, false, 0, true);

				// got "ready" label
				if(_content_MovieClip.clip.currentLabels.length>0)
				{
					trace(" ! Labels\t: "+_content_MovieClip.clip.currentLabels.length)
					// tell me again whenever you ready
					_content_MovieClip.addEventListener(SDEvent.READY, onContentReady, false, 0, true);
				}else {
					onContentReady();
				}
				
				content = _content_MovieClip
				*/
			}
			else if(content is Content)//&& MovieClip(content).currentLabels.length>0)
			{
				/*
				content.parent.addChild(content["content"]);
				content.parent.removeChild(content);
				content = content["content"];
				*/
			}
			
			trace(" * Create\t: " + content);
			
			// ================================ Phase 3 : Transition ================================
			
			// TODO : transition = script, label, classic
			// ------------------------- TODO : inner transition -------------------------
			/*
			// hide
			if(destroyable && dirty)
			{
				content.alpha = 0;
				content.visible = false;
				//dirty = false;
			}
			
			// showable
			if(config.autoplay)
			{
				if(content is SDContainer)
				{
					// it's export as class, leave it alone
					SDContainer(content).show();
				}
				else if( content is SDMovieClip)
				{
					SDMovieClip(content).show();
				}
				else
				{
					// auto reveal
					if(!_config.alpha)_config.alpha = 1;
					TweenLite.to(content, .5, {autoAlpha:_config.alpha});
				}
			}
			*/
			dispatchEvent(new SDEvent(SDEvent.CREATE, {content:content}));
		}
		
		override public function destroy():void
		{
			//loader.removeEventListener(SDEvent.COMPLETE, onGetData);
			if(content)
				content.removeEventListener(SDEvent.READY, onContentReady);
			super.destroy();
		}
		
		/*
		protected function destroyContent():void
		{
			trace(" ! destroyContent : "+content);

			// content -> bitmap
			////cachedBitmap = GraphicUtil.getBitmap(content, false, content.getRect(content));
			////addChild(cachedBitmap);
			
			// effect -> destroy
			////TweenLite.to(cachedBitmap, 1, {autoAlpha:0, onComplete:destroy, onCompleteParams:[[cachedBitmap]]});
			
			// bye
			////removeChild(content);
			
			elements.destroy();
			
			removeChild(content);
			content = null;
		}
		*/
		
		// DIRTY
		protected function onMouseRollOver(event:MouseEvent):void
		{
			var linkXML:XML = XML(links.find(event.target));
			
			// 2nd try
			if(StringUtil.isNull(linkXML.@link))
				 linkXML = XML(links.find(event.currentTarget))
				 
			if(!StringUtil.isNull(linkXML.@onRollOver))
			{
				//URLUtil.getURL(linkXML.@href, linkXML.@target);
				Navigation.getURL(linkXML.@id, linkXML.@onRollOver, "_self");
			}
		}
		
		protected function onContentClick(event:MouseEvent):void
		{
			trace(" ! onContentClick : " + this, ":", event.target.name);
			
			/*
			trace("this:"+this);
			trace("target:"+event.target);
			trace("currentTarget:"+event.currentTarget);
			*/
			
//TODO:move up
if(content is Content && content != this)
	Content(content).onContentClick(event);
				
			//var linkXML:XML = XML(links.find(event.target))
			
			// 2nd try
			//if(StringUtil.isNull(linkXML.@link))
			//	 linkXML = XML(links.find(event.currentTarget))
				 
			var linkXML:XML = XMLUtil.getXMLById(_data_xml, event.target.name);
			link(linkXML);
		}
		
		//todo:link utils?
		protected function link(linkXML:XML):void
		{	
			if(StringUtil.isNull(linkXML.toXMLString()))return;
			
			// link to other node
			if(!StringUtil.isNull(linkXML.@link))
			{
				trace(" ! Link\t: " + linkXML.@link);
				var _link:String = String(linkXML.@link);
				var _function:String = _link.split(":")[1];
				if(_function)
				{
					var _functionName:String = _function.split("(")[0];
					
					var argumentString:String = _function.substring(1+_function.indexOf("("),_function.indexOf(")"))
					var argumentArray:Array = argumentString.split(",");
					var argument:*;
					
					//TODO arguments
					var arg:String = argumentArray[0];
					if((arg.indexOf("'")==0)&&(arg.lastIndexOf("'")==arg.length)){
						//string
						argument = arg.substring(1,arg.length-1);
					}else{
						//number
						argument = int(arg);
					}
					content[_functionName].apply(content, [argument]);
				}else{
					Navigation.setFocusById(linkXML.@link);
				}
			}
			else if(!StringUtil.isNull(linkXML.@href))
			{
				trace(" ! href\t: " + linkXML.@href);
				//URLUtil.delayGetURL(linkXML.@href, linkXML.@target);
				
				if(StringUtil.isNull(linkXML.@vars))
				{
					Navigation.delayGetURL(linkXML.@id, linkXML.@href, linkXML.@target);
				}else{
					var _href:String = String(linkXML.@href);
					
					//have some args to replace
					if(_href.indexOf("$")>0)
					{
						_varsString = String(linkXML.@vars);
						_URLVariables = DataUtil.getDataByVars(_varsString);
						for(var _var:String in _URLVariables)
							_href = _href.split(_var).join("'"+DataUtil.getDataByID(_var.split("$").join(""))+"'");
						
						Navigation.delayGetURL(linkXML.@id, _href, linkXML.@target);
					}else{
						_varsString = String(linkXML.@vars);
						_URLVariables = DataUtil.getDataByVars(_varsString);
					
						Navigation.delayGetURL(linkXML.@id, _href+"&"+_URLVariables.toString(), linkXML.@target);
					}
				}
			}
			else if(!StringUtil.isNull(linkXML.@action))
			{
				_varsString = String(linkXML.@vars);
				_URLVariables = DataUtil.getDataByVars(_varsString);
				
				LoaderUtil.requestXML(linkXML.@action, _URLVariables, onActionData);
			}
			
			var _varsString:String;
			var _URLVariables:URLVariables;
			
			//trace(" ! Link : " + event.data.link);
			//Navigation.setFocusById(new SDLink(event.data.link).source);
		}
		
		private function onActionData(event:Event):void
		{
			if(event.type!=Event.COMPLETE)return;
			
			trace(" ^ onActionData\t: "+event);
			var _dataEvent:DataEvent = new DataEvent(DataEvent.DATA, false, false, event.target.data);
			ProxyUtil.dispatchEvent(_dataEvent);
		}
		
		// always lowest depth replace old content
		public function addContent(_content:DisplayObject):DisplayObject
		{
			return addChildAt(_content, 0);
		}
		
		// Form.onInComplete
		private function onInComplete(event:SDEvent):void
		{
			var isAlert:Boolean = false;
			var badList:Array = []; 
			trace(" ^ onInComplete\t: "+event.data.inputs);
			for each(var input:* in event.data.inputs)
			{
				if(!input.isEdit)
					badList.push(input.id);
			}
			if(event.target is SDForm && SDForm(event.target).onIncompleteCommand)
			{
				// TODO : real command SDApplication.command
				URLUtil.getURL(SDForm(event.target).onIncompleteCommand.split("$blacklist").join(badList.toString()));
			}else{
				SystemUtil.alert("Bad input(s) : "+badList.join(", "));
			}
		}
		
		// Form.onInvalid
		private function onInvalid(event:SDEvent):void
		{
			var isAlert:Boolean = false;
			trace(" ^ onInvalid\t: "+event.data.inputs);
			for each(var input:* in event.data.inputs)
			{
				// not edit or not valid and got msg
				if((!input.isEdit || !input.isValid) && input.onInvalidCommand)
				{
					//trace(input.isValid +","+ input.onInvalidCommand)
					if(URLUtil.isURL(input.onInvalidCommand) && !isAlert)
					{
						URLUtil.getURL(input.onInvalidCommand);
						isAlert = true;
						continue;
					}
				}
			}
			
			// no one yelling
			if(!isAlert)
			{
				if(event.target is SDForm && SDForm(event.target).onIncompleteCommand)
				{
					SystemUtil.alert(SDForm(event.target).onIncompleteCommand);
				}else{
					SystemUtil.alert("Bad input(s)!");
				}
			}
		}
	}
}