package com.sleepydesign.components
{
	import com.sleepydesign.display.SDClip;
	import com.sleepydesign.utils.ArrayUtil;
	import com.sleepydesign.utils.MathUtil;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	import org.osflash.signals.Signal;

	public class SDDOPane extends SDClip
	{
		// base
		protected var _controlClip:Sprite;

		// canvas
		protected var _canvas:Sprite;
		private var _hScrollBar:SDScrollBar;
		private var _canvasClip:Sprite;
		private var _canvasRect:Rectangle;
		private var _canvasPanel:SDScrollPane;

		// content
		private var _itemNum:int = 0;
		private var _currentPageNum:int = -1;

		protected var _pageSize:int;
		protected var _itemThumbs:Array;

		public function get itemThumbs():Array
		{
			return _itemThumbs;
		}

		//Dictionary;

		private var _itemDatas:Array;

		/**return id*/
		public var thumbSignal:Signal = new Signal(String);

		private var _prevButton:DisplayObject;
		private var _nextButton:DisplayObject;

		private var _style:SDStyle;

		public function create(prevButton:DisplayObject, nextButton:DisplayObject, boundRect:Rectangle, style:SDStyle, pageSize:int = 8):void
		{
			_prevButton = prevButton;
			_nextButton = nextButton;
			_style = style;
			_pageSize = pageSize;

			_canvasClip = new Sprite;
			_canvasClip.graphics.lineStyle(0, 0, 0);
			_canvasClip.graphics.drawRect(0, 0, boundRect.width, boundRect.height);
			_canvasClip.graphics.endFill();

			_canvasClip.x = boundRect.x;
			_canvasClip.y = boundRect.y;

			// base
			addChild(_canvasClip);

			// nav
			if (prevButton && !prevButton.parent)
				addChild(prevButton);

			if (nextButton && !nextButton.parent)
				addChild(nextButton);

			enablePrev = false;
			enableNext = false;

			// canvas
			_canvasRect = boundRect;

			_canvas = new Sprite();

			_canvasPanel = new SDScrollPane(style);
			_canvasPanel.scrollBarVisible = false;
			_canvasPanel.useMouseWheel = false;
			_canvasPanel.mouseEnabled = false;

			_canvasClip.addChild(_canvasPanel);

			// size
			_canvasPanel.setSize(_canvasRect.width, _canvasRect.height);

			// content
			_canvasPanel.addContent(_canvas);

			//_itemThumbs = []; //new Dictionary(true); //new Vector.<ItemThumb>();

			// event
			addEventListener(MouseEvent.CLICK, onClick);

			// activate
			activate();
		}

		public function set enablePrev(value:Boolean):void
		{
			if (_prevButton)
				_prevButton.visible = value;
		}

		public function set enableNext(value:Boolean):void
		{
			if (_nextButton)
				_nextButton.visible = value;
		}

		/**
		 * Page Culling
		 *
		 * | previous page  | current page |   next page    |
		 * | preload/cached |  prioritize  | preload/cached | destroy
		 *
		 */
		public function showItems(itemDatas:Array):void
		{
			if (!itemDatas)
				return;

			// all app items
			//DebugUtil.trace(" ! showItems : " + itemDatas.length);

			// get maximum size
			_itemNum = itemDatas.length;

			// collect all data
			_itemDatas = itemDatas;

			// dispose view
			if (_itemThumbs)
				for each (var dObject:DisplayObject in _itemThumbs)
				{
					if (dObject.parent && dObject.parent.getChildIndex(dObject) > -1)
						dObject.parent.removeChild(dObject);
				}

			_itemThumbs = [];

			if (itemDatas.length <= 0)
				return;

			// draw page 0
			setPage(0, true);
		}

		public function setPage(pageNum:int, forceReset:Boolean = false):void
		{
			// ignore if not dirty
			if (_currentPageNum == pageNum)
			{
				if (!forceReset)
					return;
			}

			var i:int;
			var itemThumb:DisplayObject;
			var index:int;

			// hide all item itemThumb
			for each (itemThumb in _itemThumbs)
			{
				// don't hide item near selected page
				index = itemThumb.parent.getChildIndex(itemThumb);
				if (index < pageNum * _pageSize && index > pageNum * _pageSize)
				{
					deactivateItemThumb(itemThumb);
				}
			}

			_currentPageNum = pageNum;

			// current page -> next page
			if (_itemDatas && _itemDatas.length > 0)
			{
				for (i = _currentPageNum * _pageSize; i < (_currentPageNum + 1) * _pageSize; i++)
				{
					var itemData:DisplayObject = _itemDatas[i];

					// no data? skip then
					if (!itemData)
						continue;

					itemThumb = _itemThumbs[i];

					// not create yet?
					if (!itemThumb)
						_itemThumbs[i] = itemThumb = setupThumb(i, itemData);

					// apply position
					applyThumb(i, itemThumb, itemData);
				}
			}

			// nav
			enablePrev = (_currentPageNum > 0);

			var rowSize:int;

			if (_style.ORIENTATION == SDStyle.HORIZONTAL)
			{
				if (_canvasRect.height < itemThumb.height)
					rowSize = 1;
				else
					rowSize = _canvasRect.height / itemThumb.height;

				enableNext = itemThumb && (_currentPageNum < _canvasPanel.getHPageNumFromWidth(Math.ceil(_itemNum / rowSize) * itemThumb.width) - 1);
				_canvasPanel.slidePage(_currentPageNum);
			}
			else
			{
				if (_canvasRect.width < itemThumb.width)
					rowSize = 1;
				else
					rowSize = _canvasRect.width / itemThumb.width;

				enableNext = itemThumb && (_currentPageNum < _canvasPanel.getVPageNumFromHeight(Math.ceil(_itemNum / rowSize) * itemThumb.height) - 1);
				_canvasPanel.slidePage(0, _currentPageNum);
			}

			// call when done setup
			onSetPage();
		}

		protected function onSetPage():void
		{
			// override me
		}

		public function resetPage():void
		{
			setPage(_currentPageNum, true);
		}

		protected function deactivateItemThumb(dObject:DisplayObject):void
		{
			// hide
			dObject.visible = false;
		}

		protected function setupThumb(i:int, dObject:DisplayObject):DisplayObject
		{
			return addThumb(dObject);
		}

		public function addThumb(dObject:DisplayObject):DisplayObject
		{
			if (dObject.parent && dObject.parent.getChildIndex(dObject) > -1)
				dObject.parent.removeChild(dObject);

			_canvas.addChild(dObject);
			return dObject;
		}

		public function removeThumb(dObject:DisplayObject):void
		{
			if (!dObject)
				return;

			var index:uint = ArrayUtil.removeItem(_itemThumbs, dObject);
			_itemThumbs.parent.removeChild(_itemThumbs);

			if (_itemDatas && (index > -1))
			{
				var _res:Array = [];
				var i:int = 0;
				while (i < _itemDatas.length)
				{
					if (i != index - 1)
						_res.push(_itemDatas[i]);
					i++;
				}

				_itemDatas = _res;
			}
		}

		public function removeAllThumb():void
		{
			for each (var itemThumb:DisplayObject in _itemThumbs)
				itemThumb.parent.removeChild(itemThumb);
		}

		public function getThumbByName(thumbID:String):DisplayObject
		{
			for each (var itemThumb:DisplayObject in _itemThumbs)
			{
				if (itemThumb.name == thumbID)
					return itemThumb;
			}

			return null;
		}

		public function removeThumbByName(thumbID:String):void
		{
			removeThumb(getThumbByName(thumbID));
		}

		protected function applyThumb(i:int, itemThumb:DisplayObject, itemData:Object):void
		{
			var colSize:int = _canvasRect.width / itemThumb.width;
			var rowSize:int = _canvasRect.height / itemThumb.height;
			var pos:Point;

			if (_style.ORIENTATION == SDStyle.HORIZONTAL)
			{
				// set position
				var _thumbX:Number = i * itemThumb.width;

				// auto warp
				if (_thumbX >= (1 + _currentPageNum) * _canvasRect.width)
				{
					pos = MathUtil.getPointFromIndex(i, colSize);

					itemThumb.x = (_currentPageNum * _canvasRect.width) + (pos.x * itemThumb.width);
					itemThumb.y = (pos.y % rowSize) * itemThumb.height;
				}
				else
				{
					itemThumb.x = _thumbX;
					itemThumb.y = 0;
				}

			}
			else
			{
				// set position
				var _thumbY:Number = i * itemThumb.height;

				// auto warp
				if (_thumbY >= (1 + _currentPageNum) * _canvasRect.height)
				{
					pos = MathUtil.getPointFromIndex(i, rowSize);

					itemThumb.y = (_currentPageNum * _canvasRect.height) + (pos.x * itemThumb.height);
					itemThumb.x = (pos.y % rowSize) * itemThumb.height;
				}
				else
				{
					itemThumb.x = 0;
					itemThumb.y = _thumbY;
				}
			}
		}

		protected function onClick(event:MouseEvent):void
		{
			switch (event.target.name)
			{
				case "prevButton":
					prevPage();
					break;
				case "nextButton":
					nextPage();
					break;
				default:
					if (event.target.parent is DisplayObject)
						thumbSignal.dispatch(DisplayObject(event.target.parent).name);
					else if (event.target is DisplayObject)
						thumbSignal.dispatch(DisplayObject(event.target).name);
					break;
			}
		}

		public function prevPage():void
		{
			setPage(_currentPageNum - 1);
		}

		public function nextPage():void
		{
			setPage(_currentPageNum + 1);
		}

		public function draw():void
		{
			resetPage();
		}

		public function hideItems():void
		{
			showItems([]);
		}
	}
}