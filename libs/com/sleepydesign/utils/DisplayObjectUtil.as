package com.sleepydesign.utils
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Stage;
	
	public class DisplayObjectUtil
	{
        public static function toString(displayObject:DisplayObject, list:String=""):String
        {
        	if(displayObject && displayObject.parent)
        	{
        		list = list + toString(displayObject.parent, list);
        	}
        	list = list + String(displayObject);
        	return list.split("][object ").join(".");
        }
        
        public static function cloak(parent:DisplayObjectContainer, instance:DisplayObject):void
        {
			//trace(" ! Cloak\t: "+parent+" <- "+toString(instance));
			if(!instance.parent || instance.parent is Stage)return;
			var clipParent:DisplayObjectContainer = instance.parent;
			var clipIndex:uint = instance.parent.getChildIndex(instance);
			parent.addChild(instance);
			clipParent.addChildAt(parent, clipIndex);
        }
        /*
        public static function gotoAndPlay(clip:MovieClip, frame:Object):void
        {
			// label
        	if(frame is String)
        	{
	        	for each(var label:FrameLabel in clip.currentLabels)
				{
	    			//trace("frame " + label.frame + ": " + label.name);
	    			if(frame==label)
	    			{
	    				clip.gotoAndPlay(label);
	    				return;
	    			}
	   			}
        	}
        }
        */
	}
}