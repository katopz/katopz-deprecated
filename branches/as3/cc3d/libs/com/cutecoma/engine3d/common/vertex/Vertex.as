package com.cutecoma.engine3d.common.vertex
{
    import flash.geom.*;

    public class Vertex extends Vector3D
    {
        public var u:Number = 0;
        public var v:Number = 0;
        public var nx:Number = 0;
        public var ny:Number = 0;
        public var nz:Number = 0;

        public function Vertex(param1:Number = 0, param2:Number = 0, param3:Number = 0, param4:Number = 0, param5:Number = 0, param6:Number = 0, param7:Number = 0, param8:Number = 0)
        {
            super(param1, param2, param3);
            this.u = param4;
            this.v = param5;
            this.nx = param6;
            this.ny = param7;
            this.nz = param8;
            
        }

        override public function clone() : Vector3D
        {
            return new Vertex(x, y, z, this.u, this.v, this.nx, this.ny, this.nz);
        }

    }
}
