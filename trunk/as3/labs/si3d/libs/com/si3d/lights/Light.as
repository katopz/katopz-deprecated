package com.si3d.lights
{
	import com.si3d.geom.Point3D;
	
	import flash.display.*;
	import flash.geom.*;
	
	public class Light extends Point3D
	{
		public var halfVector:Vector3D=new Vector3D();

		/** constructor (set position) */
		function Light(x:Number=1, y:Number=1, z:Number=1)
		{
			super(x, y, z, 0);
			normalize();
			setPosition(x, y, z);
		}

		/** projection */
		public function transformBy(matrix:Matrix3D):void
		{
			world=matrix.deltaTransformVector(this);
			halfVector.x=world.x;
			halfVector.y=world.y;
			halfVector.z=world.z + 1;
			halfVector.normalize();
		}
		
	    private var _direction:Vector3D = new Vector3D();
	    public function get direction()  : Vector3D { return _direction; }
	    
	    /** set position */
	    public function setPosition(x:Number, y:Number, z:Number) : void {
	        _direction.x = x;
	        _direction.y = y;
	        _direction.z = z; 
	        _direction.normalize();
	        halfVector.x = _direction.x;
	        halfVector.y = _direction.y;
	        halfVector.z = _direction.z + 1; 
	        halfVector.normalize();
	    }
	}
}