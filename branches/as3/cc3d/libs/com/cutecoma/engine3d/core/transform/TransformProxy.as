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
            this._MProjection = new Matrix3D();
            this._MView = new Matrix3D();
            this._MWorld = new Matrix3D();
            this._MViewProjection = new Matrix3D();
            this._MWorldView = new Matrix3D();
            this._MObject = new Matrix3D();
            this._CameraPosition = new Vector3D();
            
        }

        public function get cameraPosition() : Vector3D
        {
            var _loc_1:Matrix3D = null;
            if (this._UpdateFlags & this.UPDATE_CAMERA)
            {
                _loc_1 = this._MView.clone();
                _loc_1.invert();
                this._CameraPosition = _loc_1.transformVector(new Vector3D());
                this._UpdateFlags = this._UpdateFlags - this.UPDATE_CAMERA;
            }
            return this._CameraPosition;
        }

        public function get projection() : Matrix3D
        {
            if (this._UpdateFlags & this.UPDATE_PROJECTION)
            {
                this._MProjection.appendScale(this._ViewportWidth / 2, (-this._ViewportHeight) / 2, 1);
                this._UpdateFlags = this._UpdateFlags - this.UPDATE_PROJECTION;
            }
            return this._MProjection;
        }

        public function get view() : Matrix3D
        {
            return this._MView;
        }

        public function get world() : Matrix3D
        {
            return this._MWorld;
        }

        public function get worldView() : Matrix3D
        {
            if (this._UpdateFlags & this.UPDATE_WORLDVIEW)
            {
                this._MWorldView = this._MWorld.clone();
                this._MWorldView.append(this._MView);
                this._UpdateFlags = this._UpdateFlags - this.UPDATE_WORLDVIEW;
            }
            return this._MWorldView;
        }

        public function get viewProjection() : Matrix3D
        {
            if (this._UpdateFlags & this.UPDATE_VIEWPROJECTION)
            {
                this._MViewProjection = this._MView.clone();
                this._MViewProjection.append(this._MProjection);
                this._UpdateFlags = this._UpdateFlags - this.UPDATE_VIEWPROJECTION;
            }
            return this._MViewProjection;
        }

        public function get object() : Matrix3D
        {
            if (this._UpdateFlags & this.UPDATE_OBJECT)
            {
                this._MObject.rawData = this._MWorld.rawData;
                this._MObject.invert();
                this._UpdateFlags = this._UpdateFlags - this.UPDATE_WORLD;
            }
            return this._MObject;
        }

        public function set projection(param1:Matrix3D) : void
        {
            this._MProjection = param1;
            this._UpdateFlags = this._UpdateFlags | (this.UPDATE_PROJECTION | this.UPDATE_VIEWPROJECTION);
            dispatchSignal(new TransformSignal(TransformSignal.PROJECTION_UPDATE, this._MProjection));
            
        }

        public function set view(param1:Matrix3D) : void
        {
            this._MView = param1;
            this._UpdateFlags = this._UpdateFlags | (this.UPDATE_VIEW | this.UPDATE_CAMERA | this.UPDATE_WORLDVIEW | this.UPDATE_VIEWPROJECTION);
            dispatchSignal(new TransformSignal(TransformSignal.VIEW_UPDATE, this._MView));
            
        }

        public function set world(param1:Matrix3D) : void
        {
            this._MWorld = param1;
            this._UpdateFlags = this._UpdateFlags | (this.UPDATE_WORLD | this.UPDATE_OBJECT | this.UPDATE_WORLDVIEW);
            dispatchSignal(new TransformSignal(TransformSignal.WORLD_UPDATE, this._MWorld));
            
        }

        public function set viewportWidth(param1:Number) : void
        {
            this._ViewportWidth = param1;
            
        }

        public function set viewportHeight(param1:Number) : void
        {
            this._ViewportHeight = param1;
            
        }

    }
}
