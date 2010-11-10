package com.sleepydesign.components
{
	import com.sleepydesign.core.ITransformable;
	import com.sleepydesign.display.SDSprite;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Transform;
	
	import org.osflash.signals.Signal;

	public class SDComponent extends SDSprite implements ITransformable
	{
		public static const ALIGN_TOP_LEFT:String = "ALIGN_TOP_LEFT";
		public static const ALIGN_TOP_RIGHT:String = "ALIGN_TOP_RIGHT";
		public static const ALIGN_CENTER:String = "ALIGN_CENTER";
		public static const ALIGN_CENTER_STAGE:String = "ALIGN_CENTER_STAGE";
		public static const ALIGN_BOTTOM_LEFT:String = "ALIGN_BOTTOM_LEFT";
		public static const ALIGN_BOTTOM_RIGHT:String = "ALIGN_BOTTOM_RIGHT";

		protected var _width:Number;
		protected var _height:Number;

		protected var _style:ISDStyle = new SDStyle;

		private var _transformSignal:Signal = new Signal(Transform);

		public function get transformSignal():Signal
		{
			return _transformSignal;
		}

		public function SDComponent(style:ISDStyle = null)
		{
			_style = style ? style : _style;

			_width = _style.SIZE;
			_height = _style.SIZE;
		}

		public function draw():void
		{
			// align
			if (stage)
			{
				var _parent:DisplayObjectContainer = parent;
				var _stage:Stage = stage;
				switch (_align)
				{
					case ALIGN_TOP_LEFT:
						setPosition(0, 0);
						break;
					case ALIGN_TOP_RIGHT:
						setPosition(_stage.stageWidth - width, 0);
						break;
					case ALIGN_CENTER:
						_parent.removeChild(this);
						setPosition((width == 0 ? _stage.stageWidth : width) / 2 - width / 2, (height == 0 ? _stage.stageHeight : height) / 2 - height / 2);
						_parent.addChild(this);
						break;
					case ALIGN_BOTTOM_LEFT:
						_parent.removeChild(this);
						setPosition(0, _stage.stageHeight - height);
						_parent.addChild(this);
						break;
					case ALIGN_CENTER_STAGE:
						setPosition(_stage.stageWidth / 2 - width / 2, _stage.stageHeight / 2 - height / 2);
						break;
				}
			}
		}

		protected var _align:String = ALIGN_TOP_LEFT;

		public function get align():String
		{
			return _align;
		}

		public function set align(value:String):void
		{
			_align = value;

			if (!stage)
			{
				if (hasEventListener(Event.ADDED_TO_STAGE))
					removeEventListener(Event.ADDED_TO_STAGE, onStage);
				addEventListener(Event.ADDED_TO_STAGE, onStage, false, 0, true);
				return;
			}
			else
			{
				draw();
			}
		}

		private function onStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onStage);
			draw();
		}

		// Transform ------------------------------------------------------------------------

		public function setPosition(x:int, y:int):void
		{
			this.x = x;
			this.y = y;
		}

		public function setSize(w:Number, h:Number):void
		{
			var isDirty:Boolean = false;
			if (_width != w)
			{
				_width = w;
				isDirty = true;
			}

			if (_height != h)
			{
				_height = h;
				isDirty = true;
			}

			if (!isDirty)
				return;

			draw();
			//dispatchEvent(new TransformEvent(TransformEvent.RESIZE));
			transformSignal.dispatch(transform);
		}

		override public function set width(w:Number):void
		{
			if (_width == w)
				return;

			_width = w;
			draw();
			//dispatchEvent(new TransformEvent(TransformEvent.RESIZE));
			transformSignal.dispatch(transform);
		}

		override public function get width():Number
		{
			return _width;
		}

		override public function set height(h:Number):void
		{
			if (_height == h)
				return;

			_height = h;
			draw();
			//dispatchEvent(new TransformEvent(TransformEvent.RESIZE));
			transformSignal.dispatch(transform);
		}

		override public function get height():Number
		{
			return _height;
		}

		override public function set x(value:Number):void
		{
			if (x == int(value))
				return;

			super.x = int(value);
		}

		override public function set y(value:Number):void
		{
			if (y == int(value))
				return;

			super.y = int(value);
		}

		// ------------------------------------------------------------------------ Transform

		// Drag ------------------------------------------------------------------------

		protected var _dragArea:DisplayObject;

		private var _isDraggable:Boolean;

		public function get isDraggable():Boolean
		{
			return _isDraggable;
		}

		public function set isDraggable(value:Boolean):void
		{
			_isDraggable = value;

			if (!_dragArea)
				_dragArea = this;

			_dragArea.removeEventListener(MouseEvent.MOUSE_DOWN, onDrag);

			if (value)
				_dragArea.addEventListener(MouseEvent.MOUSE_DOWN, onDrag);
		}

		protected function onDrag(event:MouseEvent):void
		{
			parent.setChildIndex(this, parent.numChildren - 1);
			startDrag(false); //, root.scrollRect);
			stage.addEventListener(MouseEvent.MOUSE_UP, onDrop);
			stage.addEventListener(Event.MOUSE_LEAVE, onDrop);
			event.updateAfterEvent();
		}

		protected function onDrop(event:MouseEvent):void
		{
			stopDrag();
			stage.removeEventListener(MouseEvent.MOUSE_UP, onDrop);
			stage.removeEventListener(Event.MOUSE_LEAVE, onDrop);
			event.updateAfterEvent();
		}

		// ------------------------------------------------------------------------ Drag
		
		override public function destroy():void
		{
			// event
			removeEventListener(Event.ADDED_TO_STAGE, onStage);
			
			if(_dragArea)
				_dragArea.removeEventListener(MouseEvent.MOUSE_DOWN, onDrag);
			
			if(stage)
			{
				stage.removeEventListener(MouseEvent.MOUSE_UP, onDrop);
				stage.removeEventListener(Event.MOUSE_LEAVE, onDrop);
			}
			
			//signal
			_transformSignal.removeAll();
			_transformSignal = null;
			
			// referer
			_style = null;
			
			super.destroy();	
		}
	}
}