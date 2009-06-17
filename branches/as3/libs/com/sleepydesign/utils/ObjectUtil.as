package com.sleepydesign.utils
{
	import flash.display.LoaderInfo;
	import flash.system.ApplicationDomain;
	
	public class ObjectUtil
	{
        public static function getAsset(name:String):Class
        {
			var clazz:Class;
            try {
                clazz = ApplicationDomain.currentDomain.getDefinition(name) as Class;
            } catch (e:*) { 
				trace(" ! ObjectUtil.getAsset\t: "+e );
			}
			return clazz;
		}
		
        /*
		public static function getInstance(className:String):DisplayObject 
		{
			var SymbolClass:Class = getDefinition(className);
			return (SymbolClass) ? new SymbolClass() : null;
		}
		*/
		
		public static function getDefinition(loaderInfo:LoaderInfo, className:String):Class 
		{
			return loaderInfo.applicationDomain.getDefinition(className) as Class;
		}
		
        public static function merge(source:Object, original:Object=null):Object
        {
			// new
			if(!original)original = {};
			
			// merge
			for (var obj:* in source)
			{
				original[obj] = source[obj];
			}
			return original;
		}
		
		public static function toString(object:Object):String
		{		
			var result:String = "";
			
			for (var i:* in object) 
			{
				result = result + " " + i + "\t= " + object[i].toString() + "\n";
			}
			
			if(result.length>0)
			{
				result = " / ["+object+"] -------------------------------\n" + result;
				result = result + " ------------------------------- ["+object+"] /";
			}else{
				result = object.toString();
			}
			return result;
		}
		
		// TODO : args
		public static function print(object:Object):void
		{
			if(object)
				trace(toString(object));
		}
		
		/*
		// http://mrdoob.com/blog/post/612/
		public static function clone(source:Object, target:Object=null):Object
        {
	        var mc : DisplayObject = Cache.get(node.@src);
	
			var pathArray : Array = String(node.@src).split("/");
			var filename : String = String(pathArray[pathArray.length-1]).split(".")[0];  
			
			if (mc.loaderInfo.applicationDomain.hasDefinition(filename))
				mc = new (mc.loaderInfo.applicationDomain.getDefinition(filename))();
        }
        */
        
		/*
		public static function traverse(object:Object, functionName:Function=null):Object
		{
			for each(var child:* in object)
			{
				traverse(child);
				if(functionName)
				{
					child[functionName].apply(child);
				}
			}
		}
		*/
	}
}