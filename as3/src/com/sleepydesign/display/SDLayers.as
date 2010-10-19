package com.sleepydesign.display
{
	import com.sleepydesign.collection.iterators.DisplayObjectContainerIterator;
	import com.sleepydesign.core.ITransitionable;
	import com.sleepydesign.system.DebugUtil;
	
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
				/* TODO : remove child for better speed
				ITransitionable(child).statusSignal.addOnce(function(clip:SDClip, status:String):void{
					if(status == SDClip.STATUS_DEACTIVATE && clip.parent && clip.parent.contains(clip))
						clip.parent.removeChild(clip);
				})
				*/
			}
			else
			{
				child.visible = false;
				child.alpha = 0;
				
				/*
				if(contains(child))
					removeChild(child);
				*/
			}
			
			iterator.currentIndex = index;
			
			showLayerByIndex(index);
		}
		
		public function showLayerByIndex(index:int):void
		{
			iterator.currentIndex = index;
			
			var child:DisplayObject = iterator.current as DisplayObject;
			
			/*
			if(!contains(child))
				addChild(child);
			*/
			
			if(child is ITransitionable)
			{
				ITransitionable(child).show();
			}
			else
			{
				child.visible = true;
				child.alpha = 1;
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