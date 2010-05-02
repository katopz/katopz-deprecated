package com.cutecoma.playground.debugger
{
	import com.sleepydesign.core.SDObject;
	import com.cutecoma.game.player.Player;
	import com.cutecoma.playground.core.Engine3D;
	
	import org.papervision3d.core.math.Matrix3D;
	import org.papervision3d.materials.ColorMaterial;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.objects.primitives.Sphere;
	
	public class PlayerDebugger extends SDObject
	{		
		private var engine3D		:Engine3D;
		public static var watching 	:Player;
		
		private static var dolly			:DisplayObject3D;
		private static var decoy			:DisplayObject3D;
		//private static var beacon			:DisplayObject3D;
		
		public static function toggle(engine3D:Engine3D, player:Player):void
		{
			if(!watching)
			{
				watch(engine3D, player);
			}else{
				unwatch(engine3D);
			}
		}
		
		public static function watch(engine3D:Engine3D, player:Player):void
		{
			// Player
			dolly 	= new Sphere(new ColorMaterial(0xFF0000), 25, 2, 2);
			decoy	= new Sphere(new ColorMaterial(0x00FF00), 25, 2, 2);
			//beacon	= new Sphere(new ColorMaterial(0x0000FF), 25, 2, 2);
			
			// link
			dolly.transform = player.instance.transform;
			decoy.transform = player.decoy.transform;
			//beacon.transform = player.beacon.transform;
			
			// add
			engine3D.addChild(dolly);
			engine3D.addChild(decoy);
			//engine3D.addChild(beacon);
			
			watching = player;
		}
		
		public static function unwatch(engine3D:Engine3D):void
		{
			// remove
			engine3D.removeChild(dolly);
			engine3D.removeChild(decoy);
			//engine3D.removeChild(beacon);
			
			watching = null;
		}
	}
}
