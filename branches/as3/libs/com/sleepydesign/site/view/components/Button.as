package com.sleepydesign.site.view.components
{
	import com.sleepydesign.core.SDContainer;
	import com.sleepydesign.core.SDLink;
	import com.sleepydesign.core.SDMovieClip;
	import com.sleepydesign.events.SDEvent;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	
	// just another cloaker! must extends simple button for now
	// TODO : button interface
	public class Button extends EventDispatcher
	{
		// TODO : button interface
		private var instance:*;
		
		public var link:SDLink;
		
		public function Button(instance:DisplayObjectContainer, link:SDLink)
		{
			super();
			
			// internal or exported for
			this.instance = instance?instance:this;
			
			this.link = link;
			
			trace(" / [ Button ] ------------------------------- ");
			
			var button:SimpleButton;
			
			// TODO : need interface
			if(instance is MovieClip)
			{
				button = SimpleButton(MovieClip(instance).getChildByName(link.id));
			}
			else if(instance is SDMovieClip)
			{
				button = SimpleButton(SDMovieClip(instance).getChildByName(link.id));
			}
			else if(instance is SDContainer)
			{
				button = SimpleButton(SDContainer(instance).getChildByName(link.id));
			}
			
			trace("buttonbutton:"+button)
			if(button)button.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
			
			/*
			if(button)
			{
				if(button)button.addEventListener(MouseEvent.CLICK, onClick);
				if(!links)links = new SDGroup();
				links.insert(itemXML, button);
				instance = button;
			}
			*/
			
			trace(" ------------------------------- [ Button ] /");
		}
		
		private function onClick(event:MouseEvent):void
		{
			dispatchEvent(new SDEvent(SDEvent.CLICK, {content:this, link:link}));
		}
	}
}