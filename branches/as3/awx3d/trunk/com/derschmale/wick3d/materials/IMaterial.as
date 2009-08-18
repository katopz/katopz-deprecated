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
	import flash.geom.Point;
	
	/**
	 * The IMaterial interface is implemented by classes that represent surfaces that are used to draw triangles, simulating real-world materials.
	 * 
	 * @see com.derschmale.wick3d.core.geometry.Triangle3D
	 * 
	 * @author David Lenaerts
	 */
	public interface IMaterial
	{
		/**
		 * Renders a Triangle3D to the target Graphics object.
		 * 
		 * @param triangle The Triangle3D object to be rendered.
		 * @param target The Graphics instance that will be drawn to.
		 * 
		 * @see com.derschmale.wick3d.core.geometry.Triangle3D
		 */
		function drawTriangle(triangle : Triangle3D, target:Graphics) : void;
		
		/**
		 * Defines whether or not the triangles using this material are double sided. If false, the triangles are culled when they aren't facing the camera.
		 * 
		 * @see com.derschmale.wick3d.core.geometry.Triangle3D
		 */
		/* function get doubleSided() : Boolean;
		function set doubleSided(value : Boolean) : void; */
		
		/**
		 * Specifies whether Triangle3Ds using this material react to mouse interaction.
		 * 
		 * @see com.derschmale.wick3d.core.geometry.Triangle3D
		 */
		function get interactive() : Boolean;
		function set interactive(value : Boolean) : void;
		//function get shader() : IShader;
		//function set shader(shader : IShader) : void;
		
		/**
		 * Retrieves the material's coordinates for the 2D viewport coordinates.
		 * 
		 * @param x The x-coordinate in Viewport coordinates.
		 * @param y The y-coordinate in Viewport coordinates.
		 * 
		 * @return A Point representing the material's coordinates for the 2D viewport coordinates.
		 */
		function getUVCoords(x : Number, y : Number, triangle : Triangle3D) : Point;
	}
}