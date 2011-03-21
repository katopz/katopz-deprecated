package com.sleepydesign.display
{
	import com.sleepydesign.collection.iterators.DisplayObjectContainerIterator;
	import com.sleepydesign.core.ITransitionable;

	import flash.display.DisplayObject;

	import org.osflash.signals.Signal;

	public class SDLayer extends SDSprite
	{
		private var iterator:DisplayObjectContainerIterator;

		//TOUSE?//public static var focusSignal:Signal = new Signal(String /*canvas name*/, Object /*canvas data*/);

		//TODO : remove child for better speed?
		public function SDLayer()
		{
			iterator = new DisplayObjectContainerIterator(this);
		}

		public function showChild(child:DisplayObject):void
		{
			if (child is ITransitionable)
			{
				// TODO : task -> dispatch complete when hide all
				ITransitionable(child).show();
			}
			else
			{
				child.visible = true;
				child.alpha = 1;
			}

			iterator.currentIndex = getChildIndex(child);
		}

		public function hideChild(child:DisplayObject):void
		{
			if (child is ITransitionable)
			{
				// TODO : task -> dispatch complete when hide all
				ITransitionable(child).hide();
			}
			else
			{
				child.visible = false;
				child.alpha = 0;
			}
		}

		public function setFocus(child:DisplayObject):void
		{
			setFocusByName(child.name);
		}

		public function setFocusByName(name:String):void
		{
			iterator.currentIndex = 0;
			var child:DisplayObject = iterator.current as DisplayObject;
			while (child)
			{
				if (child.name == name)
					showChild(child);
				else
					hideChild(child);

				child = iterator.next() as DisplayObject;
			}
		}

		public function setFocusByIndex(index:int):void
		{
			iterator.currentIndex = 0;
			var child:DisplayObject = iterator.current as DisplayObject;
			while (child)
			{
				if (iterator.currentIndex == index)
					showChild(child);
				else
					hideChild(child);

				child = iterator.next() as DisplayObject;
			}

			iterator.currentIndex = index;
		}

		/*
		public function swapTo(index:int):void
		{
			var child:DisplayObject = iterator.current as DisplayObject;
			hide(child);
			iterator.currentIndex = index;
			showLayerByIndex(index);
		}
		*/

		public function hideAll():void
		{
			while (iterator.hasNext())
				hideChild(iterator.next() as DisplayObject);
		}

		public function showLayerByIndex(index:int):void
		{
			iterator.currentIndex = index;
			var child:DisplayObject = iterator.current as DisplayObject;
			showChild(child);
		}
	}
}