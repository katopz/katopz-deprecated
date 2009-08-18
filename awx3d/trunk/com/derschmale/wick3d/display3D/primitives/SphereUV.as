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
	 * The SphereUV class is a Model3D containing a UV sphere. The facets out of which the sphere is constructed contain 4 points, and are subdivided into two triangles.
	 * 
	 * @author David Lenaerts
	 */
	public class SphereUV extends Model3D
	{
		/**
		 * Creates a SphereUV instance.
		 * 
		 * @param material The material used to render this object
		 * @param radius The radius of the sphere
		 * @param uSegments The amount of segments out of which the sphere is constructed along the meridians
		 * @param vSegments The amount of segments out of which the sphere is constructed along the y-axis 
		 */
		public function SphereUV(material:AbstractMaterial, radius : Number, uSegments : int = 8, vSegments : int = 8)
		{
			var stepV : Number = Math.PI*.5/vSegments;
			var stepH : Number = Math.PI*.5/uSegments;
			var rad1 : Number, rad2 : Number;
			var xp1 : Number, xp2 : Number;
			var yp1 : Number, yp2 : Number;
			var zp1 : Number, zp2 : Number;
			var v1 : Vertex3D, v2 : Vertex3D, v3 : Vertex3D, v4 : Vertex3D;
			var uv1 : UVCoords, uv2 : UVCoords, uv3 : UVCoords, uv4 : UVCoords;
			var pi2 : Number = Math.PI*2;
			var pihalf : Number = Math.PI*.5;
			
			super(material);
			
			for (var yl:int = 0; yl < vSegments; yl++) {
				rad1 = Math.cos(yl/vSegments*Math.PI-pihalf)*radius;
				rad2 = Math.cos((yl+1)/vSegments*Math.PI-pihalf)*radius;
				
				yp1 = Math.sin(yl/vSegments*Math.PI-pihalf)*radius;
				yp2 = Math.sin((yl+1)/vSegments*Math.PI-pihalf)*radius;
				
				for (var el:int = 0; el < uSegments; el++) {
					// coordinates on the unit circle
					xp1 = Math.cos(el/uSegments*pi2);
					zp1 = Math.sin(el/uSegments*pi2);
					xp2 = Math.cos((el+1)/uSegments*pi2);
					zp2 = Math.sin((el+1)/uSegments*pi2);
					
					if (el == uSegments-1) {
						xp2 = 1;
						zp2 = 0;
					}
					
					if (yl == vSegments-1) {
						v1 = new Vertex3D(0, yp2, 0);
						v2 = new Vertex3D(xp1*rad1, yp1, zp1*rad1);
						v3 = new Vertex3D(xp2*rad1, yp1, zp2*rad1);
						
						uv1 = new UVCoords(.5, 0);
						uv2 = new UVCoords(el/uSegments, 1-yl/vSegments);
						uv3 = new UVCoords((el+1)/uSegments, 1-yl/vSegments);
						
						v4 = null;
					}
					else if (yl > 0) {
						v1 = new Vertex3D(xp1*rad1, yp1, zp1*rad1);
						v2 = new Vertex3D(xp2*rad1, yp1, zp2*rad1);
						v3 = new Vertex3D(xp2*rad2, yp2, zp2*rad2);
						v4 = new Vertex3D(xp1*rad2, yp2, zp1*rad2);
						
						uv1 = new UVCoords(el/uSegments, 1-yl/vSegments);
						uv2 = new UVCoords((el+1)/uSegments, 1-yl/vSegments);
						uv3 = new UVCoords((el+1)/uSegments, 1-(yl+1)/vSegments);
						uv4 = new UVCoords(el/uSegments, 1-(yl+1)/vSegments);
					}
					else {
						v1 = new Vertex3D(xp1*rad2, yp2, zp1*rad2);
						v2 = new Vertex3D(0, yp1, 0);
						v3 = new Vertex3D(xp2*rad2, yp2, zp2*rad2);
						
						uv1 = new UVCoords(el/uSegments, 1-(yl+1)/vSegments);
						uv2 = new UVCoords(.5, 1);
						uv3 = new UVCoords((el+1)/uSegments, 1-(yl+1)/vSegments);
						
						v4 = null;
					}
					
					if (v4) {
						addTriangle(v1, v2, v4, uv1, uv2, uv4);
						addTriangle(v2, v3, v4, uv2, uv3, uv4);
					}
					else {
						addTriangle(v1, v2, v3, uv1, uv2, uv3);
					}
				}
			}
		}
		
	}
}