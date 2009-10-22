package com.sleepydesign.site.view.components
{
	import com.greensock.TweenMax;
	import com.sleepydesign.core.SDContainer;
	import com.sleepydesign.core.SDGroup;
	import com.sleepydesign.core.SDMovieClip;
	import com.sleepydesign.events.SDEvent;
	import com.sleepydesign.site.model.vo.ContentVO;
	import com.sleepydesign.utils.StringUtil;
	import com.sleepydesign.utils.URLUtil;
	import com.sleepydesign.utils.XMLUtil;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.utils.*;
	
	/* ---------------------------------------------------------------
	
	[Page] ( id, source, xml, path) : act like a folder
		+ container : element even content
		+ content 	: page content
	
	* [Page::Layer]
		+ contents[2]
		+ contents[1]
		+ contents[0]
	
	* [Page::Slide]
		+ contents[0] < contents[1]  > contents[2]
	 
	* [Page::Table]
		+ contents[0] | contents[1]  | contents[2]
		  ------------+--------------+------------
		+ contents[3] | contents[4]  | contents[5]
		
	* [Authentication::Page]
		+ Process
		+ LogIn
		+ LogOut
		
	--------------------------------------------------------------- */

	/**
	 * [Page]
	 * 	+ source::xml : <page src="anysource">
	 * 						<content id="contentID" src="source" type="castType"/>
	 * 						<form id="formID" action="serverside/something.php" method="POST"/>
	 * 					</page>
	 *  + contents : content
	 * 
	 */	
	public class Page extends Content
	{
		public var contents:SDGroup;
		private var container:SDContainer;// = new SDContainer("container");
		
		//linklist : TODO page/content interface
		private var currentContent:*;
		
		//currentContentPath
		public function get path():String
		{
			if(!_data)return null;
			trace(" ! id :"+ContentVO(_data).id);
			return Site.getPathById(ContentVO(_data).id);
		}
        
        private static var _dispatcher:EventDispatcher = new EventDispatcher();
        public static function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, 
            useWeakReference:Boolean = false):void {
            _dispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
        }
        
		//public function Page(id:String=null, source:*=null, xml:XML=null)
		public function Page(id:String=null, source:*=null, xml:XML=null)
		{
			// prepare loader for external config
			//loader = SDApplication.loader?SDApplication.loader:new SDLoader();
			
			// container manager
			container = new SDContainer(id+"_SDContainer");
			
			//trace( " ! Page.path : " +path);
			//this.path = path;
			
			super(id, source, xml);
			
			// on top of content
			addChild(container);
			
			// Call global config
			//if(stage)
			//{
				//trace("! Dependency call global config");
				//getConfig(SDApplication.configSource);
			//}
		}
		
		// ______________________________ Focus ____________________________
		
		override protected function applyConfig():void
		{		
			//if(!_data.xml || StringUtil.isNull(_data.xml))return;
			trace(" ! Page.applyConfig");
			super.applyConfig();
			
			// focus page/content
            if (_data && _data.xml && String(_data.xml.@focus).length > 0)
            {
				trace(" ! Page Focus Content\t: " + _data.xml.@focus);
				Navigation.setFocusById(String(_data.xml.@focus));
            }
  		}
		
		// maybe change to DisplayObjectGroup
		public function setFocus(child:Content):Content
		{
			if(!child)return null;
			trace(" * setFocus\t: "+child);
			
			for each(var _content:* in contents.childs)
			{
				if(_content == child)
				{
					_content.visible = true;
				}else{
					_content.visible = false;
				}
			}
			return child;
		}
		
		public function setFocusBy(str:String, arg:String="id"):Content
		{
			trace(" * setFocusBy\t: "+str);
			if(contents)
				var _content:Content = contents.findBy(str, arg);
			
			if(_content)
				setFocus(_content);
			return _content;
		}
		
		// ______________________________ Update ____________________________
		
		// 
		override public function update(data:Object=null):void
		{
			if(!data)return;
			
			var currentSection:String;
			var xml:XML;
			var contentVO:ContentVO;
			
			var focusID:String = !StringUtil.isNull(data.xml.@focus)?String(data.xml.@focus):null;
			type = !StringUtil.isNull(data.xml.@type)?String(data.xml.@type):null;
			
			/*
			// dependency self update
			if(stage)
			{
				xml = XMLUtil.getXMLById(data.xml, id);
				if(!StringUtil.isNull(xml))data.xml = xml;
			}
			
			var focusID:String = !StringUtil.isNull(data.xml.@focus)?String(data.xml.@focus):null;
			
			type = !StringUtil.isNull(data.xml.@type)?String(data.xml.@type):null;
			
			if(!focusID && !type)
			{
				type="any"
			}
			*/
			
			//trace("\n * Page.update\t: "+type+"\n");
			
			switch(type)
			{
				case "foreground":
				case "background":
				case "any":
					//new one?
					if(!_data || _data.xml != data.xml)
						super.update(new ContentVO(data.xml.@id, data.xml.@src, data.xml));
				break;
				case "layer":
					// Page::Layer type no SWFAddress invoke here
					currentSection = String(data.xml.@id);
					
					// no focus? 1st elements then
					if(!focusID)
						focusID = XML(data.xml).children()[0].@id;
					
					trace(" ! focusID\t: "+focusID);
					
					trace("\n / [Layer.update:"+currentSection+"] --------------------------------------");
					
					super.update(data);
					
					// focus
					currentContent = setFocusBy(focusID);
					
					// data
					xml = XMLUtil.getXMLById(data.xml, focusID);
					
					// try find by @id
					var _source: DisplayObjectContainer = SDMovieClip.getCollector().findBy(focusID);
					
					// try find by @src
					if(!_source)
						_source = SDMovieClip.getCollector().findBy(String(XML(data.xml).@src));
					
					if(_source)
						Content(currentContent).update(new ContentVO(focusID, _source, xml));
						
					trace(" -------------------------------------- [Layer.update:"+currentSection+"] /\n");
				break;
				default :
					// normal case, destroy and swap page
					var queuePaths:Array = Navigation.queuePaths?Navigation.queuePaths:null;
					currentSection = queuePaths?queuePaths.shift():data.id;
					
					trace("\n / [Page.update:"+currentSection+"] --------------------------------------");
					
					//new one?
					if(!_data || _data.xml != data.xml)
					{
						removeContainer();
						super.update(data);
					}
					
					// got queues from SWFAddress
					if(queuePaths && queuePaths.length>0)
					{
		         		//trace("queuePaths:"+queuePaths);
		         		
		         		xml = XMLUtil.getXMLById(XML(data.xml), queuePaths[0]);
		        		contentVO = new ContentVO(xml.@id, null, xml);
		        		
						//TODO : getContentById
						var childContent:*;
						
						if(contents)
							childContent = contents.findBy(contentVO.id);
							
						if(!childContent)
							childContent = new Page(contentVO.id);
						
						// look like new child in town let's clear old sake
						if(currentContent && currentContent != childContent)
						{
							removeContainer(currentContent);
						}
						
						currentContent = childContent;
						
						childContent.update(contentVO);
						addContainer(childContent);
					}else{
						// old content
						//if(currentContent)
							//removeContainer(currentContent);
						removeContainer();
					}
					
					trace(" -------------------------------------- [Page.update:"+currentSection+"] /\n");
				break;
			}
			
			// onLoad
			// TODO : real command
			if(_config && !StringUtil.isNull(data.xml.@onLoad))
			{
				var onLoadCommand:String = data.xml.@onLoad;
				if(URLUtil.isURL(onLoadCommand))
					URLUtil.getURL(onLoadCommand);
			}
			
			// reload
			var _reloadSecond:uint = StringUtil.isNull(data.xml.@reload)?null:uint(data.xml.@reload);
			var _dataURI:String = StringUtil.isNull(data.xml.@data)?null:String(data.xml.@data);
			
			if(_reloadSecond && _dataURI)
			{
				reload(_dataURI, _reloadSecond);
			}
		}
		
		//private reloader:Object;
		private function reload(dataURI:*, delay:uint):void
		{
			this.dataURI = dataURI;
			trace(" * Reload ("+delay+") : "+dataURI);
			TweenMax.to(this, delay, {onComplete:reload, onCompleteParams:[dataURI, delay]});
			loader.addEventListener(SDEvent.COMPLETE, onGetData, false, 0, true);
			loader.load(dataURI);
		}
		
		public function addContainer(displayObject:DisplayObject):DisplayObject
		{
			/*
			trace("\n|||||||||||||||||||||||||||||||||")
			trace(" + addContainer	: "+ DisplayObjectUtil.toString(displayObject));
			trace("|||||||||||||||||||||||||||||||||\n")
			/*
			if(_innerContent)
			{
				removeChild(_innerContent);
				_innerContent = null;
				//destroy([_innerContent]);
			}
			*/
			if(!contents)
			{
				contents = new SDGroup();
			}
			contents.insert(displayObject);
			container.addChild(displayObject);
			//trace("numChildren:"+container.numChildren)
			//_innerContent = displayObject;
			return displayObject;
		}
		
		public function removeContainer(displayObject:DisplayObject=null):DisplayObject
		{
			if(displayObject)
			{
				contents.remove(displayObject);
				container.removeChild(displayObject);
			}else{
				container.destroy();
				
				if(contents)
					contents.destroy();
			}
			displayObject = null;
			return displayObject;
		}
		
		/*
        override public function removeChild(displayObject:DisplayObject):DisplayObject
        {
        	if(contents && displayObject)
        	{
        		contents.remove(displayObject);
        	}
        	super.removeChild(displayObject);
        	displayObject = null;
        	return displayObject;
        }
        */
        
		override protected function parseItem(itemXML:XML):DisplayObject
		{
			//trace("Page.itemXML:"+itemXML.toXMLString())
			if(StringUtil.isNull(itemXML))return null;
			//if(itemXML.toXMLString()=="undefined")return null;
			
			// prase all element(s) 
			var innerContent:* = super.parseItem(itemXML);
			
			var itemType:String = String(itemXML.name()).toLowerCase();
			var idString:String = String(itemXML.@id);
			var sourceString:String = idString;
			sourceString = !StringUtil.isNull(itemXML.@src)?String(itemXML.@src):sourceString;

			//trace("\n /-------------------------------------");
			trace(" ! itemXML : " + itemXML.@id);//.toXMLString());
			//trace(" -------------------------------------/\n");
			
			// parse all item(s)
			var i:uint;
			var xmlList:XMLList;
			switch(itemType)
			{
				case "menu" :
					
					// internal : xml.content -> button
					var menuClip:*
					/*
					if(content is SDMovieClip)
					{
						menuClip = SDMovieClip(content).getChildByName(sourceString);
					}
					else if(content is MovieClip)
					{
						menuClip = MovieClip(content).getChildByName(sourceString);
					}
					else if(content is Page)
					{
						menuClip = Page(content).getChildByName(sourceString);
					}
					else
					{
						return null;
					}
					*/
					
					if(content is DisplayObjectContainer)
						menuClip = DisplayObjectContainer(content).getChildByName(sourceString);
					
					if(!menuClip)
						return null;
						
					trace("menuClip:"+menuClip);
					
					if(menuClip is MovieClip && itemXML)
					{
						//for each(var contentXML:XML in data.xml)
						// tricky : reprase parent for inner flash content
						xmlList = _data.xml.children();
						for (i = 0; i < xmlList.length(); i++ ) 
						{
							var contentXML:XML = xmlList[i];
							try{
								if(contentXML.name()=="content" || contentXML.name()=="page")
								{
									var button:SimpleButton = SimpleButton(menuClip.getChildByName(contentXML.@id+"Button"));
									button.addEventListener(MouseEvent.CLICK, onMenuClick);
									if(!menus)menus = new Dictionary(true);
									menus[button] = contentXML;
								}
							}catch(e:*){trace(e);}
						}
					}
				break;
				case "page" :
					
					// ONLY TYPE="ANY" CAN LOAD EVERY PAGE WITHOUT CARING ABOUT FOCUS
					// WILL USE VISIBLE INSTEAD HERE
					
					//innerContent = new Page(itemXML.@id, XML(itemXML.(@id==itemXML.@id)));
					//addContainer(innerContent);
				break;
				/*
				case "layer" :
					var layer:SDLayer = new SDLayer(idString);
					
					// wait for content ready
					content.addEventListener(SDEvent.READY, layer.onChildReady);
					
					// store content and xml to apply later when content ready 
					layer.addContent(content, itemXML);
				break;
				*/
				case "content" :
				
					// must defined before send to Content, cause Content never known parent while init
					
					// case#1 sourceString is MovieClip
					//var clip:DisplayObject = this[sourceString];
					
					// case#1 MovieClip
					var clip:DisplayObject = this.getChildByName(sourceString);
					
					// case#2 content.MovieClip
					if(DisplayObjectContainer(content) && !clip)
					{
						clip = DisplayObjectContainer(content).getChildByName(sourceString)
					}
					
					// case#3 SDMovieClip.clip
					if(DisplayObjectContainer(content) && !clip)
					{
						clip = SDMovieClip(content).clip.getChildByName(sourceString)
					}
					
					trace(" ! Clip\t: "+sourceString+":"+clip);
					
					//innerContent = Content(contents.findBy(String(itemXML.@id)));
					var _itemXML_src:*;
					if(clip)
					{
						_itemXML_src = clip;
					}else{
						_itemXML_src = itemXML.@src;
					}
					
					// internal
					if(contents && contents.findBy(idString))
					{
						// exist?
						innerContent = contents.findBy(idString);
						innerContent.update(new ContentVO(innerContent.id, _itemXML_src, itemXML));
					}else{
						// new
						innerContent = new Content(itemXML.@id, _itemXML_src, itemXML);// XML(itemXML.(@id==itemXML.@id)));
						addContainer(innerContent);
					}
					
					//trace("+++++++++++++++++"+itemXML.@id, data.xml.@focus)
					
					if(type=="layer" && innerContent && (_data.xml.@focus || _config.focus))
					{
						innerContent.visible = (itemXML.@id==_data.xml.@focus) || (idString==_config.focus)
					}else{
						innerContent.visible = true;
					}
				break;
						/*
						if(itemXML.@id==data.xml.@focus || (config.focus && itemXML.@id==config.focus))
						{
							trace(" + content	: "+ DisplayObjectUtil.toString(content));
							
							// SWF -> Content
							if(itemType=="content")
							{
								innerContent = new Content(itemXML.@id, sourceString, XML(itemXML.(@id==itemXML.@id)));
								
							}else{
								innerContent = new Page(itemXML.@id, sourceString, XML(itemXML.(@id==itemXML.@id)));
							}
							
							addContainer(innerContent);
						}else {
							// notfocus
							// void? preload?
							//trace("notfocusnotfocusnotfocus");
						}
					
					// Page focus/selected TODO : reveal (transition manager)
					if(innerContent && (data.xml.@focus || config.focus))
					{
						innerContent.visible = (itemXML.@id==data.xml.@focus) || (itemXML.@id==config.focus)
					}
					*/
				/*
				// just load and add
				case "asset" :
					//trace("assetassetassetasset:"+itemXML.@id);
					//trace("assetassetassetassetssssssss:"+XML(itemXML.(@id==itemXML.@id)).toXMLString());
					innerContent = new Content(itemXML.@id, sourceString, XML(itemXML.(@id==itemXML.@id)));
					DisplayObjectContainer(content).addChild(innerContent);
				break;
				*/
			}
			//trace("return:"+innerContent);
			
			return innerContent;
		}
		
		// DIRTY : menu for Page is acting diff from Content
		/*
			Page : change/add new Page/Content
			Content : change current content
		*/
		
		protected var menus:Dictionary
		protected function onMenuClick(event:MouseEvent):void
		{
			if(!menus)return;
			var linkXML:XML = XML(menus[event.target]);
			trace("^ onClick\t: "+linkXML.toXMLString());
			
			var frame:uint = uint(linkXML.@frame);
			//var sdClip:MovieClip;
			
			trace("frame:"+frame);
			
			if(!StringUtil.isNull(linkXML.@id))
				Navigation.setFocusById(linkXML.@id);
			
			//try{
			//	sdClip = MovieClip(content).getChildByName(String(linkXML.@src)) as MovieClip;
			//	trace("sdClip:"+sdClip);
			//}catch(e:*){trace(e);}
			
			// link to inner clip
			if(frame>0)
			{
				//sdClip.clip.gotoAndStop(frame);
				////Navigation.setFocusById(linkXML.@id);
				
				//trace("CHANGE_FOCUSCHANGE_FOCUSCHANGE_FOCUSCHANGE_FOCUS");
				//dispatchEvent(new SDEvent(SDEvent.CHANGE_FOCUS, {content:innerContent}));
				
				/*
				if(linkXML.length()>0)
				{
					//config.focus = linkXML.@id;
					trace("linkXML:"+linkXML.toXMLString());
					var asset:* = parseItem(linkXML);
					trace("asset:"+asset);
					if(asset)
					{
						trace("clip:"+clip);
						trace("asset:"+asset);
						//clip.addChild(asset);
						//addChild(asset);
					}
				}
				*/
				
			}else{
				/*
				config.focus = linkXML.@id;
				trace(" ! config.focus -> parseItem : "+config.focus)
				parseItem(linkXML);
				*/
			}
		}
	}
}