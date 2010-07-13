package
{
	import flash.display.*;
	import flash.utils.*;

	[SWF(backgroundColor="#000000", frameRate="30", width="800", height="600")]
	public class PBLine extends Sprite
	{
		[Embed(source="../pbj/line.pbj", mimeType="application/octet-stream")]
		private var Filter:Class;

		private var shader:Shader = new Shader(new Filter() as ByteArray);

		public function PBLine()
		{
			drawLine(100, 100, 200, 200, 0xFF0000, .5, 4);

			graphics.clear();

			graphics.beginFill(0x00FF00);
			graphics.drawCircle(150, 150, 50);

			graphics.beginShaderFill(shader);
			graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			graphics.endFill();
		}

		private function drawLine(x0:Number, y0:Number, x1:Number, y1:Number, color:Number = 0xFF00FF, alpha:Number = 1, thickness:Number = 1):void
		{
			var shader_data:ShaderData = shader.data;
			
			shader_data["x0y0"].value[0] = x0;
			shader_data["x0y0"].value[1] = y0;

			shader_data["x1y1"].value[0] = x1;
			shader_data["x1y1"].value[1] = y1;

			shader_data["color"].value[0] = color >> 16 & 0xFF;
			shader_data["color"].value[1] = color >> 8 & 0xFF;
			shader_data["color"].value[2] = color & 0xFF;
			shader_data["color"].value[3] = alpha; //color >> 24 & 0xFF;

			shader_data["thickness"].value[0] = thickness;
		}
	}
}