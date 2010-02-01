package com.cutecoma.engine3d.core.signal
{
    import flash.geom.*;

    public class TransformSignal extends Signal
    {
        private var _Transform:Matrix3D = null;
        public static const WORLD_UPDATE:String = "transformsignal.worldupdate";
        public static const VIEW_UPDATE:String = "transformsignal.viewupdate";
        public static const PROJECTION_UPDATE:String = "transformsignal.projectionupdate";

        public function TransformSignal(param1:String, param2:Matrix3D)
        {
            super(param1);
            this._Transform = param2;
            
        }

        public function get transform() : Matrix3D
        {
            return this._Transform;
        }

    }
}
