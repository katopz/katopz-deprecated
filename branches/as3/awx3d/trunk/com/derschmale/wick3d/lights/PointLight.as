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

package com.derschmale.wick3d.lights
{
	import flash.geom.Vector3D;
	
	
	/**
	 * The PointLight class represents a light at a point in 3D space that emits light evenly in all directions.
	 * 
	 * @author David Lenaerts 
	 * 
	 * @private
	 */
	public class PointLight extends AbstractLight implements ILight
	{
		public function PointLight()
		{
			super();
		}
		
		/**
		 * Calculates this light's diffuse intensity on a target 3D-point (in view coordinates).
		 * 
		 * @param point The vertex which is being lit by the light.
		 * @param normal The normal of the vertex or its parent triangle.
		 * 
		 * @return The diffuse light intensity on the vertex.
		 */
		override public function calculateDiffuseIntensity(point : Vector3D, normal : Vector3D) : Number
		{
			var lightInt : Number;
			
			lightInt = intensity*(normal.x*(x-point.x)+normal.y*(y-point.y)+normal.z*(z-point.z))/(point.length);

			/* if (falloff) {
				var distance : Number = ray.length;
				if (distance > falloff)
					lightInt = 0;	// move this to front some day
				else {
					lightInt *= 1-distance/falloff;
				}
			} */
			
			
			/* check why lightInt can be < 0 */
			return lightInt < 0? 0: lightInt;
		}
		
		/**
		 * Calculates this light's specular intensity on a target 3D-point (in view coordinates).
		 * 
		 * @param point The vertex which is being lit by the light.
		 * @param normal The normal of the vertex or its parent triangle.
		 * 
		 * @return The specular light intensity on the vertex.
		 */
		override public function calculateSpecularIntensity(point : Vector3D, normal : Vector3D) : Number
		{
			return 0;
		}
	}
}