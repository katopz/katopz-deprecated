package
{
	import away3dlite.core.base.Particle;
	import away3dlite.materials.*;
	import away3dlite.primitives.*;
	import away3dlite.templates.*;
	
	import flash.display.BlendMode;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	[SWF(backgroundColor="#000000",frameRate="30",quality="MEDIUM",width="800",height="600")]
	/**
	 * @author katopz
	 */
	public class ExParticles extends BasicTemplate
	{
		private var particles:Vector.<Particle>;
		private var particle:Particle;
		private var radius:uint = 200;
		
		override protected function onInit():void
		{
			var max:uint = 10;
			var i:int = max;
			
			particles = new Vector.<Particle>(i, true);
			
			var particle:Particle;
			var nextParticle:Particle;
			
			while(i--)
			{
				var particleMaterial:Sprite = new Sprite();
				var _graphics:Graphics = particleMaterial.graphics;
				_graphics.lineStyle(2,0xFFFFFF,.75);
				_graphics.beginFill(0xFF0000, 1);
				_graphics.drawCircle(0, 0, 20);
				_graphics.endFill();
				
				//particleMaterial.alpha = 0;
				
				//particleMaterial.blendMode = BlendMode.ADD;
				
				particleMaterial.addEventListener(MouseEvent.MOUSE_OVER, onOver);
				
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
			Sprite(event.target).visible = false;
		}
		
		override protected function onPreRender():void
		{
			scene.rotationY++;
			
			var particle:Particle = particles[0];
			do{
		   		//particle.clip.alpha = (radius-particle.position.length)/100//int(particle.screenZ/1000 - .55);
		   		particle = particle.nextParticle;
			}while(particle);
			
		}
	}
}