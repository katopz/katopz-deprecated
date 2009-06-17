package com.sleepydesign.playground.core
{
	
	import com.sleepydesign.playground.events.*;
	import org.papervision3d.materials.MovieAssetMaterial;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.objects.primitives.Plane;
	
	import flash.display.BitmapData;
	import flash.events.EventDispatcher;
	
	public class Terrain extends DisplayObject3D{

		// ___________________________________________________________________ Var
		
		public var plane		: Plane;
		
		public function Terrain(initObject:*) 
		{
			
			var mapBitmap:BitmapData = initObject.material.bitmap as BitmapData;
			var material:MovieAssetMaterial = new MovieAssetMaterial( "Map0000", true ) 
			material.doubleSided = true;
			material.interactive = true;
			plane = new Plane( material, mapBitmap.width, mapBitmap.height, 4, 4 );
			
			plane.rotationX = -90;
			plane.y = 0;
			
			//scene.addChild(plane);
		}
	}
}