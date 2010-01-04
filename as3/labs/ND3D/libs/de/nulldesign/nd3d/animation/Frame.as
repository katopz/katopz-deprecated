package de.nulldesign.nd3d.animation
{

	/**
	 * Used in combination with KeyframeMesh DisplayObject3D and all sub-classes
	 * to provided keyframe-based animation to objects.
	 * <p>
	 * A Frame object has a list of vertices and a name which define the animation.
	 * 
	 * @author Philippe Ajoux (philippe.ajoux@gmail.com)
	 * @modifier katopz@sleepydesign.com
	 * 
	 */
	public class Frame
	{
		public var name:String;
		public var vertices:Array;

		/**
		 * Create a new Frame with a name and a set of vertices
		 * 
		 * @param name	The name of the frame
		 * @param vertices	An array of Vertex objects
		 */
		public function Frame(name:String, vertices:Array)
		{
			this.name = name;
			this.vertices = vertices;
		}

		public function toString():String
		{
			return "[Frame] [name:" + name + "] [vertices:" + vertices.length + "]";
		}	
	}
}