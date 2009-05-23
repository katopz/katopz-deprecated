package open3d.debug
{
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * SimpleTextField : for debug
	 * @author katopz
	 */	
	public class SimpleTextField extends TextField
	{
		public var defaultText:String="";
		
		public function SimpleTextField(text:String=null, textFormat:TextFormat=null)
		{
			super();
			
	    	selectable = false;
	    	mouseEnabled = false;
	    	mouseWheelEnabled = false;
	    	defaultTextFormat = textFormat?textFormat:new TextFormat("Tahoma", 12, 0xFFFFFF);
	    	autoSize = "left";
	    	filters = [new GlowFilter(0x000000,1,4,4,2,1)];
	    	
	    	if(text)
	    		this.htmlText = text;
		}
	}
}
	