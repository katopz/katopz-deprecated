package com.sleepydesign.crypto
{
	import flash.display.*;
	/**
	 * @author katopz
	 */
	public class PBE
	{
		[Embed(source="../pbjs/encypt.pbj",mimeType="application/octet-stream")]
		private static var Encypt:Class;
		
		[Embed(source="../pbjs/decypt.pbj",mimeType="application/octet-stream")]
		private static var Decypt:Class;
		
		private static var shader:Shader;
		
		public static function encypt(value:String):String
		{
			var inputVector:Vector.<Number> = getCharCodes(value);

			var w:int = 2+Math.ceil(Math.sqrt(inputVector.length / 3));
			//trace("encypt w:"+w);
			
			shader = new Shader(new Encypt);
			shader.data.source.width = w;
			shader.data.source.height = 1;
			shader.data.source.input = inputVector;
			
			var job:ShaderJob = new ShaderJob(shader, inputVector, w, 1);
			job.start(true);
			
			var result:String = "";
			for each(var _charCode:Number in inputVector)
				result += String.fromCharCode(_charCode);
				
			return result;
		}
		
		public static function decypt(value:String):String
		{
			var inputVector:Vector.<Number> = getCharCodes(value);

			var w:int = 2+Math.ceil(Math.sqrt(inputVector.length / 3));
			
			shader = new Shader(new Decypt);
			shader.data.source.width = w;
			shader.data.source.height = 1;
			shader.data.source.input = inputVector;
			
			var job:ShaderJob = new ShaderJob(shader, inputVector, w, 1);
			job.start(true);
			
			var result:String = "";
			for each(var _charCode:Number in inputVector)
				result += String.fromCharCode(_charCode);
				
			return result;
		}
		
		private static function getCharCodes(source:String):Vector.<Number>
		{
			var result:Vector.<Number> = new Vector.<Number>();
			
			for (var i:int = 0; i< source.length ; i++)
				result.push(source.charCodeAt(i));
			
			var begNum:int = source.length;
			var endNum:int = Math.ceil(begNum/3)*3;
			for (i = begNum; i<endNum; i++)
				result.push(0x2E);
			
			return result;
		}
	}
}