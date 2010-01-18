package open3d.animation
{
	import flash.geom.Vector3D;

	/**
	 * Used in combination with KeyframeMesh DisplayObject3D and all sub-classes
	 * to provided keyframe-based animation to objects.
	 * <p>
	 * A Frame object has a list of vertices and a name which define the animation.
	 *
	 * @author Philippe Ajoux (philippe.ajoux@gmail.com)
	 *
	 * Modify/Optimize
	 * @author katopz
	 */
	public class Frame
	{
		public var name:String;
		public var vertices:Vector.<Vector3D>;

		/**
		 * Create a new Frame with a name and a set of vertices
		 *
		 * @param name	The name of the frame
		 * @param vertices	An array of Vertex objects
		 */
		public function Frame(name:String, vertices:Vector.<Vector3D>)
		{
			this.name = name;
			this.vertices = vertices;
		}

		public function toString():String
		{
			return "[Frame][name:" + name + "][vertices:" + vertices.length + "]";
		}
	}
}