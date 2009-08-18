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

package com.derschmale.wick3d.core.imagemaps
{
	/**
	 * The UVCoords class represents UV coordinates on an image map, used in texture mapping and bump mapping.
	 *
	 * @see com.derschmale.wick3d.materials.TextureMaterial
	 *  
	 * @author David Lenaerts
	 */
	public class UVCoords
	{
		/**
		 * The horizontal coordinate in texture space.
		 */
		public var u : Number;
		
		/**
		 * The vertical coordinate in texture space.
		 */
		public var v : Number;
		
		/**
		 * Creates a new UVCoords object.
		 * 
		 * @param u The horizontal coordinate in texture space.
		 * @param v The vertical coordinate in texture space.
		 */
		public function UVCoords(u : Number = 0, v : Number = 0)
		{
			this.u = u;
			this.v = v;
		}

	}
}