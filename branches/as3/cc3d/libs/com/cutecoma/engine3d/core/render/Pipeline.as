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
            _Output = param1;
            _Transform = new TransformProxy();
            _RenderStates = new RenderStateProxy();
            _Instructions = new Vector.<IGraphicsData>;
            _Frustum = new Frustum(_Transform);
            _FrustumClipping = new FrustumClipping(_Frustum);
            _Lights = new Vector.<DirectionalLight>;
            _LightMap = new BitmapData(256, 256);
            _LightMap.lock();
            var _loc_2:int = 0;
            while (_loc_2 <= 255)
            {
                
                _LightMap.setPixel32(_loc_2, 0, 255 - _loc_2 << 24);
                _loc_2++;
            }
            _LightMap.unlock();
            
        }

        public function get lights() : Vector.<DirectionalLight>
        {
            return _Lights;
        }

        public function get transform() : TransformProxy
        {
            return _Transform;
        }

        public function get renderStates() : RenderStateProxy
        {
            return _RenderStates;
        }

        public function accept(primitiveStream:PrimitiveStream, sprite:Sprite = null) : void
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
            var _loc_5:* = primitiveStream.uvData.concat();
            var _loc_6:* = primitiveStream.indices;
            var _loc_7:IGraphicsData = null;
            var _loc_16:Pipeline;
            if (_RenderStates.zSorting != ZSorting.NONE)
            {
                _loc_6 = primitiveStream.zSorter.zSort(_Transform.object.transformVector(_Transform.cameraPosition), _Frustum);
            }
            if (!_loc_6.length)
            {
                return;
            }
            _Transform.worldView.transformVectors(primitiveStream.vertices, _loc_3);
            if (_RenderStates.clipping)
            {
                _loc_6 = _FrustumClipping.clipVertices(_loc_3, _loc_6, this.bitmap ? (_loc_5) : (null), this.renderStates.clipping);
            }
            if (!_loc_6.length)
            {
                return;
            }
            this.PROJECT(_Transform.projection, _loc_3, _loc_4, _loc_5);
            if (sprite && _NbInstructions)
            {
                _loc_8 = new Sprite();
                _loc_8.graphics.drawGraphicsData(_Instructions);
                _Output.addChild(_loc_8);
                _NbInstructions = 0;
                _Instructions.length = 0;
            }
            if (this.bitmap && this.bitmap.bitmapData)
            {
                _loc_7 = new GraphicsBitmapFill(this.bitmap.bitmapData, null, this.textureRepeat, _RenderStates.textureSmoothing);
            }
            else
            {
                _loc_7 = new GraphicsSolidFill(this.diffuse & 16777215, 1 - (this.diffuse >> 24) / 255);
            }
            if (_RenderStates.fillMode & this.FILLMODE_SOLID)
            {
                _loc_16 = this;
                _loc_16._NbInstructions = _NbInstructions++;
                _Instructions[int(_NbInstructions++)] = _loc_7;
            }
            if (_RenderStates.fillMode & this.FILLMODE_WIREFRAME)
            {
                _loc_9 = new GraphicsSolidFill(this.diffuse & 16777215, 1 - (this.diffuse >> 24) / 255);
                _loc_16 = this;
                _loc_16._NbInstructions = _NbInstructions++;
                _Instructions[int(_NbInstructions++)] = new GraphicsStroke(1, false, "normal", "none", "round", 3, _loc_9);
            }
            _loc_16 = this;
            _loc_16._NbInstructions = _NbInstructions++;
            _Instructions[int(_NbInstructions++)] = new GraphicsTrianglePath(_loc_4, _loc_6, this.bitmap ? (_loc_5) : (null), _RenderStates.triangleCulling);
            if (_Lights[0].enabled && _loc_5)
            {
                _loc_10 = _Transform.world;
                _loc_11 = new Vector.<Number>;
                _loc_12 = (_Lights[0] as DirectionalLight).matrix;
                _loc_13 = new Matrix3D();
                _loc_14 = _loc_10.decompose();
                _loc_14[0] = new Vector3D();
                _loc_14[2] = new Vector3D(1, 1, 1);
                _loc_13.recompose(_loc_14);
                _loc_13.append(_loc_12);
                _loc_13.transformVectors(primitiveStream.normals, _loc_11);
                _loc_15 = 2;
                while (_loc_15 < _loc_11.length)
                {
                    
                    _loc_11[_loc_15] = _loc_5[_loc_15];
                    _loc_15 = _loc_15 + 3;
                }
                _loc_16 = this;
                _loc_16._NbInstructions = _NbInstructions++;
                _Instructions[int(_NbInstructions++)] = new GraphicsBitmapFill(_LightMap, null, false);
                _loc_16 = this;
                _loc_16._NbInstructions = _NbInstructions++;
                _Instructions[int(_NbInstructions++)] = new GraphicsTrianglePath(_loc_4, _loc_6, _loc_11, _RenderStates.triangleCulling);
            }
            _loc_16 = this;
            _loc_16._NbInstructions = _NbInstructions++;
            _Instructions[int(_NbInstructions++)] = new GraphicsEndFill();
            if (sprite)
            {
                sprite.graphics.drawGraphicsData(_Instructions);
                _NbInstructions = 0;
                _Instructions.length = 0;
                _Output.addChild(sprite);
            }
            
        }

        public function present() : void
        {
            var _loc_1:Sprite = null;
            if (_NbInstructions)
            {
                _loc_1 = new Sprite();
                _loc_1.graphics.drawGraphicsData(_Instructions);
                _Output.addChild(_loc_1);
            }
            
        }

        public function clear() : void
        {
            while (_Output.numChildren)
            {
                
                (_Output.removeChildAt(0) as Sprite).graphics.clear();
            }
            _NbInstructions = 0;
            _Instructions.length = 0;
            
        }

    }
}
