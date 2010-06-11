package away3dlite.sprites
{
	import away3dlite.core.base.Particle;
	
	use namespace arcane;
	
	public class ParticleClip extends Particle
	{
		public function ParticleClip(x:Number, y:Number, z:Number, material:ParticleMaterial, smooth:Boolean = true)
		{
			super(x, y, z, material, smooth);
		}
	}
}