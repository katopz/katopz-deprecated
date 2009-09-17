package
{
	import __AS3__.vec.Vector;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Matrix3D;
	import flash.text.TextField;
	import flash.utils.*;

	[SWF(backgroundColor="#FFFFFF", frameRate="30", quality="MEDIUM", width="800", height="600")]
	public class TestMatrix3D extends Sprite
	{
		private var debugText:TextField;
		private var total:int = 10;
		
		public function TestMatrix3D()
		{
			debugText = new TextField();
			debugText.autoSize = "left";
			addChild(debugText);
			debugText.text = "click";
			
			stage.addEventListener(MouseEvent.CLICK, onClick);
		}
		
		private function onClick(e:MouseEvent):void
		{
			debugText.text = "result is ";
			
			var i:int=0;
			
			var r1:Vector.<Number> = new Vector.<Number>(16, true);
			var r2:Vector.<Number> = new Vector.<Number>(16, true);
			for(i=0;i<16;i++)
			{
				r1[i] = Math.random();
				r2[i] = Math.random();
			}
			
			var m1:Matrix3D = new Matrix3D(r1);
			var m2:Matrix3D = new Matrix3D(r1);
			
			debugText.appendText("\n");
			debugText.appendText(String(m1.rawData));
			debugText.appendText("\n");
			debugText.appendText(String(m2.rawData));
			debugText.appendText("\n");
			
			var result:Boolean = false;
			
			var time:int = getTimer();
			for(i=0;i<total;i++)
			{
				result = compareString(m1, m2);
			}
			debugText.appendText("compareString:"+String(result)+ ":");
			debugText.appendText(String(getTimer()-time));
			
			debugText.appendText("\n");
			
			time = getTimer();
			for(i=0;i<total;i++)
			{
				result = compareRawData(m1, m2);
			}
			debugText.appendText("compareRawData:"+String(result)+ ":");
			debugText.appendText(String(getTimer()-time));
			
			debugText.appendText("\n");
		}
		
		private function compareRawData(m1:Matrix3D, m2:Matrix3D):Boolean
		{
			var r1:Vector.<Number> = m1.rawData;
			var r2:Vector.<Number> = m2.rawData;
			return (r1[0]==r2[0]&&r1[1]==r2[1]&&r1[2]==r2[2]&&r1[3]==r2[3]&&
					r1[4]==r2[4]&&r1[5]==r2[5]&&r1[6]==r2[6]&&r1[7]==r2[7]&&
					r1[8]==r2[8]&&r1[9]==r2[9]&&r1[10]==r2[10]&&r1[11]==r2[11]&&
					r1[12]==r2[12]&&r1[13]==r2[13]&&r1[14]==r2[14]&&r1[15]==r2[15])
		}
		
		private function compareString(m1:Matrix3D, m2:Matrix3D):Boolean
		{
			return (String(m1.rawData)==String(m2.rawData));
		}
	}
}