package
{
	import __AS3__.vec.Vector;
	
	import flash.display.Shader;
	import flash.display.ShaderJob;
	import flash.display.Sprite;
	import flash.utils.*;

	[SWF(backgroundColor="#666666",frameRate="30",width="640",height="480")]
	/**
	 * @author katopz
	 */
	public class ExPBKey extends Sprite
	{
		[Embed(source="../pbjs/PBKey.pbj",mimeType="application/octet-stream")]
		private var PBKey:Class;

		public function ExPBKey()
		{
			var inputVector:Vector.<Number> = getCharCodes("ก۩!۞۩3");

			var w:int = Math.ceil(Math.sqrt(inputVector.length / 3));

			var shader:Shader = new Shader(new PBKey());
			shader.data.source.width = w;
			shader.data.source.height = 1;
			shader.data.source.input = inputVector;

			var job:ShaderJob = new ShaderJob(shader, inputVector, w, 1);
			job.start(true);

			for each(var _charCode:int in inputVector)
				trace(String.fromCharCode(_charCode));
		}
		
		private function getCharCodes(source:String):Vector.<Number>
		{
			var result:Vector.<Number> = new Vector.<Number>();
			
			for (var i:int = 0; i< source.length ; i++)
				result.push(source.charCodeAt(i));
			
			trace(result)
			return result;
		}
	}
}