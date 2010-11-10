package com.sleepydesign.text
{
	import com.sleepydesign.core.IDestroyable;
	import com.sleepydesign.events.IRemovableEventDispatcher;
	import com.sleepydesign.events.ListenerManager;

	import flash.events.Event;
	import flash.filters.GlowFilter;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.text.TextFormat;

	/**
	   A base TextField that implements {@link IRemovableEventDispatcher} and {@link IDestroyable}.

	   @author Aaron Clinger
	   @version 06/10/09
	 */
	public class SDTextField extends TextField implements IRemovableEventDispatcher, IDestroyable
	{
		protected var _listenerManager:ListenerManager;
		protected var _isDestroyed:Boolean;


		/**
		   Creates a new SDTextField.
		 *
		   public function SDTextField() {
		   super();

		   this._listenerManager = ListenerManager.getManager(this);
		   }

		   /**
		   @exclude
		 */
		override public function dispatchEvent(event:Event):Boolean
		{
			if (this.willTrigger(event.type))
				return super.dispatchEvent(event);

			return true;
		}

		/**
		   @exclude
		 */
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{
			super.addEventListener(type, listener, useCapture, priority, useWeakReference);
			this._listenerManager.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}

		/**
		   @exclude
		 */
		override public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
		{
			super.removeEventListener(type, listener, useCapture);
			this._listenerManager.removeEventListener(type, listener, useCapture);
		}

		public function removeEventsForType(type:String):void
		{
			this._listenerManager.removeEventsForType(type);
		}

		public function removeEventsForListener(listener:Function):void
		{
			this._listenerManager.removeEventsForListener(listener);
		}

		public function removeEventListeners():void
		{
			this._listenerManager.removeEventListeners();
		}

		public function get destroyed():Boolean
		{
			return this._isDestroyed;
		}

		/**
		   {@inheritDoc}

		   Calling <code>destroy()</code> on a SD display object also removes it from its current parent.
		 */
		public function destroy():void
		{
			this.removeEventListeners();
			this._listenerManager.destroy();

			this._isDestroyed = true;

			if (this.parent != null)
				this.parent.removeChild(this);
		}

		// -----------------------------------------------------------------------------------

		public var defaultText:String = "";

		public function SDTextField(text:String = null, textFormat:TextFormat = null, css:String = null)
		{
			this._listenerManager = ListenerManager.getManager(this);

			super();

			// Flash CS4 assets
			if (name.indexOf("instance") != 0)
				return;

			selectable = false;
			mouseEnabled = false;
			mouseWheelEnabled = false;
			defaultTextFormat = textFormat ? textFormat : new TextFormat("Tahoma", 12, 0x000000);
			autoSize = "left";
			cacheAsBitmap = true;
			filters = [new GlowFilter(0x000000, 0, 0, 0, 0, 0)];

			parseCSS(css);

			if (text)
				this.htmlText = "<p>" + text + "</p>";
		}

		public function parseCSS(css:String = null):void
		{
			var style:StyleSheet = new StyleSheet();
			var p:String;
			var aLink:String;
			var aHover:String;

			if (!css)
			{
				p = "p {font-family: Tahoma;font-size: 12px;color:#000000;}";
				aLink = "a:link {color:#009900;}";
				aHover = "a:hover {color:#00CC00;text-decoration:underline}";
				css = p + aLink + aHover;
			}
			style.parseCSS(css);
			//styleSheet = style;
		}
	}
}