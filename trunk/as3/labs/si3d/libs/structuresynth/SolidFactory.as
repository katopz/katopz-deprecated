package structuresynth
{
	import com.si3d.geom.*;
	import com.si3d.render.*;
	
	import flash.display.BitmapData;
	import flash.geom.*;

	public class SolidFactory
	{
		// regular solids
		//--------------------------------------------------
		static public function tetrahedron(mesh:Mesh, size:Number, mat:int=0):Mesh
		{
			mesh.vertices.push(size, size, size, size, -size, -size, -size, size, -size, -size, -size, size);
			mesh.qface(0, 2, 1, 3, mat).qface(1, 3, 0, 2, mat);
			return mesh.updateFaces(true);
		}

		static public function hexahedron(mesh:Mesh, size:Number, mat:int=0, div:Boolean=true):Mesh
		{
			for (var i:int=0; i < 8; ++i)
				mesh.vertices.push((i & 1) ? size : -size, ((i >> 1) & 1) ? size : -size, (i >> 2) ? size : -size);
			mesh.qface(0, 1, 2, 3, mat, div).qface(1, 0, 5, 4, mat, div).qface(0, 2, 4, 6, mat, div);
			mesh.qface(2, 3, 6, 7, mat, div).qface(3, 1, 7, 5, mat, div).qface(5, 4, 7, 6, mat, div);
			return mesh.updateFaces(true, 179);
		}

		static public function octahedron(mesh:Mesh, size:Number, mat:int=0):Mesh
		{
			mesh.vertices.push(0, 0, -size, -size, 0, 0, 0, -size, 0, size, 0, 0, 0, size, 0, 0, 0, size);
			mesh.qface(0, 1, 2, 5, mat).qface(0, 2, 3, 5, mat).qface(0, 3, 4, 5, mat).qface(0, 4, 1, 5, mat);
			return mesh.updateFaces(true);
		}

		static public function dodecahedron(mesh:Mesh, size:Number, mat:int=0, div:Boolean=true):Mesh
		{
			var a:Number=size * 0.149071198, b:Number=size * 0.241202266, c:Number=size * 0.283550269, d:Number=size * 0.390273464, e:Number=size * 0.458793973, f:Number=size * 0.631475730, g:Number=size * 0.742344243;
			mesh.vertices.push(c, f, d, e, f, -a, 0, f, -b - b, -e, f, -a, -c, f, d);
			mesh.vertices.push(e, a, f, g, a, -b, 0, a, -d - d, -g, a, -b, -e, a, f);
			mesh.vertices.push(0, -a, d + d, g, -a, b, e, -a, -f, -e, -a, -f, -g, -a, b);
			mesh.vertices.push(0, -f, b + b, e, -f, a, c, -f, -d, -c, -f, -d, -e, -f, a);
			mesh.qface(0, 3, 1, 2, mat, div).face(0, 4, 3, mat).qface(4, 5, 9, 10, mat, div).face(4, 0, 5, mat);
			mesh.qface(0, 6, 5, 11, mat, div).face(0, 1, 6, mat).qface(1, 7, 6, 12, mat, div).face(1, 2, 7, mat);
			mesh.qface(2, 8, 7, 13, mat, div).face(2, 3, 8, mat).qface(3, 9, 8, 14, mat, div).face(3, 4, 9, mat);
			mesh.qface(17, 11, 12, 6, mat, div).face(17, 16, 11, mat).qface(16, 10, 11, 5, mat, div).face(16, 15, 10, mat);
			mesh.qface(15, 14, 10, 9, mat, div).face(15, 19, 14, mat).qface(19, 13, 14, 8, mat, div).face(19, 18, 13, mat);
			mesh.qface(18, 12, 13, 7, mat, div).face(18, 17, 12, mat).qface(16, 18, 15, 19, mat, div).face(16, 17, 18, mat);
			return mesh.updateFaces(true, 179);
		}

		static public function icosahedron(mesh:Mesh, size:Number, mat:int=0):Mesh
		{
			var a:Number=size * 0.276393202, b:Number=size * 0.447213595, c:Number=size * 0.525731112, d:Number=size * 0.723606798, e:Number=size * 0.850650808;
			mesh.vertices.push(0, size, 0, 0, b, b + b, e, b, a, c, b, -d, -c, b, -d, -e, b, a);
			mesh.vertices.push(e, -b, -a, c, -b, d, -c, -b, d, -e, -b, -a, 0, -b, -b - b, 0, -size, 0);
			mesh.qface(0, 2, 1, 7, mat).qface(0, 3, 2, 6, mat).qface(0, 4, 3, 10, mat).qface(0, 5, 4, 9, mat).qface(0, 1, 5, 8, mat);
			mesh.qface(1, 7, 8, 11, mat).qface(2, 6, 7, 11, mat).qface(3, 10, 6, 11, mat).qface(4, 9, 10, 11, mat).qface(5, 8, 9, 11, mat);
			return mesh.updateFaces(true);
		}

		static public function sphere(mesh:Mesh, size:Number, mat:int=0):Mesh
		{
			return icosahedron(mesh, size, mat);
		}
		
		static public function plane(mesh:Mesh, width:Number, height:Number, mat:int=0):Mesh
		{
			// vertices
			mesh.vertices.push(0,0,0);
			mesh.vertices.push(width,0,0);
			mesh.vertices.push(width,height,0);
			mesh.vertices.push(0,height,0);
			
			// indices
			mesh.face(0, 1, 2, mat).face(2,3,0, mat);
			
			// uvtData
			mesh.texCoord.push(0,0,0);
			mesh.texCoord.push(1,0,0);
			mesh.texCoord.push(1,1,0);
			mesh.texCoord.push(0,1,0);	
			
			return mesh.updateFaces(false,180,mesh.texCoord);
		}
	}
}