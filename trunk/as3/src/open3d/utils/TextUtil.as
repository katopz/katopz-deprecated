package open3d.utils
{
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;

	/**
	 * TextUtil : anything handy for text should place here
	 * @author katopz
	 */
	public class TextUtil
	{
		public static function getTextField(text:String = null, textFormat:TextFormat = null):TextField
		{
			var _textField:TextField = new TextField();

			_textField.selectable = false;
			_textField.mouseEnabled = false;
			_textField.mouseWheelEnabled = false;
			_textField.defaultTextFormat = textFormat ? textFormat : new TextFormat("Tahoma", 12, 0xFFFFFF);
			_textField.autoSize = "left";
			_textField.filters = [new GlowFilter(0x000000, 1, 4, 4, 2, 1)];

			if (_textField.text)
				_textField.text = text;

			return _textField;
		}
	}
}