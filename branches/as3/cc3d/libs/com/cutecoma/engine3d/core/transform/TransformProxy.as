package com.cutecoma.engine3d.core.transform
{
    import flash.geom.*;
    import com.cutecoma.engine3d.core.signal.*;

    final public class TransformProxy extends SignalDispatcher
    {
        private const TRANSFORMTYPE_PROJECTION:int = 1;
        private const TRANSFORMTYPE_VIEW:int = 2;
        private const TRANSFORMTYPE_WORLD:int = 4;
        private const UPDATE_WORLD:int = 1;
        private const UPDATE_VIEW:int = 2;
        private const UPDATE_PROJECTION:int = 4;
        private const UPDATE_CAMERA:int = 8;
        private const UPDATE_OBJECT:int = 16;
        private const UPDATE_WORLDVIEW:int = 32;
        private const UPDATE_VIEWPROJECTION:int = 64;
        private var _ViewportWidth:uint = 0;
        private var _ViewportHeight:uint = 0;
        private var _MProjection:Matrix3D;
        private var _MView:Matrix3D;
        private var _MWorld:Matrix3D;
        private var _MViewProjection:Matrix3D;
        private var _MWorldView:Matrix3D;
        private var _MObject:Matrix3D;
        private var _UpdateFlags:int = 0;
        private var _CameraPosition:Vector3D;

        public function TransformProxy()
        {
            _MProjection = new Matrix3D();
            _MView = new Matrix3D();
            _MWorld = new Matrix3D();
            _MViewProjection = new Matrix3D();
            _MWorldView = new Matrix3D();
            _MObject = new Matrix3D();
            _CameraPosition = new Vector3D();
        }

        public function get cameraPosition() : Vector3D
        {
            var _loc_1:Matrix3D = null;
            if (_UpdateFlags & this.UPDATE_CAMERA)
            {
                _loc_1 = _MView.clone();
                _loc_1.invert();
                _CameraPosition = _loc_1.transformVector(new Vector3D());
                _UpdateFlags = _UpdateFlags - this.UPDATE_CAMERA;
            }
            return _CameraPosition;
        }

        public function get projection() : Matrix3D
        {
            if (_UpdateFlags & this.UPDATE_PROJECTION)
            {
                _MProjection.appendScale(_ViewportWidth / 2, (-_ViewportHeight) / 2, 1);
                _UpdateFlags = _UpdateFlags - this.UPDATE_PROJECTION;
            }
            return _MProjection;
        }

        public function get view() : Matrix3D
        {
            return _MView;
        }

        public function get world() : Matrix3D
        {
            return _MWorld;
        }

        public function get worldView() : Matrix3D
        {
            if (_UpdateFlags & this.UPDATE_WORLDVIEW)
            {
                _MWorldView = _MWorld.clone();
                _MWorldView.append(_MView);
                _UpdateFlags = _UpdateFlags - this.UPDATE_WORLDVIEW;
            }
            return _MWorldView;
        }

        public function get viewProjection() : Matrix3D
        {
            if (_UpdateFlags & this.UPDATE_VIEWPROJECTION)
            {
                _MViewProjection = _MView.clone();
                _MViewProjection.append(_MProjection);
                _UpdateFlags = _UpdateFlags - this.UPDATE_VIEWPROJECTION;
            }
            return _MViewProjection;
        }

        public function get object() : Matrix3D
        {
            if (_UpdateFlags & this.UPDATE_OBJECT)
            {
                _MObject.rawData = _MWorld.rawData;
                _MObject.invert();
                _UpdateFlags = _UpdateFlags - this.UPDATE_WORLD;
            }
            return _MObject;
        }

        public function set projection(value:Matrix3D) : void
        {
            _MProjection = value;
            _UpdateFlags = _UpdateFlags | (this.UPDATE_PROJECTION | this.UPDATE_VIEWPROJECTION);
            dispatchSignal(new TransformSignal(TransformSignal.PROJECTION_UPDATE, _MProjection));
        }

        public function set view(value:Matrix3D) : void
        {
            _MView = value;
            _UpdateFlags = _UpdateFlags | (this.UPDATE_VIEW | this.UPDATE_CAMERA | this.UPDATE_WORLDVIEW | this.UPDATE_VIEWPROJECTION);
            dispatchSignal(new TransformSignal(TransformSignal.VIEW_UPDATE, _MView));
        }

        public function set world(value:Matrix3D) : void
        {
            _MWorld = value;
            _UpdateFlags = _UpdateFlags | (this.UPDATE_WORLD | this.UPDATE_OBJECT | this.UPDATE_WORLDVIEW);
            dispatchSignal(new TransformSignal(TransformSignal.WORLD_UPDATE, _MWorld));
        }

        public function set viewportWidth(value:Number) : void
        {
            _ViewportWidth = value;
        }

        public function set viewportHeight(value:Number) : void
        {
            _ViewportHeight = value;
        }
    }
}