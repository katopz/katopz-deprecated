package com.si3d.objects
{
	import __AS3__.vec.Vector;
	
	import com.si3d.geom.*;
	import com.si3d.materials.Material;
	import com.si3d.render.*;
	
	import flash.display.*;
	import flash.geom.*;

	public class Model extends Mesh
	{
		//public var materials:Vector.<Material>; // material list
		//public var vertices:Vector.<Number>;
		//public var texCoord:Vector.<Number>;
		//public var faces:Vector.<Face>=new Vector.<Face>();
		private var _indices:Vector.<int>=new Vector.<int>();

		function Model(vertices:Vector.<Number>=null, texCoord:Vector.<Number>=null, materials:Vector.<Material>=null)
		{
			this.vertices=vertices || new Vector.<Number>();
			this.texCoord=texCoord || new Vector.<Number>();
			this.materials=materials || Vector.<Material>([new Material()]);
		}
/*
		public function clear():Model
		{
			for each (var face:Face in faces)
				Face.free(face);
			faces.length=0;
			return this;
		}

		public function face(i0:int, i1:int, i2:int, mat:int=0):Model
		{
			var face:Face=Face.alloc(faces.length, i0, i1, i2);
			face.i0=i0;
			face.i1=i1;
			face.i2=i2;
			face.mat=mat;
			faces.push(face);
			return this;
		}
*/
		public function get indices():Vector.<int>
		{
			_indices.length=0;
			for each (var face:Face in faces)
				_indices.push(face.i0, face.i1, face.i2);
			return _indices;
		}
	}
}