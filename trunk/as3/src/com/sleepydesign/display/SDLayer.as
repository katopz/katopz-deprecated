package com.sleepydesign.display
{
	import com.sleepydesign.collection.iterators.DisplayObjectContainerIterator;
	import com.sleepydesign.core.ITransitionable;

	import flash.display.DisplayObject;

	public class SDLayer extends SDSprite
	{
		private var iterator:DisplayObjectContainerIterator;

		//TODO : remove child for better speed?
		public function SDLayer()
		{
			iterator = new DisplayObjectContainerIterator(this);
		}

		public function swapTo(index:int):void
		{
			var child:DisplayObject = iterator.current as DisplayObject;

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

			iterator.currentIndex = index;

			showLayerByIndex(index);
		}

		public function hideAll():void
		{
			while (iterator.hasNext())
			{
				var child:DisplayObject = iterator.next() as DisplayObject;

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
		}

		public function showLayerByIndex(index:int):void
		{
			iterator.currentIndex = index;
			var child:DisplayObject = iterator.current as DisplayObject;

			if (child is ITransitionable)
			{
				// TODO : task -> dispatch complete when shown
				ITransitionable(child).show();
			}
			else
			{
				child.visible = true;
				child.alpha = 1;
			}
		}
	}
}