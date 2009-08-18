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
	 * The Cylinder class is a Model3D containing a circular cylinder.
	 * 
	 * @author David Lenaerts
	 */
	public class Cylinder extends Model3D
	{
		
		/**
		 * Creates a Cylinder instance.
		 * 
		 * @param material The material used to render this object.
		 * @param radius The radius of the cylinder.
		 * @param uSegments The amount of segments out of which the cylinder is constructed along the circumference.
		 * @param vSegments The amount of segments out of which the cylinder is constructed along the cylinder's axis.  
		 * 
		 * @see com.derschmale.wick3d.materials.AbstractMaterial
		 */
		public function Cylinder(material : AbstractMaterial, radius : Number, height : Number, uSegments : uint = 10, vSegments : uint = 4)
		{
			var stepU : Number = 2*Math.PI/uSegments;
			var stepV : Number = height/vSegments;
			var v1 : Vertex3D, v2 : Vertex3D, v3 : Vertex3D;
			var uv1 : UVCoords, uv2 : UVCoords, uv3 : UVCoords;
			var u : Number, v : Number;
			
			super(material);
			
			for (var uLoop : Number = 0; uLoop < uSegments; uLoop++) {
				for (var vLoop : Number = 0; vLoop < vSegments; vLoop++) {
					u = uLoop*stepU;
					v = vLoop*stepV - height*.5;
					v1 = new Vertex3D(	radius*Math.cos(u),
										v,
										radius*Math.sin(u)
									 );
					v2 = new Vertex3D(	radius*Math.cos(u+stepU),
										v,
										radius*Math.sin(u+stepU)
									 );
					v3 = new Vertex3D(	radius*Math.cos(u),
										v + stepV,
										radius*Math.sin(u)
									 );
					
					uv1 = new UVCoords(uLoop/uSegments, 1-vLoop/vSegments);
					uv2 = new UVCoords((uLoop+1)/uSegments, 1-vLoop/vSegments);
					uv3 = new UVCoords(uLoop/uSegments, 1-(vLoop+1)/vSegments);
					
					addTriangle(v1, v2, v3, uv1, uv2, uv3);
					
					v1 = new Vertex3D(	radius*Math.cos(u),
										v + stepV,
										radius*Math.sin(u)
									 );
					v2 = new Vertex3D(	radius*Math.cos(u+stepU),
										v,
										radius*Math.sin(u+stepU)
									 );
					v3 = new Vertex3D(	radius*Math.cos(u+stepU),
										v+stepV,
										radius*Math.sin(u+stepU)
									 );
					
					uv1 = new UVCoords(uLoop/uSegments, 1-(vLoop+1)/vSegments);
					uv2 = new UVCoords((uLoop+1)/uSegments, 1-vLoop/vSegments);
					uv3 = new UVCoords((uLoop+1)/uSegments, 1-(vLoop+1)/vSegments);
					
					addTriangle(v1, v2, v3, uv1, uv2, uv3);
					
				}
			}
			
			for (uLoop = 0; uLoop < uSegments; uLoop++) {
				u = uLoop*stepU;
				v1 = new Vertex3D(	0,
									height*.5,
									0
								 );
				v2 = new Vertex3D(	radius*Math.cos(u),
									height*.5,
									radius*Math.sin(u)
								 );
				v3 = new Vertex3D(	radius*Math.cos(u+stepU),
									height*.5,
									radius*Math.sin(u+stepU)
								 );
				
				uv1 = new UVCoords(.5, .5);
				uv2 = new UVCoords(Math.cos(u)*.5+.5, .5-Math.sin(u)*.5);
				uv3 = new UVCoords(Math.cos(u+stepU)*.5+.5, .5-Math.sin(u+stepU)*.5);
				
				addTriangle(v1, v2, v3, uv1, uv2, uv3);
				
				v1 = new Vertex3D(	radius*Math.cos(u+stepU),
									-height*.5,
									radius*Math.sin(u+stepU)
								 );
				
				v2 = new Vertex3D(	radius*Math.cos(u),
									-height*.5,
									radius*Math.sin(u)
								 );
				v3 = new Vertex3D(	0,
									-height*.5,
									0
								 );
				uv1 = new UVCoords(Math.cos(u+stepU)*.5+.5, .5-Math.sin(u+stepU)*.5);
				uv2 = new UVCoords(Math.cos(u)*.5+.5, .5-Math.sin(u)*.5);
				uv3 = new UVCoords(.5, .5);
				addTriangle(v1, v2, v3, uv1, uv2, uv3);
			}
		}
	}
}