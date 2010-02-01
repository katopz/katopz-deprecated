package com.cutecoma.engine3d.engine.camera
{
    import flash.geom.*;

    public class FreeChaseCamera extends AbstractCamera
    {

        public function FreeChaseCamera()
        {
            
        }

        override public function set distance(param1:Number) : void
        {
            if (param1 < 0)
            {
                super.distance = 0;
            }
            else
            {
                super.distance = param1;
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
