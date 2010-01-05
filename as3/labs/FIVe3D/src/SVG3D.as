package
{
	import com.zavoo.svg.SvgPath;
	
	import flash.utils.ByteArray;
	
	import net.badimon.five3D.display.Sprite3D;

	public class SVG3D extends Sprite3D
	{
		//var _SVG3D:SVG3D = new SVG3D(new ThaiTXT() as ByteArray, 2, -101.35 / 2, -186.9 / 2);
		public function SVG3D(_data:ByteArray, scale:Number = 1, offsetX:Number = 0, offsetY:Number = 0)
		{
			var _str:String = _data.readUTFBytes(_data.length);
			var paths:Array = [];
			var pathTagRE:RegExp = /(<path.*?\/>)/sig;
			var pathArray:Array;
			while (pathArray = pathTagRE.exec(_str))
				paths.push(new SvgPath(pathArray[1]));
			
			for each (var path:SvgPath in paths)
			{
				graphics3D.beginFill(path.fill, path.fillAlpha);
				graphics3D.lineStyle(path.strokeWidth, path.stroke, path.strokeAlpha);

				for each (var line:Array in path.d)
				{
					var _line_1:Array = line[1];
					switch (line[0])
					{
						case "M":
							graphics3D.moveTo(
								Number(_line_1[0]) * scale + offsetX, Number(_line_1[1]) * scale + offsetY
								);
							break;

						case "L":
							graphics3D.lineTo(
								Number(_line_1[0]) * scale + offsetX, Number(_line_1[1]) * scale + offsetY
								);
							break;

						case "C":
							graphics3D.curveTo(
								Number(_line_1[0]) * scale + offsetX, Number(_line_1[1]) * scale + offsetY,
								Number(_line_1[2]) * scale + offsetX, Number(_line_1[3]) * scale + offsetY
								);
							break;
					}
				}
				graphics3D.endFill();
			}
		}
	}
}