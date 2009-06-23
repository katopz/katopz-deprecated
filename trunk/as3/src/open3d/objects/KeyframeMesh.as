package open3d.objects
{
	import __AS3__.vec.Vector;
	
	import flash.geom.Vector3D;
	import flash.utils.getTimer;
	
	import open3d.animation.Frame;
	import open3d.geom.FaceData;
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
		public function KeyframeMesh(material:Material, fps:int = 24)
		{
			super();
			this.material = material;
			this.fps = fps;
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

		public var faceDatas:Vector.<FaceData>;
		public function updateFrame():void
		{
			if(!faceDatas)return;
			
			ctime = getTimer();

			var dst:Vector3D;
			
			var a0:Vector3D;
			var b0:Vector3D;
			var c0:Vector3D;
			
			var a1:Vector3D;
			var b1:Vector3D;
			var c1:Vector3D;
			
			var cframe:Frame;
			var nframe:Frame;
			var i:int;

			cframe = frames[_currentFrame];
			nframe = frames[(_currentFrame + 1) % framesLength];
			var _vinLength:uint = _vin.length;
			
			// TODO : optimize
			var _cframe_vertices:Vector.<Vector3D> = cframe.vertices;
			var _nframe_vertices:Vector.<Vector3D> = nframe.vertices;
			
			for each (var face:FaceData in faceDatas)
			{
				a0 = _cframe_vertices[face.a];
				b0 = _cframe_vertices[face.b];
				c0 = _cframe_vertices[face.c];
				
				a1 = _nframe_vertices[face.a];
				b1 = _nframe_vertices[face.b];
				c1 = _nframe_vertices[face.c];
								
				_vin[i++] = a0.x + interp * (a1.x - a0.x);
				_vin[i++] = a0.y + interp * (a1.y - a0.y);
				_vin[i++] = a0.z + interp * (a1.z - a0.z);
				
				_vin[i++] = b0.x + interp * (b1.x - b0.x);
				_vin[i++] = b0.y + interp * (b1.y - b0.y);
				_vin[i++] = b0.z + interp * (b1.z - b0.z);
				
				_vin[i++] = c0.x + interp * (c1.x - c0.x);
				_vin[i++] = c0.y + interp * (c1.y - c0.y);
				_vin[i++] = c0.z + interp * (c1.z - c0.z);
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