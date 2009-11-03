package org.papervision3d.objects.special{	import com.sleepydesign.text.SDTextField;
	
	import org.papervision3d.core.geom.renderables.Particle;
	import org.papervision3d.materials.special.SDParticleMaterial;		public class SDLabelParticle extends Particle	{		public var label:SDTextField;				public function SDLabelParticle(text:String, x:Number, y:Number, z:Number)		{			label = new SDTextField(text);			//label.filters = [new GlowFilter(0xFFFFFF,1,2,2,4)]			var spm:SDParticleMaterial = new SDParticleMaterial(label); 			super(spm, 1, x, y, z);		}	}}