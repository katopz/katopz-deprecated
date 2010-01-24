package
{
	import com.sleepydesign.events.MouseUIEvent;
	import com.sleepydesign.ui.MouseUI;
	import com.zavoo.svg.SvgPath;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.ByteArray;
	
	import net.badimon.five3D.display.Bitmap3D;
	import net.badimon.five3D.display.Sprite3D;
	import net.badimon.five3D.templates.Five3DTemplate;
	[SWF(width="1132", height="654", frameRate="30", backgroundColor="#000000")]
	public class MapPage extends Five3DTemplate
	{
		/*
		// assets
		[Embed(source="assets/ThaiMap.swf",symbol="ThaiMap")]
		private static var ThaiMapSWF:Class;
		private static var _mapSprite:Sprite = new ThaiMapSWF() as Sprite;
		*/
		
		private var _canvas3D:Sprite3D;
		private var _mapCanvas3D:Sprite3D;
		
		private var _mapBitmapData:BitmapData;
		private var _mapBitmap3D:Bitmap3D;
		
		//private var _trafficBitmapData:BitmapData;
		private var _trafficBitmap3D:Bitmap3D;
		
		override protected function onInit():void
		{
			setupMap3D();
			
			_canvas3D = new Sprite3D();
			_scene.addChild(_canvas3D);
			_canvas3D.singleSided = true;
			_canvas3D.mouseEnabled = false;
			
			_canvas3D.x = 0;
			_canvas3D.y = 0;
			_canvas3D.z = -400;//830;
			_canvas3D.rotationX = -60;
			
			_mapCanvas3D = new Sprite3D();
			_mapCanvas3D.singleSided = true;
			_mapCanvas3D.mouseEnabled = false;
			
			_mapBitmapData = new BitmapData(300, 370, true, 0x00000000);
			
			_mapBitmap3D = new Bitmap3D(_roadBitmapData, true);
			_mapBitmap3D.x = -_mapBitmapData.width/2;
			_mapBitmap3D.y = -_mapBitmapData.height/2;
			_mapBitmap3D.singleSided = true;
			_mapCanvas3D.addChild(_mapBitmap3D);
			
			_trafficBitmapData = new BitmapData(300, 370, true, 0x00000000);
			
			_trafficBitmap3D = new Bitmap3D(_trafficBitmapData, true);
			_trafficBitmap3D.x = -_trafficBitmapData.width/2;
			_trafficBitmap3D.y = -_trafficBitmapData.height/2;
			_trafficBitmap3D.z = -10;
			_trafficBitmap3D.singleSided = true;
			_mapCanvas3D.addChild(_trafficBitmap3D);
			
			_canvas3D.addChild(_mapCanvas3D);
			
			var _ccMouse:MouseUI = new MouseUI(stage);
			_ccMouse.addEventListener(MouseUIEvent.MOUSE_DRAG, onDrag);
		}
		
		private function onDrag(event:MouseUIEvent):void
		{
			_mapCanvas3D.rotationZ -= event.data.dx;
		}
		
		private var _point0:Point = new Point();
		override protected function onPreRender():void
		{
			if(!MouseUI.isMouseDown)
				_mapCanvas3D.rotationZ+=0.25;
		}
		
		// data
		[Embed(source="assets/n.txt", mimeType="application/octet-stream")]
		private var ThaiSVG:Class;
		private var pathTagRE:RegExp = /(<path.*?\/>)/sig;
		private var pathArray:Array;
		private var svgData:String;
		private var paths:Array = [];
		
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
		//private var color:Number = 0xCCFFCC00;
		private var color:Number = 0xFF333333;
		
		public function setupMap3D():void
		{
			// setup canvas
			_roadBitmapData = new BitmapData(300,370, true,0x00000000);
			//_roadBitmap = new Bitmap(_roadBitmapData);
			//addChild(_roadBitmap);
			
			_trafficBitmapData = new BitmapData(300,370, true,0x00000000);
			//_trafficBitmap = new Bitmap(_trafficBitmapData);
			//addChild(_trafficBitmap);
			
			_trafficCanvas = new Sprite();
			//addChild(_trafficCanvas);
			
			// setup data
			var _data:ByteArray = new ThaiSVG() as ByteArray;
			svgData = _data.readUTFBytes(_data.length); 
			
			// process
			_vertices = new Vector.<Vertex2D>();
			addEventListener(Event.ENTER_FRAME, processData);
			//addEventListener(Event.ENTER_FRAME, drawData);
			addEventListener(Event.ENTER_FRAME, drawPath);
			//addChild(new Stats());
		}
		
		private function processData(e:Event):void
		{
			pathArray = pathTagRE.exec(svgData);
			if (pathArray)// && pathIndexs.length<10)
			{
				var _path:SvgPath = new SvgPath(pathArray[1]);
				setPixelSVG(_path, _roadBitmapData);
				paths.push(_path);
				// cue point
				pathIndexs.push(_vertices.length);
				currentIndexs.push(_vertices.length);
			}
			else
			{
				removeEventListener(Event.ENTER_FRAME, processData);
				//removeEventListener(Event.ENTER_FRAME, drawData);
				_vertices.fixed = true;
			}
		}
		
		private function drawData(e:Event):void
		{
			if(i<_vertices.length)
			{
				setPixel(10);
				i+=10;
			}else{
				removeEventListener(Event.ENTER_FRAME, drawData);
			}
		}
		
		private function drawPath(e:Event):void
		{
			var _size:int = 20*Math.random()+20;
			
			if(i<_vertices.length)
			{
				setPixel(_size);
				i+=_size;
			}
			
			var _vertex2D:Vertex2D;
			var _length:int;
			
			_trafficCanvas.graphics.clear();
			
			// loop in group
			_trafficCanvas.graphics.lineStyle(1, 0xFFFFFF);
			var _pathIndexs_length:int = pathIndexs.length-1;
			var _index:int;
			//var _seekIndex:int = (_pathIndexs_length-1>0)?0:_pathIndexs_length-1;
			
			for (var k:int=0; k < _pathIndexs_length; k++)
			{
				var _beg:int = pathIndexs[k]+currentIndexs[k];
				
				_size = (pathIndexs[k]/100)*Math.random()+10;
				_size = (_size>20)?20:_size;
				
				//draw _size pixel
				_length = _beg+_size;
				
				//ob max
				if(_length>pathIndexs[k+1])
					_length=pathIndexs[k+1];
					
				var _step:int = 0;
				_index = _beg+_step;
				if(_index<_length)
				{
					_vertex2D = _vertices[_index];
					_trafficCanvas.graphics.moveTo(_vertex2D.x, _vertex2D.y);
					do
					{
						_index = _beg+_step;
						if(_index<_length)
						{
							_vertex2D = _vertices[_index];
							_trafficCanvas.graphics.lineTo(_vertex2D.x, _vertex2D.y);
						}
					}while(_step++<_length);
				}
				
				// cue next
				currentIndexs[k]+=_size;
				
				// to start
				if(currentIndexs[k]>=pathIndexs[k+1])
					currentIndexs[k]=0;
			}
			_trafficCanvas.graphics.endFill();
			
			_trafficBitmapData.fillRect(_trafficBitmapData.rect,0x00000000);
			_trafficBitmapData.draw(_trafficCanvas);
		}
		
		private function setPixel(step:int):void
		{
			_roadBitmapData.lock();
			var _vertex2D:Vertex2D;
			var _length:int = _vertices.length;
			do{
				if(i+step<_length)
				{
					_vertex2D =_vertices[i+step];
					_roadBitmapData.setPixel32(_vertex2D.x, _vertex2D.y, color);
				}
			}while(step-->0);
			
			_roadBitmapData.unlock();
		}
		
		private var i:int = 0;
		private var j:int = 0;
		
		private var pathIndexs:Array = [0];
		private var currentIndexs:Array = [0];
		
		private var _vertices:Vector.<Vertex2D>;
		
		private function setPixelSVG(path:SvgPath, bitmapData:BitmapData, scale :Number = 1, offsetX:Number = 0, offsetY:Number = 0) : void 
		{
			//bitmapData.lock();
			var _path_d:Array = path.d;
			for each(var line:Array in _path_d)
			{
				var _line_1:Array = line[1];
				if(_line_1[1]>0)
					_vertices.push(new Vertex2D(int(_line_1[0]) * scale + offsetX, int(_line_1[1]) * scale + offsetY));
			}
		}
	}
}