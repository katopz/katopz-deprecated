package com.cutecoma.engine3d.api.mesh.shape
{
    import flash.display.*;
    
    import com.cutecoma.engine3d.api.*;
    import com.cutecoma.engine3d.api.mesh.*;
    import com.cutecoma.engine3d.common.vertex.*;

    public class Cube extends BaseMesh
    {
        public function Cube()
        {
            super(Vector.<Vertex>([
            	new Vertex(0.5, 0.5, 0.5, 1, 0, 0, -1, 0), 
            	new Vertex(-0.5, 0.5, -0.5, 0, 1, 0, -1, 0), 
            	new Vertex(0.5, 0.5, -0.5, 1, 1, 0, -1, 0), 
            	new Vertex(0.5, 0.5, 0.5, 1, 0, 0, -1, 0), 
            	new Vertex(-0.5, 0.5, 0.5, 0, 0, 0, -1, 0), 
            	new Vertex(-0.5, 0.5, -0.5, 0, 1, 0, -1, 0), 
            	new Vertex(-0.5, -0.5, -0.5, 0, 0, 0, 1, 0), 
            	new Vertex(0.5, -0.5, 0.5, 1, 1, 0, 1, 0), 
            	new Vertex(0.5, -0.5, -0.5, 1, 0, 0, 1, 0), 
            	new Vertex(-0.5, -0.5, 0.5, 0, 1, 0, 1, 0), 
            	new Vertex(0.5, -0.5, 0.5, 1, 1, 0, 1, 0), 
            	new Vertex(-0.5, -0.5, -0.5, 0, 0, 0, 1, 0), 
            	new Vertex(0.5, -0.5, 0.5, 0, 1, 0, 0, 1), 
            	new Vertex(-0.5, 0.5, 0.5, 1, 0, 0, 0, 1), 
            	new Vertex(0.5, 0.5, 0.5, 0, 0, 0, 0, 1), 
            	new Vertex(-0.5, 0.5, 0.5, 1, 0, 0, 0, 1), 
            	new Vertex(0.5, -0.5, 0.5, 0, 1, 0, 0, 1), 
            	new Vertex(-0.5, -0.5, 0.5, 1, 1, 0, 0, 1), 
            	new Vertex(-0.5, -0.5, -0.5, 1, 1, -1, 0, 0), 
            	new Vertex(-0.5, 0.5, 0.5, 0, 0, -1, 0, 0), 
            	new Vertex(-0.5, -0.5, 0.5, 0, 1, -1, 0, 0), 
            	new Vertex(-0.5, 0.5, 0.5, 0, 0, -1, 0, 0), 
            	new Vertex(-0.5, -0.5, -0.5, 1, 1, -1, 0, 0), 
            	new Vertex(-0.5, 0.5, -0.5, 1, 0, -1, 0, 0), 
            	new Vertex(-0.5, 0.5, -0.5, 0, 0, 0, 0, -1), 
            	new Vertex(-0.5, -0.5, -0.5, 0, 1, 0, 0, -1), 
            	new Vertex(0.5, 0.5, -0.5, 1, 0, 0, 0, -1), 
            	new Vertex(-0.5, -0.5, -0.5, 0, 1, 0, 0, -1), 
            	new Vertex(0.5, -0.5, -0.5, 1, 1, 0, 0, -1), 
            	new Vertex(0.5, 0.5, -0.5, 1, 0, 0, 0, -1), 
            	new Vertex(0.5, -0.5, 0.5, 1, 1, 1, 0, 0), 
            	new Vertex(0.5, 0.5, 0.5, 1, 0, 1, 0, 0), 
            	new Vertex(0.5, 0.5, -0.5, 0, 0, 1, 0, 0), 
            	new Vertex(0.5, 0.5, -0.5, 0, 0, 1, 0, 0), 
            	new Vertex(0.5, -0.5, -0.5, 0, 1, 1, 0, 0),
            	new Vertex(0.5, -0.5, 0.5, 1, 1, 1, 0, 0)
           ]));
        }

        override public function draw(device:Device, sprite:Sprite = null) : void
        {
            super.draw(device, sprite);
        }
    }
}