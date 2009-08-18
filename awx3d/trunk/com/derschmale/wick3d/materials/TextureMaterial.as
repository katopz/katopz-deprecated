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
	import com.derschmale.wick3d.core.geometry.Vertex3D;
	import com.derschmale.wick3d.core.imagemaps.UVCoords;
	
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.Graphics;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * The TextureMaterial class is a material that maps an image to a triangle, adding detail to the surface.
	 * 
	 * @author David Lenaerts
	 */
	public class TextureMaterial extends AbstractMaterial implements IMaterial
	{
		private var _bitmapData : BitmapData;
		private var _smooth : Boolean;
		private var _perspectiveCorrection : Boolean;
		private var _perspectiveDetail : int = 2;
		
		/**
		 * The horizontal downscaling of the texture, so the texture will be tiled. For example, a value of 2 will scale the texture's width by half, providing a tile of 2.
		 */
		public var tileU : Number = 1;
		
		/**
		 * The vertical downscaling of the texture, so the texture will be tiled. For example, a value of 2 will scale the texture's height by half, providing a tile of 2.
		 */
		public var tileV : Number = 1;
		
		/**
		 * The horizontal offset in texture space. For example, a value of 0.5 will move the texture half its width to the right
		 */
		public var offsetU : Number = 0;
		
		/**
		 * The vertical offset in texture space. For example, a value of 0.5 will move the texture half its height down.
		 */
		public var offsetV : Number = 0;
		
		private var _tr1 : Matrix = new Matrix();
		private var _tr2 : Matrix = new Matrix();
		
		/**
		 * Creates a TextureMaterial instance.
		 * 
		 * @param bitmapData The BitmapData object to be used as the texture.
		 * @param smooth Defines whether the texture should be smoothed when drawing or not.
		 */
		public function TextureMaterial(bitmapData : BitmapData, smooth : Boolean = false)
		{
			super();
			_bitmapData = bitmapData;
			_smooth = smooth;
		}
		
		/**
		 * The BitmapData object to be used as the texture.
		 */
		public function get bitmapData() : BitmapData
		{
			return _bitmapData;
		}
		
		public function set bitmapData(value : BitmapData) : void
		{
			_bitmapData = value;
		}
		
		/**
		 * Defines whether the texture data should be interpolated when mapped.
		 */
		public function get smooth() : Boolean
		{
			return _smooth;
		}
		
		public function set smooth(value : Boolean) : void
		{
			_smooth = value;
		}
		
		/**
		 * Defines whether the triangles should be subdivided to make the textures look more perspective correct.
		 */
		public function get perspectiveCorrection() : Boolean
		{
			return _perspectiveCorrection;
		}
		
		public function set perspectiveCorrection(value : Boolean) : void
		{
			_perspectiveCorrection = value;
		}
		
		/**
		 * The amount of times the triangles should be subdivided iteratively. Higher values will look more correct, but will be slower. This parameter has no effect if perspectiveCorrection is set to false. Default value is 2. 
		 */
		public function get perspectiveDetail() : int
		{
			return _perspectiveDetail;
		}
		
		public function set perspectiveDetail(value : int) : void
		{
			_perspectiveDetail = value;
		}
		
		/**
		 * Renders a Triangle3D to the target Graphics object.
		 * 
		 * @param triangle The Triangle3D object to be rendered.
		 * @param target The Graphics instance that will be drawn to.
		 * 
		 * @see com.derschmale.wick3d.core.geometry.Triangle3D
		 */
		override public function drawTriangle(triangle : Triangle3D, target:Graphics):void
		{
			if (_perspectiveCorrection)
				drawSubDivisions(triangle, target, _perspectiveDetail-1);
			else drawAffine(triangle, target);
		}
		
		/**
		 * Retrieves the material's texture coordinates for the 2D viewport coordinates.
		 * 
		 * @param x The x-coordinate in Viewport coordinates.
		 * @param y The y-coordinate in Viewport coordinates.
		 * 
		 * @return A Point representing the material's coordinates for the 2D viewport coordinates.
		 */
		override public function getUVCoords(x : Number, y : Number, triangle : Triangle3D) : Point
		{
			var uv : Point = new Point(x, y);
			_tr1 = generateTransform(triangle);
			_tr1.invert();
			
			return _tr1.transformPoint(uv);
		}
		
		// count will be used when iterating
		private function drawSubDivisions(triangle : Triangle3D, target:Graphics, count:int) : void
		{
			var newTriangle1 : Triangle3D = new Triangle3D(null, null, null),
				newTriangle2 : Triangle3D = new Triangle3D(null, null, null),
				newTriangle3 : Triangle3D = new Triangle3D(null, null, null),
				newTriangle4 : Triangle3D = new Triangle3D(null, null, null);
			var newVertex1 : Vertex3D, newVertex2 : Vertex3D, newVertex3 : Vertex3D;
			var newUV1 : UVCoords, newUV3 : UVCoords, newUV2 : UVCoords;
			var interpolationZ1 : Number;
			var interpolationZ2 : Number;
			var interpolationZ3 : Number;
			
			// we only need the interpolated z-values, which is NOT equal to the mean z due to perspective transformation
			interpolationZ1 = 2/(1/triangle.v1.z + 1/triangle.v2.z);
			interpolationZ2 = 2/(1/triangle.v2.z + 1/triangle.v3.z);
			interpolationZ3 = 2/(1/triangle.v3.z + 1/triangle.v1.z);
			
			newVertex1 = new Vertex3D( 0, 0, interpolationZ1 );
			newVertex2 = new Vertex3D( 0, 0, interpolationZ2 );
			newVertex3 = new Vertex3D( 0, 0, interpolationZ3 );
					
			newVertex1.coords2D = new Point((triangle.v1.coords2D.x+triangle.v2.coords2D.x)*.5,
											(triangle.v1.coords2D.y+triangle.v2.coords2D.y)*.5
											);
			newVertex2.coords2D = new Point((triangle.v2.coords2D.x+triangle.v3.coords2D.x)*.5,
											(triangle.v2.coords2D.y+triangle.v3.coords2D.y)*.5
											);
			newVertex3.coords2D = new Point((triangle.v1.coords2D.x+triangle.v3.coords2D.x)*.5,
											(triangle.v1.coords2D.y+triangle.v3.coords2D.y)*.5
											);
			newUV1 = new UVCoords(	interpolationZ1*( triangle.uv1.u/triangle.v1.z+triangle.uv2.u/triangle.v2.z )*.5,
									interpolationZ1*( triangle.uv1.v/triangle.v1.z+triangle.uv2.v/triangle.v2.z )*.5
								);
			newUV2 = new UVCoords(	interpolationZ2*( triangle.uv2.u/triangle.v2.z+triangle.uv3.u/triangle.v3.z )*.5,
									interpolationZ2*( triangle.uv2.v/triangle.v2.z+triangle.uv3.v/triangle.v3.z )*.5
								);
			newUV3 = new UVCoords(	interpolationZ3*( triangle.uv1.u/triangle.v1.z+triangle.uv3.u/triangle.v3.z )*.5,
									interpolationZ3*( triangle.uv1.v/triangle.v1.z+triangle.uv3.v/triangle.v3.z )*.5
								);
			
			newTriangle1.v1 = triangle.v1;
			newTriangle1.uv1 = triangle.uv1;
			newTriangle1.v2 = newVertex1;
			newTriangle1.uv2 = newUV1;
			newTriangle1.v3 = newVertex3;
			newTriangle1.uv3 = newUV3;

			newTriangle2.v1 = newVertex1;
			newTriangle2.uv1 = newUV1;
			newTriangle2.v2 = triangle.v2;
			newTriangle2.uv2 = triangle.uv2;
			newTriangle2.v3 = newVertex2;
			newTriangle2.uv3 = newUV2;
			
			newTriangle3.v1 = newVertex2;
			newTriangle3.uv1 = newUV2;
			newTriangle3.v2 = triangle.v3;
			newTriangle3.uv2 = triangle.uv3;
			newTriangle3.v3 = newVertex3;
			newTriangle3.uv3 = newUV3;
			
			newTriangle4.v1 = newVertex1;
			newTriangle4.uv1 = newUV1;
			newTriangle4.v2 = newVertex2;
			newTriangle4.uv2 = newUV2;
			newTriangle4.v3 = newVertex3;
			newTriangle4.uv3 = newUV3;
			
			if (count-- > 0) {
				drawSubDivisions(newTriangle1, target, count);
				drawSubDivisions(newTriangle2, target, count);
				drawSubDivisions(newTriangle3, target, count);
				drawSubDivisions(newTriangle4, target, count);
			}
			else {
				drawAffine(newTriangle1, target);
				drawAffine(newTriangle2, target);
				drawAffine(newTriangle3, target);
				drawAffine(newTriangle4, target);
			}
		}
		
		private function drawAffine(triangle : Triangle3D, target : Graphics) : void
		{
			var matrix : Matrix = generateTransform(triangle);

			//target.lineStyle(1, 0xff0000);
			target.beginBitmapFill(_bitmapData, matrix, true, smooth);
			target.moveTo(triangle.v1.coords2D.x, triangle.v1.coords2D.y);
			target.lineTo(triangle.v2.coords2D.x, triangle.v2.coords2D.y);
			target.lineTo(triangle.v3.coords2D.x, triangle.v3.coords2D.y);
			target.endFill();
		}
		
		private function generateTransform(triangle : Triangle3D) : Matrix
		{
			var w : Number = _bitmapData.width, h : Number = _bitmapData.height;
			var uvU1 : Number = (triangle.uv1.u*tileU+offsetU)*w,
				uvV1 : Number = (triangle.uv1.v*tileV+offsetV)*h,
				uvU2 : Number = (triangle.uv2.u*tileU+offsetU)*w,
				uvV2 : Number = (triangle.uv2.v*tileV+offsetV)*h, 
				uvU3 : Number = (triangle.uv3.u*tileU+offsetU)*w, 
				uvV3 : Number = (triangle.uv3.v*tileV+offsetV)*h;
			
			/* fix colinear uv coordinates */
			if( (uvU1 == uvU2 && uvV1 == uvV2) || (uvU1 == uvU3 && uvV1 == uvV3) )
			{
				uvU1 -= (uvU1 > 0.05)? 0.05 : -0.05;
				uvV1 -= (uvV1 > 0.07)? 0.07 : -0.07;
			}
			
			if( uvU3 == uvU2 && uvV3 == uvV2 )
			{
				uvU3 -= (uvU3 > 0.05)? 0.04 : -0.04;
				uvV3 -= (uvV3 > 0.06)? 0.06 : -0.06;
			}
			
			_tr1.a = uvU2-uvU1;
			_tr1.b = uvV2-uvV1;
			_tr1.c = uvU3-uvU1;
			_tr1.d = uvV3-uvV1;
			_tr1.tx = uvU1;
			_tr1.ty = uvV1;
			
			_tr2.a = triangle.v2.coords2D.x-triangle.v1.coords2D.x;
			_tr2.b = triangle.v2.coords2D.y-triangle.v1.coords2D.y;
			_tr2.c = triangle.v3.coords2D.x-triangle.v1.coords2D.x;
			_tr2.d = triangle.v3.coords2D.y-triangle.v1.coords2D.y;
			_tr2.tx = triangle.v1.coords2D.x;
			_tr2.ty = triangle.v1.coords2D.y;
			_tr1.invert();
			_tr1.concat(_tr2);
			
			return _tr1;
		}
	}
}