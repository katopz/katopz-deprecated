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
	 * The Cube3D class is a Model3D containing a cube.
	 * 
	 * @author David Lenaerts
	 */
	public class Cube3D extends Model3D
	{
		/**
		 * Creates a Cube3D instance.
		 * 
		 * @param material The material used to render this object.
		 * @param size The length of the cube's ribs.
		 * @param segmentsW The amount of segments out of which the cube is constructed along the x-axis
		 * @param segmentsH The amount of segments out of which the cube is constructed along the y-axis
		 * @param segmentsZ The amount of segments out of which the cube is constructed along the z-axis
		 * 
		 * @see com.derschmale.wick3d.materials.AbstractMaterial
		 */
		public function Cube3D(material : AbstractMaterial, size : Number, segmentsW : int = 4, segmentsH : int = 4, segmentsD : int = 4)
		{
			var v1 : Vertex3D, v2 : Vertex3D, v3 : Vertex3D;
			var uv1 : UVCoords, uv2 : UVCoords, uv3 : UVCoords;
			
			var segW : Number = size/segmentsW;
			var segH : Number = size/segmentsH;
			var segD : Number = size/segmentsD;
			
			super(material);
			
			size *= .5;
			
			for (var w : int = 0; w < segmentsW; w++) {
				for (var h : int = 0; h < segmentsH; h++) {
					v1 = new Vertex3D(w*segW-size, h*segH-size, -size);
					v2 = new Vertex3D((w+1)*segW-size, h*segH-size, -size);
					v3 = new Vertex3D((w+1)*segW-size, (h+1)*segH-size, -size);
					
					uv1 = new UVCoords(w/segmentsW, 1-h/segmentsH);
					uv2 = new UVCoords((w+1)/segmentsW, 1-h/segmentsH);
					uv3 = new UVCoords((w+1)/segmentsW, 1-(h+1)/segmentsH);
					
					addTriangle(v1, v2, v3, uv1, uv2, uv3);
					
					v1 = new Vertex3D((w+1)*segW-size, (h+1)*segH-size, -size);
					v2 = new Vertex3D(w*segW-size, (h+1)*segH-size, -size);
					v3 = new Vertex3D(w*segW-size, h*segH-size, -size);
					
					uv1 = new UVCoords((w+1)/segmentsW, 1-(h+1)/segmentsH);
					uv2 = new UVCoords(w/segmentsW, 1-(h+1)/segmentsH);
					uv3 = new UVCoords(w/segmentsW, 1-h/segmentsH);
					
					addTriangle(v1, v2, v3, uv1, uv2, uv3);
					
					v1 = new Vertex3D((w+1)*segW-size, h*segH-size, size);
					v2 = new Vertex3D(w*segW-size, h*segH-size, size);
					v3 = new Vertex3D(w*segW-size, (h+1)*segH-size, size);

					uv1 = new UVCoords(1-(w+1)/segmentsW, 1-h/segmentsH);
					uv2 = new UVCoords(1-w/segmentsW, 1-h/segmentsH);
					uv3 = new UVCoords(1-w/segmentsW, 1-(h+1)/segmentsH);
					
					addTriangle(v1, v2, v3, uv1, uv2, uv3);

					v1 = new Vertex3D(w*segW-size, (h+1)*segH-size, size);
					v2 = new Vertex3D((w+1)*segW-size, (h+1)*segH-size, size);
					v3 = new Vertex3D((w+1)*segW-size, h*segH-size, size);
					
					uv1 = new UVCoords(1-w/segmentsW, 1-(h+1)/segmentsH);
					uv2 = new UVCoords(1-(w+1)/segmentsW, 1-(h+1)/segmentsH);
					uv3 = new UVCoords(1-(w+1)/segmentsW, 1-h/segmentsH);
					
					addTriangle(v1, v2, v3, uv1, uv2, uv3);
				}
			}
			
			
			
			for (var d : int = 0; d < segmentsD; d++) {
				for (h = 0; h < segmentsH; h++) {
					v1 = new Vertex3D(size, h*segH-size, d*segD-size);
					v2 = new Vertex3D(size, h*segH-size, (d+1)*segD-size);
					v3 = new Vertex3D(size, (h+1)*segH-size, (d+1)*segD-size);
					
					uv1 = new UVCoords(d/segmentsD, 1-h/segmentsH);
					uv2 = new UVCoords((d+1)/segmentsD, 1-h/segmentsH);
					uv3 = new UVCoords((d+1)/segmentsD, 1-(h+1)/segmentsH);
					
					addTriangle(v1, v2, v3, uv1, uv2, uv3);
					
					v1 = new Vertex3D(size, (h+1)*segH-size, (d+1)*segD-size);
					v2 = new Vertex3D(size, (h+1)*segH-size, d*segD-size);
					v3 = new Vertex3D(size, h*segH-size, d*segD-size);
					
					uv1 = new UVCoords((d+1)/segmentsD, 1-(h+1)/segmentsH);
					uv2 = new UVCoords(d/segmentsD, 1-(h+1)/segmentsH);
					uv3 = new UVCoords(d/segmentsD, 1-h/segmentsH);
					
					addTriangle(v1, v2, v3, uv1, uv2, uv3);

					v1 = new Vertex3D(-size, h*segH-size, (d+1)*segD-size);
					v2 = new Vertex3D(-size, h*segH-size, d*segD-size);
					v3 = new Vertex3D(-size, (h+1)*segH-size, d*segD-size);
					
					uv1 = new UVCoords(1-(d+1)/segmentsD, 1-h/segmentsH);
					uv2 = new UVCoords(1-d/segmentsD, 1-h/segmentsH);
					uv3 = new UVCoords(1-d/segmentsD, 1-(h+1)/segmentsH);
					
					addTriangle(v1, v2, v3, uv1, uv2, uv3);
					
					v1 = new Vertex3D(-size, (h+1)*segH-size, d*segD-size);
					v2 = new Vertex3D(-size, (h+1)*segH-size, (d+1)*segD-size);
					v3 = new Vertex3D(-size, h*segH-size, (d+1)*segD-size);
					
					uv1 = new UVCoords(1-d/segmentsD, 1-(h+1)/segmentsH);
					uv2 = new UVCoords(1-(d+1)/segmentsD, 1-(h+1)/segmentsH);
					uv3 = new UVCoords(1-(d+1)/segmentsD, 1-h/segmentsH);
					
					addTriangle(v1, v2, v3, uv1, uv2, uv3);
				}
			}
			
			
			
			
			
			for (d = 0; d < segmentsD; d++) {
				for (w = 0; w < segmentsW; w++) {
					v1 = new Vertex3D(w*segW-size, size, d*segD-size);
					v2 = new Vertex3D((w+1)*segW-size, size, d*segD-size);
					v3 = new Vertex3D((w+1)*segW-size, size, (d+1)*segD-size);
					
					uv1 = new UVCoords(w/segmentsW, 1-d/segmentsD);
					uv2 = new UVCoords((w+1)/segmentsW, 1-d/segmentsD);
					uv3 = new UVCoords((w+1)/segmentsW, 1-(d+1)/segmentsD);
					
					addTriangle(v1, v2, v3, uv1, uv2, uv3);

					v1 = new Vertex3D((w+1)*segW-size, size, (d+1)*segD-size);
					v2 = new Vertex3D(w*segW-size, size, (d+1)*segD-size);
					v3 = new Vertex3D(w*segW-size, size, d*segD-size);
					
					uv1 = new UVCoords((w+1)/segmentsW, 1-(d+1)/segmentsD);
					uv2 = new UVCoords(w/segmentsW, 1-(d+1)/segmentsD);
					uv3 = new UVCoords(w/segmentsW, 1-d/segmentsD);
					
					addTriangle(v1, v2, v3, uv1, uv2, uv3);

					v1 = new Vertex3D((w+1)*segW-size, -size, d*segD-size);
					v2 = new Vertex3D(w*segW-size, -size, d*segD-size);
					v3 = new Vertex3D(w*segW-size, -size, (d+1)*segD-size);
					
					uv1 = new UVCoords((w+1)/segmentsW, d/segmentsD);
					uv2 = new UVCoords(w/segmentsW, d/segmentsD);
					uv3 = new UVCoords(w/segmentsW, (d+1)/segmentsD);
					
					addTriangle(v1, v2, v3, uv1, uv2, uv3);

					v1 = new Vertex3D(w*segW-size, -size, (d+1)*segD-size);
					v2 = new Vertex3D((w+1)*segW-size, -size, (d+1)*segD-size);
					v3 = new Vertex3D((w+1)*segW-size, -size, d*segD-size);
					
					uv1 = new UVCoords(w/segmentsW, (d+1)/segmentsD);
					uv2 = new UVCoords((w+1)/segmentsW, (d+1)/segmentsD);
					uv3 = new UVCoords((w+1)/segmentsW, d/segmentsD);
					
					addTriangle(v1, v2, v3, uv1, uv2, uv3);
				}
			}
		}
		
	}
}