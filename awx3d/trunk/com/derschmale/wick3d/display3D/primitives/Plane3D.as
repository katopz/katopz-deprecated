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

package com.derschmale.wick3d.display3D.primitives
{
	import com.derschmale.wick3d.core.geometry.Vertex3D;
	import com.derschmale.wick3d.core.imagemaps.UVCoords;
	import com.derschmale.wick3d.core.objects.Model3D;
	import com.derschmale.wick3d.materials.AbstractMaterial;

	/**
	 * The Plane3D class is a Model3D containing a non-infinite plane (a rectangle in 3 dimensions).
	 * 
	 * @author David Lenaerts
	 */
	public class Plane3D extends Model3D
	{
		/**
		 * Creates a Plane3D instance.
		 * 
		 * @param material The material used to render this object.
		 * @param width The width of the plane
		 * @param height The height of the plane
		 * @param hSegments The amount of segments out of which the plane is constructed along the x-axis 
		 * @param vSegments The amount of segments out of which the plane is constructed along the y-axis 
		 */
		public function Plane3D(material : AbstractMaterial, width : Number, height : Number, hSegments : uint = 6, vSegments : uint = 6)
		{
			var segWidth : Number = width/hSegments;
			var segHeight : Number = height/hSegments;
			var v1 : Vertex3D;
			var v2 : Vertex3D;
			var v3 : Vertex3D;
			var uv1 : UVCoords;
			var uv2 : UVCoords;
			var uv3 : UVCoords;
			
			super(material);
			
			for (var w : int = 0; w < hSegments; w++) {
				for (var h : int = 0; h < vSegments; h++) {
					v1 = new Vertex3D(w*segWidth-width*.5, h*segHeight-height*.5, 0);
					v2 = new Vertex3D((w+1)*segWidth-width*.5, h*segHeight-height*.5, 0);
					v3 = new Vertex3D(w*segWidth-width*.5, (h+1)*segHeight-height*.5, 0);
					
					uv1 = new UVCoords(w/hSegments, 1-h/vSegments);
					uv2 = new UVCoords((w+1)/hSegments, 1-h/vSegments);
					uv3 = new UVCoords(w/hSegments, 1-(h+1)/vSegments);
					
					addTriangle(v1, v2, v3, uv1, uv2, uv3);
					
					v1 = new Vertex3D((w+1)*segWidth-width*.5, h*segHeight-height*.5, 0);
					v2 = new Vertex3D((w+1)*segWidth-width*.5, (h+1)*segHeight-height*.5, 0);
					v3 = new Vertex3D(w*segWidth-width*.5, (h+1)*segHeight-height*.5, 0);
					
					uv1 = new UVCoords((w+1)/hSegments, 1-h/vSegments);
					uv2 = new UVCoords((w+1)/hSegments, 1-(h+1)/vSegments);
					uv3 = new UVCoords(w/hSegments, 1-(h+1)/vSegments);
					
					addTriangle(v1, v2, v3, uv1, uv2, uv3);
				}
			}
		}
	}
}