package com.si3d.render
{
	import __AS3__.vec.Vector;

	import flash.display.*;
	import flash.geom.*;
	import com.si3d.geom.*;
	
	public class ProjectionMesh
	{
		public var verticesOnWorld:Vector.<Number>; // vertex on camera coordinate
		public var verticesOnScreen:Vector.<Number>; // vertex on screen
		public var facesProjected:Vector.<Face>; // projected face
		public var normalsProjected:Vector.<Vector3D>; // projected normals
		public var vnormals:Vector.<Vector3D>; // vertex normal
		public var nearZ:Number, farZ:Number; // z buffer range
		public var screenProjected:Boolean=false; // flag to projection on screen
		private var _projectedFaceIndices:Vector.<int>=new Vector.<int>();
		private var _base:Mesh;

		/** indices of projected faces */
		public function get indicesProjected():Vector.<int>
		{
			var idx:Vector.<int>=_projectedFaceIndices;
			if (idx.length == 0)
				for each (var f:Face in facesProjected)
					idx.push(f.i0, f.i1, f.i2);
			return idx;
		}

		public function set indexDirty(b:Boolean):void
		{
			if (b)
				_projectedFaceIndices.length=0;
		}

		public function get base():Mesh
		{
			return _base;
		}

		public function set base(m:Mesh):void
		{
			if (m && normalsProjected.length < m.faces.length)
			{
				var i:int=normalsProjected.length, imax:int=m.faces.length;
				normalsProjected.length=imax;
				for (; i < imax; ++i)
					normalsProjected[i]=new Vector3D();
			}
			_base=m;
		}

		public function get vertexImax():int
		{
			return (_base.verticesCount << 1) + _base.verticesCount;
		}

		/** constructor */
		function ProjectionMesh(m:Mesh=null)
		{
			this.verticesOnWorld=new Vector.<Number>();
			this.verticesOnScreen=new Vector.<Number>();
			this.facesProjected=new Vector.<Face>();
			this.normalsProjected=new Vector.<Vector3D>();
			this.vnormals=null;
			this.base=m;
		}
	}
}