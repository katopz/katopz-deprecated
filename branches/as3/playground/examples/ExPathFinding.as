package examples
{
	import com.sleepydesign.events.SDEvent;
	import com.cutecoma.game.core.Position;
	import com.cutecoma.game.player.Player;
	import com.cutecoma.playground.core.Engine3D;
	import com.cutecoma.playground.core.Ground;
	import com.cutecoma.playground.core.Map;
	import com.cutecoma.playground.data.MapData;
	import com.cutecoma.playground.pathfinder.AStar3D;
	
	import flash.display.Sprite;
	
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	
	import org.papervision3d.core.math.Matrix3D;
	import org.papervision3d.events.InteractiveScene3DEvent;
	import org.papervision3d.materials.ColorMaterial;
	import org.papervision3d.materials.WireframeMaterial;
	import org.papervision3d.objects.primitives.Sphere;
	
	[SWF(backgroundColor="0xFFFFFF", frameRate="30", width="800", height="600")]
	public class ExPathFinding extends Sprite
	{
		private var engine3D	: Engine3D;
		private var map			: Map;
		private var player		: Player;
		private var pathFinder	: AStar3D;
		
		public function ExPathFinding()
		{
			// Engine3D
			engine3D = new Engine3D(this);
			engine3D.axis = true;
			engine3D.compass = true;
			
			// Map
			map = new Map("map.dat", 30, 30);
			addChild(map);
			
			// Ground
			var ground:Ground = new Ground(engine3D, map, true);
			ground.addEventListener(InteractiveScene3DEvent.OBJECT_CLICK, onClick);
			engine3D.uiScene.addChild(ground);
			
			// AStar3D
			pathFinder = new AStar3D(engine3D.scene);
			pathFinder.create(map.data.bitmapData, map.factorX, map.factorZ, 1.5, 1.5);
			pathFinder.addEventListener(SDEvent.COMPLETE, onPathComplete);
			pathFinder.addEventListener(SDEvent.ERROR, onPathError);
			
			// Player
			var position:Position = pathFinder.getPositionByNode(MapData(map.data).spawnPoint.x, 0, MapData(map.data).spawnPoint.y)
			var transform : Matrix3D = Matrix3D.translationMatrix(position.x, position.y, position.z);
			createPlayer(transform);
			
			// start
			engine3D.start();
		}
		
		public function createPlayer( transform:Matrix3D ):void
		{
			var sphere:Sphere = new Sphere(new WireframeMaterial(0xFF00FF), 50, 5, 5);
			sphere.transform = Matrix3D.clone(transform);
			engine3D.scene.addChild(sphere);
			
			player = new Player(null, sphere);
			
			player.dolly 	= new Sphere(new ColorMaterial(0xFF0000), 25, 2, 2);
			player.decoy	= new Sphere(new ColorMaterial(0x00FF00), 25, 2, 2);
			player.beacon	= new Sphere(new ColorMaterial(0x0000FF), 25, 2, 2);
			
			player.paths	= [];
			player.speed	= 2,
			player.action	= "stand"
			
			player.dolly.transform = Matrix3D.clone(sphere.transform);
			
			engine3D.scene.addChild(player.dolly);
			engine3D.scene.addChild(player.decoy);
			engine3D.scene.addChild(player.beacon);
		}
		
		// _______________________________________________________ Path
		
		private function onPathError(event:SDEvent):void
		{
			trace(" ! Over flow")
		}
		
		private function onPathComplete(event:SDEvent):void
		{
			//walk
			walk(event.data.paths);
			
			//draw map
			map.drawPath(event.data.paths, event.data.segmentX, event.data.segmentZ);
		}
		
		// _______________________________________________________ Action
		
		private function walk(paths:Array):void
		{
			player.paths = paths;
			if (player.paths[1])
			{
				player.dolly.copyPosition(player.paths[0]);
				player.decoy.copyPosition(player.paths[player.paths.length-1]);

				trace(" ! Length : "+ player.paths.length);
				var time:Number;
				var factor:Number = (map.factorX+map.factorZ)/2;
				
				if(player.paths.length==2)
				{
					time = player.dolly.distanceTo(player.decoy)/player.speed/factor/1.5;
				}else{
					time = player.paths.length/player.speed
				}
				
				trace(" ! Time : "+time);
				TweenMax.to(player.dolly, 1+time, 
				{
					//x:player.decoy.x, y:player.decoy.y, z:player.decoy.z,
					bezier:player.paths ,
					onStart:function():void { act("walk") },
					onUpdate:onWalk,
					//onComplete:walk,
					ease:Linear.easeNone
				} );
				
			}else {
				//TODO : recheck condition
				act("stand");
			}
		}
		
		private function onWalk():void
		{
			player.instance.lookAt(player.dolly);
			
			player.instance.x += (player.dolly.x - player.instance.x) * .5;
			player.instance.z += (player.dolly.z - player.instance.z) * .5;
		}
		
		private function act(action:String):void
		{
			/*
			if (player.action != action)
			{
				player.instance.play( new AnimationSequence(action, true, true, 16) );
			}
			player.action = action;
			*/
		}
		
		private function onClick(event:InteractiveScene3DEvent):void
		{
			trace(event);
			trace(" ^ mouse3D	: "+engine3D.mouse3D)
			pathFinder.findPath(player.dolly, engine3D.mouse3D);
		}
	}
}
