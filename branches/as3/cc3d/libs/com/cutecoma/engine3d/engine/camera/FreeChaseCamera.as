package com.cutecoma.engine3d.engine.camera
{
    import flash.geom.*;

    public class FreeChaseCamera extends AbstractCamera
    {

        public function FreeChaseCamera()
        {
            
        }

        override public function set distance(value:Number) : void
        {
            if (value < 0)
            {
                super.distance = 0;
            }
            else
            {
                super.distance = value;
            }
            
        }

        override protected function updateMatrix() : void
        {
            position.x = direction.x - distance * COS(yaw) * COS(pitch);
            position.y = direction.y - distance * SIN(pitch);
            position.z = direction.z - distance * SIN(yaw) * COS(pitch);
            viewMatrix = LOOK_AT_LH(position, direction, Vector3D.Y_AXIS);
            super.updateMatrix();
            
        }

    }
}
