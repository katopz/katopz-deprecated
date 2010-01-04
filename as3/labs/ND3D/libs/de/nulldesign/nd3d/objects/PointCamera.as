package de.nulldesign.nd3d.objects 
{
	import de.nulldesign.nd3d.geom.Quaternion;
	import de.nulldesign.nd3d.objects.Object3D;	

	/**
	 * A simple pointcamera
	 * @author Lars Gerckens (lars@nulldesign.de)
	 */
	public class PointCamera 
	{
		// 2d perspective values
		public var fl:Number = 250;
		public var zOffset:Number = 100;
		public var vpX:Number;
		public var vpY:Number;

		// camera position and angle
		public var x:Number = 0;
		public var y:Number = 0;
		public var z:Number = 0;

		private var _angleX:Number = 0;

		public function set angleX(angle:Number):void 
		{
			deltaAngleX = angle - _angleX;
			_angleX = angle;
		}

		public function get angleX():Number 
		{
			return _angleX;
		}

		private var _angleY:Number = 0;

		public function set angleY(angle:Number):void 
		{
			deltaAngleY = angle - _angleY;
			_angleY = angle;
		}

		public function get angleY():Number 
		{
			return _angleY;
		}

		private var _angleZ:Number = 0;

		public function set angleZ(angle:Number):void 
		{
			deltaAngleZ = angle - _angleZ;
			_angleZ = angle;
		}

		public function get angleZ():Number 
		{
			return _angleZ;
		}

		public var deltaAngleX:Number = 0;
		public var deltaAngleY:Number = 0;
		public var deltaAngleZ:Number = 0;

		public var quaternion:Quaternion;

		public function PointCamera(screenW:Number, screenH:Number)	
		{
			vpX = screenW / 2;
			vpY = screenH / 2;
			
			quaternion = new Quaternion();
		}

		private function maintainAngle(angle:Number):Number 
		{
			if(Math.abs(angle) >= Math.PI) 
			{
				if(angle < 0) 
				{
					angle += Math.PI * 2;
				} 
				else 
				{
					angle -= Math.PI * 2;
				}
			}
			
			return angle;
		}
		/**
		 * Experimental
		 * @param	target
		 * @param	speed
		 * @param	turnSpeed
		 */
		public function follow(target:Object3D, speed:Number, turnSpeed:Number):void 
		{
			/*
			// CAM FOLLOW... COORDS SWITCHED???!
			cam.angleZ = spaceShip.angleX;
			cam.angleY = -spaceShip.angleY + Object3D.deg2rad(90);
			cam.angleX = spaceShip.angleZ;
			 */

			var diffZ:Number = (target.angleX - angleZ);
			var diffY:Number = (-target.angleY - angleY + Object3D.deg2rad(90));
			var diffX:Number = (target.angleZ - angleX);
			
			// avoid large gaps from -180 to 180, dirrrty test...
			diffZ = maintainAngle(diffZ);
			diffY = maintainAngle(diffY);
			diffX = maintainAngle(diffX);

			angleZ += diffZ * turnSpeed;
			angleY += diffY * turnSpeed;
			angleX += diffX * turnSpeed;
			
			// limit to 0 - 360 ... the gap thing
			angleZ = angleZ % (Math.PI * 2);
			angleY = angleY % (Math.PI * 2);
			angleX = angleX % (Math.PI * 2);
			
			x += (target.xPos - x) * speed;
			y += (target.yPos - y) * speed;
			z += (target.zPos - z) * speed;
		}

		public function toString():String
		{
			return "[PointCamera " + " x: " + x + ", y: " + y + ", z: " + z + ", angleX: " + angleX + ", angleY: " + angleY + ", angleZ: " + angleZ + "]";
		}
	}
}
