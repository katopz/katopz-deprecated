package
{
	import flash.display.*;
	import flash.events.Event;
	import flash.text.*;
	import flash.utils.*;

	[SWF(backgroundColor="#FFFFFF", frameRate="30", width="800", height="600")]
	public class TestSpeed extends Sprite
	{
		private var _text:String;
		private var logger:TextField;
		private var beforeTime:int;

		[Embed(source="../pbj/line.pbj", mimeType="application/octet-stream")]
		private var Filter:Class;

		private var shader:Shader = new Shader(new Filter() as ByteArray);

		public function TestSpeed()
		{
			logger = new TextField();
			logger.autoSize = TextFieldAutoSize.LEFT;
			addChild(logger);

			//stage.addEventListener(MouseEvent.CLICK, doTest);
			addEventListener(Event.ENTER_FRAME, doTest);
		}

		private function start():void
		{
			beforeTime = getTimer();
		}

		private function stop(msg:*):void
		{
			log(msg + " : " + (getTimer() - beforeTime));
		}

		private function log(msg:*):void
		{
			_text += (msg + "\n");
		}

		private function doTest(e:*):void
		{
			_text = "";
			var i:int;
			const REPS:int = 1000;

			//================================================

			graphics.clear();
			//graphics.beginFill(0x00FF00);
			//graphics.drawCircle(150, 150, 50);

			i = 0;

			start();

			var x0y0:Vector.<Number> = new Vector.<Number>(REPS * 2, true);
			var x1y1:Vector.<Number> = new Vector.<Number>(REPS * 2, true);
			var colors:Vector.<int> = new Vector.<int>(REPS, true);

			while (i < REPS)
			{
				x0y0[int(i)] = Math.random() * 800;
				x0y0[int(i + 1)] = Math.random() * 600;

				x1y1[int(i)] = Math.random() * 800;
				x1y1[int(i + 1)] = Math.random() * 600;

				colors[int(i)] = int(Math.random() * 0xFFFFFF);

				i++;
			}

			drawLines(x0y0, x1y1, colors);

			graphics.beginShaderFill(shader);
			graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);

			stop("drawLine");

			//------------------------------------------------

			i = REPS;

			start();

			while (i--)
			{
				/*graphics.lineStyle(1, int(Math.random() * 0xFFFFFF), 1);
				graphics.moveTo(Math.random() * 800, Math.random() * 600);
				graphics.lineTo(Math.random() * 800, Math.random() * 600);*/
			}

			stop("lineTo");

			//================================================

			logger.text = _text;
		}

		private function drawLines(x0y0:Vector.<Number>, x1y1:Vector.<Number>, colors:Vector.<int>):void
		{
			drawLine(x0y0[0], x0y0[1], x1y1[0], x1y1[1], colors[0]);
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