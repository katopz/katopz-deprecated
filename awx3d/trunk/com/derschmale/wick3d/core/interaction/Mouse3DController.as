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
package com.derschmale.wick3d.core.interaction
{
	import com.derschmale.wick3d.core.geometry.Triangle3D;
	import com.derschmale.wick3d.core.objects.Model3D;
	import com.derschmale.wick3d.events.Mouse3DEvent;
	import com.derschmale.wick3d.materials.DisplayObjectMaterial;
	import com.derschmale.wick3d.materials.AbstractMaterial;
	import com.derschmale.wick3d.view.Viewport;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	/**
	 * The Mouse3DController class is responsible for generating interactive 3D content. As such, it dispatches Mouse3DEvents from 3D objects and makes DisplayObjectMaterials behave like normal DisplayObjects in terms of MouseEvents.
	 * 
	 * @see com.derschmale.wick3d.events.Mouse3DEvent
	 * @see com.derschmale.wick3d.materials.AbstractMaterial
	 * @see com.derschmale.wick3d.materials.DisplayObjectMaterial
	 * 
	 * @author David Lenaerts
	 */
	public class Mouse3DController
	{
		private var _oldModel : Model3D;
		private var _oldDisplayObject : DisplayObject;
		private var _viewport : Viewport; 
		
		/**
		 * Creates a new Mouse3DController.
		 * 
		 * @param viewport The Viewport instance used to check for mouse events.
		 *
		 * @see com.derschmale.wick3d.view.Viewport
		 */
		public function Mouse3DController(viewport : Viewport)
		{
			_viewport = viewport;
			_viewport.addEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove);
			_viewport.addEventListener(MouseEvent.MOUSE_OUT, handleMouseOut);
			_viewport.addEventListener(MouseEvent.MOUSE_DOWN, handleDefaultMouseEvent);
			_viewport.addEventListener(MouseEvent.MOUSE_UP, handleDefaultMouseEvent);
			_viewport.addEventListener(MouseEvent.MOUSE_WHEEL, handleDefaultMouseEvent);
			_viewport.addEventListener(MouseEvent.CLICK, handleClick);
		}
		
		private function handleDefaultMouseEvent(event : MouseEvent) : void
		{
			var triangle : Triangle3D = _viewport.getTopTriangleUnderPoint(_viewport.mouseX, _viewport.mouseY, true);
			if (triangle)
				enforceInteraction(event, triangle.material, triangle.getUVCoords(_viewport.mouseX, _viewport.mouseY));
		}
		
		private function handleMouseMove(event : MouseEvent) : void
		{
			var triangle : Triangle3D = _viewport.getTopTriangleUnderPoint(_viewport.mouseX, _viewport.mouseY, true);
			if (triangle) doMouseMove(triangle, event);
		}
		
		private function handleMouseOut(event : MouseEvent) : void
		{
			if (_oldModel) {
				_oldModel.dispatchEvent(new Mouse3DEvent(Mouse3DEvent.MOUSE_OUT, 0, 0, null));
				_oldModel = null;
			}
			if (_oldDisplayObject) {
				_oldDisplayObject.dispatchEvent(new MouseEvent(MouseEvent.ROLL_OUT, true, false, 0, 0));
				_oldDisplayObject.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_OUT, true, false, 0, 0));
				_oldDisplayObject = null;
			}
		}
		
		private function handleClick(event : MouseEvent) : void
		{
			var triangle : Triangle3D = _viewport.getTopTriangleUnderPoint(_viewport.mouseX, _viewport.mouseY, true);
			if (triangle) doClick(triangle, event);
		}
		
		private function doMouseMove(triangle : Triangle3D, sourceEvent : MouseEvent) : void
		{
			var parent : Model3D = triangle.parent;
			var texCoords : Point = triangle.getUVCoords(_viewport.mouseX, _viewport.mouseY);
			
			parent.dispatchEvent(new Mouse3DEvent(Mouse3DEvent.MOUSE_MOVE, texCoords.x, texCoords.y, triangle));
			
			if (triangle.parent != _oldModel) {
				if (_oldModel) {
					_oldModel.dispatchEvent(new Mouse3DEvent(Mouse3DEvent.MOUSE_OUT, texCoords.x, texCoords.y, triangle));
				}
				triangle.parent.dispatchEvent(new Mouse3DEvent(Mouse3DEvent.MOUSE_OVER, texCoords.x, texCoords.y, triangle));
				_oldModel = triangle.parent;
			}
			
			enforceInteraction(sourceEvent, triangle.material, texCoords);
		}
				
		private function doClick(triangle : Triangle3D, sourceEvent : MouseEvent) : void
		{
			var parent : Model3D = triangle.parent;
			var texCoords : Point = triangle.getUVCoords(_viewport.mouseX, _viewport.mouseY);
			parent.dispatchEvent(new Mouse3DEvent(Mouse3DEvent.CLICK, texCoords.x, texCoords.y, triangle));
			enforceInteraction(sourceEvent, triangle.material, texCoords);
		}
		
		private function enforceInteraction(sourceEvent : MouseEvent, material : AbstractMaterial, texCoords : Point) : void
		{
			var mat : DisplayObjectMaterial;
			var dp : DisplayObject;
			
			if (material is DisplayObjectMaterial) {
				mat = material as DisplayObjectMaterial;
				
				if (mat.source is DisplayObjectContainer) {
					dp = getTopMouseEnabled(mat.source as DisplayObjectContainer, texCoords);
				}
				else {
					dp = mat.source;
				}
				
				if (_oldDisplayObject && _oldDisplayObject != dp) {
					_oldDisplayObject.dispatchEvent(new MouseEvent(MouseEvent.ROLL_OUT, true, false, texCoords.x, texCoords.y, null, sourceEvent.ctrlKey, sourceEvent.altKey, sourceEvent.shiftKey, sourceEvent.buttonDown, sourceEvent.delta));
					_oldDisplayObject.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_OUT, true, false, texCoords.x, texCoords.y, null, sourceEvent.ctrlKey, sourceEvent.altKey, sourceEvent.shiftKey, sourceEvent.buttonDown, sourceEvent.delta));
				}
				
				if (dp) {
					if(_oldDisplayObject != dp) {
						dp.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_OVER, true, false, texCoords.x, texCoords.y, null, sourceEvent.ctrlKey, sourceEvent.altKey, sourceEvent.shiftKey, sourceEvent.buttonDown, sourceEvent.delta));
						dp.dispatchEvent(new MouseEvent(MouseEvent.ROLL_OVER, true, false, texCoords.x, texCoords.y, null, sourceEvent.ctrlKey, sourceEvent.altKey, sourceEvent.shiftKey, sourceEvent.buttonDown, sourceEvent.delta));
					}
					dp.dispatchEvent(new MouseEvent(sourceEvent.type, true, false, texCoords.x, texCoords.y, null, sourceEvent.ctrlKey, sourceEvent.altKey, sourceEvent.shiftKey, sourceEvent.buttonDown, sourceEvent.delta));
					
				}
				_oldDisplayObject = dp;
								
			}  
		}
		
		private function getTopMouseEnabled(displayObject : DisplayObjectContainer, coords : Point) : DisplayObject
		{
			var allUnder : Vector.<DisplayObject> = Vector.<DisplayObject>(displayObject.getObjectsUnderPoint(coords));
			var parents : Vector.<DisplayObject> = getParentList(allUnder[allUnder.length-1]);
			var current : DisplayObjectContainer;
			var lastValid : InteractiveObject;
			
			for (var i : int = parents.length - 1; i > 0; i--) {
				// i > 0 (not top-level), hence parents[i] has children and is DisplayObjectContainer
				current = parents[i] as DisplayObjectContainer;
				
				if (current.mouseEnabled)
					lastValid = current;
				
				if (!current.mouseChildren)
					// none of the following will receive mouse events
					return lastValid;
			}
			
			return lastValid;
		}
		
		private function getParentList(displayObject : DisplayObject) : Vector.<DisplayObject> 
		{
			var parents : Vector.<DisplayObject> = new Vector.<DisplayObject>();
			var current : DisplayObject = displayObject;
			
			while (current) {
				if (current is InteractiveObject) parents.push(current);
				current = current.parent;
			}
			
			return parents;
		}
	}
}