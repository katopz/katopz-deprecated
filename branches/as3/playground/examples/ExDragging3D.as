package examples
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	import flash.ui.Mouse;
	
	import com.greensock.TweenLite;
	
	import org.papervision3d.cameras.CameraType;
	import org.papervision3d.core.geom.Lines3D;
	import org.papervision3d.core.geom.renderables.Vertex3D;
	import org.papervision3d.core.math.Number3D;
	import org.papervision3d.core.math.Plane3D;
	import org.papervision3d.core.math.Quaternion;
	import org.papervision3d.materials.BitmapMaterial;
	import org.papervision3d.materials.MovieMaterial;
	import org.papervision3d.materials.special.LineMaterial;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.objects.primitives.Plane;
	import org.papervision3d.objects.primitives.Sphere;
	import org.papervision3d.view.BasicView;
	import org.papervision3d.view.layer.ViewportLayer;
	import org.papervision3d.view.layer.util.ViewportLayerSortMode;

	[SWF(backgroundColor="0xFFFFFF", frameRate="31")]
	public class ExDragging3D extends Sprite
	{
		public var v:BasicView;
		public var dragObject:Sphere;
		public var dragLine:Lines3D;
		
		private var vx:Number = 0;
		private var vy:Number = 0;
		private var vz:Number = 0;
		
		[Embed(source="default.jpg")]
		public var texture:Class;
		
		[Embed(systemFont='Verdana', fontName="Font", mimeType="application/x-font-truetype", unicodeRange="U+0061-U+007A")]
		private var font:Class;
 		
		public var shadowPlane:Plane;		
		public var isDragging:Boolean = false;
		
		private var txt:TextField;
		public var plane:Plane3D;
		
		public var radius:Number = 150;
		
		public var hotspot:Plane;
		
		public function ExDragging3D()
		{
			stage.quality = "medium";
			stage.scaleMode = "noScale";
			stage.align = "tl";
			
			v = new BasicView(0, 0, true, false, CameraType.FREE);
			addChild(v);
			
			v.camera.zoom = 11;
			v.camera.focus = 100;
			v.camera.z = -2000;
			v.camera.y = 900;
			v.camera.lookAt(new DisplayObject3D());
			
			var bmat:BitmapMaterial = new BitmapMaterial(Bitmap(new texture()).bitmapData, true);
			bmat.tiled  =true;
			bmat.smooth = true;
			
			dragObject = new Sphere(bmat, radius, 18, 16);
			dragObject.x = -2000;
			v.scene.addChild(dragObject);
			var vpl:ViewportLayer = v.viewport.getChildLayer(dragObject);
			vx = -40;
			
			var c:Sprite = new Sprite();
			c.graphics.beginFill(0xFF0000,.5);
			c.graphics.drawCircle(300,300,200);
			c.graphics.endFill();
			addChild(c);
			
			c.addEventListener(MouseEvent.MOUSE_DOWN, onStartDrag);
			stage.addEventListener(MouseEvent.MOUSE_UP, onStopDrag);
			
			dragLine = new Lines3D(new LineMaterial(0xFF0000, 0.4));
			dragLine.addNewLine(0.25, 0, 0, 0, 100, 100, 100);
			v.scene.addChild(dragLine);
			v.viewport.getChildLayer(dragLine);
			dragLine.visible = false;
		
			createShadow();
			createHotspot();
			/*  var stats:StatsView = new StatsView(v.renderer);
			addChild(stats);*/
			
			plane = new Plane3D();
			plane.setNormalAndPoint(new Number3D(0, 1, 0), new Number3D(0, 0, 0));
			  
			showInstructions();
			
			v.viewport.containerSprite.sortMode = ViewportLayerSortMode.INDEX_SORT;
			
			
		//uncomment this if you want to play with vertical as well
		
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp); 
			
			addEventListener(Event.ENTER_FRAME, tick);
		}
		
		
		 private function onKeyDown(e:KeyboardEvent):void{
			if(e.keyCode == Keyboard.CONTROL){
				//trace("control key");
				plane.setNormalAndPoint(new Number3D(0, 0, 1), new Number3D(dragObject.x, dragObject.y, dragObject.z));
			}
		}
		
		private function onKeyUp(e:KeyboardEvent):void{
			if(e.keyCode == Keyboard.CONTROL){
				//trace("let go");
				plane.setNormalAndPoint(new Number3D(0, 1, 0), new Number3D(0, 0, 0));
			}
		} 
		
		
		private function showInstructions():void{
			txt = new TextField();
			txt.autoSize = TextFieldAutoSize.LEFT;
			txt.text = "click and drag";
			txt.antiAliasType = AntiAliasType.ADVANCED;
			txt.textColor = 0x202020;
			var tf:TextFormat = new TextFormat("Font", 14, 0x303030, true);
			txt.setTextFormat(tf);
			txt.embedFonts = true;
			v.viewport.containerSprite.addChild(txt);
			
			txt.alpha = 0;
			txt.x = 56;
					
			txt.selectable = false;
			TweenLite.to(txt, 4, {alpha:1, delay:4}); 
			
		}
		
		private function hideInstructions():void{
			if(txt.visible)
				TweenLite.to(txt, 2, {alpha:0, delay:0.25, onComplete:hideComplete});
		}
		
		private function hideComplete():void{
			txt.visible = false;	
		}
		
		public function onStartDrag(e:MouseEvent):void{
			TweenLite.to(hotspot.container, 4,{alpha:1});
			hideInstructions();
			isDragging = true;
			dragLine.visible =true;
			Mouse.hide();
		}
		
		public function onStopDrag(e:MouseEvent):void{
			TweenLite.to(hotspot.container,4, {alpha:0,delay:2.5});
			isDragging = false;
			dragLine.visible = false;
			Mouse.show();
		}
		
		public function createShadow():void{
			var floorSprite:Sprite = new Sprite();
			floorSprite.graphics.beginFill(0xdddddd, 0);
			floorSprite.graphics.drawRect(0, 0, 400, 400);
			floorSprite.graphics.endFill();
			
			var shadow:Sprite = new Sprite();
			shadow.graphics.beginFill(0x101010, 1);
			shadow.graphics.drawCircle(0, 0, 100);
			shadow.graphics.endFill();
			floorSprite.addChild(shadow);
			
			shadow.filters = [new BlurFilter(30, 30, 8)];
			shadow.x = 200;
			shadow.y = 200;
			
			shadowPlane = new Plane(new MovieMaterial(floorSprite, true, false, true), 500, 500, 1, 1);
			shadowPlane.pitch(90);
			v.scene.addChild(shadowPlane);
			//shadowPlane.y = -radius;
			v.viewport.getChildLayer(shadowPlane);
			v.viewport.getChildLayer(shadowPlane).layerIndex = -1;
		}


		public function createHotspot():void{
			var floorSprite:Sprite = new Sprite();
			floorSprite.graphics.beginFill(0xdddddd, 0);
			floorSprite.graphics.drawRect(0, 0, 400, 400);
			floorSprite.graphics.endFill();
			
			var shadow:Sprite = new Sprite();
			shadow.graphics.beginFill(0x4463F7, 1);
			shadow.graphics.drawCircle(0, 0, 100);
			shadow.graphics.endFill();
			floorSprite.addChild(shadow);
			
			shadow.filters = [new BlurFilter(30, 30, 8)];
			shadow.x = 200;
			shadow.y = 200;
			
			hotspot = new Plane(new MovieMaterial(floorSprite, true, false, true), 100, 100, 1, 1);
			hotspot.pitch(90);
			v.scene.addChild(hotspot);
			//hotspot.y = -radius;
			
			v.viewport.getChildLayer(hotspot).alpha = 0;
			v.viewport.getChildLayer(hotspot).layerIndex = -5;
			
			
		}
		
		private function updateLine(pt:Number3D, obj:DisplayObject3D):void{
			
			var v0:Vertex3D = dragLine.geometry.vertices[0];
			var v1:Vertex3D = dragLine.geometry.vertices[1];
			
			var ang:Number = Math.atan2(obj.z-pt.z, obj.x-pt.x);
			var offsetX:Number = Math.cos(ang)*radius;
			var offsetZ:Number = Math.sin(ang)*radius;
			
			v0.x = pt.x;
			v0.y = pt.y;
			v0.z = pt.z;
			
			v1.x = obj.x-offsetX;
			v1.y = obj.y;
			v1.z = obj.z-offsetZ;

		}
		
		public function tick(e:Event):void{
			
			
			if(isDragging){
				
				//update camera position
				var cameraPosition:Number3D = new Number3D(v.camera.x, v.camera.y, v.camera.z);

				//get the direction vector of the mouse position
				var ray:Number3D = v.camera.unproject(v.viewport.containerSprite.mouseX, v.viewport.containerSprite.mouseY);
				
				//convert ray to a 3d point in the ray direction from the camera
				ray = Number3D.add(ray, cameraPosition);
				
				//find the intersection of the line defined by the camera and the ray position with the plane3D
				var intersect:Number3D = plane.getIntersectionLineNumbers(cameraPosition, ray);
				
				//find distance to object and add to velocity
				vx += (dragObject.x-intersect.x)/1200;
				vy += (dragObject.y-intersect.y)/100;
				vz += (dragObject.z-intersect.z)/1200;
				
				//move our hotspot
				hotspot.x -= (hotspot.x - intersect.x)/4;
				hotspot.z -= (hotspot.z - intersect.z)/4;

			}
			
			//gravity if you turn on vertical planes (see key handlers above)
			vy += 2.6;
			
			//ease the velocity
			vx *= 0.98;
			vy *= 0.94;
			vz *= 0.98;
			
			dragObject.x -= vx;
			dragObject.y -= vy;
			dragObject.z -= vz;
			
			if(dragObject.y < 0){
				vy *= -1;
				dragObject.y = 0;
			}
			
			rollMe(vx, vy, vz);
			
			//debugging if you want it...
			if(dragLine.visible && isDragging)
				updateLine(intersect, dragObject);
			
			shadowPlane.x = dragObject.x;
			shadowPlane.z = dragObject.z;
			
			v.singleRender();		
			
		}
		
		
		private function rollMe(vx:Number, vy:Number, vz:Number):void{
		
			var pos:Number3D = new Number3D(dragObject.x, dragObject.y, dragObject.z);
			var dif:Number3D = new Number3D(-vx, -vy, -vz);
			var dist:Number = Math.sqrt(dif.x*dif.x+dif.z*dif.z);
					
			//find the cross of the up axis with the direction vector
			var rotAxis:Number3D = Number3D.cross(dif, new Number3D(0, 1, 0));
			rotAxis.normalize();
			
			//rotate around that axis by how long the direction vector is relative to the radius
			var rotation:Quaternion = Quaternion.createFromAxisAngle(rotAxis.x, rotAxis.y, rotAxis.z, dist);
			rotation.normalize();
			
			dragObject.transform.calculateMultiply3x3(rotation.matrix, dragObject.transform);
			
		}
	}
}
