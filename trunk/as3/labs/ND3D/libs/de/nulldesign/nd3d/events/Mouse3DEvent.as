package de.nulldesign.nd3d.events 
{
	import de.nulldesign.nd3d.geom.Face;
	import de.nulldesign.nd3d.geom.UV;
	import de.nulldesign.nd3d.objects.Mesh;
	import de.nulldesign.nd3d.objects.Object3D;
	import flash.events.MouseEvent;

	import flash.events.Event;

	/**
	 * Mouse3DEvent, dispatched by the Renderer on mesh rollover/rollout/click
	 * @author Lars Gerckens (lars@nulldesign.de)
	 */
	public class Mouse3DEvent extends Event
	{
		static public const MOUSE_OVER:String = "onMouse3DOver";
		static public const MOUSE_OUT:String = "onMouse3DOut";
		static public const MOUSE_CLICK:String = "onMouse3DClick";
		static public const MOUSE_MOVE:String = "onMouse3DMove";
		static public const MOUSE_DOWN:String = "onMouse3DDown";
		static public const MOUSE_UP:String = "onMouse3DUp";

		/**
		 * Holds the current clicked mesh
         */
		public var mesh:Object3D;
		
		/**
		 * Holds the current clicked face
         */
		public var face:Face;
		
		/**
		 * Holds the UV coordinates of the clickposition on the texture. Use these coordinates to find the exact click location on your texture.
         */
		public var uv:UV;

		public function Mouse3DEvent(type:String, mesh:Object3D, face:Face, uv:UV) 
		{
			super(type);
			this.mesh = mesh;
			this.face = face;
			this.uv = uv;
		}
	}
}