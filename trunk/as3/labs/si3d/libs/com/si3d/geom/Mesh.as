package com.si3d.geom
{
	import __AS3__.vec.Vector;
	
	import com.si3d.lights.*;
	import com.si3d.materials.*;
	import com.si3d.objects.*;
	import com.si3d.render.*;
	import com.si3d.ui.*;
	
	import flash.display.*;
	import flash.geom.*;
	
	public class Mesh
	{
		public var materials:Vector.<Material>; // material list
		public var vertices:Vector.<Number>; // vertex
		public var verticesCount:int; // vertex count
		public var texCoord:Vector.<Number>; // texture coordinate
		public var faces:Vector.<Face>=new Vector.<Face>(); // face list
		public var wires:Vector.<Wire>=new Vector.<Wire>(); // wireframe list

		/** constructor */
		function Mesh(materials:Vector.<Material>=null)
		{
			this.materials=materials;
			this.vertices=new Vector.<Number>();
			this.texCoord=new Vector.<Number>();
			this.verticesCount=0;
		}

		/** clear all faces */
		public function clear():Mesh
		{
			for each (var face:Face in faces)
				Face.free(face);
			faces.length=0;
			return this;
		}

		/** register face */
		public function face(i0:int, i1:int, i2:int, mat:int=0):Mesh
		{
			faces.push(Face.alloc(faces.length, i0, i1, i2, -1, mat));
			return this;
		}

		/** register quadrangle face. set div=true to divide into 2 triangles. */
		public function qface(i0:int, i1:int, i2:int, i3:int, mat:int=0, div:Boolean=true):Mesh
		{
			if (div)
			{
				faces.push(Face.alloc(faces.length, i0, i1, i2, -1, mat), Face.alloc(faces.length + 1, i3, i2, i1, -1, mat));
			}
			else
				faces.push(Face.alloc(faces.length, i0, i1, i3, i2, mat));
			return this;
		}

		/** register wire */
		public function wire(i0:int, i1:int):Mesh
		{
			wires.push(Wire.alloc(wires.length, i0, i1));
			return this;
		}

		/** put mesh on world coordinate. */
		public function put(src:ProjectionMesh, mat:int=-1):Mesh
		{
			var i0:int=vertices.length, imax:int=src.vertexImax, flist:Vector.<Face>=src.base.faces;
			vertices.length+=imax;
			for (var i:int=0; i < imax; ++i)
				vertices[i0 + i]=src.verticesOnWorld[i];
			i0/=3;
			for each (var f:Face in flist)
			{
				i=(mat == -1) ? f.mat : mat;
				if (f.i3 == -1)
					face(f.i0 + i0, f.i1 + i0, f.i2 + i0, i);
				else
					qface(f.i0 + i0, f.i1 + i0, f.i3 + i0, f.i2 + i0, i, false);
			}
			return this;
		}

		/** update face gravity point and normal. create fireframe lines when createWire==true */
		public function updateFaces(createWire:Boolean=false, facetAngle:Number=180, _texCoord:*=null):Mesh
		{
			verticesCount=vertices.length / 3;
			var vs:Vector.<Number>=vertices;
			var j:int = 0 ;
			for each (var f:Face in faces)
			{
				f.gpi=vs.length + 2;
				var i0:int=(f.i0 << 1) + f.i0, i1:int=(f.i1 << 1) + f.i1, i2:int=(f.i2 << 1) + f.i2;
				var x01:Number=vs[i1] - vs[i0], x02:Number=vs[i2] - vs[i0];
				vs.push((vs[i0++] + vs[i1++] + vs[i2++]) * 0.333333333333);
				var y01:Number=vs[i1] - vs[i0], y02:Number=vs[i2] - vs[i0];
				vs.push((vs[i0++] + vs[i1++] + vs[i2++]) * 0.333333333333);
				var z01:Number=vs[i1] - vs[i0], z02:Number=vs[i2] - vs[i0];
				vs.push((vs[i0++] + vs[i1++] + vs[i2++]) * 0.333333333333);
				f.normal=new Point3D(y02 * z01 - y01 * z02, z02 * x01 - z01 * x02, x02 * y01 - x01 * y02, 0);
				f.normal.normalize();
				if (f.i3 != -1)
				{
					var i3:int=(f.i3 << 1) + f.i3;
					vs[f.gpi - 2]=vs[f.gpi - 2] * 0.75 + vs[i3++] * 0.25;
					vs[f.gpi - 1]=vs[f.gpi - 1] * 0.75 + vs[i3++] * 0.25;
					vs[f.gpi]=vs[f.gpi] * 0.75 + vs[i3] * 0.25;
				}
				
				// uv
				if(_texCoord)
				{
					this.texCoord = _texCoord;
				}else{
					texCoord.push(vs[j], vs[j+1], vs[j+2]);
				}
					
				j+=3;
			}
			if (createWire)
			{
				var facetCos:Number=Math.cos((180 - facetAngle) * 57.29577951308232);
				for each (var f0:Face in faces)
				{
					_wire(f0, f0.i0, f0.i1);
					_wire(f0, f0.i1, f0.i2);
					if (f0.i3 == -1)
						_wire(f0, f0.i2, f0.i0);
					else
					{
						_wire(f0, f0.i2, f0.i3);
						_wire(f0, f0.i3, f0.i0);
					}
				}
			}
			return this;

			function _wire(f0:Face, i0:int, i1:int):void
			{
				var f1:Face=_findFace(i0, i1);
				if (f1 == null || facetCos >= f0.normal.dotProduct(f1.normal))
				{
					if (_findWire(i0, i1) == null)
						wire(i0, i1);
				}
			}
			function _findFace(i0:int, i1:int):Face
			{
				for each (var f:Face in faces)
				{
					if ((f.i0 == i0 && f.i1 == i1) || (f.i0 == i1 && f.i1 == i0) || (f.i1 == i0 && f.i2 == i1) || (f.i1 == i1 && f.i2 == i0))
						return f;
					if (f.i3 == -1)
						if ((f.i2 == i0 && f.i0 == i1) || (f.i2 == i1 && f.i0 == i0))
							return f;
						else if ((f.i2 == i0 && f.i3 == i1) || (f.i2 == i1 && f.i3 == i0) || (f.i3 == i0 && f.i0 == i1) || (f.i3 == i1 && f.i0 == i0))
							return f;
				}
				return null;
			}
			function _findWire(i0:int, i1:int):Wire
			{
				for each (var w:Wire in wires)
				{
					if ((w.i0 == i0 && w.i1 == i1) || (w.i0 == i1 && w.i1 == i0))
						return w;
				}
				return null;
			}
		}
	}
}