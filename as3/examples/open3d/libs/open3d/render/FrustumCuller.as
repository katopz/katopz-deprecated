package open3d.render
{
	import flash.display.*;
	import flash.geom.Vector3D;

	/**
	 * FrustumCuller via Sphere
	 * http://www.lighthouse3d.com/opengl/viewfrustum/index.php?rimp2
	 * @author katopz
	 * TODO : cleaning
	 */
	public class FrustumCuller
	{
		private static var OUTSIDE:uint = 0;
		private static var INTERSECT:uint = 1;
		private static var INSIDE:uint = 2;
		
		// camera position
		private var cameraPosition:Vector3D;
		
		// the camera referential
		private var vX:Vector3D = Vector3D.X_AXIS;
		private var vY:Vector3D = Vector3D.Y_AXIS;
		private var vZ:Vector3D = Vector3D.Z_AXIS;
		
		private var angle:Number,nearD:Number, farD:Number;
		
		// NEW: these are the variables required to test spheres
		private var sphereFactorX:Number, sphereFactorY:Number;
		
		//private const ANG2RAD:Number = 3.14159265358979323846/180.0;
		
		private var ratio:Number;
		private var tanAngle:Number;
		
		public function FrustumCuller():void
		{
			// should be init here?
			// setCamInternals
			// setCamDef
		}
		
		public function setCamInternals(angle:Number, ratio:Number, nearD:Number, farD:Number):void
		{
			// store the information
			this.angle = angle;//angle*ANG2RAD;
			this.ratio = ratio;
			this.nearD = nearD;
			this.farD = farD;
			
			// compute width and height of the near and far plane sections
			tanAngle = Math.tan(angle);
			sphereFactorY = 1.0/Math.cos(angle);
			
			// compute half of the the horizontal field of view and sphereFactorX 
			var angleX:Number = Math.atan(tanAngle*ratio);
			sphereFactorX = 1.0/Math.cos(angleX); 
		}
		
		public function setCamDef(position:Vector3D, left:Vector3D, up:Vector3D):void
		{
			cameraPosition = position.clone();
			
			// compute the Z axis of the camera referential
			// this axis points in the same direction from 
			// the looking direction
			vZ = left.subtract(position);
			vZ.normalize();
		
			// X axis of camera with given "up" vector and Z axis
			vX = vZ.crossProduct(up);
			vX.normalize();
		
			// the real "up" vector is the dot product of X and Z
			vY = vX.crossProduct(vZ);
		}
		
		public function pointInFrustum(position:Vector3D):int
		{
			var pcz:Number, pcx:Number, pcy:Number, aux:Number;
		
			// compute vector from camera position to p
			var v:Vector3D = position.subtract(cameraPosition);
		
			// compute and test the Z coordinate
			pcz = v.dotProduct(vZ);
			if (pcz > farD || pcz < nearD)
				return OUTSIDE;
		
			// compute and test the Y coordinate
			pcy = v.dotProduct(vY);
			aux = pcz * tanAngle;
			if (pcy > aux || pcy < -aux)
				return OUTSIDE;
				
			// compute and test the X coordinate
			pcx = v.dotProduct(vX);
			aux = aux * ratio;
			if (pcx > aux || pcx < -aux)
				return OUTSIDE;
		
			return INSIDE;
		}
		
		// function to test spheres
		public function sphereInFrustum(position:Vector3D, radius:Number):int
		{
			var d:Number, az:Number, ax:Number, ay:Number;
			var result:int = INSIDE;

			var v:Vector3D = position.subtract(cameraPosition);
			
			az = v.dotProduct(vZ);
			
			if (az > farD + radius || az < nearD-radius)
				return OUTSIDE;
			
			if (az > farD - radius || az < nearD+radius)
				return INTERSECT;
			
			ay = v.dotProduct(vY);
			d = sphereFactorY * radius;
			az *= tanAngle;
			
			if (ay > az+d || ay < -az-d)
				return OUTSIDE;
			
			if (ay > az-d || ay < -az+d)
				return INTERSECT;
			
			ax = v.dotProduct(vX);
			az *= ratio;
			d = sphereFactorX * radius;
			
			if (ax > az+d || ax < -az-d)
				return OUTSIDE;
			
			if (ax > az-d || ax < -az+d)
				return INTERSECT;
		
			return result;
		}
   	}
}