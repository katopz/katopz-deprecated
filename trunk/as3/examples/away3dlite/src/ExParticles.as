package
{
	import away3dlite.core.base.Particle;
	import away3dlite.materials.*;
	import away3dlite.primitives.*;
	import away3dlite.templates.*;
	
	import flash.events.MouseEvent;
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
		private var particles:Vector.<Particle>;
		private var particle:Particle;
		private var radius:uint = 300;
		
		override protected function onInit():void
		{
			view.mouseEnabled = false;
			
			var max:uint = 1;
			var i:int = max;
			
			particles = new Vector.<Particle>(i, true);
			
			var particle:Particle;
			var nextParticle:Particle;
			
			while(i--)
			{
				/*
				var particleMaterial:Sprite = new Sprite();
				var _graphics:Graphics = particleMaterial.graphics;
				_graphics.beginFill(0xFF0000, 1);
				_graphics.drawCircle(0, 0, 10);
				_graphics.endFill();
				*/
				
				var particleMaterial:TextField = new TextField();
				particleMaterial.embedFonts = false;
				particleMaterial.antiAliasType = AntiAliasType.ADVANCED;
				particleMaterial.type = TextFieldType.INPUT;
				particleMaterial.background = true;
				particleMaterial.backgroundColor = 0xFFFFFF*Math.random();
				//particleMaterial.mouseEnabled = false;
				particleMaterial.mouseWheelEnabled = false;
				particleMaterial.tabEnabled = false;
				particleMaterial.autoSize = TextFieldAutoSize.CENTER;
				particleMaterial.text = "Click and Type!";
				
				particleMaterial.setTextFormat(new TextFormat("Tahoma",9 , 0xFFFFFF-particleMaterial.backgroundColor));
				
				//particleMaterial.filters = [new GlowFilter(0xFF0000,1,2,2,1)];
				
				//particleMaterial.alpha = 0;
				
				//particleMaterial.blendMode = BlendMode.ADD;
				
				//particleMaterial.addEventListener(MouseEvent.MOUSE_OVER, onOver);
				
				particle = new Particle(particleMaterial);
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
		
		private function onOver(event:MouseEvent):void
		{
			//Sprite(event.target).visible = false;
			//TextField(event.target)
		}
		
		override protected function onPreRender():void
		{
			scene.rotationY+=.5;
			
			var particle:Particle = particles[0];
			do{
		   		//particle.clip.alpha = (radius-particle.position.length)/100//int(particle.screenZ/1000 - .55);
		   		var textField:TextField = TextField(particle.clip).text; 
		   		textField = String(int(particle.screenZ));
		   		particle = particle.nextParticle;
			}while(particle);
			
		}
	}
}