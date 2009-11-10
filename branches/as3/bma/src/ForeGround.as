package 
{
	import com.sleepydesign.utils.LoaderUtil;
	import com.sleepydesign.utils.XMLUtil;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import gs.TweenLite;
	
	public class ForeGround extends Sprite
	{
		private const monthName:Array = new Array("มกราคม", "กุมภาพันธ์", "มีนาคม", "เมษายน", "พฤษภาคม", "มิถุนายน", "กรกฎาคม", "สิงหาคม", "กันยายน", "ตุลาคม", "พฤศจิกายน", "ธันวาคม");
		private const dayName:Array = new Array("อาทิตย์", "จันทร์", "อังคาร", "พุธ", "พฤหัสบดี", "ศุกร์", "เสาร์");
		public static var ticker:Timer;
		
		public function ForeGround()
		{
			var date
			
			if (!ticker)
			{
				ticker = new Timer(1000);
				ticker.addEventListener(TimerEvent.TIMER, onTick);
        	}
			
            ticker.start();
		}
		
		private function onTick(event:TimerEvent)
		{
			//วันศุกร์ที่ 10 กรกฎาคม 2552  12.00 น.
			var dateTime:Date = new Date();
			dateText.text = "วัน" + dayName[dateTime.day] +" ที่ " + dateTime.date + " " + monthName[dateTime.month] + " " + (543+dateTime.fullYear) + " " + addLeadingZeros(dateTime.hours) + "." + addLeadingZeros(dateTime.minutes) + " น.";
		}
		
		private function addLeadingZeros(input:Number, count:uint=2):String
		{
			var result:String = String(input);
			while (result.length < count) 
			{
				result = "0" + result;
			}
			return result;
		}
	}
}