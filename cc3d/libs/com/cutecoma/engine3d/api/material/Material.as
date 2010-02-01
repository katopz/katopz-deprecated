package com.cutecoma.engine3d.api.material
{
    import com.cutecoma.engine3d.common.*;
    import com.cutecoma.engine3d.common.utils.*;

    public class Material extends Object implements IClonable
    {
        public var ambient:Color;
        public var diffuse:Color;
        public var specular:Color;

        public function Material(param1:Color = null, param2:Color = null, param3:Color = null)
        {
            this.ambient = Color.BLACK;
            this.diffuse = Color.BLACK;
            this.specular = Color.BLACK;
            if (param1 != null)
            {
                this.ambient = param1;
            }
            if (param2 != null)
            {
                this.diffuse = param2;
            }
            if (param3 != null)
            {
                this.specular = param3;
            }
            
        }

        public function clone() : IClonable
        {
            return new Material(this.ambient, this.diffuse, this.specular);
        }

    }
}
