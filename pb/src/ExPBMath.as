package
{
	import __AS3__.vec.Vector;
	
	import flash.display.Shader;
	import flash.display.ShaderJob;
	import flash.display.Sprite;
	import flash.utils.getTimer;

	[SWF(backgroundColor="#666666",frameRate="30",width="640",height="480")]

	/**
	 * http://blog.robskelly.com/2009/02/using-pixel-bender-for-math-in-flashflex/
	 * @author katopz
	 */
	public class ExPBMath extends Sprite
	{
		[Embed(source="../pbj/PBSqrt.pbj",mimeType="application/octet-stream")]
		private var PBSqrt:Class;
		
		[Embed(source="../pbj/PBAdd.pbj",mimeType="application/octet-stream")]
		private var PBAdd:Class;
		
		[Embed(source="../pbj/ZSort.pbj",mimeType="application/octet-stream")]
		private var ZSort:Class;
		
		private var total:int = 100;

		public function ExPBMath()
		{
			var nVec:Vector.<Number> = new Vector.<Number>();
			var nVec2:Vector.<Number> = new Vector.<Number>();
			for (var i:int = 0; i < total; i++)
			{
				nVec.push(i);
				nVec2.push(i);
			}

			// The number of pixels (assuming a 3-element pixel).
			// Since our length is 100, the number of pixels isn’t going to be
			// whole, but we won’t worry about that just yet.
			var count:Number = nVec.length / 3;

			// Calculate the width of the grid. We round it up, because the
			// width and height have to be whole numbers.
			var w:uint = Math.ceil(Math.sqrt(count)); // w = 6

			// Calculate the height of the grid.
			var h:uint = Math.ceil(count / w); // h = 6

			// Multiplying width (6) by height (6) gives us 36, which
			// is more than our total number of pixels. We have to pad our vector.
			// The length of the vector is going to be 36*3, or 108.
			// Chose your padding carefully, because these values will be
			// used in the computation. I’ll use 0 here.
			while (nVec.length < w * h * 3)
				nVec.push(0);
			
			var shader:Shader;
			var job:ShaderJob;
			
			// --------------------------------------- PBSqrt ---------------------------------------
			
			/*
			shader = new Shader(new PBSqrt());
			shader.data.source.width = w;
			shader.data.source.height = h;
			shader.data.source.input = nVec;
			
			job = new ShaderJob(shader, nVec, w, h);
			
			// try with ShaderJob
			var timer:Number = getTimer();
			job.start(true);
			timer = getTimer() - timer;
			trace("PBSqrt : "+timer);
			
			// normal loop
			timer = getTimer();
			for (i = 0; i < total; i++)
			{
				nVec2[i] = Math.sqrt(nVec2[i]);
			}
			timer = getTimer() - timer;
			trace("Math.sqrt : "+timer);
			*/
			
			// --------------------------------------- PBAdd ---------------------------------------
			
			nVec = new Vector.<Number>();
			for (i = 0; i < w * h * 3; i++)
			{
				nVec.push(i);
			}
			
			shader = new Shader(new PBAdd());
			shader.data.source.width = w;
			shader.data.source.height = h;
			shader.data.source.input = nVec;
			
			job = new ShaderJob(shader, nVec, w, h);
			job.start(true);
			
			trace(nVec);
			
			// --------------------------------------- ZSort ---------------------------------------
			
			nVec = new Vector.<Number>();
			for (i = 0; i < 8; i++)
			{
				nVec.push(i);
			}
						
			count = nVec.length / 4;
			w = Math.ceil(Math.sqrt(count));
			h = Math.ceil(count / w);
			
			for (i = 0; i < w * h * 4; i++)
			{
				nVec.push(i);
			}
			
			shader = new Shader(new ZSort());
			shader.data.source.width = w;
			shader.data.source.height = h;
			shader.data.source.input = nVec;
			
			job = new ShaderJob(shader, nVec, w, h);
			job.start(true);
			
			trace(nVec);
		}
	}
}
