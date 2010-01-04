package de.nulldesign.nd3d.utils
{
	import de.nulldesign.nd3d.events.MeshEvent;
	import de.nulldesign.nd3d.material.Material;
	import de.nulldesign.nd3d.objects.MD2;
	import de.nulldesign.nd3d.objects.Mesh;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.ByteArray;

	/**
	 * [broadcast event] Dispatched when the mesh and textures are fully loaded.
	 * @eventType de.nulldesign.nd3d.events.MeshEvent
	 */
	[Event(name="meshLoaded", type="de.nulldesign.nd3d.events.MeshEvent")] 

	/**
	 * @author katopz@sleepydesign.com
	 */	
	public class MD2Parser extends EventDispatcher implements IMeshParser
	{
		public var mesh:Mesh;
		private var fps:int;
		private var scale:Number;

		public function MD2Parser(fps:int = 24, scale:Number = 1)
		{
			this.fps = fps;
			this.scale = scale;
		}

		public function parseFile(meshData:ByteArray, matList:Array, defaultMaterial:MaterialDefaults = null):void
		{
			var mat:Material = matList ? matList[0] : defaultMaterial.getMaterial();
			mesh = new MD2(mat, meshData, fps, scale);
			
			dispatchEvent(new MeshEvent(MeshEvent.MESH_PARSED, mesh));
		}
	}
}