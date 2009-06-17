package com.sleepydesign.draw
{
	import flash.display.Shape;
	
    /**
	 * SleepyDesign Grid
	 * @author katopz
	 */
	public class SDGrid extends Shape
	{
		public function SDGrid(col:Number=4, row:Number=4, colSpan:int=100, rowSpan:int=100, cols:Array=null, rows:Array=null, lineColor:uint=0x000000, thickness:Number=0.25)
		{
			this.graphics.beginFill(0xFFFFFF, 0);
			this.graphics.lineStyle(thickness, lineColor);
			
			//col
			var pos:Number;
			var currentX:Number=0;
			
			for(var i:int=0;i<=col;i++)
			{
				pos = i*colSpan;
				
				if(cols && cols[i])
				{
					pos = cols[i];
				}else{
					pos = colSpan;
				}
				
				this.graphics.moveTo(currentX,0);
				this.graphics.lineTo(currentX,row*rowSpan);
				
				currentX+=pos;
			}
			
			//row
			currentX-=pos;
			var currentY:Number=0;
			
			for(var j:int=0;j<=row;j++)
			{
				pos = j*rowSpan;
				
				if(rows && rows[j])
				{
					pos = rows[j];
				}else{
					pos = rowSpan;
				}
				
				this.graphics.moveTo(0,currentY);
				this.graphics.lineTo(currentX,currentY);
				currentY+=pos;
			}
			
			this.graphics.endFill();
		}
	}
}
