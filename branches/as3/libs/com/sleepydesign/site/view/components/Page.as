package com.sleepydesign.site.view.components
{
	import com.greensock.TweenLite;
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
	 * 						<form id="formID" action="localside/something.php" method="POST"/>
	 * 					</page>
	 *  + contents : content
	 *
	 */
	public class Page extends Content
	{
		public var contents:SDGroup;
		private var container:SDContainer;

		// return current data as raw
		public function get currentData():*
		{
			return _data;
		}

		private var currentContent:*;

		//currentContentPath
		public function get path():String
		{
			if (!_data)return null;
			
			trace(" ! id :" + ContentVO(_data).id);
			return Site.getPathById(ContentVO(_data).id);
		}
		
		/**
		 * dispatch data event to global
		private static var _dispatcher:EventDispatcher = new EventDispatcher();
		public static function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{
			_dispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		*/

		public function Page(id:String = null, source:* = null, xml:XML = null)
		{
			// container manager
			container = new SDContainer(id + "_SDContainer");
			super(id, source, xml);

			// on top of content
			addChild(container);
		}

		// ______________________________ Focus ____________________________

		override protected function applyConfig():void
		{
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
			if (!child)
				return null;
			trace(" * setFocus\t: " + child);

			for each (var _content:*in contents.childs)
			{
				if (_content == child)
				{
					_content.visible = true;
				}
				else
				{
					_content.visible = false;
				}
			}
			return child;
		}

		public function setFocusBy(str:String, arg:String = "id"):Content
		{
			trace(" * setFocusBy\t: " + str);
			if (contents)
				var _content:Content = contents.findBy(str, arg);

			if (_content)
				setFocus(_content);
			return _content;
		}

		// ______________________________ Update ____________________________

		// 
		override public function update(data:Object = null):void
		{
			if (!data)return;
			
			var currentSection:String;
			var xml:XML;
			var contentVO:ContentVO;

			var focusID:String = !StringUtil.isNull(data.xml.@focus) ? String(data.xml.@focus) : null;
			type = !StringUtil.isNull(data.xml.@type) ? String(data.xml.@type) : null;

			switch (type)
			{
				case "foreground":
				case "background":
					//new one?
					if (!_data || _data.xml != data.xml)
						super.update(new ContentVO(data.xml.@id, data.xml.@src, data.xml));
					break;
				/*
				case "any":
					//new one?
					if (!_data || _data.xml != data.xml)
						super.update(new ContentVO(data.xml.@id, data.xml.@src, data.xml));
					break;
				*/
				/*
				case "layer":
					// Page::Layer type no SWFAddress invoke here
					currentSection = String(data.xml.@id);

					// no focus? 1st elements then
					if (!focusID)
						focusID = XML(data.xml).children()[0].@id;

					trace(" ! focusID\t: " + focusID);

					trace("\n / [Layer.update:" + currentSection + "] --------------------------------------");

					super.update(data);

					// focus
					currentContent = setFocusBy(focusID);

					// data
					xml = XMLUtil.getXMLById(data.xml, focusID);

					// try find by @id
					var _source:DisplayObjectContainer = SDMovieClip.getCollector().findBy(focusID);

					// try find by @src
					if (!_source)
						_source = SDMovieClip.getCollector().findBy(String(XML(data.xml).@src));

					if (_source)
						Content(currentContent).update(new ContentVO(focusID, _source, xml));

					trace(" -------------------------------------- [Layer.update:" + currentSection + "] /\n");
					break;
				*/
				default:
					// normal case, destroy and swap page
					var queuePaths:Array = Navigation.queuePaths ? Navigation.queuePaths : null;
					currentSection = queuePaths ? queuePaths.shift() : data.id;

					trace("\n / [Page.update:" + currentSection + "] --------------------------------------");

					//new one?
					if (!_data || _data.xml != data.xml)
					{
						removeContainer();
						super.update(data);
					}

					// got queues from SWFAddress
					if (queuePaths && queuePaths.length > 0)
					{
						xml = XMLUtil.getXMLById(XML(data.xml), queuePaths[0]);
						contentVO = new ContentVO(xml.@id, null, xml);

						//TODO : getContentById
						var childContent:*;

						if (contents)
							childContent = contents.findBy(contentVO.id);

						if (!childContent)
							childContent = new Page(contentVO.id);

						// look like new child in town let's clear old sake
						if (currentContent && currentContent != childContent)
							removeContainer(currentContent);

						currentContent = childContent;

						childContent.update(contentVO);
						addContainer(childContent);
					}
					else
					{
						removeContainer();
					}

					trace(" -------------------------------------- [Page.update:" + currentSection + "] /\n");
					break;
			}

			// onLoad
			// TODO : real command
			if (_config && !StringUtil.isNull(data.xml.@onLoad))
			{
				var onLoadCommand:String = data.xml.@onLoad;
				if (URLUtil.isURL(onLoadCommand))
					URLUtil.getURL(onLoadCommand);
			}
		}
		
		public function addContainer(displayObject:DisplayObject):DisplayObject
		{
			if (!contents)
				contents = new SDGroup();
			
			contents.insert(displayObject);
			container.addChild(displayObject);
			
			return displayObject;
		}

		public function removeContainer(displayObject:DisplayObject = null):DisplayObject
		{
			if (displayObject)
			{
				contents.remove(displayObject);
				container.removeChild(displayObject);
			}
			else
			{
				container.destroy();

				if (contents)
					contents.destroy();
			}
			displayObject = null;
			return displayObject;
		}

		override protected function parseItem(itemXML:XML):DisplayObject
		{
			if (StringUtil.isNull(itemXML))
				return null;

			// prase all element(s) 
			var innerContent:* = super.parseItem(itemXML);

			var itemType:String = String(itemXML.name()).toLowerCase();
			var idString:String = String(itemXML.@id);
			var sourceString:String = idString;
			sourceString = !StringUtil.isNull(itemXML.@src) ? String(itemXML.@src) : sourceString;

			trace(" ! itemXML : " + itemXML.@id);

			// parse all item(s)
			var i:uint;
			var xmlList:XMLList;
			switch (itemType)
			{
				case "content":
					// case#1 MovieClip
					var clip:DisplayObject = this.getChildByName(sourceString);

					// case#2 content.MovieClip
					if (DisplayObjectContainer(content) && !clip)
					{
						clip = DisplayObjectContainer(content).getChildByName(sourceString)
					}

					// case#3 SDMovieClip.clip
					if (DisplayObjectContainer(content) && !clip && content is SDMovieClip)
					{
						clip = SDMovieClip(content).clip.getChildByName(sourceString)
					}
					
					// case#4 embed asset
					if(!clip)
					{
						clip = content[sourceString];
					}

					trace(" ! Clip\t: " + sourceString + ":" + clip);

					var _itemXML_src:*;
					if (clip)
					{
						_itemXML_src = clip;
					}
					else
					{
						_itemXML_src = itemXML.@src;
					}

					// internal
					if (contents && contents.findBy(idString))
					{
						// exist?
						innerContent = contents.findBy(idString);
						innerContent.update(new ContentVO(innerContent.id, _itemXML_src, itemXML));
					}
					else
					{
						// new
						innerContent = new Content(itemXML.@id, _itemXML_src, itemXML); // XML(itemXML.(@id==itemXML.@id)));
						addContainer(innerContent);
					}

					if (type == "layer" && innerContent && (_data.xml.@focus || _config.focus))
					{
						innerContent.visible = (itemXML.@id == _data.xml.@focus) || (idString == _config.focus)
					}
					else
					{
						innerContent.visible = true;
					}
					break;
			}
			return innerContent;
		}
	}
}