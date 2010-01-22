package com.sleepydesign.events
{
	import com.sleepydesign.components.TreeNode;

	import flash.events.Event;

	public class TreeEvent extends Event
	{
		public static const CHANGE_NODE_FOCUS:String = "change-node-focus";

		public var node:TreeNode;

		public function TreeEvent(type:String, node:* = null, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
			this.node = node;
		}

		override public function clone():Event
		{
			return new TreeEvent(type, node, bubbles, cancelable);
		}

		public override function toString():String
		{
			return formatToString("TreeEvent", "type", "bubbles", "cancelable", "eventPhase", "node");
		}
	}
}