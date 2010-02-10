package com.cutecoma.engine3d.core.transform
{
    import flash.geom.*;
    import com.cutecoma.engine3d.core.signal.*;

    final public class TransformProxy extends SignalDispatcher
    {
        private const TRANSFORMTYPE_pROJECTION:int = 1;
        private const TRANSFORMTYPE_vIEW:int = 2;
        private const TRANSFORMTYPE_WORLD:int = 4;
        private const UPDATE_WORLD:int = 1;
        private const UPDATE_vIEW:int = 2;
        private const UPDATE_pROJECTION:int = 4;
        private const UPDATE_cAMERA:int = 8;
        private const UPDATE_oBJECT:int = 16;
        private const UPDATE_WORLDVIEW:int = 32;
        private const UPDATE_vIEWPROJECTION:int = 64;
        private var _viewportWidth:uint = 0;
        private var _viewportHeight:uint = 0;
        private var _projectionMatrix3D:Matrix3D;
        private var _viewMatrix3D:Matrix3D;
        private var _worldMatrix3D:Matrix3D;
        private var _viewMatrix3DProjection:Matrix3D;
        private var _worldMatrix3DView:Matrix3D;
        private var _objectMatrix3D:Matrix3D;
        private var _updateFlags:int = 0;
        private var _cameraPosition:Vector3D;

        public function TransformProxy()
        {
            _projectionMatrix3D = new Matrix3D();
            _viewMatrix3D = new Matrix3D();
            _worldMatrix3D = new Matrix3D();
            _viewMatrix3DProjection = new Matrix3D();
            _worldMatrix3DView = new Matrix3D();
            _objectMatrix3D = new Matrix3D();
            _cameraPosition = new Vector3D();
        }

        public function get cameraPosition() : Vector3D
        {
            var _matrix3D:Matrix3D;
            if (_updateFlags & UPDATE_cAMERA)
            {
                _matrix3D = _viewMatrix3D.clone();
                _matrix3D.invert();
                _cameraPosition = _matrix3D.transformVector(new Vector3D());
                _updateFlags = _updateFlags - UPDATE_cAMERA;
            }
            return _cameraPosition;
        }

        public function get projection() : Matrix3D
        {
            if (_updateFlags & UPDATE_pROJECTION)
            {
                _projectionMatrix3D.appendScale(_viewportWidth / 2, (-_viewportHeight) / 2, 1);
                _updateFlags = _updateFlags - UPDATE_pROJECTION;
            }
            return _projectionMatrix3D;
        }

        public function get view() : Matrix3D
        {
            return _viewMatrix3D;
        }

        public function get world() : Matrix3D
        {
            return _worldMatrix3D;
        }

        public function get worldView() : Matrix3D
        {
            if (_updateFlags & UPDATE_WORLDVIEW)
            {
                _worldMatrix3DView = _worldMatrix3D.clone();
                _worldMatrix3DView.append(_viewMatrix3D);
                _updateFlags = _updateFlags - UPDATE_WORLDVIEW;
            }
            return _worldMatrix3DView;
        }

        public function get viewProjection() : Matrix3D
        {
            if (_updateFlags & UPDATE_vIEWPROJECTION)
            {
                _viewMatrix3DProjection = _viewMatrix3D.clone();
                _viewMatrix3DProjection.append(_projectionMatrix3D);
                _updateFlags = _updateFlags - UPDATE_vIEWPROJECTION;
            }
            return _viewMatrix3DProjection;
        }

        public function get object() : Matrix3D
        {
            if (_updateFlags & UPDATE_oBJECT)
            {
                _objectMatrix3D.rawData = _worldMatrix3D.rawData;
                _objectMatrix3D.invert();
                _updateFlags = _updateFlags - UPDATE_WORLD;
            }
            return _objectMatrix3D;
        }

        public function set projection(value:Matrix3D) : void
        {
            _projectionMatrix3D = value;
            _updateFlags = _updateFlags | (UPDATE_pROJECTION | UPDATE_vIEWPROJECTION);
            dispatchSignal(new TransformSignal(TransformSignal.PROJECTION_UPDATE, _projectionMatrix3D));
        }

        public function set view(value:Matrix3D) : void
        {
            _viewMatrix3D = value;
            _updateFlags = _updateFlags | (UPDATE_vIEW | UPDATE_cAMERA | UPDATE_WORLDVIEW | UPDATE_vIEWPROJECTION);
            dispatchSignal(new TransformSignal(TransformSignal.VIEW_UPDATE, _viewMatrix3D));
        }

        public function set world(value:Matrix3D) : void
        {
            _worldMatrix3D = value;
            _updateFlags = _updateFlags | (UPDATE_WORLD | UPDATE_oBJECT | UPDATE_WORLDVIEW);
            dispatchSignal(new TransformSignal(TransformSignal.WORLD_UPDATE, _worldMatrix3D));
        }

        public function set viewportWidth(value:Number) : void
        {
            _viewportWidth = value;
        }

        public function set viewportHeight(value:Number) : void
        {
            _viewportHeight = value;
        }
    }
}