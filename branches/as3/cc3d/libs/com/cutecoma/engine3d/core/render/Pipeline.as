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
        protected const PROJECT:Function = Utils3D.projectVectors;
        
        protected const ZSORTINGMODE_bSP:int = 2;
        protected const ZSORTINGMODE_cGS:int = 4;
        protected const FILLMODE_SOLID:int = 1;
        protected const FILLMODE_WIREFRAME:int = 2;
        
        public var diffuse:int = 0;
        public var ambient:int = 0;
        public var specular:int = 0;
        public var bitmap:Bitmap;
        public var textureRepeat:Boolean = false;
        
        protected var _lights:Vector.<DirectionalLight>;
        protected var _lightMap:BitmapData;
        protected var _transform:TransformProxy;
        protected var _renderStates:RenderStateProxy;
        protected var _output:DisplayObjectContainer;
        protected var _instructions:Vector.<IGraphicsData>;
        protected var _nbInstructions:int = 0;
        protected var _layer:Sprite;
        protected var _frustum:Frustum;
        protected var _frustumClipping:FrustumClipping;

        public function Pipeline(displayObjectContainer:DisplayObjectContainer)
        {
            _output = displayObjectContainer;
            _transform = new TransformProxy();
            _renderStates = new RenderStateProxy();
            _instructions = new Vector.<IGraphicsData>;
            _frustum = new Frustum(_transform);
            _frustumClipping = new FrustumClipping(_frustum);
            _lights = new Vector.<DirectionalLight>;
            _lightMap = new BitmapData(256, 256);
            _lightMap.lock();
            var _loc_2:int = 0;
            
            while (_loc_2 <= 255)
            {
                _lightMap.setPixel32(_loc_2, 0, 255 - _loc_2 << 24);
                _loc_2++;
            }
            _lightMap.unlock();
        }

        public function get lights() : Vector.<DirectionalLight>
        {
            return _lights;
        }

        public function get transform() : TransformProxy
        {
            return _transform;
        }

        public function get renderStates() : RenderStateProxy
        {
            return _renderStates;
        }

        public function accept(primitiveStream:PrimitiveStream, sprite:Sprite = null) : void
        {
            var _loc_8:Sprite;
            var _loc_9:IGraphicsFill;
            var _loc_10:Matrix3D;
            var _loc_11:Vector.<Number>;
            var _loc_12:Matrix3D;
            var _loc_13:Matrix3D;
            var _loc_14:Vector.<Vector3D>;
            var _loc_15:int = 0;
            var _loc_3:Vector.<Number> = new Vector.<Number>;
            var _vertices:Vector.<Number> = new Vector.<Number>;
            var _loc_5:Vector.<Number> = primitiveStream.uvData.concat();
            var _indices:Vector.<int> = primitiveStream.indices;
            var _loc_7:IGraphicsData;
            var _pipeline:Pipeline;
            if (_renderStates.zSorting != ZSorting.NONE)
                _indices = primitiveStream.zSorter.zSort(_transform.object.transformVector(_transform.cameraPosition), _frustum);
            
            if (!_indices.length)
                return;
            
            _transform.worldView.transformVectors(primitiveStream.vertices, _loc_3);
            
            if (_renderStates.clipping)
                _indices = _frustumClipping.clipVertices(_loc_3, _indices, bitmap ? (_loc_5) : (null), this.renderStates.clipping);
            
            if (!_indices.length)
                return;
            
            this.PROJECT(_transform.projection, _loc_3, _vertices, _loc_5);
            if (sprite && _nbInstructions)
            {
                _loc_8 = new Sprite();
                _loc_8.graphics.drawGraphicsData(_instructions);
                _output.addChild(_loc_8);
                _nbInstructions = 0;
                _instructions.length = 0;
            }
            if (bitmap && bitmap.bitmapData)
            {
                _loc_7 = new GraphicsBitmapFill(bitmap.bitmapData, null, this.textureRepeat, _renderStates.textureSmoothing);
            }
            else
            {
                _loc_7 = new GraphicsSolidFill(this.diffuse & 16777215, 1 - (this.diffuse >> 24) / 255);
            }
            if (_renderStates.fillMode & this.FILLMODE_SOLID)
            {
                _pipeline = this;
                _pipeline._nbInstructions = _nbInstructions++;
                _instructions[int(_nbInstructions++)] = _loc_7;
            }
            if (_renderStates.fillMode & this.FILLMODE_WIREFRAME)
            {
                _loc_9 = new GraphicsSolidFill(this.diffuse & 16777215, 1 - (this.diffuse >> 24) / 255);
                _pipeline = this;
                _pipeline._nbInstructions = _nbInstructions++;
                _instructions[int(_nbInstructions++)] = new GraphicsStroke(1, false, "normal", "none", "round", 3, _loc_9);
            }
            _pipeline = this;
            _pipeline._nbInstructions = _nbInstructions++;
            _instructions[int(_nbInstructions++)] = new GraphicsTrianglePath(_vertices, _indices, bitmap ? (_loc_5) : (null), _renderStates.triangleCulling);
            if (_lights[0].enabled && _loc_5)
            {
                _loc_10 = _transform.world;
                _loc_11 = new Vector.<Number>;
                _loc_12 = (_lights[0] as DirectionalLight).matrix;
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
                _pipeline = this;
                _pipeline._nbInstructions = _nbInstructions++;
                _instructions[int(_nbInstructions++)] = new GraphicsBitmapFill(_lightMap, null, false);
                _pipeline = this;
                _pipeline._nbInstructions = _nbInstructions++;
                _instructions[int(_nbInstructions++)] = new GraphicsTrianglePath(_vertices, _indices, _loc_11, _renderStates.triangleCulling);
            }
            _pipeline = this;
            _pipeline._nbInstructions = _nbInstructions++;
            _instructions[int(_nbInstructions++)] = new GraphicsEndFill();
            if (sprite)
            {
                sprite.graphics.drawGraphicsData(_instructions);
                _nbInstructions = 0;
                _instructions.length = 0;
                _output.addChild(sprite);
            }
        }

        public function present() : void
        {
            var _sprite:Sprite;
            if (_nbInstructions)
            {
                _sprite = new Sprite();
                _sprite.graphics.drawGraphicsData(_instructions);
                _output.addChild(_sprite);
            }
        }

        public function clear() : void
        {
            while (_output.numChildren)
                (_output.removeChildAt(0) as Sprite).graphics.clear();
            _nbInstructions = 0;
            _instructions.length = 0;
        }
    }
}