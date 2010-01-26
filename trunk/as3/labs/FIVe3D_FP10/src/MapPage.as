package
{
	import com.sleepydesign.events.MouseUIEvent;
	import com.sleepydesign.ui.MouseUI;
	import com.zavoo.svg.SvgPath;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	import net.badimon.five3D.display.Bitmap3D;
	import net.badimon.five3D.display.Sprite3D;
	import net.badimon.five3D.templates.Five3DTemplate;

	[SWF(width="1132", height="654", frameRate="30", backgroundColor="#000000")]
	public class MapPage extends Five3DTemplate
	{
		private var _canvas3D:Sprite3D;
		private var _mapCanvas3D:Sprite3D;

		private var _mapBitmapData:BitmapData;
		private var _mapBitmap3D:Bitmap3D;

		private var _trafficBitmap3D:Bitmap3D;
		
		public var _candleCanvas3D:Sprite3D;
		public var _ballonCanvas3D:Sprite3D;

		override protected function onInit():void
		{
			debug = false;
			mouseEnabled = false;

			// setup canvas
			_trafficCanvas = new Sprite();

			_canvas3D = new Sprite3D();
			_scene.addChild(_canvas3D);
			_canvas3D.singleSided = true;
			_canvas3D.mouseEnabled = false;
			
			_candleCanvas3D = new Sprite3D();
			_candleCanvas3D.singleSided = true;
			_candleCanvas3D.mouseEnabled = false;
			
			_ballonCanvas3D = new Sprite3D();
			_ballonCanvas3D.singleSided = true;
			_ballonCanvas3D.mouseEnabled = false;

			_mapCanvas3D = new Sprite3D();
			_mapCanvas3D.singleSided = true;
			_mapCanvas3D.mouseEnabled = false;

			_canvas3D.addChild(_mapCanvas3D);
			
			_canvas3D.addChild(_candleCanvas3D);
			_canvas3D.addChild(_ballonCanvas3D);
			
			_canvas3D.x = 0;
			_canvas3D.y = 0;
			_canvas3D.z = -600; //830;
			_canvas3D.rotationX = -60;

			if (!_mouseUI)
			{
				_mouseUI = new MouseUI(stage);
				_mouseUI.addEventListener(MouseUIEvent.MOUSE_DRAG, onDrag);
				_mouseUI.addEventListener(MouseEvent.MOUSE_WHEEL, onWheel);
			}
		}

		private function onWheel(event:MouseEvent):void
		{
			if (!visible)
				return;

			var _x:Number = _canvas3D.x;
			var _y:Number = _canvas3D.y;
			var _z:Number = _canvas3D.z;

			_z = _z + 5 * event.delta * Math.cos(60);
			if (_z < -700)
			{
				_z = _canvas3D.z;
			}

			_canvas3D.setPosition(_x, _y, _z);
		}

		private function onDrag(event:MouseUIEvent):void
		{
			_mapCanvas3D.rotationZ -= event.data.dx / 4;
			_ballonCanvas3D.rotationZ=_candleCanvas3D.rotationZ=_mapCanvas3D.rotationZ;
		}

		private var _mouseUI:MouseUI;
		private var _point0:Point = new Point();

		private var pathTagRE:RegExp = /(<path.*?\/>)/sig;
		private var pathArray:Array;
		private var svgData:String;
		private var _currentMapID:String;

		// layer
		private var canvas:Sprite;
		private var _time:Number;

		// bmp
		private var _roadBitmap:Bitmap;
		private var _roadBitmapData:BitmapData;

		private var _trafficBitmap:Bitmap;
		private var _trafficBitmapData:BitmapData;

		private var _trafficCanvas:Sprite;

		// color
		private var color:Number = 0xCCCCAA00;

		public function setupMap3D():void
		{
			if (_mapBitmap3D)
				_mapCanvas3D.removeChild(_mapBitmap3D);

			_mapBitmap3D = new Bitmap3D(_roadBitmapData, true);
			_mapBitmap3D.x = -_roadBitmapData.width / 2;
			_mapBitmap3D.y = -_roadBitmapData.height / 2;
			_mapBitmap3D.singleSided = true;
			_mapCanvas3D.addChild(_mapBitmap3D);

			if (_trafficBitmap3D)
				_mapCanvas3D.removeChild(_trafficBitmap3D);

			_trafficBitmap3D = new Bitmap3D(_trafficBitmapData, true);
			_trafficBitmap3D.x = -_trafficBitmapData.width / 2;
			_trafficBitmap3D.y = -_trafficBitmapData.height / 2;
			_trafficBitmap3D.z = -3;
			_trafficBitmap3D.singleSided = true;
			_mapCanvas3D.addChild(_trafficBitmap3D);
		}

		override protected function onPreRender():void
		{
			//Map.currentMapID="_m";

			if (Map.currentMapID && _currentMapID != Map.currentMapID)
			{
				_currentMapID = Map.currentMapID;

				var _rect:Rectangle = MapData[Map.currentMapID + "_rect"];
				_roadBitmapData = new BitmapData(_rect.width, _rect.height, true, 0x00000000);
				_trafficBitmapData = new BitmapData(_roadBitmapData.width, _roadBitmapData.height, true, 0x00000000);

				setupMap3D();

				// setup data
				var _data:ByteArray = MapData[Map.currentMapID];
				_data.position = 0;
				svgData = _data.readUTFBytes(_data.length);

				// storage
				_vertices = new Vector.<Vertex2D>();
				pathIndexs = [0];
				currentIndexs = [0];
				pixelIndex = 0;
				pathIndex = 0;

				// process
				removeEventListener(Event.ENTER_FRAME, processData);
				removeEventListener(Event.ENTER_FRAME, drawPath);

				addEventListener(Event.ENTER_FRAME, processData);
				addEventListener(Event.ENTER_FRAME, drawPath);
			}

			if (!MouseUI.isMouseDown)
			{
				_mapCanvas3D.rotationZ += 0.25;
				_ballonCanvas3D.rotationZ=_candleCanvas3D.rotationZ=_mapCanvas3D.rotationZ;
			}
		}

		private function processData(e:Event):void
		{
			if (!isRun)
				return;

			pathArray = pathTagRE.exec(svgData);
			if (pathArray)
			{
				var _path:SvgPath = new SvgPath(pathArray[1]);
				setPixelSVG(_path, _roadBitmapData);

				// cue point
				pathIndexs.push(_vertices.length);
				currentIndexs.push(_vertices.length);
			}
			else
			{
				if (_vertices.length > 0)
				{
					removeEventListener(Event.ENTER_FRAME, processData);
					_vertices.fixed = true;
				}
			}
		}

		private var isRun:Boolean = true;

		override public function start():void
		{
			trace("start");
			super.start();
			isRun = true;
		}

		override public function stop():void
		{
			trace("stop");
			super.stop();
			isRun = false;
		}

		private function drawPath(e:Event):void
		{
			if (!isRun)
				return;
			if (_vertices.length <= 0)
				return;

			var _size:int = 20 * Math.random() + 20;

			if (pathIndex < _vertices.length)
			{
				setPixel(_size);
				pathIndex += _size;
				pixelIndex += _size;
			}

			var _vertex2D:Vertex2D;
			var _length:int;

			_trafficCanvas.graphics.clear();

			// loop in group
			_trafficCanvas.graphics.lineStyle(1, 0xFFFFFF);
			var _pathIndexs_length:int = pathIndexs.length - 1;
			var _index:int;

			for (var k:int = 0; k < _pathIndexs_length; k++)
			{
				var _beg:int = pathIndexs[k] + currentIndexs[k];

				_size = ((pathIndexs[k + 1] - pathIndexs[k]) / 20) * Math.random() + 10;
				_size = (_size > 40) ? 40 : _size;

				//draw _size pixel
				_length = _beg + _size;

				//ob max
				if (_length > pathIndexs[k + 1])
					_length = pathIndexs[k + 1];

				var _step:int = 0;
				_index = _beg + _step;
				if (_index < _length)
				{
					_vertex2D = _vertices[_index];
					_trafficCanvas.graphics.moveTo(_vertex2D.x, _vertex2D.y);
					do
					{
						_index = _beg + _step;

						if (_index < _length)
						{
							_vertex2D = _vertices[_index];
							_trafficCanvas.graphics.lineTo(_vertex2D.x, _vertex2D.y);
						}
					} while (_step++ < _length);
				}

				// cue next
				currentIndexs[k] += _size;

				// to start
				if (currentIndexs[k] >= pathIndexs[k + 1])
					currentIndexs[k] = 0;
			}
			_trafficCanvas.graphics.endFill();

			_trafficBitmapData.fillRect(_trafficBitmapData.rect, 0x00000000);
			_trafficBitmapData.draw(_trafficCanvas);
		}

		private function setPixel(step:int):void
		{
			_roadBitmapData.lock();
			var _vertex2D:Vertex2D;
			var _length:int = _vertices.length;
			do
			{
				if (pixelIndex + step < _length)
				{
					_vertex2D = _vertices[pixelIndex + step];
					_roadBitmapData.setPixel32(_vertex2D.x, _vertex2D.y, color);
				}
			} while (step-- > 0);

			_roadBitmapData.unlock();
		}

		private var _matrix2:Matrix = new Matrix(2, 0, 0, 2, 0, 0);

		private var pixelIndex:int = 0;
		private var pathIndex:int = 0;

		private var j:int = 0;

		private var pathIndexs:Array = [0];
		private var currentIndexs:Array = [0];

		private var _vertices:Vector.<Vertex2D>;

		private function setPixelSVG(path:SvgPath, bitmapData:BitmapData, scale:Number = 1, offsetX:Number = 0, offsetY:Number = 0):void
		{
			//bitmapData.lock();
			var _path_d:Array = path.d;
			for each (var line:Array in _path_d)
			{
				var _line_1:Array = line[1];
				if (_line_1[1] > 0)
					_vertices.push(new Vertex2D(int(_line_1[0]) * scale + offsetX, int(_line_1[1]) * scale + offsetY));
			}
		}
	}
}