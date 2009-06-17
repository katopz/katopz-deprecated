/*
 Copyright (c) 2008 AllFlashWebsite.com
 All rights reserved.

*/
package com.sleepydesign.utils
{
    public class SWFAddressUtil 
    {
		// Convert URI String to an Array
		public static function segmentURI(uri:String):Array 
		{
			//var q = uri.indexOf("?");
			// TODO Possibly handle ? differently
			if (!uri || uri == "") return [];
			var arr:Array = uri.split("/");
			arr.shift();
			return arr;
		}
		
		// Convert URI Array to URI String
		public static function joinURI(uriSegments:Array):String 
		{
			return "/"+uriSegments.join("/");
		}
		
		// Build a title from a URI Array
		// Either customize this function, or have the Mediator build the title
		public static function formatTitleSeg(uriSegments:Array):String 
		{
			return formatTitle(joinURI(uriSegments));
		}
		
		// Build a title from a URI String
		// Either customize this function, or have the Mediator build the title
		public static function formatTitle(title:String):String 
		{
			return 'SWFAddress Website' + (title != '/' ? ' / ' + toTitleCase(replace(title.substr(1, title.length - 2), '/', ' / ')) : '');
		}
		
		private static function toTitleCase(str:String):String 
		{
			return str.substr(0,1).toUpperCase() + str.substr(1);
		}
		
		private static function replace(str:String, find:String, replace:String):String
		{
			return str.split(find).join(replace);
		}
    }
}