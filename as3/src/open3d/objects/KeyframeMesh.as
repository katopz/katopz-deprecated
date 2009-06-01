package open3d.objects
{
	import flash.geom.Vector3D;
	import flash.utils.getTimer;

	import open3d.animation.Frame;
	import open3d.materials.Material;

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
	 *
	 * Modify/Optimize
	 * @author katopz
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
		protected var frames:Array = [];
		private var framesLength:int = 0;

		/**
		 * Keep track of the current frame number and animation
		 */
		private var _currentFrame:int = 0;
		private var interp:Number = 0;
		private var start:int, end:int, _type:int;
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

		public function addFrame(frame:Frame):void
		{
			frames.push(frame);
			framesLength++;
		}

		public function gotoAndPlay(frame:int):void
		{
			keyframe = frame;
			_type = ANIM_NORMAL;
		}

		public function loop(start:int, end:int):void
		{
			this.start = (start % framesLength);
			keyframe = start;
			this.end = (end % framesLength);
			_type = ANIM_LOOP;
		}

		public function stop():void
		{
			_type = ANIM_STOP;
		}

		public function gotoAndStop(frame:int):void
		{
			keyframe = frame;
			_type = ANIM_STOP;
		}

		public function updateFrame():void
		{
			ctime = getTimer();

			var dst:Vector3D;
			var a:Vector3D;
			var b:Vector3D;
			var vertices:Vector.<Number> = _triangles.vertices;
			var cframe:Frame;
			var nframe:Frame;
			var i:int;

			cframe = frames[_currentFrame];
			nframe = frames[(_currentFrame + 1) % framesLength];
			var verticesLength:uint = vertices.length;
			for (i = 0; i < verticesLength; i += 3)
			{
				dst = new Vector3D(vertices[i], vertices[i + 1], vertices[i + 2]);
				a = cframe.vertices[i];
				b = nframe.vertices[i];

				dst.x = a.x + interp * (b.x - a.x);
				dst.y = a.y + interp * (b.y - a.y);
				dst.z = a.z + interp * (b.z - a.z);
			}

			// Update the timer part, to get time based animation

			if (_type != ANIM_STOP)
			{
				interp += fps * (ctime - otime) / 1000;
				if (interp >= 1)
				{
					if (_type == ANIM_LOOP && _currentFrame + 1 == end)
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
			_currentFrame = i % framesLength;
		}
	}
}