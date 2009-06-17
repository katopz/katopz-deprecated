/*
 * - - - - - - - - - -
 * Paul Spitzer (c)
 * - - - - - - - - - -
 * mod by katopz@sleepydesign.com
 *
 */
package com.sleepydesign.playground.pathfinder
{
	import com.sleepydesign.game.core.Position;
	
	/**
	 * Represents a graph node in 3D.
	 */
	public class AStarNode extends Position
	{
		// The 3D positions in the graph
		public var xPoint			: uint = 0;
		public var yPoint		: uint = 0;
		public var zPoint		: uint = 0;
		
		// Score
		public var f			: Number = 0;
		public var g			: Number = 0;
		public var h			: Number = 0;
		public var parentNode	: AStarNode;
		
		// State
		public var walkable		: Boolean = true;
		public var isPath		: Boolean = false;
		public var color		: Number = 0;
		
		/**
		 * Constructs a new AStarNode object.
		 */
		public function AStarNode(x:Number = 0, y:Number = 0, z:Number = 0)
		{
			super(x, y, z);
		}
		
		override public function toObject(fix:uint = 2):Object 
		{
			return { x:Number(x.toFixed(fix)), y:Number(y.toFixed(fix)), z:Number(z.toFixed(fix)), xPoint:xPoint, y:yPoint, zPoint:zPoint};
        }
        
		/**
		 * @return String - String representation of the object
		 */
		override public function toString(): String
		{
			return "[AStarNode : " + xPoint + "," + yPoint + "," + zPoint  + " : " + x.toFixed(2) + "," + y.toFixed(2)  + "," + z.toFixed(2)  + "]";
		}
		
	}
	
}