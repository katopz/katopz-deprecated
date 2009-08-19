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

package com.derschmale.wick3d.materials
{
	import com.derschmale.wick3d.core.geometry.Triangle3D;
	
	import flash.display.Graphics;
	import flash.display.GraphicsBitmapFill;
	import flash.display.IGraphicsData;
	import flash.geom.Point;
	
	/**
	 * The abstract class AbstractMaterial forms the basis for all material classes.
	 * 
	 * @author David Lenaerts
	 */
	public class AbstractMaterial implements IMaterial
	{
		public var graphicsData:Vector.<IGraphicsData>;
		public var graphicsBitmapFill:GraphicsBitmapFill;
		
		/**
		 * The transparency of this material. A value between 0 and 1.
		 */
		public var alpha : Number;
		
		private var _interactive : Boolean;
		
		//private var _doubleSided : Boolean;
		public var doubleSided : Boolean;
		
		//private var _shader : IShader;
		
		
		/**
		 * Renders a Triangle3D to the target Graphics object.
		 * 
		 * @param triangle The Triangle3D object to be rendered.
		 * @param target The Graphics instance that will be drawn to.
		 * 
		 * @see com.derschmale.wick3d.core.geometry.Triangle3D
		 */
		public function drawTriangle(triangle : Triangle3D, target : Graphics) : void
		{
			throw (new Error("Abstract function AbstractMaterial::drawTriangle() called, which needs to be overridden"));
		}
		
		/**
		 * Defines whether or not the triangles using this material are double sided. If false, the triangles are culled when they aren't facing the camera.
		 * 
		 * @see com.derschmale.wick3d.core.geometry.Triangle3D
		 */
		/* public function get doubleSided() : Boolean
		{
			return _doubleSided;
		}
		
		public function set doubleSided(value : Boolean) : void
		{
			_doubleSided = value;
		} */
		
		
		/**
		 * Specifies whether Triangles using this material react to mouse interaction.
		 * 
		 * @see com.derschmale.wick3d.core.geometry.Triangle3D
		 */
		public function get interactive() : Boolean
		{
			return _interactive;
		}
		
		public function set interactive(value : Boolean) : void
		{
			_interactive = value;
		}
		
		/**
		 * Retrieves the material's coordinates for the 2D viewport coordinates.
		 * 
		 * @param x The x-coordinate in Viewport coordinates.
		 * @param y The y-coordinate in Viewport coordinates.
		 * 
		 * @return A Point representing the material's coordinates for the 2D viewport coordinates.
		 */
		public function getUVCoords(x : Number, y : Number, triangle : Triangle3D) : Point
		{
			return new Point();
		}
		 
		/* public function get shader() : IShader
		{
			return _shader;
		} */
		
		/* public function set shader(value : IShader) : void
		{
			_shader = value;
		} */
	}
}