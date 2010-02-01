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
            this._Center = new Vector3D(param2.x + param1.x >> 1, param2.y + param1.y >> 1, param2.z + param1.z >> 1);
            this._Radius = Math.max(Vector3D.distance(this._Center, max), Vector3D.distance(this._Center, param1));
            
        }

        public function get center() : Vector3D
        {
            return this._Center;
        }

        public function get radius() : Number
        {
            return this._Radius;
        }

        public function set center(param1:Vector3D) : void
        {
            this._Center = param1;
            
        }

        public function set radius(param1:Number) : void
        {
            this._Radius = param1;
            
        }

    }
}
