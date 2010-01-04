package de.nulldesign.nd3d.utils 
{
	import de.nulldesign.nd3d.objects.Mesh;

	import flash.events.IEventDispatcher;
	import flash.utils.ByteArray;

	/**
	 * ...
	 * @author philippe.elsass*gmail.com
	 */
	public interface IMeshParser extends IEventDispatcher
	{
		/**
		 * Parse mesh data and dispatch Event.COMPLETE when done
		 */
		function parseFile(meshData:ByteArray, matList:Array, defaultMaterial:MaterialDefaults = null):void;
	}
}