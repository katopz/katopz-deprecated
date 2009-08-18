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
	
	/**
	 * The HierarchicObject3D class is an spatial object in 3D space that is part of a hierarchic tree. It can have children objects which are relative to the current object's coordinate space, and it can be a child of another HierarchicObject3D.
	 *
	 * @see com.derschmale.wick3d.core.objects.SpatialObject3D
	 *  
	 * @author David Lenaerts
	 */
	public class HierarchicObject3D extends SpatialObject3D
	{
		private var _children : Array = [];
		private var _parent : HierarchicObject3D;
		
		/**
		 * Creates a HierarchicObject3D instance.
		 */
		public function HierarchicObject3D()
		{
			super();
		}
		
		/**
		 * Adds a child HierarchicObject3D. This means the child's coordinate system is relative to the current object's coordinate system.
		 * 
		 * @object The HierarchicObject3D to be added as a child. It cannot already be a child of a different parent; if this is the case, addChild is ignored.
		 */
		public function addChild(object : HierarchicObject3D) : void
		{
			if (object.parent == null) {
				_children.push(object);
				object._parent = this;
			}
		}
		
		/**
		 * The transformation object
		 * 
		 * @see com.derschmale.wick3d.core.math.Transformation3D
		 */
		override public function get transform() : Transformation3D
		{
			var parentTransform : Transformation3D;
			if (parent) {
				parentTransform = parent.transform;
				_transform.updateTransformationMatrix(null, parentTransform);
			}
			else {
				_transform.updateTransformationMatrix(null, null);
			}
			
			return _transform;
		}
		
		/**
		 * Retreives the child object by index.
		 * 
		 * @param i The index of the child to be retreived.
		 */
		public function getChildAt(i : int) : HierarchicObject3D
		{
			return _children[i];
		}
		
		/**
		 * The amount of children for the current object.
		 */
		public function get numChildren() : int
		{
			return _children.length;
		}
		
		/**
		 * Checks whether a HierarchicObject3D is a child of the current object.
		 *
		 * @return true if the referenced object is a child, false otherwise. 
		 */
		public function contains(object : HierarchicObject3D) : Boolean
		{
			var len : int = _children.length;
			for (var i : uint = 0; i < len; i++) {
				if (_children[i] as SpatialObject3D == object) return true
			}
			return false;
		}
		
		/**
		 * Removes a child from the current object. If the referenced object is not a child, no action occurs.
		 */
		public function removeChild(object : HierarchicObject3D) : void
		{
			var len : int = _children.length;
			var current : HierarchicObject3D;
			
			for (var i : uint = 0; i < len; i++) {
				current = _children[i] as HierarchicObject3D; 
				if (current == object) {
					_children.splice(i, 1);
					current._parent = null;
				}
			}
		}
		
		
		/**
		 * Updates the object's transformation if necessary and transforms the object to view coordinates
		 * 
		 * @param recursive If true (default), the current's objects children will also be transformed into world coordinates. The whole hierarchical tree is traversed starting from this object until no children are found.
		 */
		override public function transformToViewCoords(geometryData : GeometryData, camera : Camera3D, parentTransform : Transformation3D = null, recursive : Boolean = true) : void
		{
			// notes for extenstion: always call super first!
			// maybe update should be abstracted, in a way that it is ALWAYS called without risk. Possible?
			// for lights: apply transformation to (x, y, z)
			
			super.transformToViewCoords(geometryData, camera, parentTransform, recursive);
			
			if (recursive) {
				var len : int = _children.length;
				
				for (var i : int = 0; i < len; i++) {
					HierarchicObject3D(_children[i]).transformToViewCoords(geometryData, camera, transform);
				}
			}
		}
		
		/**
		 * Updates the object's transformation if necessary and transforms the object to world coordinates
		 * 
		 * @param recursive If true (default), the current's objects children will also be transformed into world coordinates. The whole hierarchical tree is traversed starting from this object until no children are found.
		 */
		override public function transformToWorldCoords(geometryData : GeometryData, parentTransform : Transformation3D = null, recursive : Boolean = true) : void
		{
			// notes for extenstion: always call super first!
			// maybe update should be abstracted, in a way that it is ALWAYS called without risk. Possible?
			// for lights: apply transformation to (x, y, z)
			
			super.transformToWorldCoords(geometryData, parentTransform, recursive);
			
			if (recursive) {
				var len : int = _children.length;
				
				for (var i : int = 0; i < len; i++) {
					HierarchicObject3D(_children[i]).transformToWorldCoords(geometryData, transform);
				}
			}
		}
		
		/**
		 * The parent of the current object
		 */
		public function get parent() : HierarchicObject3D
		{
			return _parent;
		}
		
		
		/**
		 * Converts the Vector3D object from the hierarchic object's (local) coordinates to world (global) coordinates.
		 */
		public function localToGlobal(point : Vector3D) : Vector3D
		{
			return transform.vectorToWorldCoords(point);
		}
		
		/**
		 * Converts the Vector3D object from world coordinates (global) to the hierarchic object's (local) coordinates.
		 */
		public function globalToLocal(point : Vector3D) : Vector3D
		{
			return transform.vectorToLocalCoords(point);
		}
	}
}