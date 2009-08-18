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

package com.derschmale.wick3d.core.io.collada
{
	import com.derschmale.wick3d.core.geometry.Vertex3D;
	import com.derschmale.wick3d.core.imagemaps.UVCoords;
	import com.derschmale.wick3d.core.objects.Model3D;
	import com.derschmale.wick3d.materials.AbstractMaterial;
	
	
	/**
	 * The ColladaModel class is a geometric model generated from a Collada file.
	 * 
	 * @see com.derschmale.display3D.Collada
	 * 
	 * @author David Lenaerts
	 */
	public class ColladaModel extends Model3D
	{
		private var _xml : XML;
		
		private var _id : String;		
		private var _parsedVertices : Array;
		private var _parsedUV : Array;
		
		private var _geometryLib : XMLList;

		/**
		 * Creates a ColladaModel instance.
		 * 
		 * @param xml The Collada XML from which this model is generated.
		 * @param id The id of this collada geometry
		 * @param material The material used to render the model.
		 */
		public function ColladaModel(xml : XML, id : String, material : AbstractMaterial = null)
		{
			var geometryLibId : String;
			super(material);
			_id = id;
			_xml = xml;
			
			var ns : Namespace = _xml.namespace();
			default xml namespace = ns;
			
			geometryLibId = _xml.library_visual_scenes.visual_scene.node.(@id == _id).instance_geometry.@url;
			geometryLibId = geometryLibId.substr(1);
			_geometryLib = _xml.library_geometries.geometry.(@id==geometryLibId);
			
			parseVertices();
			parseUV();
			parseTriangles();
		}
		
		private function parseVertices() : void
		{
			var ns : Namespace = _xml.namespace();
			default xml namespace = ns;
			// the id of vertices for the node
			var verticesSourceId : String = _geometryLib.mesh.vertices.input.(@semantic == "POSITION").@source;
			verticesSourceId = verticesSourceId.substr(1);
			var verticesData : Array = String(_geometryLib.mesh.source.(@id==verticesSourceId).float_array).split(" ");
			var vertex : Vertex3D;
			
			_parsedVertices = [];
			
			for (var i : int = 0; i < verticesData.length; i += 3)
			{
				vertex = new Vertex3D(verticesData[i], verticesData[i+1], verticesData[i+2]);
				_parsedVertices.push(vertex);
			}
		}
		
		private function parseUV() : void
		{
			var ns : Namespace = _xml.namespace();
			default xml namespace = ns;
			// the id of vertices for the node
			var uvSourceId : String = _geometryLib.mesh.triangles.input.(@semantic == "TEXCOORD").@source;
			uvSourceId = uvSourceId.substr(1);
			var uvData : Array = String(_geometryLib.mesh.source.(@id==uvSourceId).float_array).split(" ");
			var uv : UVCoords;
			var stride : int = _geometryLib.mesh.source.(@id==uvSourceId).technique_common.accessor.@stride;
			_parsedUV = [];
			
			for (var i : int = 0; i < uvData.length; i += stride)
			{
				uv = new UVCoords(uvData[i], 1-uvData[i+1]);
				_parsedUV.push(uv);
			}
		}
		
		private function parseTriangles() : void
		{
			var ns : Namespace = _xml.namespace();
			default xml namespace = ns;
			var trianglesData : Array = String(_geometryLib.mesh.triangles.p).split(" ");
			var verticesOffset : int = _geometryLib.mesh.triangles.input.(@semantic == "VERTICES").@offset;
			//var verticesId : String = _geometryLib.mesh.vertices.input.(@semantic == "VERTICES").source;
			var uvOffset : int = _geometryLib.mesh.triangles.input.(@semantic == "TEXCOORD").@offset;
			
			var v1 : Vertex3D, v2 : Vertex3D, v3 : Vertex3D;
			var uv1 : UVCoords, uv2 : UVCoords, uv3 : UVCoords;
			//verticesId = verticesId.substr(1);
			
			for (var i : int = 0; i < trianglesData.length; i += 9)
			{
				v1 = _parsedVertices[trianglesData[i+verticesOffset+6]];
				uv1 = _parsedUV[trianglesData[i+uvOffset+6]];
				v2 = _parsedVertices[trianglesData[i+verticesOffset+3]];
				uv2 = _parsedUV[trianglesData[i+uvOffset+3]];
				v3 = _parsedVertices[trianglesData[i+verticesOffset]];
				uv3 = _parsedUV[trianglesData[i+uvOffset]];
				addTriangle(v1, v2, v3, uv1, uv2, uv3);
			}
		}
	}
}