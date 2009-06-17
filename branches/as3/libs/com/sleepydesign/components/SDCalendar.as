package com.sleepydesign.components
{
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class SDCalendar extends Component
	{
		private var _date		:Date;
		private var _tf			:Cell;
		
		public var cellWidth	:int = 22;
		public var cellHeight	:int = 22;
		public const monthNames	:Array = new Array("January", "February ", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December");
		public const dayNames	:Array = new Array("S", "M", "T", "W", "T", "F", "S");
		
		private const eoms		:Array = new Array(31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);
		
		private var cells		:Array;
		
		public function SDCalendar(iDdate:Date = null)
		{
			_date = (iDdate)?iDdate:new Date();
			super();
		}
		
		override public function create(config:Object=null):void
		{
			//left
			var leftButton:PushButton = new PushButton(this, 0, 0, "<");
			leftButton.setSize(cellWidth+1, cellHeight);
			leftButton.name = "leftButton";
			leftButton.addEventListener(MouseEvent.CLICK, onControlClick, false, 0, true);
			leftButton.blendMode = "multiply";
			
			//title
			//_tf = new Label(this, 0, 0, String(_date.fullYear) + ", " + monthNames[_date.month]);
			_tf = new SDCell(this, cellWidth, 0, String(_date.fullYear) + ", " + monthNames[_date.month]);
			_tf.name = "label";
			_tf.data = _date;
			_tf.setSize(cellWidth * 5 +1, cellHeight);
			_tf.buttonMode = false;
			_tf.blendMode = "multiply";
			
			//right
			var rightButton:PushButton = new PushButton(this, cellWidth * 6, 0, ">");
			rightButton.setSize(cellWidth+1, cellHeight);
			rightButton.name = "rightButton";
			rightButton.addEventListener(MouseEvent.CLICK, onControlClick, false, 0, true);
			rightButton.blendMode = "multiply";
			
			//days cell
			create(date);
			
		}
		
		/**
		 * External use
		 */
		public function get date () :Date
		{
			return _date;
		}
		
		public function set date (iDate:Date) :void
		{
			_date = iDate;
		}
		
		/**
		 * List of Begin of Month
		 */
		private function getBeginOfMonth (iYear:Number) :Array
		{
			// leap year
			if (iYear%4 == 0) {
				eoms[1] = 29;
			} else {
				eoms[1] = 28;
			}
			
			//1st of day in month
			var currentDate = new Date();
			currentDate.setFullYear(iYear);
			currentDate.setMonth(0);
			currentDate.setDate(0);
			
			var begDay = currentDate.getDay()+1;
			var _boms = [];
			
			for (var j = 0; j<12; j++) {
				_boms.push(begDay);
				begDay += eoms[j];
			}
			return _boms;
		};
		
		/**
		 * Parses a specific Date and gives it Date-specific properties.
		 */
		public function create(iDate:Date=null):Array
		{
			//clear
			if (cells) {
				for each(var iCell in cells) {
					this.removeChild(iCell);
				}
			}
			
			_tf.data = _date = (iDate)?iDate:new Date();
			_tf.label = String(date.fullYear) + ", " + monthNames[_date.month];
			
			cells = [];
			
			//1st date
			var boms = getBeginOfMonth(iDate.fullYear);
			var i:uint;
			
			//day 1st name
			for (i = 0; i < 7; i++) {
				var dayCell:Cell =  new SDCell(this, i * cellWidth, _tf.height-1, dayNames[i]);
				dayCell.buttonMode = false;
				cells.push(dayCell);
			}
			
			var y0 =  _tf.y + _tf.height-1+ dayCell.height-1;
			var bom = boms[iDate.month];
			
			//begin cells
			for (i = 0; i < bom%7; i++)
			{
				var begCell:Cell =  new SDCell(this, i * cellWidth, y0, "");
				begCell.buttonMode = false;
				cells.push(begCell);
			}
			//cells
			for (i = 0; i < eoms[iDate.month]; i++)
			{
				var cell:Cell =  new SDCell(this, int(((bom + i) % 7) * cellWidth), y0 + int(((bom % 7) + i) / 7) * cellHeight, String(i + 1));
				cell.name = "date_"+i;
				cell.data = new Date(iDate.fullYear, iDate.month, i + 1);
				
				if ((((bom+i)%7) == 0) || ((((bom+i+1)%7) == 0))) {
					//weekend
				} else {
					//normal day
				}
				
				cell.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
				
				cells.push(cell);
			}
			
			//end cells
			if(int(((bom+eoms[iDate.month])%7))>0){
				for (i = int(((bom+eoms[iDate.month])%7)); i < 7; i++)
				{
					var endCell:Cell =  new SDCell(this, i * cellWidth, cell.y, "");
					endCell.buttonMode = false;
					cells.push(endCell);
				}
			}
			
			draw();
			change();
			return cells;
		}
		
		override public function draw():void
		{
			//hilight today
			var currentDate:Date = new Date();
			for each (var cell:Cell in cells) {
				cell.blendMode = "multiply";
				if (cell.data) {
					if (String(cell.data.date) + String(cell.data.month) + String(cell.data.fullYear) == String(currentDate.date) + String(currentDate.month) + String(currentDate.fullYear)) {
						cell.blendMode = "normal";
					}
				}
				cell.draw();
			}
			
			super.draw();
		}
		
		private function onClick(event:MouseEvent):void
		{
			var cell:Cell;
			if (event.target is Cell) {
				cell = event.target as Cell;
			}else {
				cell = event.target.parent as Cell;
			}
			
			date = cell.data;
			
			//change focus color
			draw();
			change();
		}
		
		private function onControlClick(event:MouseEvent):void
		{
			var newYear = _date.fullYear;
			var newMonth = _date.month;
			var newDate = 1;
			
			if (event.target.parent.name == "rightButton") {
				newMonth++;
				if (newMonth > 11) {
					newYear++;
					newMonth = 0;
				}
			}else {
				newMonth--;
				if (newMonth < 0) {
					newYear--;
					newMonth = 11;
				}
			}
			create(new Date(newYear,newMonth,newDate));
			change();
		}
		
		override public function change():void
		{
			//external data exchange
			data = date;
			dispatchEvent(new Event(Component.CHANGE));
		}
	}
}