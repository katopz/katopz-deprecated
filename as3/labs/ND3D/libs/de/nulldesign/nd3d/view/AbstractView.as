package de.nulldesign.nd3d.view 
{
	import de.nulldesign.nd3d.geom.Vertex;
	import de.nulldesign.nd3d.material.LineMaterial;
	import de.nulldesign.nd3d.objects.Line3D;
	import de.nulldesign.nd3d.objects.PointCamera;
	import de.nulldesign.nd3d.renderer.Renderer;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;

	/**
	 * A prepared 3D scene with debug modes (debug axis, debug display and manual placement ob ojects)
	 * @author Lars Gerckens (www.nulldesign.de)
	 */
	public class AbstractView extends Sprite
	{
		protected var cam:PointCamera;
		protected var renderer:Renderer;
		protected var renderList:Array;

		protected var manualObject:*;
		protected var isAngleMode:Boolean = false;
		protected var downKey:int = -1;
		protected var debugTxt:TextField;

		public function AbstractView(canvas:Sprite, sceneWidth:int, sceneHeight:int) 
		{
			renderer = new Renderer(canvas);
			cam = new PointCamera(sceneWidth, sceneHeight);
			renderList = [];

			addEventListener(Event.ENTER_FRAME, loop);
		}

		protected function loop(e:Event):void 
		{
			renderer.render(renderList, cam);
			
			if(debugTxt)
			{
				debugTxt.text = "Faces rendered: " + renderer.facesRendered + " of " + renderer.facesTotal + ", vertices processed: " + renderer.verticesProcessed;
				                
				if(manualObject) debugTxt.appendText("\n(" + (isAngleMode ? "angle" : "pos") + ") " + manualObject.toString());
			}
      
			if(downKey > -1)
			{
				if(isAngleMode)
				{
					switch(downKey)
					{
						case Keyboard.UP: 
							manualObject.angleX -= 0.05; 
							break;
						case Keyboard.DOWN: 
							manualObject.angleX += 0.05; 
							break;
						case Keyboard.LEFT: 
							manualObject.angleY -= 0.05; 
							break;
						case Keyboard.RIGHT: 
							manualObject.angleY += 0.05; 
							break;
						case 187: 
							manualObject.angleZ -= 0.05; 
							break; // +
						case 189: 
							manualObject.angleZ += 0.05; 
							break; // -
					}
				}
				else
				{
					switch(downKey)
					{
						case Keyboard.UP: 
							manualObject is PointCamera ? manualObject.y -= 5 : manualObject.yPos -= 5; 
							break;
						case Keyboard.DOWN: 
							manualObject is PointCamera ? manualObject.y += 5 : manualObject.yPos += 5; 
							break;
						case Keyboard.LEFT: 
							manualObject is PointCamera ? manualObject.x -= 5 : manualObject.xPos -= 5; 
							break;
						case Keyboard.RIGHT: 
							manualObject is PointCamera ? manualObject.x += 5 : manualObject.xPos += 5; 
							break;
						case 187: 
							manualObject is PointCamera ? manualObject.z -= 5 : manualObject.zPos -= 5; 
							break; // +
						case 189: 
							manualObject is PointCamera ? manualObject.z += 5 : manualObject.zPos += 5; 
							break; // -
					}
				}
			}
		}

		protected function createDebugAxis():void
		{
			var p0:Vertex = new Vertex(0, 0, 0);
			var lineX:Line3D = new Line3D(p0, new Vertex(500, 0, 0), new LineMaterial(0xFF0000));
			var lineY:Line3D = new Line3D(p0, new Vertex(0, 500, 0), new LineMaterial(0x00FF00));
			var lineZ:Line3D = new Line3D(p0, new Vertex(0, 0, 500), new LineMaterial(0x0000FF));
      
			renderList.push(lineX, lineY, lineZ);
		}

		protected function createDebugOutPut(textColor:Number = 0xFFFFFF):void
		{
			if(!debugTxt)
			{
				debugTxt = new TextField();
				debugTxt.width = 500;
				debugTxt.height = 40;
				debugTxt.multiline = true;
				debugTxt.defaultTextFormat = new TextFormat("Arial", 11, textColor);
				addChild(debugTxt);
			}
		}

		protected function enableManualPlacement(o:*):void
		{
			createDebugOutPut();
			manualObject = o;
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyUp);
		}

		protected function keyDown(e:KeyboardEvent):void
		{
			if(e.keyCode == Keyboard.SPACE) renderer.wireFrameMode = !renderer.wireFrameMode;
			if(e.keyCode == Keyboard.CONTROL) isAngleMode = !isAngleMode;
			downKey = e.keyCode;
		}

		protected function keyUp(e:KeyboardEvent):void
		{
			downKey = -1;
		}
	}
}