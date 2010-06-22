package com.cutecoma.game.core
{
	import away3dlite.containers.Scene3D;
	import away3dlite.containers.View3D;
	
	import com.sleepydesign.display.SDSprite;

	public interface IEngine3D
	{
		function get systemLayer():SDSprite;
		function get contentLayer():SDSprite;
		
		function get scene3D():Scene3D;
		function get view3D():View3D;
		
		function start():void;
		function stop():void;
	}
}