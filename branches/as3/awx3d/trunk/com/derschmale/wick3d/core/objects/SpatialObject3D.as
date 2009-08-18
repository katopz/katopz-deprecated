/*
Copyright (c) 2008 David Lenaerts.  See:
    http://code.google.com/p/wick3d
    http://www.derschmale.com

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/

package com.derschmale.wick3d.core.objects
{
	import com.derschmale.wick3d.cameras.Camera3D;
	import com.derschmale.wick3d.core.data.GeometryData;
	import com.derschmale.wick3d.core.math.Transformation3D;
	import flash.geom.Vector3D;
	
	import flash.events.EventDispatcher;
	
	/**
	 * The SpatialObject3D class is an abstract class representing an object in 3D space, which can be positioned and transformed.
	 * 
	 * @author David Lenaerts
	 * 
	 * @see com.derschmale.wick3d.core.math.Transformation3D
	 */
	public class SpatialObject3D extends EventDispatcher
	{
		
		protected var _transform : Transformation3D = new Transformation3D();
		
		/**
		 * Updates the object's transformation if necessary and transforms the object to view coordinates
		 * 
		 * @param recursive If true (default), the current's objects children will also be transformed into world coordinates. The whole hierarchical tree is traversed starting from this object until no children are found.
		 */
		public function transformToViewCoords(geometryData : GeometryData, camera : Camera3D, parentTransform : Transformation3D = null, recursive : Boolean = true) : void
		{
			// notes for extenstion: always call super first!
			// maybe update should be abstracted, in a way that it is ALWAYS called without risk. Possible?
			// for lights: apply transformation to (x, y, z)
			
			transform.updateTransformationMatrix(camera.transform, parentTransform);
			
		}
		
		/**
		 * Updates the object's transformation if necessary and transforms the object to world coordinates
		 * 
		 * @param recursive If true (default), the current's objects children will also be transformed into world coordinates. The whole hierarchical tree is traversed starting from this object until no children are found.
		 */
		public function transformToWorldCoords(geometryData : GeometryData, parentTransform : Transformation3D = null, recursive : Boolean = true) : void
		{
			// notes for extenstion: always call super first!
			// maybe update should be abstracted, in a way that it is ALWAYS called without risk. Possible?
			// for lights: apply transformation to (x, y, z)
			
			transform.updateTransformationMatrix(null, parentTransform);
		}
		
		/**
		 * The transformation object
		 * 
		 * @see com.derschmale.wick3d.core.math.Transformation3D
		 */
		public function get transform() : Transformation3D
		{
			return _transform;
		}
		
		public function set transform(value : Transformation3D) : void
		{
			_transform = value;
		}
		
		/**
		 * The x-coordinate of the origin of the object's coordinate system
		 */
		public function get x() : Number
		{
			return transform.translateX;
		}
		
		public function set x(value : Number) : void
		{
			transform.translateX = value;
		}
		
		/**
		 * The y-coordinate of the origin of the object's coordinate system
		 */
		public function get y() : Number
		{
			return transform.translateY;
		}
		
		public function set y(value : Number) : void
		{
			transform.translateY = value;
		}
		
		/**
		 * The z-coordinate of the origin of the object's coordinate system
		 */
		public function get z() : Number
		{
			return transform.translateZ;
		}
		
		public function set z(value : Number) : void
		{
			transform.translateZ = value;
		}
		
		/**
		 * The rotation about the X-Axis in radians 
		 */
		public function get rotationX() : Number
		{
			return transform.rotationX;
		}
		
		public function set rotationX(value : Number) : void
		{
			transform.rotationX = value;
		}
		
		/**
		 * The rotation about the Y-Axis in radians 
		 */
		public function get rotationY() : Number
		{
			return transform.rotationY;
		}
		
		public function set rotationY(value : Number) : void
		{
			transform.rotationY = value;
		}
		
		/**
		 * The rotation about the Z-Axis in radians 
		 */
		public function get rotationZ() : Number
		{
			return transform.rotationZ;
		}
		
		public function set rotationZ(value : Number) : void
		{
			transform.rotationZ = value;
		}
		
		/**
		 * The scale factor along the X-Axis
		 */
		public function get scaleX() : Number
		{
			return transform.scaleX;
		}
		
		public function set scaleX(value : Number) : void
		{
			transform.scaleX = value;
		}
		
		/**
		 * The scale factor along the Y-Axis
		 */
		public function get scaleY() : Number
		{
			return transform.scaleY;
		}
		
		public function set scaleY(value : Number) : void
		{
			transform.scaleY = value;
		}
		
		/**
		 * The scale factor along the Z-Axis
		 */
		public function get scaleZ() : Number
		{
			return transform.scaleZ;
		}
		
		public function set scaleZ(value : Number) : void
		{
			transform.scaleZ = value;
		}
		
		
		/**
		 * The origin of the object's coordinate system as a Vector3D object 
		 */
		public function get position() : Vector3D
		{
			return transform.translation;
		}
		
		/**
		 * Sets the transformation matrix so that the current object is oriented towards a target.
		 * 
		 * @param target The target SpatialObject3D towards which the current object should be oriented.
		 */
		public function lookAt(target : SpatialObject3D) : void
		{
			transform.lookAt(target.position);
		}
		
		/**
		 * The yaw Euler angle (independent rotation about the y-Axis) for the local transformation.
		 */
		public function get yaw() : Number
		{
			return transform.yaw;
		}
		
		public function set yaw(value : Number) : void
		{
			transform.yaw = value;
		}
		
		/**
		 * The pitch Euler angle (independent rotation about the x-Axis) for the local transformation.
		 */
		public function get pitch() : Number
		{
			return transform.pitch;
		}
		
		public function set pitch(value : Number) : void
		{
			transform.pitch = value;
		}
		
		/**
		 * The roll Euler angle (independent rotation about the z-Axis) for the local transformation.
		 */
		public function get roll() : Number
		{
			return transform.roll;
		}
		
		public function set roll(value : Number) : void
		{
			transform.roll = value; 
		}
		
		
		/**
		 * Performs a forward movement. The object will move by a certain distance in the direction of its local X-axis.
		 * 
		 * @param distance The distance to move the camera along the X-axis.
		 */
		public function moveForward(distance : Number) : void
		{
			transform.moveForward(distance);
		}
		
		/**
		 * Performs a backwards movement. The object will move by a certain distance in the direction of its local X-axis.
		 * 
		 * @param distance The distance to move the camera along the X-axis.
		 */
		public function moveBackward(distance : Number) : void
		{
			transform.moveBackward(distance);
		}
		
		/**
		 * Performs a strafing movement to the left. The object will move by a certain distance in the direction of its local Z-axis.
		 * 
		 * @param distance The distance to move the camera along the Z-axis.
		 */
		public function moveLeft(distance : Number) : void
		{
			transform.moveLeft(distance);
		}
		
		/**
		 * Performs a strafing movement to the right. The object will move by a certain distance in the direction of its local Z-axis.
		 * 
		 * @param distance The distance to move the camera along the Z-axis.
		 */
		public function moveRight(distance : Number) : void
		{
			transform.moveRight(distance);
		}
		
		/**
		 * Performs an upwards movement. The camera will move by a certain distance in the direction of its local Y-axis.
		 * 
		 * @param distance The distance to move the camera along the Y-axis.
		 */
		public function moveUp(distance : Number) : void
		{
			transform.moveUp(distance);
		}
		
		
		/**
		 * Performs a downwards movement. The camera will move by a certain distance in the direction of its local Y-axis.
		 * 
		 * @param distance The distance to move the camera along the Y-axis.
		 */
		public function moveDown(distance : Number) : void
		{
			transform.moveDown(distance);
		}
	}
}