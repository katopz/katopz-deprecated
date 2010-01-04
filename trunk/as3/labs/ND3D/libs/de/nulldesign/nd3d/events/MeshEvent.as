package de.nulldesign.nd3d.events 
{
	import de.nulldesign.nd3d.objects.Mesh;

	import flash.events.Event;

	/**
	 * MeshEvent dispatched by the MeshLoader
	 * @author philippe.elsass*gmail.com
	 */
	public class MeshEvent extends Event 
	{
		static public const MESH_LOADED:String = "meshLoaded";
		static public const MESH_PARSED:String = "meshParsed";

		public var mesh:Mesh;

		public function MeshEvent(type:String, mesh:Mesh = null) 
		{ 
			super(type, bubbles, cancelable);
			this.mesh = mesh;
		} 

		public override function clone():Event 
		{ 
			return new MeshEvent(type, mesh);
		} 

		public override function toString():String 
		{ 
			return formatToString("MeshEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
	}
}