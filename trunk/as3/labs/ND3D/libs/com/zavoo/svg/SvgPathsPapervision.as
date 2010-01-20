package com.zavoo.svg {	import com.zavoo.svg.SvgPath;		import org.papervision3d.objects.special.Graphics3D;			public class SvgPathsPapervision
	{
		public var paths:Array = new Array();
		
		public function SvgPathsPapervision(svgData:String)
		{
			var pathTagRE:RegExp = /(<path.*?\/>)/sig;
		    var pathArray:Array;
		    while(pathArray = pathTagRE.exec(svgData))
		    {
		    	paths.push(new SvgPath(pathArray[1]));						    		
		    }
		}
		
		public function drawToVectorShape(grahics : Graphics3D, scale :Number = 1, offsetX:Number = 0, offsetY:Number = 0) : void {
			//g.clear();
			for each(var path:SvgPath in paths)
			{
				grahics.beginFill(path.fill,path.fillAlpha);
				grahics.lineStyle(path.strokeWidth,path.stroke,path.strokeAlpha);
	
				for each(var line:Array in path.d)
				{
					switch(line[0])
					{
						case "M":
							grahics.moveTo(Number(line[1][0]) * scale + offsetX, Number(line[1][1]) * scale + offsetY);
							break;
							
						case "L":
							grahics.lineTo(Number(line[1][0]) * scale + offsetX, Number(line[1][1]) * scale + offsetY);
							break;
							
						case "C":
							grahics.curveTo(Number(line[1][0]) * scale + offsetX, Number(line[1][1]) * scale + offsetY, 
								Number(line[1][2]) * scale + offsetX, Number(line[1][3]) * scale + offsetY);
							break;
					}
				}
				grahics.endFill();
			}
		}
	}
}