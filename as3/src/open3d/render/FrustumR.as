package open3d.render
{
	import flash.display.*;
	import flash.geom.Vector3D;

	/**
	 * http://www.lighthouse3d.com/opengl/viewfrustum/index.php?rimp2
	 * @author katopz
	 */
	public class FrustumR
	{
		public var totalFaces:int = 0;
		
		public static var OUTSIDE:uint = 0;
		public static var INTERSECT:uint = 1;
		public static var INSIDE:uint = 2;
		
		public var cc:Vector3D; // camera position
		
		// the camera referential
		public var vX:Vector3D = Vector3D.X_AXIS;
		public var vY:Vector3D = Vector3D.Y_AXIS;
		public var vZ:Vector3D = new Vector3D(0,0,-1);
		
		public var nearD:Number, farD:Number, width:Number, height:Number;
		
		// NEW: these are the variables required to test spheres
		public var sphereFactorX:Number, sphereFactorY:Number;
		
		private const ANG2RAD:Number = 3.14159265358979323846/180.0;
		
		private var ratio:Number;
		private var tang:Number;
		
		public function setCamInternals(angle:Number, ratio:Number, nearD:Number, farD:Number):void
		{
			// store the information
			this.ratio = ratio;
			this.nearD = nearD;
			this.farD = farD;
			
			angle = angle*ANG2RAD;
			
			// compute width and height of the near and far plane sections
			tang = Math.tan(angle);
			sphereFactorY = 1.0/Math.cos(angle);
			
			// compute half of the the horizontal field of view and sphereFactorX 
			var angleX:Number = Math.atan(tang*ratio);
			sphereFactorX = 1.0/Math.cos(angleX); 
		}
		
		public function setCamDef(p:Vector3D, l:Vector3D, u:Vector3D):void
		{
			cc = p.clone();
			
			// compute the Z axis of the camera referential
			// this axis points in the same direction from 
			// the looking direction
			vZ = l.subtract(p);
			vZ.normalize();
		
			// X axis of camera with given "up" vector and Z axis
			vX = vZ.crossProduct(u);
			vX.normalize();
		
			// the real "up" vector is the dot product of X and Z
			vY = vX.crossProduct(vZ);
		}
		
		public function pointInFrustum(p:Vector3D):int
		{
			var pcz:Number,pcx:Number,pcy:Number,aux:Number;
		
			// compute vector from camera position to p
			var v:Vector3D = p.subtract(cc);
		
			// compute and test the Z coordinate
			pcz = v.dotProduct(vZ);
			if (pcz > farD || pcz < nearD)
				return OUTSIDE;
		
			// compute and test the Y coordinate
			pcy = v.dotProduct(vY);
			aux = pcz * tang;
			if (pcy > aux || pcy < -aux)
				return OUTSIDE;
				
			// compute and test the X coordinate
			pcx = v.dotProduct(vX);
			aux = aux * ratio;
			if (pcx > aux || pcx < -aux)
				return OUTSIDE;
		
			return INSIDE;
		}
		
		// NEW: function to test spheres
		public function sphereInFrustum(p:Vector3D, radius:Number):int
		{
			var d:Number;
			var az:Number, ax:Number, ay:Number;
			var result:int = INSIDE;

			var v:Vector3D = p.subtract(cc);
			
			az = v.dotProduct(vZ);
			
			if (az > farD + radius || az < nearD-radius)
				return OUTSIDE;
			
			if (az > farD - radius || az < nearD+radius)
				result = INTERSECT;
			
			ay = v.dotProduct(vY);
			d = sphereFactorY * radius;
			az *= tang;
			if (ay > az+d || ay < -az-d)
				return OUTSIDE;
			if (ay > az-d || ay < -az+d)
				result = INTERSECT;
			
			ax = v.dotProduct(vX);
			az *= ratio;
			d = sphereFactorX * radius;
			if (ax > az+d || ax < -az-d)
				return OUTSIDE;
			if (ax > az-d || ax < -az+d)
				result = INTERSECT;
		
			return result;
		}
		
		public function FrustumR():void
		{
			
		}
   	}
}