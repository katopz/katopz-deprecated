package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Rectangle;

	[SWF(backgroundColor="0xDDDDDD",frameRate="30",width="800",height="600")]
	public class MarkerEditor extends Sprite
	{
		public function MarkerEditor()
		{
			/*
			   var widthInput:SDInputText = new SDInputText("10");
			   addChild(widthInput);

			   var heightInput:SDInputText = new SDInputText("10");
			   addChild(heightInput);

			   var okButton:SDButton = new SDButton("OK");
			   addChild(okButton);
			 */

			var _amountW:uint = 2;
			var _amountH:uint = 2;

			var _segmentW:uint = 4;
			var _segmentH:uint = 4;

			var _size:uint = 5;

			var bitmapData:BitmapData = new BitmapData(_amountW * _segmentW * _size, _amountH * _segmentH * _size, false, 0xFFFFFF);

			var bitmap:Bitmap = new Bitmap(bitmapData);
			addChild(bitmap);

			var u:uint = 0

			for (var a:int = 0; a < _amountW; a++)
			{
				for (var b:int = 0; b < _amountH; b++)
				{

					for (var i:int = 0; i < _segmentW; i++)
					{
						for (var j:int = 0; j < _segmentH; j++)
						{
							var _color:Number = -1;

							/*
							//border
							if (i == 0 || j == 0)
								_color = 0xFFFFFF;

							if (i == _segmentW - 1 || j == _segmentH - 1)
								_color = 0xFFFFFF;
							*/

							// shift
							if (_color == -1)
							{
								if (i + j - 2 < u)
								{
									trace(i,j,u);
									_color = 0x000000;
								}
								else
								{
									_color = 0xFFFFFF;
								}
							}

							bitmapData.fillRect(new Rectangle((a * _segmentW * _size) + (i * _size), (b * _segmentH * _size) + (j * _size), _size, _size), _color);
						}
					}
					trace("---------------------");
					u++;
				}
			}
		}
	}
}