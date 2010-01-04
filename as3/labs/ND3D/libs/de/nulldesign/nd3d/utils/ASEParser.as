package de.nulldesign.nd3d.utils 
{
	import de.nulldesign.nd3d.events.MeshEvent;
	import de.nulldesign.nd3d.geom.Face;
	import de.nulldesign.nd3d.geom.UV;
	import de.nulldesign.nd3d.geom.Vertex;
	import de.nulldesign.nd3d.material.Material;
	import de.nulldesign.nd3d.objects.Mesh;	

	import flash.events.EventDispatcher;
	import flash.utils.ByteArray;

	/**
	 * [broadcast event] Dispatched when the mesh and textures are fully loaded.
	 * @eventType de.nulldesign.nd3d.events.MeshEvent
	 */
	[Event(name="meshLoaded", type="de.nulldesign.nd3d.events.MeshEvent")] 

	public class ASEParser extends EventDispatcher implements IMeshParser
	{

		public function ASEParser()	
		{
		}

		/*
		 * Original Code by Andre Michelle (www.andre-michelle.com)
		 */
		public function parseFile(meshData:ByteArray, matList:Array, defaultMaterial:MaterialDefaults = null):void 
		{
			var fileData:String = meshData.readUTFBytes(meshData.length);
			var defMat:Material = (defaultMaterial) ? defaultMaterial.getMaterial() : new Material(0xffffff);

			var m:Mesh = new Mesh();
			
			var lines:Array = unescape(fileData).split('\r\n');
			var line:String;
			var chunk:String;
			var content:String;
			
			var vertexList:Array = [];
			var uvList:Array = [];
			
			while(lines.length)	
			{
				
				line = String(lines.shift());
				
				//-- clear white space from beginn
				line = line.substr(line.indexOf('*') + 1);
				//-- clear closing brackets
				if(line.indexOf('}') >= 0) line = '';
				//-- get chunk description
				chunk = line.substr(0, line.indexOf(' '));
				
				switch(chunk) 
				{
					case 'MESH_VERTEX_LIST':
						while((content = String(lines.shift())).indexOf('}') < 0) 
						{
							content = content.substr(content.indexOf('*') + 1);
							var mvl:Array = content.split('\t'); 
							// separate here
							//-- switch coordinates to fit my coordinate system
							vertexList.push(new Vertex(parseFloat(mvl[1]), parseFloat(mvl[3]), -parseFloat(mvl[2])));
						}
						break;
					
					case 'MESH_FACE_LIST':
						while((content = String(lines.shift())).indexOf('}') < 0) 
						{
							content = content.substr(content.indexOf('*') + 1);
							var mfl:String = content.split('\t')[0]; 
							// ignore: [MESH_SMOOTHING,MESH_MTLID]
							var matID:Number = content.split('\t')[2].split(" ")[1]; 
							// MATERIAL ID

							var drc:Array = mfl.split(':'); 
							// separate here
							var con:String;
							
							con = drc[2];
							var vIndex1:Number = parseInt(con.substr(0, con.lastIndexOf(' ')));
							con = drc[3];
							var vIndex2:Number = parseInt(con.substr(0, con.lastIndexOf(' ')));
							con = drc[4];
							var vIndex3:Number = parseInt(con.substr(0, con.lastIndexOf(' ')));
							m.addFace(vertexList[vIndex1], vertexList[vIndex2], vertexList[vIndex3], matList[matID] == null ? defMat : matList[matID]);
						}
						break;
					
					case 'MESH_TVERTLIST':
						while((content = String(lines.shift())).indexOf('}') < 0) 
						{
							content = content.substr(content.indexOf('*') + 1);
							var mtvl:Array = content.split('\t'); 
							// separate here
							uvList.push(new UV(parseFloat(mtvl[1]), parseFloat(mtvl[2])));
						}
						break;
					
					case 'MESH_TFACELIST':
						var num:Number = 0;
						while((content = String(lines.shift())).indexOf('}') < 0) 
						{
							content = content.substr(content.indexOf('*') + 1);
							var mtfl:Array = content.split('\t'); 
							// separate here
							var f:Face = m.faceList[num];
							f.uvMap = [uvList[parseInt(mtfl[1])], uvList[parseInt(mtfl[2])], uvList[parseInt(mtfl[3])]];
							num++;
						}
						break;
				}
			}
			
			dispatchEvent(new MeshEvent(MeshEvent.MESH_PARSED, m));
		}
	}
}
