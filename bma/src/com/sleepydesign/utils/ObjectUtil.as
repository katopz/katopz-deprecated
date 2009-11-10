/**
* @author katopz@sleepydesign.com
* @version 0.1
*/

package com.sleepydesign.utils {
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.utils.ByteArray;
	
	public class ObjectUtil {
		/*
		public static function isClassCompatibleWith(test:Class,desired:Class):Boolean{
			var search:String=describeType(desired).@name;    
			var desc:XML=describeType(test);    
			return ((desc.factory.extendsClass.(@type==search)).length()>0);
		}
		*/
		public static function copy(source:Object):* {
			var myBA:ByteArray = new ByteArray();
			myBA.writeObject(source);
			myBA.position = 0;
			return myBA.readObject();
		}
		public static function toByteArray(source:Object):ByteArray{
			var myBA:ByteArray = new ByteArray();
			myBA.writeObject(source);
			myBA.position = 0;
			return myBA;
		}
		/*
		function trace(container:DisplayObjectContainer, indentString:String = ""):void
		{
			var child:DisplayObject;
			for (var i:uint=0; i < container.numChildren; i++)
			{
				child = container.getChildAt(i);
				trace(indentString, child, child.name); 
				if (container.getChildAt(i) is DisplayObjectContainer)
				{
					traceDisplayList(DisplayObjectContainer(child), indentString + "    ")
				}
			}
		}
		*/
	}
	
}
