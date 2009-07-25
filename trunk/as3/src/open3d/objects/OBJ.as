package open3d.objects 
{
	import open3d.geom.Face;
	import open3d.geom.UV;
	import open3d.materials.BitmapFileMaterial;
	import open3d.materials.Material;
	import open3d.utils.LoaderUtil;
	
	import flash.events.*;
	import flash.geom.Vector3D;
	import flash.net.*;
	import flash.utils.ByteArray;	

	//TODO : clean this!, mtl + group not done yet
	
	/**
	 * File loader for the OBJ file format.<br/>
	 * <br/>
	 * note: Multiple objects support and autoload mtls are supported since Away v 2.1.<br/>
	 * Class tested with the following 3D apps:<br/>
	 * - Strata CX mac 5.5<br/>
	 * - Biturn ver 0.87b4 PC<br/>
	 * - LightWave 3D OBJ Export v2.1 PC<br/>
	 * - Max2Obj Version 4.0 PC<br/>
	 * - AC3D 6.2.025 mac<br/>
	 * - Carrara (file provided)<br/>
	 * - Hexagon (file provided)<br/>
	 * - geometry supported tags: f,v,vt, g<br/>
	 * - geometry unsupported tags:vn,ka, kd r g b, kd, ks r g b,ks,ke r g b,ke,d alpha,d,tr alpha,tr,ns s,ns,illum n,illum,map_Ka,map_Bump<br/>
	 * - mtl unsupported tags: kd,ka,ks,ns,tr<br/>
	 * <br/>
	 * export from apps as polygon group or mesh as .obj file.<br/>
	 * added support for 3dmax negative vertexes references
	 * 
	 * @author katopz
	 */
	public class OBJ extends Mesh
	{
		public var mesh:Mesh;
		private var mtlPath:String;
		private var aMeshes:Array = [];
		private var aSources:Array;
		private var aMats:Array;
		private var vertices:Vector.<Vector3D>;
		private var uvs:Array = [];
		private var scaling:Number = 1;
		
		private var faceDatas:Vector.<Face>;
		private var container:Object3D;
		
		private var i:int = 0;
		private var n:int = -1;
		 
		private function parse(data:String):void
		{
			var lines:Array = data.split('\n');
			if (lines.length == 1)
				lines = data.split(String.fromCharCode(13));
			var trunk:Array;
			var isNew:Boolean = true;
			var group:Object3D;
			
			faceDatas = new Vector.<Face>();
			vertices= new Vector.<Vector3D>();
			vertices[0] = new Vector3D();
			uvs = [new UV()];

			var isNeg:Boolean;
			var myPattern:RegExp = new RegExp("-", "g");
			var face0:Array;
			var face1:Array;
			var face2:Array;
			var face3:Array;

			for each (var line:String in lines)
			{
				trunk = line.replace("  ", " ").replace("  ", " ").replace("  ", " ").split(" ");

				switch (trunk[0])
				{
					case "g":
						group = new Object3D();
						group.name = trunk[1];

						if (container == null)
						{
							container = new Object3D();
						}

						(container as Object3D).addChild(group);
						isNew = true;

						break;

					case "usemtl":
						//aMeshes[aMeshes.length - 1].materialid = trunk[1];
						break;

					case "v":
						if (isNew)
						{
							//generateNewMesh();
							isNew = false;
							if (group != null)
							{
								//group.addChild(mesh);
							}
						}
						var _v:Vector3D = new Vector3D(-parseFloat(trunk[1]) * scaling, parseFloat(trunk[2]) * scaling, -parseFloat(trunk[3]) * scaling);
						vertices.push(_v);

						break;

					case "vt":
						uvs.push(new UV(parseFloat(trunk[1]), 1-parseFloat(trunk[2])));
						break;

					case "f":
						isNew = true;

						if (trunk[1].indexOf("-") == -1)
						{

							face0 = trysplit(trunk[1], "/");
							face1 = trysplit(trunk[2], "/");
							face2 = trysplit(trunk[3], "/");

							if (trunk[4] != null)
							{
								face3 = trysplit(trunk[4], "/");
							}
							else
							{
								face3 = null;
							}

							isNeg = false;

						}
						else
						{

							face0 = trysplit(trunk[1].replace(myPattern, ""), "/");
							face1 = trysplit(trunk[2].replace(myPattern, ""), "/");
							face2 = trysplit(trunk[3].replace(myPattern, ""), "/");

							if (trunk[4] != null)
							{
								face3 = trysplit(trunk[4].replace(myPattern, ""), "/");
							}
							else
							{
								face3 = null;
							}

							isNeg = true;
						}

						try
						{

							if (face3 != null && face3.length > 0 && !isNaN(parseInt(face3[0])))
							{

								if (isNeg)
								{
									addFace
									(
										vertices[vertices.length - parseInt(face1[0])], 
										vertices[vertices.length - parseInt(face0[0])], 
										vertices[vertices.length - parseInt(face3[0])],
										Vector.<UV>([
											checkUV(1, uvs[uvs.length - parseInt(face1[1])]), 
											checkUV(2, uvs[uvs.length - parseInt(face0[1])]), 
											checkUV(3, uvs[uvs.length - parseInt(face3[1])])
										])
									);

									addFace
									(
										vertices[vertices.length - parseInt(face2[0])], vertices[vertices.length - parseInt(face1[0])], vertices[vertices.length - parseInt(face3[0])],
										Vector.<UV>([
											checkUV(1, uvs[uvs.length - parseInt(face2[1])]), 
											checkUV(2, uvs[uvs.length - parseInt(face1[1])]), 
											checkUV(3, uvs[uvs.length - parseInt(face3[1])])
										])
									);
								}
								else
								{
									addFace
									(
										vertices[parseInt(face1[0])], vertices[parseInt(face0[0])], vertices[parseInt(face3[0])],
										Vector.<UV>([
											checkUV(1, uvs[parseInt(face1[1])]), 
											checkUV(2, uvs[parseInt(face0[1])]), 
											checkUV(3, uvs[parseInt(face3[1])])
										])
									);

									addFace
									(
										vertices[parseInt(face2[0])], vertices[parseInt(face1[0])], vertices[parseInt(face3[0])],
										Vector.<UV>([
											checkUV(1, uvs[parseInt(face2[1])]), 
											checkUV(2, uvs[parseInt(face1[1])]), 
											checkUV(3, uvs[parseInt(face3[1])])
										])
									);
								}

							}
							else
							{

								if (isNeg)
								{
									addFace
									(
										vertices[vertices.length - parseInt(face2[0])], vertices[vertices.length - parseInt(face1[0])], vertices[vertices.length - parseInt(face0[0])],
										Vector.<UV>([
											checkUV(1, uvs[uvs.length - parseInt(face2[1])]), 
											checkUV(2, uvs[uvs.length - parseInt(face1[1])]), 
											checkUV(3, uvs[uvs.length - parseInt(face0[1])])
										])
									);
								}
								else
								{
									addFace
									(
										vertices[parseInt(face2[0])], vertices[parseInt(face1[0])], vertices[parseInt(face0[0])],
										Vector.<UV>([
											checkUV(1, uvs[parseInt(face2[1])]), 
											checkUV(2, uvs[parseInt(face1[1])]), 
											checkUV(3, uvs[parseInt(face0[1])])
										])
									);
								}
							}
						}
						catch (e:Error)
						{
							trace("Error while parsing obj file: unvalid face f " + face0 + "," + face1 + "," + face2 + "," + face3);
						}

						break;

				}
			}

			vertices = null;
			uvs = null;
			
			buildFaces(material);
		}

		private function addFace(v0:Vector3D,v1:Vector3D,v2:Vector3D, uvs:Vector.<UV>):void
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
		
		private function checkUV(id:int, uv:UV = null):UV
		{
			if (uv == null)
			{
				switch (id)
				{
					case 1:
						return new UV(0, 1);
						break;
					case 2:
						return new UV(.5, 0);
						break;
					case 3:
						return new UV(1, 1);
						break;
				}

			}

			return uv;
		}

		private static function trysplit(source:String, by:String):Array
		{
			if (source == null)
				return null;
			if (source.indexOf(by) == -1)
				return [source];

			return source.split(by);
		}
		
		/*
		private function checkMtl(data:String):void
		{
			var index:int = data.indexOf("mtllib");
			if (index != -1)
			{
				aSources = [];
				loadMtl(parseUrl(index, data));
			}
		}
		*/
		
		private function errorMtl(event:Event):void
		{
			trace("Obj MTL LOAD ERROR: unable to load .mtl file at " + mtlPath);
		}

		private function mtlProgress(event:Event):void
		{
			//NOT BUILDED IN YET
			//trace( (event.target.bytesLoaded / event.target.bytesTotal) *100);
		}

		private function loadMtl(url:String):void
		{
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, parseMtl);
			loader.addEventListener(IOErrorEvent.IO_ERROR, errorMtl);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, errorMtl);
			loader.addEventListener(ProgressEvent.PROGRESS, mtlProgress);
			loader.load(new URLRequest(mtlPath + url));
		}

		private function parseUrl(index:Number, data:String):String
		{
			return data.substring(index + 7, data.indexOf(".mtl") + 4);
		}

		private function parseMtl(event:Event):void
		{
			var lines:Array = event.target["data"].split('\n');
			if (lines.length == 1)
				lines = event.target["data"].split(String.fromCharCode(13));
			var trunk:Array;
			var i:int;
			var j:int;
			var mat:BitmapFileMaterial;
			aMats = [];

			for each (var line:String in lines)
			{
				trunk = line.split(" ");
				switch (trunk[0])
				{
					case "newmtl":
						aSources.push({material: null, materialid: trunk[1]});
						break;
					case "map_Kd":
						mat = checkDoubleMaterials(mtlPath + trunk[1]);
						aSources[aSources.length - 1].material = mat;
						//aSources[aSources.length-1].material = new BitmapFileMaterial(baseUrl+trunk[1]);
						break;
				}
			}

			for (j = 0; j < aMeshes.length; ++j)
			{
				for (i = 0; i < aSources.length; ++i)
				{
					if (aMeshes[j].materialid == aSources[i].materialid)
					{
						mat = aSources[i].material;
						aMeshes[j].mesh.material = mat;
						/*for each(_face in aMeshes[j].mesh.faces)
						 _face.material = mat;*/
					}
				}
			}

			aSources = null;
			aMats = null;
		}

		private function checkDoubleMaterials(url:String):BitmapFileMaterial
		{
			var mat:BitmapFileMaterial;
			for (var i:int = 0; i < aMats.length; ++i)
			{
				if (aMats[i].url == url)
				{
					mat = aMats[i].material;
					aMats.push({url: url, material: mat});
					return mat;
				}
			}

			mat = new BitmapFileMaterial(url.replace(String.fromCharCode(13), ""));
			aMats.push({url: url, material: mat});
			return mat;
		}
		
		/*
		private function generateNewMesh():void
		{
			mesh = new Mesh(ini);
			mesh.name = "obj_" + aMeshes.length;
			mesh.type = "Obj";
			mesh.url = "External";

			if (aMeshes.length == 1 && container == null)
				container = new Object3D(aMeshes[0].mesh);

			aMeshes.push({materialid: "", mesh: mesh});

			if (aMeshes.length > 1 || container != null)
				(container as Object3D).addChild(mesh);
		}
		*/

		/**
		 * Creates a new <code>Obj</code> object. Not intended for direct use, use the static <code>parse</code> or <code>load</code> methods.
		 *
		 * @param	data				The binary data of a loaded file.
		 * @param	urlbase				The url of the .obj file, required to compose the url mtl adres and be able access the bitmap sources relative to mtl location.
		 * @param	init	[optional]	An initialisation object for specifying default instance properties.
		 *
		 * @see away3d.loaders.Obj#parse()
		 * @see away3d.loaders.Obj#load()
		 */

		public function OBJ(data:* = null, material:Material = null, scale:int=1)
		{
			super();
			
			this.material = material;
			
			if (data)
			{
				if (data is ByteArray)
				{
					parse(data);
				}
				else
				{
					load(data);
				}
			}
			
			scaling = scale;
			
			//parseObj(dataString);
			//checkMtl(dataString);
		}

		/**
		 * Loads and parses a obj file into a 3d mesh object.
		 *
		 * @param	url					The url location of the file to load.
		 * @param	init	[optional]	An initialisation object for specifying default instance properties.
		 * @return						A 3d loader object that can be used as a placeholder in a scene while the file is loading.
		 */
		public function load(uri:String, mtlPath:String = null):Object
		{
			/*
			TODO : mtl
			//mtlPath as model folder
			var _pathArray:Array = url.split("/");
			_pathArray.pop();
			this.mtlPath = (_pathArray.length > 0) ? _pathArray.join("/") + "/" : _pathArray.join("/");
			*/
			
			return LoaderUtil.load(uri, onLoad);
		}

		private function onLoad(event:Event):void
		{
			if(event.type == Event.COMPLETE)
				parse(String(event.target.data));
		}
	}
}