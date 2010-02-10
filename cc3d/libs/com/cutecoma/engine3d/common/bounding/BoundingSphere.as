package com.cutecoma.engine3d.common.bounding
{
    import flash.geom.*;

    final public class BoundingSphere extends BoundingBox
    {
        private var _center:Vector3D;
        private var _radius:Number = 0;

        public function BoundingSphere(param1:Vector3D, param2:Vector3D)
        {
            super(param1, param2);
            _center = new Vector3D(param2.x + param1.x >> 1, param2.y + param1.y >> 1, param2.z + param1.z >> 1);
            _radius = Math.max(Vector3D.distance(_center, max), Vector3D.distance(_center, param1));
        }

        public function get center() : Vector3D
        {
            return _center;
        }

        public function get radius() : Number
        {
            return _radius;
        }

        public function set center(value:Vector3D) : void
        {
            _center = value;
        }

        public function set radius(value:Number) : void
        {
            _radius = value;
        }
    }
}