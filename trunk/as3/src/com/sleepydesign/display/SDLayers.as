package com.sleepydesign.display
{
	import com.sleepydesign.collection.iterators.DisplayObjectContainerIterator;
	import com.sleepydesign.core.ITransitionable;
	
	import flash.display.DisplayObject;
	
	import org.osflash.signals.Signal;

	public class SDLayers extends SDSprite
	{
		private var iterator:DisplayObjectContainerIterator;
		
		public function SDLayers()
		{
			iterator = new DisplayObjectContainerIterator(this);
		}
		
		public function swapTo(index:int):void
		{
			var child:DisplayObject = iterator.current as DisplayObject;
			if(child is ITransitionable)
			{
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
		
		public function showLayerByIndex(index:int):void
		{
			iterator.currentIndex = index;
			
			var child:DisplayObject = iterator.current as DisplayObject;
			
			if(child is ITransitionable)
			{
				ITransitionable(child).show();
			}
			else
			{
				child.visible = false;
				child.alpha = 0;
			}
		}
		
		/*
		override public function addChild(child:DisplayObject):DisplayObject
		{
			return super.addChild(child);
		}
		*/
	}
}