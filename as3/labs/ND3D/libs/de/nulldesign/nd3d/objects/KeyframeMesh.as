package de.nulldesign.nd3d.objects
{
	import de.nulldesign.nd3d.animation.Frame;
	import de.nulldesign.nd3d.geom.Vertex;
	import de.nulldesign.nd3d.material.Material;

	import flash.utils.getTimer;

	/**
	 * KeyframeMesh provides framework for objects that have keyframed animation.
	 * Note that is class is [abstract] in that in itself provides no functionality.
	 * <p>
	 * There are a couple very specific details that must be adhered to by all subclasses
	 * in order for this to work properly:
	 * <p>
	 * [1] The subclass MUST allocate properly sized arrays with memory for <i>faces</i> and <i>vertices</i><br>
	 * [2] The <i>Face3D</i> objects in <i>faces</i> must have an <i>id</i> cooresponding to their original array order
	 * <p>
	 * Please feel free to use, but please mention me!
	 * 
	 * @version 05.01.07
	 * @author Philippe Ajoux (philippe.ajoux@gmail.com)
	 * @modifier katopz@sleepydesign.com 
	 */
	public class KeyframeMesh extends Mesh
	{
		/**
		 * Three kinds of animation sequences:
		 *  [1] Normal (sequential, just playing)
		 *  [2] Loop   (a loop)
		 *  [3] Stop   (stopped, not animating)
		 */
		public static const ANIM_NORMAL:int = 1;
		public static const ANIM_LOOP:int = 2;
		public static const ANIM_STOP:int = 4;

		/**
		 * The array of frames that make up the animation sequence.
		 */
		public var frames:Array = new Array();

		/**
		 * Keep track of the current frame number and animation
		 */
		private var _currentFrame:int = 0;
		private var interp:Number = 0;
		private var start:int, end:int, type:int;
		private var ctime:Number = 0, otime:Number = 0;

		/**
		 * Number of animation frames to display per second
		 */
		public var fps:int;

		/**
		 * KeyframeMesh is a class used [internal] to provide a "keyframe animation"/"vertex animation"/"mesh deformation"
		 * framework for subclass loaders. There are some subtleties to using this class, so please, I suggest you
		 * don't (not yet). Possible file formats are MD2, MD3, 3DS, etc...
		 */
		public function KeyframeMesh(material:Material, fps:int = 24, scale:Number = 1)
		{
			super();
			this.fps = fps;
			scale = scale;
		}

		public function gotoAndPlay(frame:int):void
		{
			keyframe = frame;
			type = ANIM_NORMAL;
		}

		public function loop(start:int, end:int):void
		{
			this.start = (start % frames.length);
			keyframe = start;
			this.end = (end % frames.length);
			type = ANIM_LOOP;
		}

		public function stop():void
		{
			type = ANIM_STOP;
		}

		public function gotoAndStop(frame:int):void
		{
			keyframe = frame;
			type = ANIM_STOP;
		}

		public function update():void
		{
			ctime = getTimer();
			
			var dst:Vertex;
			var a:Vertex;
			var b:Vertex;
			var vertices:Array = vertexList;
			var cframe:Frame;
			var nframe:Frame;
			var i:int;
			
			cframe = frames[_currentFrame];
			nframe = frames[(_currentFrame + 1) % frames.length];
			
			for (i = 0;i < vertices.length; i++)
			{
				dst = vertices[i];
				a = cframe.vertices[i];
				b = nframe.vertices[i];

				dst.x = a.x + interp * (b.x - a.x);
				dst.y = a.y + interp * (b.y - a.y);
				dst.z = a.z + interp * (b.z - a.z); 
			}

			// Update the timer part, to get time based animation

			if (type != ANIM_STOP)
			{
				interp += fps * (ctime - otime) / 1000;
				if (interp >= 1)
				{
					if (type == ANIM_LOOP && _currentFrame + 1 == end)
						keyframe = start;
					else
						keyframe++;
					interp = 0;
				}
			}
			otime = ctime;
		}

		public function get keyframe():int 
		{ 
			return _currentFrame; 
		}

		public function set keyframe(i:int):void 
		{ 
			_currentFrame = i % frames.length; 
		}
	}
}