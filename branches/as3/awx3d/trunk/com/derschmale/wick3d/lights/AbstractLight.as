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
	import com.derschmale.wick3d.core.objects.HierarchicObject3D;
	
	/**
	 * The AbstractLight class is an abstract class forming the base for Light classes.
	 * 
	 * @author David Lenaerts
	 * 
	 * @private
	 */
	
	public class AbstractLight extends HierarchicObject3D implements ILight
	{
		/**
		 * The red component of the light's colour. A value from 0 to 1.
		 */
		public var r : Number = 1;
		
		/**
		 * The green component of the light's colour. A value from 0 to 1.
		 */
		public var g : Number = 1;
		
		/**
		 * The blue component of the light's colour. A value from 0 to 1.
		 */
		public var b : Number = 1;
		
		/**
		 * The intensity of the light.
		 */
		public var intensity : Number;
		
		/**
		 * Defines if the light is enabled, ie switched on.
		 */
		public var enabled : Boolean = true;
		
		/**
		 * Defines if the light is influenced by falloff. If true, the light's intensity diminished over distance.
		 */
		public var useFallOff : Boolean = false;
		
		private var _fallOffConstant : Number = 0;
		private var _fallOffLinear : Number = 0;
		private var _fallOffQuadratic : Number = 1;
		
		// falloff = intensity/(constant+linear*dist+quad*dist*dist)
		
		/**
		 * Creates an AbstractLight instance.
		 */
		public function AbstractLight()
		{
		}
		
		/**
		 * Calculates this light's diffuse intensity on a target 3D-point (in view coordinates).
		 * 
		 * @param point The vertex which is being lit by the light.
		 * @param normal The normal of the vertex or its parent triangle.
		 * 
		 * @return The diffuse light intensity on the point.
		 */
		public function calculateDiffuseIntensity(point : Vector3D, normal : Vector3D) : Number
		{
			return 0;
		}
		
		/**
		 * Calculates this light's specular intensity on a target 3D-point (in view coordinates).
		 * 
		 * @param point The vertex which is being lit by the light.
		 * @param normal The normal of the vertex or its parent triangle.
		 * 
		 * @return The specular light intensity on the vertex.
		 */
		public function calculateSpecularIntensity(point : Vector3D, normal : Vector3D) : Number
		{
			return 0;
		}
	}
}