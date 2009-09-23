package
{
	import away3dlite.core.base.Object2D;
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
	public class ExParticles extends BasicTemplate
	{
		private var particles:Vector.<Object2D>;
		private var particle:Object2D;
		private var radius:uint = 300;
		private var focusTextField:TextField;
		
		override protected function onInit():void
		{
			view.mouseEnabled = false;
			renderer.sortObjects = true;
			
			//maximum = 160
			//test = 200 @ 26fps
			var max:uint = 100;
			var i:int = max;
			
			particles = new Vector.<Object2D>(i, true);
			
			var particle:Object2D;
			var nextParticle:Object2D;
			
			while(i--)
			{
				if(false && i<10)
				{
					// Sprite
					var sprite:Sprite = new Sprite();
					var _graphics:Graphics = sprite.graphics;
					_graphics.beginFill(0xFFFFFF*Math.random(), 1);
					_graphics.drawCircle(0, 0, 10);
					_graphics.endFill();
					
					particle = new Object2D(sprite);
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
					textField.autoSize = TextFieldAutoSize.CENTER;
					textField.setTextFormat(new TextFormat("Tahoma",9));
					textField.textColor = 0xFFFFFF-textField.backgroundColor;
					textField.text = "...";
					textField.filters = [new GlowFilter(0x000000,0,0,0,0,0)];
					
					particle = new Object2D(textField);
				}
				
				particle.addEventListener(MouseEvent.MOUSE_DOWN, onMouse);
				scene.addChild(particle);
				
				particle.x = radius*Math.random()-radius*Math.random(); 
				particle.y = radius*Math.random()-radius*Math.random(); 
				particle.z = radius*Math.random()-radius*Math.random(); 
				
				if(i<max-1)
				{
					particle.nextParticle = nextParticle;
				}
				nextParticle = particle;
				
				particles[i] = particle;
			}
			
			var sphere:Sphere = new Sphere();
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
		private var step:Number=0;
		override protected function onPreRender():void
		{
			scene.rotationY++;
			/*
			camera.x = 1000*Math.cos(step);
			camera.z = -1000*Math.sin(step);
			camera.lookAt(new Vector3D(0,0,0));
			*/
			step+=.1;
			
			var particle:Object2D = particles[0];
			do{
		   		if(particle.displayObject is TextField)
		   		{
			   		var textField:TextField = TextField(particle.displayObject);
			   		//textField.alpha = 1-Math.abs(particle.position.length)/radius;
			   		if(textField!=focusTextField)
			   			textField.text = String(int(particle.screenZ));//String(particle.position.x+","+particle.position.y+","+particle.position.z);
		   		}
		   		particle = particle.nextParticle;
			}while(particle);
		}
	}
}