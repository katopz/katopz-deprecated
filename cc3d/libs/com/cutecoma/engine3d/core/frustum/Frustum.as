package com.cutecoma.engine3d.core.frustum
{
    import com.cutecoma.engine3d.common.math.*;
    import com.cutecoma.engine3d.core.signal.*;
    import com.cutecoma.engine3d.core.transform.*;

    public class Frustum extends Object
    {
        private var _PNear:Plane;
        private static const EPSILON:Number = 0.001;

        public function Frustum(param1:TransformProxy)
        {
            this._PNear = new Plane();
            param1.addSignalListener(TransformSignal.PROJECTION_UPDATE, this.projectionUpdateHandler);
            
        }

        public function get nearPlane() : Plane
        {
            return this._PNear;
        }

        private function projectionUpdateHandler(param1:TransformSignal) : void
        {
            var _loc_2:* = param1.transform.rawData;
            this._PNear.x = _loc_2[2];
            this._PNear.y = _loc_2[6];
            this._PNear.z = _loc_2[10];
            this._PNear.w = _loc_2[14];
            
        }

    }
}
