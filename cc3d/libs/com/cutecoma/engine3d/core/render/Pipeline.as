package com.cutecoma.engine3d.core.render
{
    
    import flash.display.*;
    import flash.geom.*;
    import com.cutecoma.engine3d.api.light.*;
    import com.cutecoma.engine3d.common.*;
    import com.cutecoma.engine3d.core.frustum.*;
    import com.cutecoma.engine3d.core.primitive.*;
    import com.cutecoma.engine3d.core.transform.*;

    public class Pipeline extends Object
    {
        protected var PROJECT:Function;
        protected const ZSORTINGMODE_BSP:int = 2;
        protected const ZSORTINGMODE_CGS:int = 4;
        protected const FILLMODE_SOLID:int = 1;
        protected const FILLMODE_WIREFRAME:int = 2;
        public var diffuse:int = 0;
        public var ambient:int = 0;
        public var specular:int = 0;
        public var bitmap:Bitmap = null;
        public var textureRepeat:Boolean = false;
        protected var _Lights:Vector.<DirectionalLight> = null;
        protected var _LightMap:BitmapData = null;
        protected var _Transform:TransformProxy = null;
        protected var _RenderStates:RenderStateProxy = null;
        protected var _Output:DisplayObjectContainer = null;
        protected var _Instructions:Vector.<IGraphicsData> = null;
        protected var _NbInstructions:int = 0;
        protected var _Layer:Sprite = null;
        protected var _Frustum:Frustum = null;
        protected var _FrustumClipping:FrustumClipping = null;

        public function Pipeline(param1:DisplayObjectContainer)
        {
            this.PROJECT = Utils3D.projectVectors;
            this._Output = param1;
            this._Transform = new TransformProxy();
            this._RenderStates = new RenderStateProxy();
            this._Instructions = new Vector.<IGraphicsData>;
            this._Frustum = new Frustum(this._Transform);
            this._FrustumClipping = new FrustumClipping(this._Frustum);
            this._Lights = new Vector.<DirectionalLight>;
            this._LightMap = new BitmapData(256, 256);
            this._LightMap.lock();
            var _loc_2:int = 0;
            while (_loc_2 <= 255)
            {
                
                this._LightMap.setPixel32(_loc_2, 0, 255 - _loc_2 << 24);
                _loc_2++;
            }
            this._LightMap.unlock();
            
        }

        public function get lights() : Vector.<DirectionalLight>
        {
            return this._Lights;
        }

        public function get transform() : TransformProxy
        {
            return this._Transform;
        }

        public function get renderStates() : RenderStateProxy
        {
            return this._RenderStates;
        }

        public function accept(param1:PrimitiveStream, param2:Sprite = null) : void
        {
            var _loc_8:Sprite = null;
            var _loc_9:IGraphicsFill = null;
            var _loc_10:Matrix3D = null;
            var _loc_11:Vector.<Number> = null;
            var _loc_12:Matrix3D = null;
            var _loc_13:Matrix3D = null;
            var _loc_14:Vector.<Vector3D> = null;
            var _loc_15:int = 0;
            var _loc_3:* = new Vector.<Number>;
            var _loc_4:* = new Vector.<Number>;
            var _loc_5:* = param1.uvData.concat();
            var _loc_6:* = param1.indices;
            var _loc_7:IGraphicsData = null;
            var _loc_16:Pipeline;
            if (this._RenderStates.zSorting != ZSorting.NONE)
            {
                _loc_6 = param1.zSorter.zSort(this._Transform.object.transformVector(this._Transform.cameraPosition), this._Frustum);
            }
            if (!_loc_6.length)
            {
                return;
            }
            this._Transform.worldView.transformVectors(param1.vertices, _loc_3);
            if (this._RenderStates.clipping)
            {
                _loc_6 = this._FrustumClipping.clipVertices(_loc_3, _loc_6, this.bitmap ? (_loc_5) : (null), this.renderStates.clipping);
            }
            if (!_loc_6.length)
            {
                return;
            }
            this.PROJECT(this._Transform.projection, _loc_3, _loc_4, _loc_5);
            if (param2 && this._NbInstructions)
            {
                _loc_8 = new Sprite();
                _loc_8.graphics.drawGraphicsData(this._Instructions);
                this._Output.addChild(_loc_8);
                this._NbInstructions = 0;
                this._Instructions.length = 0;
            }
            if (this.bitmap && this.bitmap.bitmapData)
            {
                _loc_7 = new GraphicsBitmapFill(this.bitmap.bitmapData, null, this.textureRepeat, this._RenderStates.textureSmoothing);
            }
            else
            {
                _loc_7 = new GraphicsSolidFill(this.diffuse & 16777215, 1 - (this.diffuse >> 24) / 255);
            }
            if (this._RenderStates.fillMode & this.FILLMODE_SOLID)
            {
                _loc_16 = this;
                _loc_16._NbInstructions = this._NbInstructions++;
                this._Instructions[int(this._NbInstructions++)] = _loc_7;
            }
            //if (this._RenderStates.fillMode & this.FILLMODE_WIREFRAME)
            {
                _loc_9 = new GraphicsSolidFill(this.diffuse & 16777215, 1 - (this.diffuse >> 24) / 255);
                _loc_16 = this;
                _loc_16._NbInstructions = this._NbInstructions++;
                this._Instructions[int(this._NbInstructions++)] = new GraphicsStroke(1, false, "normal", "none", "round", 3, _loc_9);
            }
            _loc_16 = this;
            _loc_16._NbInstructions = this._NbInstructions++;
            this._Instructions[int(this._NbInstructions++)] = new GraphicsTrianglePath(_loc_4, _loc_6, this.bitmap ? (_loc_5) : (null), this._RenderStates.triangleCulling);
            if (this._Lights[0].enabled && _loc_5)
            {
                _loc_10 = this._Transform.world;
                _loc_11 = new Vector.<Number>;
                _loc_12 = (this._Lights[0] as DirectionalLight).matrix;
                _loc_13 = new Matrix3D();
                _loc_14 = _loc_10.decompose();
                _loc_14[0] = new Vector3D();
                _loc_14[2] = new Vector3D(1, 1, 1);
                _loc_13.recompose(_loc_14);
                _loc_13.append(_loc_12);
                _loc_13.transformVectors(param1.normals, _loc_11);
                _loc_15 = 2;
                while (_loc_15 < _loc_11.length)
                {
                    
                    _loc_11[_loc_15] = _loc_5[_loc_15];
                    _loc_15 = _loc_15 + 3;
                }
                _loc_16 = this;
                _loc_16._NbInstructions = this._NbInstructions++;
                this._Instructions[int(this._NbInstructions++)] = new GraphicsBitmapFill(this._LightMap, null, false);
                _loc_16 = this;
                _loc_16._NbInstructions = this._NbInstructions++;
                this._Instructions[int(this._NbInstructions++)] = new GraphicsTrianglePath(_loc_4, _loc_6, _loc_11, this._RenderStates.triangleCulling);
            }
            _loc_16 = this;
            _loc_16._NbInstructions = this._NbInstructions++;
            this._Instructions[int(this._NbInstructions++)] = new GraphicsEndFill();
            if (param2)
            {
                param2.graphics.drawGraphicsData(this._Instructions);
                this._NbInstructions = 0;
                this._Instructions.length = 0;
                this._Output.addChild(param2);
            }
            
        }

        public function present() : void
        {
            var _loc_1:Sprite = null;
            if (this._NbInstructions)
            {
                _loc_1 = new Sprite();
                _loc_1.graphics.drawGraphicsData(this._Instructions);
                this._Output.addChild(_loc_1);
            }
            
        }

        public function clear() : void
        {
            while (this._Output.numChildren)
            {
                
                (this._Output.removeChildAt(0) as Sprite).graphics.clear();
            }
            this._NbInstructions = 0;
            this._Instructions.length = 0;
            
        }

    }
}
