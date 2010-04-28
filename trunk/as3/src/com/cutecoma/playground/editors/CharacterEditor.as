package com.cutecoma.playground.editors
{
	import com.blitzagency.xray.logger.util.ObjectTools;
	import com.cutecoma.playground.events.PlayerEvent;
	import fl.containers.ScrollPane;
	import fl.controls.ColorPicker;
	import fl.controls.listClasses.ImageCell;
	import fl.controls.TileList;
	import fl.containers.Window;
	import fl.controls.WindowGroup;
	import fl.data.DataProvider;
	import fl.events.ColorPickerEvent;
	import fl.events.ComponentEvent;
	import fl.events.ListEvent;
	import fl.motion.Color;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	import org.papervision3d.core.utils.InteractiveSceneManager;
	import org.papervision3d.events.FileLoadEvent;
	import org.papervision3d.events.InteractiveScene3DEvent;
	import org.papervision3d.materials.BitmapAssetMaterial;
	import org.papervision3d.materials.BitmapFileMaterial;
	import org.papervision3d.materials.ColorMaterial;
	import org.papervision3d.materials.MovieMaterial;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.objects.parsers.MD2;
	import org.papervision3d.objects.primitives.Plane;
	import org.papervision3d.Papervision3D;
	
	import com.cutecoma.playground.*;
	
	public class CharacterEditor extends Sprite
	{
		
		private var engine3D 		: Engine;
		private var rootNode		: DisplayObject3D;
		
		private var currentPlayer	: *;
		
		var model : MD2
		
		public function ModelEditor():void
		{
			
			var config = {};
				
			config.camera = {
				x : 0, y : 500, z : 500,
				zoom : 4, focus : 500
			}
			
			config.FOV = 500;
			
			config.animated = !true;
			config.interactive = true;
			config.autoClipping = !true;
			config.autoCulling = !true;
			
			engine3D = new Engine3D(this);
			engine3D.create(config);
			
			//engine3D.im = new InteractiveManager(this);
			
			rootNode = new DisplayObject3D();
			
			//engine3D.scene.addChild(rootNode);
			engine3D.scene.addChild(rootNode);
			engine3D.decoy = rootNode;
			/*
			//TODO : external player data
			var data:PlayerData = new PlayerData();
			data.act = PlayerEvent.STAND;
			data.model = "pg/model.md2";
			data.skin = "pg/skin.png";
			data.raw = "0,0";
			
			data.model = "dz/model.dae";
			
			currentPlayer = new Player();
			currentPlayer.create("",data,true,false,false);
			currentPlayer.addEventListener( PlayerEvent.COMPLETE, initPlayer );
			*/
			
			var material:ColorMaterial = new ColorMaterial(0xFF0000,0.5);
			material.doubleSided = true;
			
			currentPlayer = new Plane(material, 100, 100, 4, 4);
			
			createTools();
			createNav();
			
			engine3D.run();
			
		}
		//____________________________________________________________ Nav
		
		private function createNav() {
			var mat:ColorMaterial = new ColorMaterial(0x0000FF,0.5);
			mat.doubleSided = true;
			
			var plane = new Plane(mat , 100, 100, 10, 10 );
			plane.rotationX = -90;
			rootNode.addChild(plane);
			
			stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseHandlerPlane);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseHandlerPlane);
			
			//stage.addEventListener(MouseEvent.MOUSE_UP, mouseHandler);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseHandlerPlane);
			
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelHandler);

			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyHandler);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyHandler);
		}
		
		var _lastMouse:Point = new Point();
		var _orbiting:Boolean = false;
		var isALT:Boolean = false;
		private function keyHandler( event:KeyboardEvent ):void
		{
			
			switch(event.type) {
				case KeyboardEvent.KEY_DOWN:
					isALT = true;// event.ctrlKey || event.shiftKey
				break;
				case KeyboardEvent.KEY_UP:
					isALT = false;// event.ctrlKey || event.shiftKey
				break;
			}
		}
		
		private function mouseHandlerPlane( event:MouseEvent ):void
		{
			if(isALT){
				switch(event.type) {
					case MouseEvent.MOUSE_DOWN:
						_orbiting = true
						_lastMouse.x = event.stageX;
						_lastMouse.y = event.stageY;
					break;
					case MouseEvent.MOUSE_UP:
						_orbiting = false;
						_lastMouse.x = event.stageX;
						_lastMouse.y = event.stageY;
					break;
					case MouseEvent.MOUSE_MOVE:
						if( _orbiting){
							var dx:Number = event.stageX - _lastMouse.x;
							var dy:Number = event.stageY - _lastMouse.y;
							
							rootNode.rotationY -= dx;
							rootNode.rotationX += dy;
							
							_lastMouse.x = event.stageX;
							_lastMouse.y = event.stageY;
						}
					break;
				}
			}
			  //stage.focus = child;
			  stage.focus = this;
		}
		
		private function mouseWheelHandler( event:MouseEvent ):void
		{
			var nextZoom = engine3D.camera.zoom + event.delta
			if((nextZoom>0)&&(nextZoom<20)){
				engine3D.camera.zoom = nextZoom
			}
		}
		//____________________________________________________________ Tools
		
		var tools;
		var windows:WindowGroup
		private function createTools()
		{
			//_____________________________________________________________________ physical
			/*
			windows = new WindowGroup("panel");
			
			var skinWindow:Window = new Window();
			skinWindow.name = "skin"
			skinWindow.label = "Skin";
			skinWindow.group = windows;
			skinWindow.source = new FileBrowser();
			skinWindow.content.name = "skin"
			addChild(skinWindow)
			
			var faceWindow:Window = new Window();
			faceWindow.name = "face"
			faceWindow.label = "Face";
			faceWindow.group = windows;
			faceWindow.source = new FileBrowser();
			faceWindow.content.name = "face"
			addChild(faceWindow)
			*/
			tools = addChild(new Tools())
			tools.x = 50;
			tools.y = 50;
			
			//_____________________________________________________________________ logical
			/*
			(faceWindow.content as FileBrowser).dataProvider = new DataProvider(Config.faceDataProvider);
			(faceWindow.content as FileBrowser).tileList.addEventListener(ListEvent.ITEM_CLICK, onDraw);
			
			(skinWindow.content as FileBrowser).dataProvider = new DataProvider(Config.skinDataProvider);
			(skinWindow.content as FileBrowser).tileList.addEventListener(ListEvent.ITEM_CLICK, onDraw);
			*/
			var colorPicker:ColorPicker = tools.colorPicker;
			currentColor = colorPicker.selectedColor;
			
			//_____________________________________________________________________ event
			
			tools.header.addEventListener(MouseEvent.MOUSE_DOWN, mouseHandler);
			tools.header.addEventListener(MouseEvent.MOUSE_UP, mouseHandler);
			
			colorPicker.addEventListener(ColorPickerEvent.CHANGE, setColor);
			
			tools.faceButton.addEventListener(MouseEvent.CLICK, mouseHandler);
			tools.skinButton.addEventListener(MouseEvent.CLICK, mouseHandler);
			
		}
		var currentColor:Number=0x000000;
		private function setColor(event:ColorPickerEvent) {
			currentColor = event.color;
			//stage.focus = child;
		}
		
		var faceMaterial :BitmapFileMaterial
		var skinMaterial :BitmapFileMaterial
		
		private function onDraw( event:ListEvent ):void
		{
			var tileList:TileList = event.target as TileList;
            var renderer:ImageCell = tileList.itemToCellRenderer(event.item) as ImageCell;
			doDraw(String(renderer.source),tileList.parent.name)
		}
		private function doDraw(src:String,layerName:String):void
		{
			switch(layerName) {
				case "face":
					faceMaterial = new BitmapFileMaterial(src);
					if(!faceMaterial.bitmap){
						faceMaterial.addEventListener(FileLoadEvent.LOAD_COMPLETE, onFaceDraw);
					}else {
						draw(faceMaterial.bitmap,faceLayer)
					}
				break;
				case "skin":
					skinMaterial = new BitmapFileMaterial(src);
					if(!skinMaterial.bitmap){
						skinMaterial.addEventListener(FileLoadEvent.LOAD_COMPLETE, onSkinDraw);
					}else {
						draw(skinMaterial.bitmap,skinLayer)
					}
				break;
			}
		}
		private function onFaceDraw( event:FileLoadEvent ):void
		{
			trace("onFaceDraw")
			draw(faceMaterial.bitmap, faceLayer)
		}
		private function onSkinDraw( event:FileLoadEvent ):void
		{
			trace("onSkinDraw")
			draw(skinMaterial.bitmap, skinLayer)
		}
		private function draw(bmpData:BitmapData,layer:*) {
			trace("draw" + bmpData)
			//faceLayer.addChild(new Bitmap(bmpData))
			
			layer.graphics.clear();
			layer.graphics.beginBitmapFill(bmpData);
			layer.graphics.drawRect(0, 0, bmpData.width, bmpData.height);
			layer.graphics.endFill();
			
		}
		
		private function mouseHandler( event:MouseEvent ):void
		{
			switch(event.target) {
				
				case tools.faceButton :
					windows.selection = windows.getWindowByName("face");
					windows.selection.x = tools.x + tools.width +2
					windows.selection.y = tools.y + event.target.y
				break;
				case tools.skinButton :
					windows.selection = windows.getWindowByName("skin");
					windows.selection.x = tools.x + tools.width+2
					windows.selection.y = tools.y + event.target.y
				break;
				
				case tools.header :
					switch(event.type) {
						case MouseEvent.MOUSE_DOWN:
							material.interactive = !true;
							material.animated = !true;
							tools.startDrag();
						break;
						case MouseEvent.MOUSE_UP:
							tools.stopDrag();
							material.interactive = true;
							material.animated = true;
						break;
					}
				break;
				default :
					switch(event.type) {
						case MouseEvent.MOUSE_UP:
							tools.stopDrag();
							material.interactive = true;
							material.animated = true;
						break;
					}
				break;
			}
			
		}
		
		//____________________________________________________________ init3D
		
		var material : MovieMaterial
		var material_bmp : BitmapFileMaterial
		var tmp:Sprite
		var drawLayer:Sprite
		var faceLayer:Sprite
		var skinLayer:Sprite
		private function initPlayer(event:PlayerEvent)
		{
			//add
			currentPlayer.removeEventListener( PlayerEvent.COMPLETE, initPlayer );
			
			trace(" > initPlayer : " + currentPlayer);
			
			currentPlayer.action(PlayerEvent.STAND);
			model = currentPlayer.instance as MD2;
			
			trace(currentPlayer.extra.skin)
			
			//model.material.addEventListener(FileLoadEvent.LOAD_COMPLETE, initPlayer2);
			initPlayer2()
		}
		
		private function initPlayer2()
		{
			tmp = new Sprite();
			
			//skin = new Bitmap(model.material.bitmap)
			skinLayer = new Sprite();
			draw(new BitmapData(256,256,false,0xCCCCCC),skinLayer)
			tmp.addChild(skinLayer);
			
			faceLayer = new Sprite();
			tmp.addChild(faceLayer);
			
			drawLayer = new Sprite();
			tmp.addChild(drawLayer);
			
			material = new MovieMaterial(tmp);
			
			material.smooth = true;
			material.interactive = true;
			material.animated = true;
			
			model.setMaterial(material);
			model.addEventListener(InteractiveScene3DEvent.OBJECT_PRESS, handleMouseDown);
			model.addEventListener(InteractiveScene3DEvent.OBJECT_RELEASE, handleMouseUp);
			model.addEventListener(InteractiveScene3DEvent.OBJECT_RELEASE_OUTSIDE, handleMouseUp);
			model.addEventListener(InteractiveScene3DEvent.OBJECT_OUT, handleMouseOut);
			model.addEventListener(InteractiveScene3DEvent.OBJECT_MOVE, handleMouseMove);
			
			rootNode.addChild(currentPlayer);
		}
		
		//TODO load layer data from static player data
		var materialReady = 0
		private function initTool(event:FileLoadEvent)
		{
			//faceDataProvider
			//doDraw();
		}
		//_______________________________________________________________Mouse Events
		
		private function handleMouseUp(e:InteractiveScene3DEvent)
		{
			//trace("handleMouseUp")
			InteractiveSceneManager.MOUSE_IS_DOWN = false
		}
		
		private function handleMouseOut(e:InteractiveScene3DEvent)
		{
			//trace("handleMouseOut")
			InteractiveSceneManager.MOUSE_IS_DOWN = false
		}
		
		private function paint(x, y) {
			if(!isALT){
				if(!_orbiting){
					drawLayer.graphics.beginFill(currentColor,1);
					drawLayer.graphics.drawCircle(engine3D.im.ism.virtualMouse.x, engine3D.im.ism.virtualMouse.y, 3)
					drawLayer.graphics.endFill();
				}
			}
		}
		

		
		private function handleMouseDown(e:InteractiveScene3DEvent)
		{
			var canvas:DisplayObject3D  = e.displayObject3D as DisplayObject3D;
			if (canvas) {
				paint(engine3D.im.ism.virtualMouse.x, engine3D.im.ism.virtualMouse.y)
			}
		}
		
		private function handleMouseMove(e:InteractiveScene3DEvent)
		{
			var canvas:DisplayObject3D  = e.displayObject3D as DisplayObject3D;
			if (canvas&&InteractiveSceneManager.MOUSE_IS_DOWN){
				paint(engine3D.im.ism.virtualMouse.x, engine3D.im.ism.virtualMouse.y)
			}
		}
		
		private function onRender():void
		{
			//rootNode.rotationY+=1;
		}
	}
}
