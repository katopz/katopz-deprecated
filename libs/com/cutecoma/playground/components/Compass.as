package com.cutecoma.playground.components
{
	import com.cutecoma.game.core.Game;
	import com.sleepydesign.events.SDMouseEvent;
	
	import org.papervision3d.materials.ColorMaterial;
	import org.papervision3d.materials.utils.MaterialsList;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.objects.primitives.Cube;
	import org.papervision3d.view.Viewport3D;
	import org.papervision3d.view.layer.ViewportLayer;
	import org.papervision3d.view.layer.util.ViewportLayerSortMode;
	
	public class Compass extends DisplayObject3D
	{
		private const right 	: Number = 0xFF0000;
		private const left 		: Number = 0x660000;
		
		private const top 		: Number = 0x00FF00;
		private const bottom	: Number = 0x006600;
		
		private const front 	: Number = 0x0000FF;
		private const back 		: Number = 0x000066;
		
		private var target		: DisplayObject3D;
		public static var mode:String = "MOVE";
		
		public function Compass(viewport:Viewport3D, target:DisplayObject3D)
		{
			//useOwnContainer = true;
			super("compass");
			
			this.target = target;
			
			create(viewport);
		}
		
		private function createCube():void
		{	
			// Materials
			var materials:MaterialsList = new MaterialsList(
			{
				right	: new ColorMaterial(right, 1, true),
				left	: new ColorMaterial(left, 1, true),
				
				top		: new ColorMaterial(top, 1, true),
				bottom	: new ColorMaterial(bottom, 1, true),
				
				front	: new ColorMaterial(front, 1, true),
				back	: new ColorMaterial(back, 1, true)
			});
			
			var cube:Cube = new Cube(materials, 50, 50, 50);
			addChild(cube);
			
			//cube.addEventListener(InteractiveScene3DEvent.OBJECT_PRESS, onPress);
		}
		
		public function create(viewport:Viewport3D):void
		{
			createCube();
			
			var layer:ViewportLayer = createViewportLayer(viewport);
			layer.sortMode = ViewportLayerSortMode.INDEX_SORT;
			
			container.alpha = .5;
			
			Game.getController().addEventListener(SDMouseEvent.MOUSE_DRAG, onMouseIsDrag, false, 0 ,true);
		}
		
		public function destroy():void
		{
			Game.getController().removeEventListener(SDMouseEvent.MOUSE_DRAG, onMouseIsDrag);
		}
		
		private function onMouseIsDrag(event:SDMouseEvent):void
		{
			if(event.data.target != container) return;
			switch(mode)
			{
				case "MOVE":
					target.y -= event.data.dy;
					target.x -= event.data.dx;
				break;
				case "ROTATE":
					target.rotationY -= event.data.*.25;
					target.rotationX += event.data.*.25;
				break;
			}
		}
	}
}