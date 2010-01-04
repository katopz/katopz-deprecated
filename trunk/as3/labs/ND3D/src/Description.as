package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;

	import de.nulldesign.nd3d.geom.Vertex;
	import de.nulldesign.nd3d.objects.Mesh;	

	public class Description extends Sprite
	{
		private var txtField:TextField;
		private var followMesh:Mesh;

		public function Description(txt:String, followMesh:Mesh) 
		{
			txtField = new TextField();
			txtField.background = true;
			txtField.backgroundColor = 0x000000;
			txtField.textColor = 0xFFFFFF;
			txtField.text = txt;
			txtField.multiline = false;
			txtField.autoSize = "left";
			
			var txtFmt:TextFormat = new TextFormat("Arial", 11);
			txtField.setTextFormat(txtFmt);
			
			addChild(txtField);
			
			this.followMesh = followMesh;
			addEventListener(Event.ENTER_FRAME, loop);
		}

		private function loop(e:Event):void 
		{
			this.x = followMesh.positionAsVertex.screenX;
			this.y = followMesh.positionAsVertex.screenY;
		}
	}
}