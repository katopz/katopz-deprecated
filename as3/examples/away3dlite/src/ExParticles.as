package
{
	import away3dlite.core.base.Object2D;
	import away3dlite.materials.*;
	import away3dlite.primitives.*;
	import away3dlite.templates.*;
	
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
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
				/*
				var textField:Sprite = new Sprite();
				var _graphics:Graphics = textField.graphics;
				_graphics.beginFill(0xFF0000, 1);
				_graphics.drawCircle(0, 0, 10);
				_graphics.endFill();
				*/
				
				var textField:TextField = new TextField();
				textField.embedFonts = false;
				textField.antiAliasType = AntiAliasType.ADVANCED;
				textField.type = TextFieldType.INPUT;
				textField.background = true;
				textField.backgroundColor = 0xFFFFFF*Math.random();
				textField.mouseWheelEnabled = false;
				textField.tabEnabled = false;
				textField.autoSize = TextFieldAutoSize.CENTER;
				textField.text = "...";
				textField.setTextFormat(new TextFormat("Tahoma",9 , 0xFFFFFF-textField.backgroundColor));
				textField.filters = [new GlowFilter(0x000000,0,0,0,0,0)];
				
				//textField.alpha = 0;
				
				textField.addEventListener(MouseEvent.MOUSE_DOWN, onMouse);
				
				particle = new Object2D(textField);
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
		}
		
		private function onMouse(event:MouseEvent):void
		{
			//Sprite(event.target).visible = false;
			focusTextField = TextField(event.target);
		}
		
		override protected function onPreRender():void
		{
			scene.rotationY+=.5;
			
			var particle:Object2D = particles[0];
			do{
		   		var textField:TextField = TextField(particle.displayObject);
		   		//textField.alpha = 1-Math.abs(particle.position.length)/radius;
		   		if(textField!=focusTextField)
		   			textField.text = String(int(particle.screenZ));
		   		
		   		particle = particle.nextParticle;
			}while(particle);
			
		}
	}
}