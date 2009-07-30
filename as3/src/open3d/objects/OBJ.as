package open3d.objects
{
	import flash.events.*;
	import flash.geom.Vector3D;
	import flash.net.URLLoader;
	import flash.utils.Dictionary;
	
	import open3d.geom.UV;
	import open3d.geom.Vertex;
	import open3d.materials.BitmapFileMaterial;
	import open3d.materials.Material;
	import open3d.utils.LoaderUtil;

	/**
	 * The OBJ class let you parse and load object files (.obj).
	 *
	 * @author Knut Urdalen <knut.urdalen@gmail.com>
	 * @see http://people.scs.fsu.edu/~burkardt/txt/obj_format.txt
	 * 
	 * Modify for Native
	 * @author katopz
	 */
	public class OBJ extends Mesh
	{

		private var _loaderObj:URLLoader;
		private var _loaderMtl:URLLoader;
		private var _obj:String;
		private var _mtl:String;
		private var _filename:String;
		private var _loader:URLLoader;
		private var _childrenCount:int = 0;
		private var _materials:Dictionary;

		public function OBJ(obj:String, mtl:* = null, scale:Number = 1)
		{
			super();

			this._obj = obj;

			if (mtl is String)
			{
				this._mtl = mtl;
				loadMtl();
			}
			else if (mtl is Material)
			{
				//this._materials = mtl;
				material = mtl;
			}
			
			loadObj();

			//this._materials = materials || new MaterialsList();
		}
		
		public function loadMtl():Object
		{
			return LoaderUtil.load(this._mtl, onLoadMtl);
		}

		private function onLoadMtl(event:Event):void
		{
			if(event.type == Event.COMPLETE)
				parseMtl(String(event.target.data));
		}
		
		public function loadObj():Object
		{
			return LoaderUtil.load(this._obj, onLoadObj);
		}

		private function onLoadObj(event:Event):void
		{
			if(event.type == Event.COMPLETE)
				parseObj(String(event.target.data));
		}
		
		/**
		 * Material Library File (.mtl)
		 *
		 * Material library files contain one or more material definitions, each
		 * of which includes the color, texture, and reflection map of individual
		 * materials. These are applied to the surfaces and vertices of objects.
		 * Material files are stored in ASCII format and have the .mtl extension.
		 */
		private function parseMtl(mtl:String):void
		{
			var lines:Array = mtl.split("\n");
			var parts:Array;
			var keyword:String;
			var currentMaterial:Material;
			var currentName:String;
			var mtls:Object = {};

			for (var i:int = 0; i < lines.length; ++i)
			{

				if (lines[i].substring(0, 1) == "#" || lines[i].length == 0)
				{ // Comment or blank
					continue; // skip
				}

				parts = lines[i].split(" ");
				if (parts.length > 0)
				{
					keyword = parts[0];
				}
				
				if(keyword=="\r")continue;
				
				switch (keyword)
				{

					case "newmtl":
					{ // assigns a name to the material and designates the start of a material description

						currentName = parts[1].split("\r")[0];
						//currentMaterial = this.materials.addMaterial(new MaterialObject3D(), parts[1]);

						break;
					}
					// Ka r g b
					case "Ka":
					{ // defines the ambient color of the material to be (r,g,b). The default is (0.2,0.2,0.2); 
						break;
					}
					// Kd r g b
					case "Kd":
					{ // defines the diffuse color of the material to be (r,g,b). The default is (0.8,0.8,0.8);
						break;
					}
					// Ks r g b
					case "Ks":
					{ // defines the specular color of the material to be (r,g,b). This color shows up in highlights. The default is (1.0,1.0,1.0);
						break;
					}
					// Ke r g b
					case "Ke":
					{
						break;
					}
					// d alpha
					case "d":
					{ // defines the transparency of the material to be alpha. The default is 1.0 (not transparent at all) Some formats use Tr instead of d; 
						break;
					}
					// Tr alpha
					case "Tr":
					{ // defines the transparency of the material to be alpha. The default is 1.0 (not transparent at all). Some formats use d instead of Tr; 
						break;
					}
					// Ns s
					case "Ns":
					{ // defines the shininess of the material to be s. The default is 0.0;
						break;
					}
					// illum n
					case "illum":
					{ // denotes the illumination model used by the material. illum = 1 indicates a flat material with no specular highlights, so the value of Ks is not used. illum = 2 denotes the presence of specular highlights, and so a specification for Ks is required.
						break;
					}
					// map_Ka filename
					case "map_Ka":
					{ // names a file containing a texture map, which should just be an ASCII dump of RGB values; 
						break;
					}
					// map_Kd filename
					case "map_Kd":
					{

						//var material:MaterialObject3D = this.materials.getMaterialByName(currentName);
						//this.materials.removeMaterial(currentMaterial);

						mtls[currentName] = new BitmapFileMaterial("image/" + parts[1]);

						//mtls.push({currentName:new BitmapFileMaterial(parts[1])});

						// new MaterialsList({currentName:new BitmapFileMaterial(parts[1])});						

						//currentMaterial.url = parts[1];

						break;
					}
					// map_Bump filename
					case "map_Bump":
					{
						break;
					}

				}
			}

			//this.materials = new MaterialsList(mtls);
			_materials = new Dictionary(true);
			_materials[currentName] = mtls[currentName];
			trace("currentName:"+currentName)
			//loadObj();
		}
		
		private var vertices:Array = [];
		private function parseObj(obj:String):void
		{
			var lines:Array = obj.split("\n");
			var parts:Array;
			var keyword:String;
			var verticesList:Array = [];
			var uvList:Array = [];
			var normalList:Array = [];
			var currentObject:Object3D = this;
			var _currentMaterial:String;

			for (var i:int = 0; i < lines.length; ++i)
			{

				if (lines[i].substring(0, 1) == "#" || lines[i].length == 0)
				{ // Comment or blank
					continue; // skip
				}

				parts = lines[i].split(" ");
				if (parts.length > 0)
				{
					keyword = parts[0];
				}

				switch (keyword)
				{

					// Vertex data
					case "v":
					{ // Geometric vertices
						verticesList.push(new Vertex(parts[1], parts[2], -parts[3]));
						vertices.push(verticesList[verticesList.length - 1]);
						break;
					}
					case "vt":
					{ // Texture vertices
						uvList.push(new UV(parts[1], 1-parts[2]));
						break;
					}
					case "vn":
					{ // Vertex normal
						normalList.push(new Vector3D(parts[1], parts[2], parts[3]));
						break;
					}
					case "vp":
					{ // Parameter space vertices
						break;
					}

					// Elements
					case "p":
					{ // Point
						break;
					}
					case "l":
					{ // Line
						break;
					}
					case "f":
					{ // Face

						if (parts.length != 4)
						{ // not a triangle
							continue; // skip
						}

						var v0:Vertex, v1:Vertex, v2:Vertex;
						var i0:Array, i1:Array, i2:Array;
						var uv0:UV, uv1:UV, uv2:UV;

						// split info in each parameter
						i0 = parts[1].split("/");
						i1 = parts[2].split("/");
						i2 = parts[3].split("/");

						v0 = verticesList[i0[0] - 1];
						v1 = verticesList[i1[0] - 1];
						v2 = verticesList[i2[0] - 1];

						//trace("v0: " + v0 + ", v1: " + v1 + ", v2: " + v2);

						if (i0[1] != "")
						{ // texture data may not be present (this happens if normals are exported, but not texture coordinates)
							uv0 = uvList[i0[1] - 1];
							uv1 = uvList[i1[1] - 1];
							uv2 = uvList[i2[1] - 1];
						}
						else
						{
							uv0 = new UV(0, 0);
							uv1 = new UV(0, 1);
							uv2 = new UV(1, 0);
						}

						if (i0[2] != "")
						{ // add normals
							v0.normal = normalList[i0[2] - 1];
							v1.normal = normalList[i1[2] - 1];
							v2.normal = normalList[i2[2] - 1];
						}

						//currentObject.geometry.faces.push(new Triangle3D(this, [v0, v1, v2], _materials.getMaterialByName(_currentMaterial), [uv0, uv1, uv2]));
						addFace(v0, v1, v2, Vector.<UV>([uv0, uv1, uv2]));
						
						break;
					}
					case "curv":
					{ // Curve
						break;
					}
					case "curv2":
					{ // 2D curve
						break;
					}
					case "surf":
					{ // Surface
						break;
					}

					// Free-form curve/surface attributes
					case "deg":
					{ // Degree
						break;
					}
					case "bmat":
					{ // Basis matrix
						break;
					}
					case "step":
					{ // Step size
						break;
					}
					case "cstype":
					{ // Curve or surface type
						break;
					}


					// Free-form curve/surface body statements
					case "parm":
					{ // Parameter values
						break;
					}
					case "trim":
					{ // Outer trimming loop
						break;
					}
					case "hole":
					{ // Inner trimming loop
						break;
					}
					case "scrv":
					{ // Special curve
						break;
					}
					case "sp":
					{ // Special point
						break;
					}
					case "end":
					{ // End statement
						break;
					}

					// Connectivity between free-form surfaces
					case "con":
					{ // Connect
						break;
					}

					// Grouping
					case "g":
					{ // Group name

						//TODO//currentObject = this.addChild(new TriangleMesh3D(null, null, null, parts[1]), parts[1]);

						break;
					}
					case "s":
					{ // Smoothing group
						break;
					}
					case "mg":
					{ // Merging group
						break;
					}
					case "o":
					{ // Object name
						//currentObject = this.addChild(new TriangleMesh3D(null, null, null, parts[1]), parts[1]);				
						break;
					}

					// Display/render attributes
					case "bevel":
					{ // Bevel interpolation
						break;
					}
					case "c_interp":
					{ // Color interpolation
						break;
					}
					case "d_interp":
					{ // Dissolve interpolation
						break;
					}
					case "lod":
					{ // Level of detail
						break;
					}
					case "usemtl":
					{ // Material name

						currentObject.material = this._materials[parts[1]];

						//var material:MaterialObject3D = MaterialObject3D.DEFAULT;
						//material.name = parts[1];
						//this._materials.addMaterial(material, parts[1]);				

						break;
					}
					case "mtllib":
					{ // Material library

						var filename:String = parts[1];

						break;
					}
					case "shadow_obj":
					{ // Shadow casting
						break;
					}
					case "trace_obj":
					{ // Ray tracing
						break;
					}
					case "ctech":
					{ // Curve approximation technique
						break;
					}
					case "stech":
					{ // Surface approximation technique
						break;
					}
					default:
					{ // unknown keyword
						break;
					}
				}
			}
			
			buildFaces(material);
		}
		
		private var i:int = 0;
		private var n:int = -1;
		
		private function addFace(v0:Vertex,v1:Vertex,v2:Vertex, uvs:Vector.<UV>):void
		{
			_vin[i++] = v0.x;
			_vin[i++] = v0.y;
			_vin[i++] = v0.z;
			
			_vin[i++] = v1.x;
			_vin[i++] = v1.y;
			_vin[i++] = v1.z;

			_vin[i++] = v2.x;
			_vin[i++] = v2.y;
			_vin[i++] = v2.z;
			
			_triangles.uvtData.push(uvs[0].u, uvs[0].v, 1);
			_triangles.uvtData.push(uvs[1].u, uvs[1].v, 1);
			_triangles.uvtData.push(uvs[2].u, uvs[2].v, 1);
			
			n += 3;

			_triangles.indices.push(n, n - 1, n - 2);
		}
	}
}


