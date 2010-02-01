package com.cutecoma.engine3d.api.mesh
{
    
    import flash.display.*;
    import com.cutecoma.engine3d.api.*;
    import com.cutecoma.engine3d.common.*;
    import com.cutecoma.engine3d.common.bounding.*;
    import com.cutecoma.engine3d.common.vertex.*;
    import com.cutecoma.engine3d.core.bsp.*;

    public class BaseMesh extends Object implements IClonable
    {
        protected const TRIANGLELIST:Number = 1;
        protected var _Name:String = null;
        private var _VertexBuffer:Vector.<Vertex> = null;
        private var _Subsets:Vector.<Vector.<int>>;
        private var _BSphere:BoundingSphere = null;

        public function BaseMesh(param1:Vector.<Vertex> = null, param2:Vector.<Vector.<int>> = null)
        {
            this._Subsets = new Vector.<Vector.<int>>;
            this._VertexBuffer = param1;
            if (param2 && param2.length)
            {
                this._Subsets = this._Subsets.concat(param2);
            }
            
        }

        public function set name(param1:String) : void
        {
            this._Name = param1;
            
        }

        public function set vertexBuffer(param1:Vector.<Vertex>) : void
        {
            this._VertexBuffer = param1;
            
        }

        public function set subsets(param1:Vector.<Vector.<int>>) : void
        {
            this._Subsets = param1;
            
        }

        public function set boundingSphere(param1:BoundingSphere) : void
        {
            this._BSphere = param1;
            
        }

        public function get name() : String
        {
            return this._Name;
        }

        public function get vertexBuffer() : Vector.<Vertex>
        {
            return this._VertexBuffer;
        }

        public function get subsets() : Vector.<Vector.<int>>
        {
            return this._Subsets;
        }

        public function get boundingSphere() : BoundingSphere
        {
            return this._BSphere;
        }

        public function draw(param1:Device, param2:Sprite = null) : void
        {
            var _loc_3:Vector.<int> = null;
            if (!this._VertexBuffer || !this._VertexBuffer.length)
            {
                return;
            }
            if (this._Subsets && this._Subsets.length != 0)
            {
                for each (_loc_3 in this._Subsets)
                {
                    
                    param1.drawPrimitive(this.TRIANGLELIST, this._VertexBuffer, _loc_3, BspTree, param2);
                }
            }
            else
            {
                param1.drawPrimitive(this.TRIANGLELIST, this._VertexBuffer, null, BspTree, param2);
            }
            
        }

        public function clone() : IClonable
        {
            var _loc_3:Vertex = null;
            var _loc_4:Vector.<int> = null;
            var _loc_1:* = new BaseMesh(new Vector.<Vertex>(this._VertexBuffer.length, true));
            var _loc_2:int = 0;
            for each (_loc_3 in this._VertexBuffer)
            {
                
                _loc_1.vertexBuffer[_loc_2++] = _loc_3.clone() as Vertex;
            }
            for each (_loc_4 in this._Subsets)
            {
                
                _loc_1.subsets.push(_loc_4.concat());
            }
            return _loc_1 as IClonable;
        }

    }
}
