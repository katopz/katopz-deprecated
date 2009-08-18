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

package com.derschmale.wick3d.core.math
{
	import com.derschmale.wick3d.core.geometry.Vertex3D;
	
	import flash.geom.Vector3D;
	
	/**
	 * The Transformation3D class represents a transformation of an object in 3D space.
	 * 
	 * @author David Lenaerts
	 * 
	 * @see com.derschmale.wick3d.core.math.Matrix3D
	 */
	public class Transformation3D
	{
		/**
		 * The local transformation matrix, which will convert local object coordinates to those of the parent
		 */
		public var matrix : SDMatrix3D = new SDMatrix3D(true);
		
		private var _rotationMatrix : SDMatrix3D = new SDMatrix3D(true);
		private var _scaleMatrix : SDMatrix3D = new SDMatrix3D(true);
		private var _eulerMatrix : SDMatrix3D = new SDMatrix3D(true);

		private var _worldTransform : SDMatrix3D;
		private var _viewTransform : SDMatrix3D;
		
		private var _rotation : Vector3D = new Vector3D();
		private var _scale : Vector3D = new Vector3D(1, 1, 1, 0);
		private var _translation : Vector3D = new Vector3D(0, 0, 0, 1);
		private var _euler : Vector3D = new Vector3D();
		
		private var _transformDirty : Boolean = false;
		private var _rotationDirty : Boolean = false;
		private var _scaleDirty : Boolean = false;
		private var _eulerDirty : Boolean = false;
		
		private var _inverse : SDMatrix3D;
		
		/**
		 * The translation or origin of the object's coordinate system
		 */
		public function get translation() : Vector3D
		{
			return _translation;
		}
		
		/**
		 * The x-coordinate of the origin of the object's coordinate system
		 */
		public function get translateX() : Number
		{
			return _translation.x;
		}
		
		public function set translateX(value : Number) : void
		{
			_transformDirty = true;
			_translation.x = value;
		}
		
		/**
		 * The y-coordinate of the origin of the object's coordinate system 
		 */
		public function get translateY() : Number
		{
			return _translation.y;
		}
		
		public function set translateY(value : Number) : void
		{
			_transformDirty = true;
			_translation.y = value;
		}
		
		/**
		 * The z-coordinate of the origin of the object's coordinate system
		 */
		public function get translateZ() : Number
		{
			return _translation.z;
		}
		
		public function set translateZ(value : Number) : void
		{
			_transformDirty = true;
			_translation.z = value;
		}
		
		
		/**
		 * The rotation about the X-Axis in radians 
		 */
		public function get rotationX() : Number
		{
			return _rotation.x;
		}
		
		public function set rotationX(value : Number) : void
		{
			_rotationDirty = true;
			_transformDirty = true;
			_rotation.x = value;
		}
		
		/**
		 * The rotation about the Y-Axis in radians 
		 */
		public function get rotationY() : Number
		{
			return _rotation.y;
		}
		
		public function set rotationY(value : Number) : void
		{
			_rotationDirty = true;
			_transformDirty = true;
			_rotation.y = value;
		}
		
		/**
		 * The rotation about the Z-Axis in radians 
		 */
		public function get rotationZ() : Number
		{
			return _rotation.z;
		}
		
		public function set rotationZ(value : Number) : void
		{
			_rotationDirty = true;
			_transformDirty = true;
			_rotation.z = value;
		}
		
		
		/**
		 * The scale factor along the X-Axis
		 */
		public function get scaleX() : Number
		{
			return _scale.x;
		}
		
		public function set scaleX(value : Number) : void
		{
			_scaleDirty = true;
			_transformDirty = true;
			_scale.x = value;
		}
		
		/**
		 * The scale factor along the Y-Axis
		 */
		public function get scaleY() : Number
		{
			return _scale.y;
		}
		
		public function set scaleY(value : Number) : void
		{
			_scaleDirty = true;
			_transformDirty = true;
			_scale.y = value;
		}
		
		/**
		 * The scale factor along the Z-Axis
		 */
		public function get scaleZ() : Number
		{
			return _scale.z;
		}
		
		public function set scaleZ(value : Number) : void
		{
			_scaleDirty = true;
			_transformDirty = true;
			_scale.z = value;
		}
		
		public function get viewTransform() : SDMatrix3D
		{
			return _viewTransform;
		}
		/**
		 * Updates the object's world and view transformation matrices.
		 * 
		 * @param cameraTransform The view transformation object of the Camera
		 * @param parentTransform The world transformation object of the current object's parent. If null, the object has no parent.
		 * 
		 */
		public function updateTransformationMatrix(cameraTransform : Transformation3D = null, parentTransform : Transformation3D = null) : void
		{	
			if (_transformDirty) {
				if (_scaleDirty) {
					_scaleMatrix = SDMatrix3D.scaleMatrix(_scale.x, _scale.y, _scale.z);
					_scaleDirty = false;
				}
				if (_rotationDirty) {
					_rotationMatrix = SDMatrix3D.rotationMatrix(_rotation.x, _rotation.y, _rotation.z);
					_rotationDirty = false;
				}
				if (_eulerDirty) {
					_eulerMatrix = SDMatrix3D.eulerMatrix(_euler.x, _euler.y, _euler.z);
				}
				
				matrix = _rotationMatrix.multiply3x3(_scaleMatrix);
				matrix = matrix.multiply3x3(_eulerMatrix);
				//matrix = _scaleMatrix;
				
				matrix.m14 = _translation.x;
				matrix.m24 = _translation.y;
				matrix.m34 = _translation.z;
				
				_transformDirty = false;
			}
			
			if (parentTransform)
				_worldTransform = parentTransform._worldTransform.multiply(matrix);
			else
				_worldTransform = matrix;

			if (cameraTransform)
				_viewTransform = cameraTransform._inverse.multiply(_worldTransform);
		}
		
		/**
		 * Transforms vertices into view coordinates without creating new instances
		 * 
		 * @param vertices An array of the object's vertices in object space.
		 * @param transformedVertices An array of the object's vertices in view space.
		 * 
		 * @see com.derschmale.wick3d.core.geometry.Vertex3D
		 */
		public function transformVerticesToView(vertices : Vector.<Vertex3D>, transformedVertices : Vector.<Vertex3D>) : void
		{
			var i : int = vertices.length;
			var tr : Vertex3D;
			var v : Vertex3D;

			while ((i>0) && (v = vertices[--i] as Vertex3D)) { 
				tr = transformedVertices[i] as Vertex3D;
				
				tr.x = _viewTransform.m11*v.x + _viewTransform.m12*v.y + _viewTransform.m13*v.z + _viewTransform.m14;
				tr.y = _viewTransform.m21*v.x + _viewTransform.m22*v.y + _viewTransform.m23*v.z + _viewTransform.m24;
				tr.z = _viewTransform.m31*v.x + _viewTransform.m32*v.y + _viewTransform.m33*v.z + _viewTransform.m34;
				tr.normal = null;
				tr.isProjected = false;
			}
		}
		
		/**
		 * Transforms vertices into world coordinates without creating new instances
		 * 
		 * @param vertices An array of the object's vertices in object space.
		 * @param transformedVertices An array of the object's vertices in world space.
		 * 
		 * @see com.derschmale.wick3d.core.geometry.Vertex3D
		 */
		public function transformVerticesToWorld(vertices : Vector.<Vertex3D>, transformedVertices : Vector.<Vertex3D>) : void
		{
			var i : int = vertices.length;
			var tr : Vertex3D;
			var v : Vertex3D;

			while ((i>0) && (v = vertices[--i] as Vertex3D)) { 
				tr = transformedVertices[i] as Vertex3D;
				
				tr.x = _worldTransform.m11*v.x + _worldTransform.m12*v.y + _worldTransform.m13*v.z + _worldTransform.m14;
				tr.y = _worldTransform.m21*v.x + _worldTransform.m22*v.y + _worldTransform.m23*v.z + _worldTransform.m24;
				tr.z = _worldTransform.m31*v.x + _worldTransform.m32*v.y + _worldTransform.m33*v.z + _worldTransform.m34;
				tr.normal = null;
				tr.isProjected = false;
			}
		}
		
		/**
		 * Transforms a vertex into view coordinates
		 * 
		 * @param v The vertex in object space.
		 * 
		 * @return The transformed vertex, in view coordinates
		 * 
		 * @see com.derschmale.wick3d.core.geometry.Vertex3D 
		 */
		public function vectorToViewCoords(v : Vector3D) : Vector3D
		{
			var x : Number, y : Number, z : Number;
			
			x = _viewTransform.m11*v.x + _viewTransform.m12*v.y + _viewTransform.m13*v.z + _viewTransform.m14*v.w;
			y = _viewTransform.m21*v.x + _viewTransform.m22*v.y + _viewTransform.m23*v.z + _viewTransform.m24*v.w;
			z = _viewTransform.m31*v.x + _viewTransform.m32*v.y + _viewTransform.m33*v.z + _viewTransform.m34*v.w;
			
			return new Vector3D(x, y, z, v.w);
		}
		
		/**
		 * Transforms a vector or point into world coordinates
		 * 
		 * @param v The vertex in object space.
		 * 
		 * @return The transformed vertex, in view coordinates
		 * 
		 * @see com.derschmale.wick3d.core.math.Vector3D
		 */
		public function vectorToWorldCoords(v : Vector3D) : Vector3D
		{
			var x : Number, y : Number, z : Number;
			
			x = _worldTransform.m11*v.x + _worldTransform.m12*v.y + _worldTransform.m13*v.z + _worldTransform.m14*v.w;
			y = _worldTransform.m21*v.x + _worldTransform.m22*v.y + _worldTransform.m23*v.z + _worldTransform.m24*v.w;
			z = _worldTransform.m31*v.x + _worldTransform.m32*v.y + _worldTransform.m33*v.z + _worldTransform.m34*v.w;
			
			return new Vector3D(x, y, z, v.w);
		}
		
		/**
		 * Transforms a vector or point from world space coordinates to object space coordinates
		 * 
		 * @param v The vertex in object space.
		 * 
		 * @return The transformed vertex, in view coordinates
		 * 
		 * @see com.derschmale.wick3d.core.math.Vector3D
		 */
		public function vectorToLocalCoords(v : Vector3D) : Vector3D
		{
			var m : SDMatrix3D = _worldTransform.inverse();
			var x : Number, y : Number, z : Number;
			
			x = m.m11*v.x + m.m12*v.y + m.m13*v.z + m.m14*v.w;
			y = m.m21*v.x + m.m22*v.y + m.m23*v.z + m.m24*v.w;
			z = m.m31*v.x + m.m32*v.y + m.m33*v.z + m.m34*v.w;
			
			return new Vector3D(x, y, z, v.w);
		}
		
		/**
		 * Generates the inverse of the world or local transformation matrix. This is typically used by cameras to determine the view transform.
		 * 
		 * @param useWorldTransform Determines whether the world transformation should be used or the local transformation matrix.
		 */
		public function generateInverse(useWorldTransform : Boolean = true) : void
		{
			if (useWorldTransform)
				_inverse = _worldTransform.inverse();
			else
				_inverse = matrix.inverse();
		}
		
		/**
		 * The pitch Euler angle (independent rotation about the x-Axis) for the local transformation.
		 */
		public function get pitch() : Number
		{
			return _euler.x;
		}
		
		public function set pitch(angle : Number) : void
		{
			_transformDirty = true;
			_eulerDirty = true;
			_euler.x = angle;
		}
		
		/**
		 * The yaw Euler angle (independent rotation about the y-Axis) for the local transformation.
		 */
		public function get yaw() : Number
		{
			return _euler.y;
		}
		
		public function set yaw(angle : Number) : void
		{
			_transformDirty = true;
			_eulerDirty = true;
			_euler.y = angle;
		}
		
		/**
		 * The roll Euler angle (independent rotation about the z-Axis) for the local transformation.
		 */
		public function get roll() : Number
		{
			return _euler.z;
		}
		
		public function set roll(angle : Number) : void
		{
			_transformDirty = true;
			_eulerDirty = true;
			_euler.z = angle;
		}
		
		/**
		 * Changes the object's transformation matrix so it will be oriented towards a target position.
		 * 
		 * @param target A position in 3D space to which the object should be oriented.
		 * @param cameraMode Defines if the object to be transformed is a camera.
		 */
		public function lookAt(target : Vector3D, cameraMode : Boolean = false) : void
		{	matrix.createLookAt(_translation, target, Vector3D.Y_AXIS);
			
			if (cameraMode) {
				_inverse = matrix;
			}
			else matrix = matrix.inverse();

			_transformDirty = false;
		}
		
		
		/**
		 * Performs a strafing movement to the right. The object will move by a certain distance in the direction of its local X-axis.
		 * 
		 * @param distance The distance to move the camera along the X-axis.
		 */
		public function moveRight(distance : Number) : void
		{
			updateTransformationMatrix();
			translateX += matrix.m11*distance;
			translateY += matrix.m21*distance;
			translateZ += matrix.m31*distance;
			_transformDirty = true;
		}
		
		/**
		 * Performs a strafing movement to the left. The object will move by a certain distance in the direction of its local X-axis.
		 * 
		 * @param distance The distance to move the camera along the X-axis.
		 */
		public function moveLeft(distance : Number) : void
		{
			updateTransformationMatrix();
			translateX -= matrix.m11*distance;
			translateY -= matrix.m21*distance;
			translateZ -= matrix.m31*distance;
			_transformDirty = true;
		}
		
		/**
		 * Performs a backward movement. The object will move by a certain distance in the direction of its local Z-axis.
		 * 
		 * @param distance The distance to move the camera along the Z-axis.
		 */
		public function moveBackward(distance : Number) : void
		{
			updateTransformationMatrix();
			_translation.x -= matrix.m13*distance;
			_translation.y -= matrix.m23*distance;
			_translation.z -= matrix.m33*distance;
			_transformDirty = true;
		}
		
		/**
		 * Performs a forward movement. The object will move by a certain distance in the direction of its local Z-axis.
		 * 
		 * @param distance The distance to move the camera along the Z-axis.
		 */
		public function moveForward(distance : Number) : void
		{
			updateTransformationMatrix();
			_translation.x += matrix.m13*distance;
			_translation.y += matrix.m23*distance;
			_translation.z += matrix.m33*distance;
			_transformDirty = true;
		}
		
		/**
		 * Performs an upwards movement. The camera will move by a certain distance in the direction of its local Y-axis.
		 * 
		 * @param distance The distance to move the camera along the Y-axis.
		 */
		public function moveUp(distance : Number) : void
		{
			updateTransformationMatrix();
			_translation.x += matrix.m12*distance;
			_translation.y += matrix.m22*distance;
			_translation.z += matrix.m32*distance;
			_transformDirty = true;
		}
		
		
		/**
		 * Performs a downwards movement. The camera will move by a certain distance in the direction of its local Y-axis.
		 * 
		 * @param distance The distance to move the camera along the Y-axis.
		 */
		public function moveDown(distance : Number) : void
		{
			updateTransformationMatrix();
			_translation.x -= matrix.m12*distance;
			_translation.y -= matrix.m22*distance;
			_translation.z -= matrix.m32*distance;
			_transformDirty = true;
		}
	}
}