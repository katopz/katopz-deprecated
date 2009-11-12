package flars
{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Point;
	import flash.media.Camera;
	import flash.media.Video;
	import flash.utils.*;
	
	import org.libspark.flartoolkit.core.FLARCode;
	import org.libspark.flartoolkit.core.param.FLARParam;
	import org.libspark.flartoolkit.core.raster.rgb.FLARRgbRaster_BitmapData;
	import org.libspark.flartoolkit.core.transmat.FLARTransMatResult;
	import org.libspark.flartoolkit.detector.FLARMultiMarkerDetector;
	import org.libspark.flartoolkit.support.sandy.FLARBaseNode;
	import org.libspark.flartoolkit.support.sandy.FLARCamera3D;
	
	import sandy.core.Scene3D;
	import sandy.core.data.Point3D;
	import sandy.core.data.Polygon;
	import sandy.core.scenegraph.Group;
	import sandy.materials.attributes.LineAttributes;
	import sandy.primitive.Plane3D;
	
	public class FLARManager
	{
		public var ready:Boolean = false;
		
		// sandy
		private var sandyScene:Scene3D;
		private var stuff:Vector.<FLARBaseNode>;
		
		public function getStuff():Vector.<Number>
		{
			return Vector.<Number>([
				stuff[0].x, stuff[0].y, stuff[0].z,
				stuff[1].x, stuff[1].y, stuff[1].z,
				stuff[2].x, stuff[2].y, stuff[2].z])
		}
		
		private var size:int = 100;
		
		private var aggregate:FLARTransMatResult;
		private var param:FLARParam;
		private var code:FLARCode;
		private var raster:FLARRgbRaster_BitmapData;
		private var detector:FLARMultiMarkerDetector;
		
		private var _stuff:FLARBaseNode;
		private var _FLARCamera3D:FLARCamera3D;
		
		public var _bitmapData:BitmapData;
	
		// FLAR
		[Embed(source='camera.dat',mimeType='application/octet-stream')]
		private var CameraData:Class;

		[Embed(source='qr.pat',mimeType='application/octet-stream')]
		private var MarkerData:Class;
		
		// FLAR
		private var A:FLARResult;
		private var B:FLARResult;
		private var C:FLARResult;
		
		private var _container:DisplayObjectContainer;
		
		private var _webcam:Camera;
		private var _video:Video;
		public function get video():Video
		{
			return _video;
		}
		
		private var _cameraBitmap:Bitmap;
		public function get cameraBitmap():Bitmap
		{
			return _cameraBitmap;
		}
		
		private var _width:int = 320;
		private var _height:int = 240;
		
		public function FLARManager(container:DisplayObjectContainer, bitmapData:BitmapData)
		{
			_container = container;
			_bitmapData = bitmapData;
			
			_width = _bitmapData.width;
			_height = _bitmapData.height;
			
			param = new FLARParam;
			param.loadARParam(new CameraData);
			param.changeScreenSize(_width, _height);
			code = new FLARCode(16, 16, 70, 70);
			code.loadARPatt(new MarkerData);
			raster = new FLARRgbRaster_BitmapData(_bitmapData);
			detector = new FLARMultiMarkerDetector(param, [code], [size], 1);
			detector.setContinueMode(false);

			// set up sandy
			_FLARCamera3D = new FLARCamera3D(param, 0.001);
			sandyScene = new Scene3D("scene", Sprite(container.addChild(new Sprite)), _FLARCamera3D, new Group("root"));
			sandyScene.container.visible = false;

			stuff = new Vector.<FLARBaseNode>;
			for (var i:int = 0; i < 4; i++)
			{
				stuff[i] = new FLARBaseNode;
				var p:Plane3D = new Plane3D("plane" + i);
				LineAttributes(p.appearance.frontMaterial.attributes.attributes[0]).color = (i < 3) ? 0xFF00 : 0xFFFF00;
				p.rotateX = 180;
				stuff[i].addChild(p);
				sandyScene.root.addChild(stuff[i]);
			}

			_stuff = stuff[3];
			
			ready = true;
		}
		
		public function drawVideo():void
		{
			if(_cameraBitmap && _video)
				_cameraBitmap.bitmapData.draw(_video);
		}
		
		public function setCamera(w:Number, h:Number, fps:int):Camera
		{
			if(!_webcam)
				_webcam = Camera.getCamera();

			if(_webcam)
			{
				_webcam.setMode(w, h, fps);
				_video = new Video(w, h);
				_video.attachCamera(_webcam);
			}
			
			_cameraBitmap = new Bitmap(new BitmapData(w, h, false, 0), PixelSnapping.AUTO, true);
			
			return _webcam;
		};
		
		private var n:Number;
		
		public function getDetectNumber(target:DisplayObject):Number
		{
			// get image into _bitmapData
			_bitmapData.fillRect(_bitmapData.rect, 0);

			_container.stage.quality = "high";
			_bitmapData.draw(target);
			_container.stage.quality = "low";
			
			n = detector.detectMarkerLite(raster, 128);
			return n;
		}
		
		public function getAxis():*
		{
			var _A_result:FLARTransMatResult;
			var _B_result:FLARTransMatResult;
			var _C_result:FLARTransMatResult;
			
			// we want 3 best matches
			var k:int, results:Array = [];
			for (k = 0; k < n; k++)
			{
				var r:FLARResult = new FLARResult();
				r.confidence = detector.getConfidence(k);
				detector.getTransmationMatrix(k, r.result);
				r.square = detector.getResult(k).square;
				results.push(r);
			}

			results.sortOn("confidence", Array.DESCENDING | Array.NUMERIC);
			results.splice(3, n - 3);

			// sort them into right triangle
			for (k = 0; k < 3; k++)
			{
				A = FLARResult(results[(2 + k) % 3]);
				B = FLARResult(results[(3 + k) % 3]);
				C = FLARResult(results[(4 + k) % 3]);
				
				_A_result = A.result;
				_B_result = B.result;
				_C_result = C.result;
				
				// I will use sandy math but not coordinates here (feel free to inline)
				var BA:Point3D = new Point3D((_B_result.m03 - _A_result.m03), (_B_result.m13 - _A_result.m13), (_B_result.m23 - _A_result.m23));
				var BC:Point3D = new Point3D((_B_result.m03 - _C_result.m03), (_B_result.m13 - _C_result.m13), (_B_result.m23 - _C_result.m23));
				// average distance is only meaningful for 1 vertex (you can compute it later)
				B.distance = 0.5 * (BA.getNorm() + BC.getNorm());
				BA.normalize();
				BC.normalize();
				B.cosine = Math.abs(BA.dot(BC));
			}

			results.sortOn("cosine", Array.NUMERIC);

			// display intermediate results
			for (k = 0; k < 3; k++)
				stuff[k].setTransformMatrix(FLARResult(results[k]).result);

			// aggregate 3D results (this assumes all markers are oriented same way)
			A = FLARResult(results[2]);
			B = FLARResult(results[0]);
			C = FLARResult(results[1]);
			
			_A_result = A.result;
			_B_result = B.result;
			_C_result = C.result;

			var scale3:Number = (1 + B.distance / size) / 3;
			aggregate = new FLARTransMatResult();
			
			aggregate.m03 = (_A_result.m03 + _C_result.m03) * 0.5;
			aggregate.m13 = (_A_result.m13 + _C_result.m13) * 0.5;
			aggregate.m23 = (_A_result.m23 + _C_result.m23) * 0.5;
			aggregate.m00 = (_A_result.m00 + _B_result.m00 + _C_result.m00) * scale3;
			aggregate.m10 = (_A_result.m10 + _B_result.m10 + _C_result.m10) * scale3;
			aggregate.m20 = (_A_result.m20 + _B_result.m20 + _C_result.m20) * scale3;
			aggregate.m01 = (_A_result.m01 + _B_result.m01 + _C_result.m01) * scale3;
			aggregate.m11 = (_A_result.m11 + _B_result.m11 + _C_result.m11) * scale3;
			aggregate.m21 = (_A_result.m21 + _B_result.m21 + _C_result.m21) * scale3;
			aggregate.m02 = (_A_result.m02 + _B_result.m02 + _C_result.m02) * scale3;
			aggregate.m12 = (_A_result.m12 + _B_result.m12 + _C_result.m12) * scale3;
			aggregate.m22 = (_A_result.m22 + _B_result.m22 + _C_result.m22) * scale3;
			
			return results[0];
		}
		
		public function getPoint():Object
		{
			// debug plane 
			stuff[3].setTransformMatrix(aggregate);
			
			// homography (I shall use 3D engine math - you can mess with FLARParam if you want to)
			var plane3D:Plane3D = Plane3D(stuff[3].children[0]);

			// since 3D fit is not perfect, we shall grab some extra area
			plane3D.scaleX = plane3D.scaleY = plane3D.scaleZ = 1.06 + 0.1*Math.random();

			// I call render() to init sandy matrices - you can do matrix math by hand and
			// not render a thing, or use better engine :-p~
			sandyScene.render();

			var face1:Polygon = Polygon(plane3D.aPolygons[0]);
			sandyScene.camera.projectArray(face1.vertices);
			
			var face2:Polygon = Polygon(plane3D.aPolygons[1]);
			sandyScene.camera.projectArray(face2.vertices);

			// shaking abit 
			var _randomNum:Number
			_randomNum = 4*Math.random() - 4*Math.random();
			var p0:Point = new Point(face1.b.sx + _randomNum, face1.b.sy + _randomNum);
			_randomNum = 4*Math.random() - 4*Math.random();
			var p1:Point = new Point(face1.a.sx + _randomNum, face1.a.sy + _randomNum);
			_randomNum = 4*Math.random() - 4*Math.random();
			var p2:Point = new Point(face1.c.sx + _randomNum, face1.c.sy + _randomNum);
			_randomNum = 4*Math.random() - 4*Math.random();
			var p3:Point = new Point(face2.b.sx + _randomNum, face2.b.sy + _randomNum);

			plane3D.scaleX = plane3D.scaleY = plane3D.scaleZ = 1.0;
			
			return {p0:p0, p1:p1, p2:p2, p3:p3}
		}
		
		public function get fieldOfView():Number
		{
			return _FLARCamera3D.fov;
		}
		
		public function get focalLength():Number
		{
			return _FLARCamera3D.focalLength;
		}
	}
}