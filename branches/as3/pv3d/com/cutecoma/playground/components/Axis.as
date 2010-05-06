package com.cutecoma.playground.components
{
	
	import org.papervision3d.core.geom.Lines3D;
	import org.papervision3d.core.geom.Particles;
	import org.papervision3d.core.geom.renderables.Line3D;
	import org.papervision3d.core.geom.renderables.Vertex3D;
	import org.papervision3d.materials.special.LineMaterial;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.objects.special.SDLabelParticle;
	
	public class Axis extends DisplayObject3D
	{
		private var guideLine:Lines3D;
		private var particles3D:Particles;
		
		public function Axis(size:Number = 500)
		{
			super("axis");
			
			guideLine = new Lines3D(new LineMaterial(0x000000));
			
			guideLine.addLine(new Line3D(guideLine, new LineMaterial(0xFF0000, .75), 1, new Vertex3D( -size, 0, 0), new Vertex3D( size, 0, 0)));
			guideLine.addLine(new Line3D(guideLine, new LineMaterial(0x00FF00, .75), 1, new Vertex3D( 0, -size, 0), new Vertex3D( 0, size, 0)));
			guideLine.addLine(new Line3D(guideLine, new LineMaterial(0x0000FF, .75), 1, new Vertex3D( 0, 0, -size), new Vertex3D( 0, 0, size)));
			
			addChild(guideLine);
			
			particles3D = new Particles("label");
			particles3D.addParticle(new SDLabelParticle("-X", -size, 0, 0));
			particles3D.addParticle(new SDLabelParticle("X", size, 0, 0));
			
			particles3D.addParticle(new SDLabelParticle("-Y", 0, -size, 0));
			particles3D.addParticle(new SDLabelParticle("Y", 0, size, 0));
			
			particles3D.addParticle(new SDLabelParticle("-Z", 0, 0,-size));
			particles3D.addParticle(new SDLabelParticle("Z", 0, 0, size));
			
			addChild(particles3D);
		}
		
		override public function destroy():void
		{
			removeChild(guideLine);
			removeChild(particles3D);
			
			super.destroy();
		}
	}
}