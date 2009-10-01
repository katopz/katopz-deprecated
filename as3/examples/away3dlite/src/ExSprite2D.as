package
{
	import away3dlite.containers.Sprite2D;
	import away3dlite.materials.*;
	import away3dlite.primitives.*;
	import away3dlite.templates.*;
	
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Vector3D;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;

	[SWF(backgroundColor="#DDDDDD",frameRate="30",quality="MEDIUM",width="800",height="600")]
	/**
	 * @author katopz
	 */
	public class ExSprite2D extends BasicTemplate
	{
		private var sprites:Vector.<Sprite2D>;
		private var sprite:Sprite2D;
		private var radius:uint = 200;
		private var focusTextField:TextField;
		private var step:Number=0;
		
		override protected function onInit():void
		{
			view.mouseEnabled = false;
			
			var max:uint = 100;
			var i:int = max;
			
			sprites = new Vector.<Sprite2D>(i, true);
			
			var sprite:Sprite2D;
			var nextParticle:Sprite2D;
			
			while(i--)
			{
				if(i<max/2)
				{
					// Sprite
					var canvas:Sprite = new Sprite();
					var _graphics:Graphics = canvas.graphics;
					_graphics.beginFill(0xFFFFFF*Math.random(), 1);
					_graphics.drawCircle(0, 0, 10);
					_graphics.endFill();
					
					sprite = new Sprite2D(canvas);
				}else{
					// TextField
					var textField:TextField = new TextField();
					textField.embedFonts = false;
					textField.antiAliasType = AntiAliasType.ADVANCED;
					textField.type = TextFieldType.INPUT;
					textField.background = true;
					textField.backgroundColor = 0xFFFFFF*Math.random();
					textField.mouseWheelEnabled = false;
					textField.tabEnabled = false;
					textField.autoSize = TextFieldAutoSize.LEFT;
					textField.setTextFormat(new TextFormat("Tahoma",9));
					textField.textColor = 0xFFFFFF-textField.backgroundColor;
					//textField.text = "...";
					//textField.filters = [new GlowFilter(0x000000,0,0,0,0,0)];
					
					sprite = new Sprite2D(textField);
				}
				
				sprite.addEventListener(MouseEvent.MOUSE_DOWN, onMouse);
				
				scene.addChild(sprite);
				
				/*
				sprite.x = radius*Math.random()-radius*Math.random(); 
				sprite.y = radius*Math.random()-radius*Math.random(); 
				sprite.z = radius*Math.random()-radius*Math.random(); 
				*/
				sprite.x = radius*Math.cos(step);//radius*Math.random()-radius*Math.random(); 
				sprite.y = -max+step*20;//radius*Math.random()-radius*Math.random(); 
				sprite.z = radius*Math.sin(step);//radius*Math.random()-radius*Math.random(); 
				
				step+=.1;
				
				sprites[i] = sprite;
			}
			
			camera.y = -1000;
			camera.lookAt(new Vector3D(0,0,0));
			
			var sphere:Sphere = new Sphere(null,100,6,6);
			scene.addChild(sphere);
		}
		
		private function onMouse(event:MouseEvent):void
		{
			if(event.target is TextField)
			{
				focusTextField = TextField(event.target);
			}else if(event.target is Sprite){
				if(event.target.filters.length>0)
				{
					event.target.filters = null;
				}else{
					event.target.filters = [new GlowFilter(0xFF0000,1,4,4,1,1)];
				}
			}
		}
		
		override protected function onPreRender():void
		{
			//scene.rotationX+=.25;
			//scene.rotationY+=.5;
			scene.rotationZ+=.25;
			
			/* TODO
			camera.x = 1000*Math.cos(step);
			//camera.y = 10*(300-mouseY);
			camera.z = 1000*Math.sin(step);
			camera.lookAt(new Vector3D(0,0,0));
			*/
			
			step+=.05;
			
			for each(var sprite:Sprite2D in sprites)
			{
		   		if(sprite.displayObject is TextField)
		   		{
			   		var textField:TextField = TextField(sprite.displayObject);
			   		//textField.alpha = 1-Math.abs(sprite.position.length)/radius;
			   		if(textField!=focusTextField)
			   			textField.text = String(int(sprite.screenZ));//String(sprite.position.x+","+sprite.position.y+","+sprite.position.z);
		   		}
			}
		}
	}
}