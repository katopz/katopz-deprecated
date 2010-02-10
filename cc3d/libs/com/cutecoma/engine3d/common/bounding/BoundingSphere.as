package com.cutecoma.engine3d.common.bounding
{
    import flash.geom.*;

    final public class BoundingSphere extends BoundingBox
    {
        private var _Center:Vector3D = null;
        private var _Radius:Number = 0;

        public function BoundingSphere(param1:Vector3D, param2:Vector3D)
        {
            super(param1, param2);
            _Center = new Vector3D(param2.x + param1.x >> 1, param2.y + param1.y >> 1, param2.z + param1.z >> 1);
            _Radius = Math.max(Vector3D.distance(_Center, max), Vector3D.distance(_Center, param1));
            
        }

        public function get center() : Vector3D
        {
            return _Center;
        }

        public function get radius() : Number
        {
            return _Radius;
        }

        public function set center(value:Vector3D) : void
        {
            _Center = value;
            
        }

        public function set radius(value:Number) : void
        {
            _Radius = value;
            
        }

    }
}
