package org.papervision3d.objects.parsers {
	
	import org.papervision3d.Papervision3D;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.events.FileLoadEvent;
	
	import flash.events.*;
	import flash.net.*;
	
	import mx.controls.*;
	import org.papervision3d.core.geom.renderables.Vertex3D;
	import org.papervision3d.core.geom.renderables.Triangle3D;
	import org.papervision3d.core.proto.MaterialObject3D;
	import org.papervision3d.core.proto.GeometryObject3D;
	import org.papervision3d.core.math.NumberUV;
	import org.papervision3d.materials.ColorMaterial;
	import org.papervision3d.core.geom.TriangleMesh3D;
	import org.papervision3d.core.math.Number3D;
	import org.papervision3d.materials.utils.MaterialsList;
	import org.papervision3d.materials.BitmapFileMaterial;
	
	/**
	 * The OBJ class let you parse and load object files (.obj).
	 * 
	 * The parser supports:
	 * <ul>
	 * <li>Geometric vertices, Texture vertices and vertex normals</li>
	 * <li>Seperate objects for each group</li>
	 * <li>Parsing materials from Material Library File (.mtl)</li>
	 * </ul>
	 * 
	 * Basic example (loading both the object file and materials):
	 * <code>
	 * scene.addChild(new OBJ("fish.obj", "fish.mtl"), "Fish");
	 * </code>
	 * 
	 * Always remember to triangulate the geometry in the exported OBJ-file.
	 * 
	 * @author Knut Urdalen <knut.urdalen@gmail.com>
	 * @see http://people.scs.fsu.edu/~burkardt/txt/obj_format.txt
	 */
	public class OBJ extends TriangleMesh3D {
		
		private var _loaderObj:URLLoader;
		private var _loaderMtl:URLLoader;
		private var _obj:String;
		private var _mtl:String;
		private var _filename:String;
		private var _loader:URLLoader;
		private var _childrenCount:int = 0;
		private var _materials:MaterialsList;
		
		/**
		 *
		 * @param obj
		 * @param mtl
		 */
		
		public function OBJ(obj:String, mtl:* = null, scale:Number = 1, initObject:Object = null) {		
			super(material, new Array(), new Array(), null, initObject);
		
			this._obj = obj;
			
			if(mtl is String) {
				this._mtl = mtl;
				loadMtl();
			} else if(mtl is MaterialsList) {
				this._materials = mtl;
				loadObj();
			}
			
			//this._materials = materials || new MaterialsList();
		};
		
		private function loadMtl() : void {
			this._filename = this._mtl;
			this._loaderMtl = new URLLoader();
			this._loaderMtl.addEventListener(Event.COMPLETE, parseMtl);
			this._loaderMtl.addEventListener(IOErrorEvent.IO_ERROR, handleIOError);
			this._loaderMtl.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handleSecurityLoadError);
			this._loaderMtl.addEventListener(ProgressEvent.PROGRESS, handleLoadProgress);
			this._loaderMtl.load(new URLRequest(this._mtl));
		}
		
		private function loadObj() : void {
			this._filename = this._obj;
			this._loaderObj = new URLLoader();
			this._loaderObj.addEventListener(Event.COMPLETE, parseObj);
			this._loaderObj.addEventListener(IOErrorEvent.IO_ERROR, handleIOError);
			this._loaderObj.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handleSecurityLoadError);
			this._loaderObj.addEventListener(ProgressEvent.PROGRESS, handleLoadProgress);
			this._loaderObj.load(new URLRequest(this._obj));
		}
		
		private function handleLoadProgress( e:ProgressEvent ) : void {
			var progressEvent:FileLoadEvent = new FileLoadEvent( FileLoadEvent.LOAD_PROGRESS, this._filename, e.bytesLoaded, e.bytesTotal);
			dispatchEvent( progressEvent );
		}
		
		private function handleIOError(e:IOErrorEvent) : void {
			trace("OBJ file load error", e.text);
			dispatchEvent(new FileLoadEvent(FileLoadEvent.LOAD_ERROR, this._filename,0,0,e.text));
		}
		
		private function handleSecurityLoadError(e:SecurityErrorEvent) : void {
			trace("OBJ file security load error", e.text);
			dispatchEvent(new FileLoadEvent(FileLoadEvent.SECURITY_LOAD_ERROR, this._filename, 0, 0, e.text));
		}
		
		/**
		 * Material Library File (.mtl)
		 * 
		 * Material library files contain one or more material definitions, each 
		 * of which includes the color, texture, and reflection map of individual 
		 * materials. These are applied to the surfaces and vertices of objects.  
		 * Material files are stored in ASCII format and have the .mtl extension.
		 */
		private function parseMtl(event:Event) : void {
			var mtl:String = this._loaderMtl.data;
			this._loaderMtl.close();
			
			trace(mtl);
			
			var lines:Array = mtl.split("\n");
			var parts:Array;
			var keyword:String;
			var currentMaterial:MaterialObject3D;
			var currentName:String;
			var mtls:Object = {};
			
			for(var i:int = 0; i<lines.length; ++i) {
				
				if(lines[i].substring(0, 1) == "#" || lines[i].length == 0) { // Comment or blank
					continue; // skip
				}		
				
				parts = lines[i].split(" ");
				if(parts.length > 0) {
					keyword = parts[0];
				}
				
				switch(keyword) {
					
					case "newmtl": { // assigns a name to the material and designates the start of a material description
						
						currentName = parts[1];
						//currentMaterial = this.materials.addMaterial(new MaterialObject3D(), parts[1]);
						
						break;
					}
					// Ka r g b
					case "Ka": { // defines the ambient color of the material to be (r,g,b). The default is (0.2,0.2,0.2); 
						break;
					}
					// Kd r g b
					case "Kd": { // defines the diffuse color of the material to be (r,g,b). The default is (0.8,0.8,0.8);
						break;
					}
					// Ks r g b
					case "Ks": { // defines the specular color of the material to be (r,g,b). This color shows up in highlights. The default is (1.0,1.0,1.0);
						break;
					}
					// Ke r g b
					case "Ke": {
						break;
					}
					// d alpha
					case "d": { // defines the transparency of the material to be alpha. The default is 1.0 (not transparent at all) Some formats use Tr instead of d; 
						break;
					}
					// Tr alpha
					case "Tr": { // defines the transparency of the material to be alpha. The default is 1.0 (not transparent at all). Some formats use d instead of Tr; 
						break;
					}
					// Ns s
					case "Ns": { // defines the shininess of the material to be s. The default is 0.0;
						break;
					}
					// illum n
					case "illum": { // denotes the illumination model used by the material. illum = 1 indicates a flat material with no specular highlights, so the value of Ks is not used. illum = 2 denotes the presence of specular highlights, and so a specification for Ks is required.
						break;
					}
					// map_Ka filename
					case "map_Ka": { // names a file containing a texture map, which should just be an ASCII dump of RGB values; 
						break;
					}
					// map_Kd filename
					case "map_Kd": {
						
						//var material:MaterialObject3D = this.materials.getMaterialByName(currentName);
						//this.materials.removeMaterial(currentMaterial);
						
						mtls[currentName] = new BitmapFileMaterial("image/" + parts[1]);
						
						//mtls.push({currentName:new BitmapFileMaterial(parts[1])});
						
						// new MaterialsList({currentName:new BitmapFileMaterial(parts[1])});						
						
						//currentMaterial.url = parts[1];
						
						break;
					}
					// map_Bump filename
					case "map_Bump": { 
						break;
					}
					
				}
			}
			
			//this.materials = new MaterialsList(mtls);
			
			_materials = new MaterialsList(mtls);
			
			loadObj();
		}
		
		private function parseObj(event:Event) : void {
		
			var obj:String = this._loaderObj.data;		
			this._loaderObj.close();
			var lines:Array = obj.split("\n");
			var parts:Array;
			var keyword:String;
			var verticesList:Array = [];
			var uvList:Array = [];
			var normalList:Array = [];
			var currentObject:DisplayObject3D = this;
			var _currentMaterial:String;

			for(var i:int = 0; i<lines.length; ++i) {
				
				if(lines[i].substring(0, 1) == "#" || lines[i].length == 0) { // Comment or blank
					continue; // skip
				}		
				
				parts = lines[i].split(" ");
				if(parts.length > 0) {
					keyword = parts[0];
				}
				
				switch(keyword) {
					
					// Vertex data
					case "v": { // Geometric vertices
						verticesList.push(new Vertex3D(parts[1], parts[2], parts[3]));
						currentObject.geometry.vertices.push(verticesList[verticesList.length-1]);
						break;
					}
					case "vt": { // Texture vertices
						uvList.push(new NumberUV(parts[1], parts[2]));
						break;
					}
					case "vn": { // Vertex normal
						normalList.push(new Number3D(parts[1], parts[2], parts[3]));
						break;
					}
					case "vp": { // Parameter space vertices
						break;
					}

					// Elements
					case "p": { // Point
						break;
					}
					case "l": { // Line
						break;
					}
					case "f": { // Face
					
						if(parts.length != 4) { // not a triangle
							continue; // skip
						}
					
						var v0:Vertex3D, v1:Vertex3D, v2:Vertex3D;
						var i0:Array, i1:Array, i2:Array;
						var uv0:NumberUV, uv1:NumberUV, uv2:NumberUV;
						
						// split info in each parameter
						i0 = parts[1].split("/");
						i1 = parts[2].split("/");
						i2 = parts[3].split("/");
		
						v0 = verticesList[i0[0]-1];
						v1 = verticesList[i1[0]-1];
						v2 = verticesList[i2[0]-1];
						
						//trace("v0: " + v0 + ", v1: " + v1 + ", v2: " + v2);
						
						if(i0[1] != "") { // texture data may not be present (this happens if normals are exported, but not texture coordinates)
							uv0 = uvList[i0[1]-1];
							uv1 = uvList[i1[1]-1];
							uv2 = uvList[i2[1]-1];
						} else {
							uv0 = new NumberUV(0, 0);
							uv1 = new NumberUV(0, 1);
							uv2 = new NumberUV(1, 0);
						}
						
						if(i0[2] != "") { // add normals
							v0.normal = normalList[i0[2]-1];
							v1.normal = normalList[i1[2]-1];
							v2.normal = normalList[i2[2]-1];
						}
						
						currentObject.geometry.faces.push(new Triangle3D(this, [v0, v1, v2], _materials.getMaterialByName(_currentMaterial), [uv0, uv1, uv2]));
						
						break;
					}
					case "curv": { // Curve
						break;
					}
					case "curv2": { // 2D curve
						break;
					}
					case "surf": { // Surface
						break;
					}
					
					// Free-form curve/surface attributes
					case "deg": { // Degree
						break;
					}
					case "bmat": { // Basis matrix
						break;
					}
					case "step": { // Step size
						break;
					}
					case "cstype": { // Curve or surface type
						break;
					}
					
					
					// Free-form curve/surface body statements
					case "parm": { // Parameter values
						break;
					}
					case "trim": { // Outer trimming loop
						break;
					}
					case "hole": { // Inner trimming loop
						break;
					}
					case "scrv": { // Special curve
						break;
					}
					case "sp": { // Special point
						break;
					}
					case "end": { // End statement
						break;
					}
					
					// Connectivity between free-form surfaces
					case "con": { // Connect
						break;
					}
					
					// Grouping
					case "g": { // Group name
	
						currentObject = this.addChild(new TriangleMesh3D(null, null, null, parts[1]), parts[1]);

						break;
					}
					case "s": { // Smoothing group
						break;
					}
					case "mg": { // Merging group
						break;
					}
					case "o": { // Object name
						//currentObject = this.addChild(new TriangleMesh3D(null, null, null, parts[1]), parts[1]);				
						break;
					}
					
					// Display/render attributes
					case "bevel": { // Bevel interpolation
						break;
					}
					case "c_interp": { // Color interpolation
						break;
					}
					case "d_interp": { // Dissolve interpolation
						break;
					}
					case "lod": { // Level of detail
						break;
					}
					case "usemtl": { // Material name

						currentObject.material = this._materials.getMaterialByName(parts[1]);
						
						//var material:MaterialObject3D = MaterialObject3D.DEFAULT;
						//material.name = parts[1];
						//this._materials.addMaterial(material, parts[1]);				
						
						break;
					}
					case "mtllib": { // Material library
					
						var filename:String = parts[1];
					
						break;
					}
					case "shadow_obj": { // Shadow casting
						break;
					}
					case "trace_obj": { // Ray tracing
						break;
					}
					case "ctech": { // Curve approximation technique
						break;
					}
					case "stech": { // Surface approximation technique
						break;
					}
					default: { // unknown keyword
						break;
					}	
				}			
			}
	
			this.geometry.ready = true; // Activate object

		}
		
	}

}


