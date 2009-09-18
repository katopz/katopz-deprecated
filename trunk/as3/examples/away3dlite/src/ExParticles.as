package
{
	import away3dlite.materials.*;
	import away3dlite.primitives.*;
	import away3dlite.templates.*;
	
	import flash.display.Sprite;
	
	import net.hires.debug.Stats;
	
	[SWF(backgroundColor="#000000", frameRate="30", quality="MEDIUM", width="800", height="600")]
	/**
	 * @author katopz
	 */	
	public class ExParticles extends BasicTemplate
	{
		override protected function onInit():void
		{
			var particleMaterial:Sprite = new Stats();
			
			var particle:Particle = new Particle(particleMaterial);
			scene.addChild(particle);
			
			/*
			do{
				particle = particle.next;
			}while( particle );
			*/
		}
	}
}