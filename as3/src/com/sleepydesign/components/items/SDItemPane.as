package com.sleepydesign.components.items
{
	import com.sleepydesign.components.SDScrollBar;
	import com.sleepydesign.components.SDScrollPane;
	import com.sleepydesign.components.SDStyle;
	import com.sleepydesign.display.SDClip;
	import com.sleepydesign.system.DebugUtil;
	import com.sleepydesign.utils.ArrayUtil;
	import com.sleepydesign.utils.MathUtil;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	import org.osflash.signals.Signal;

	public class SDItemPane extends SDClip
	{
		// base
		protected var _controlClip:Sprite;

		// canvas
		protected var _canvas:Sprite;
		private var _hScrollBar:SDScrollBar;
		private var _canvasClip:DisplayObjectContainer;
		private var _canvasRect:Rectangle;
		private var _canvasPanel:SDScrollPane;

		// content
		private var _itemNum:int = 0;
		private var _currentPageNum:int = -1;

		protected var _pageSize:int;
		protected var _itemThumbs:Array; //Dictionary;

		private var _itemDatas:Array;

		// skin
		protected var _itemClass:Class;

		/**return id*/
		public var thumbSignal:Signal = new Signal(SDItemThumb);

		private var _prevButton:DisplayObject;
		private var _nextButton:DisplayObject;

		private var _style:SDStyle;

		public function create(prevButton:DisplayObject, nextButton:DisplayObject, canvasClip:DisplayObjectContainer, itemClass:Class, style:SDStyle):void
		{
			_prevButton = prevButton;
			_nextButton = nextButton;

			_canvasClip = canvasClip;
			_style = style;

			// base
			addChild(canvasClip);

			if (!prevButton.parent)
				addChild(prevButton);

			if (!nextButton.parent)
				addChild(nextButton);

			_itemClass = itemClass;

			if (!_pageSize)
				_pageSize = 8;

			// default
			prevButton.visible = false;
			nextButton.visible = false;

			// canvas
			_canvasRect = new Rectangle(canvasClip.x, canvasClip.y, canvasClip.width, canvasClip.height);

			_canvas = new Sprite();

			_canvasPanel = new SDScrollPane(style);
			_canvasPanel.scrollBarVisible = false;
			_canvasPanel.useMouseWheel = false;
			canvasClip.addChild(_canvasPanel);

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
			DebugUtil.trace(" ! showItems : " + itemDatas.length);

			// get maximum size
			_itemNum = itemDatas.length;

			// collect all data
			_itemDatas = itemDatas;

			// dispose view
			if (_itemThumbs)
				for each (var itemThumb:SDItemThumb in _itemThumbs)
					itemThumb.destroy();

			_itemThumbs = [];

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
			var itemThumb:SDItemThumb;

			// hide all item itemThumb
			for each (itemThumb in _itemThumbs)
			{
				// don't hide item near selected page
				if (itemThumb.index < pageNum * _pageSize && itemThumb.index > pageNum * _pageSize)
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
					var itemData:ItemData = _itemDatas[i] as ItemData;

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
			_prevButton.visible = (_currentPageNum > 0);

			var rowSize:int;

			if (_style.ORIENTATION == SDStyle.HORIZONTAL)
			{
				rowSize = _canvasRect.height / itemThumb.height;
				_nextButton.visible = itemThumb && (_currentPageNum < _canvasPanel.getHPageNumFromWidth(Math.ceil(_itemNum / rowSize) * itemThumb.width) - 1);
				_canvasPanel.slidePage(_currentPageNum);
			}
			else
			{
				rowSize = _canvasRect.width / itemThumb.width;
				_nextButton.visible = itemThumb && (_currentPageNum < _canvasPanel.getVPageNumFromHeight(Math.ceil(_itemNum / rowSize) * itemThumb.height) - 1);
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

		protected function deactivateItemThumb(itemThumb:SDItemThumb):void
		{
			// hide
			itemThumb.hide();
		}

		protected function setupThumb(i:int, itemData:ItemData):SDItemThumb
		{
			return addThumb(new SDItemThumb(i, itemData.id, itemData.title, _itemClass));
		}

		public function addThumb(itemThumb:SDItemThumb):SDItemThumb
		{
			_canvas.addChild(itemThumb);
			return itemThumb;
		}

		public function removeThumb(itemThumb:SDItemThumb):void
		{
			if (!itemThumb)
				return;

			var index:uint = ArrayUtil.removeItem(_itemThumbs, itemThumb);
			itemThumb.destroy();

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
			for each (var itemThumb:SDItemThumb in _itemThumbs)
				itemThumb.destroy();
		}

		public function getThumbByID(thumbID:String):SDItemThumb
		{
			for each (var itemThumb:SDItemThumb in _itemThumbs)
			{
				if (itemThumb.id == thumbID)
					return itemThumb;
			}

			return null;
		}

		public function removeThumbByID(thumbID:String):void
		{
			removeThumb(getThumbByID(thumbID));
		}

		protected function applyThumb(i:int, itemThumb:SDItemThumb, itemData:ItemData):void
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
					setPage(_currentPageNum - 1);
					break;
				case "nextButton":
					setPage(_currentPageNum + 1);
					break;
				default:
					if (event.target is SDItemThumb)
						thumbSignal.dispatch(event.target);
					break;
			}
		}

		public function draw():void
		{
			resetPage();
		}
	}
}