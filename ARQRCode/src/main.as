package
{
	import away3dlite.materials.ColorMaterial;
	import away3dlite.materials.WireColorMaterial;
	import away3dlite.primitives.Plane;
	import away3dlite.primitives.Sphere;
	import away3dlite.templates.BasicTemplate;
	
	import com.logosware.event.QRdecoderEvent;
	import com.logosware.event.QRreaderEvent;
	import com.logosware.utils.QRcode.GetQRimage;
	import com.logosware.utils.QRcode.QRdecode;
	import com.sleepydesign.utils.FileUtil;
	import com.sleepydesign.utils.SystemUtil;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.filters.DropShadowFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.net.FileReference;
	import flash.text.TextField;
	
	import org.libspark.flartoolkit.core.FLARCode;
	import org.libspark.flartoolkit.core.FLARSquare;
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

	/**
	 * QRCodeReader + FLARToolKit PoC (libspark rev. 3199, sandy rev. 1138)
	 * @license GPLv2
	 * @author makc
	 * @see http://www.openqrcode.com/
	 * 
	 */
	[SWF(backgroundColor="0x333333", frameRate="30", width="800", height="240")]
	public class main extends BasicTemplate
	{
		private var paper:Sprite;
		private var tool:Sprite;
		
		private var _bitmap:Bitmap;
		
		public function main()
		{
			// sys
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			// layer
			paper = new Sprite();
			addChild(paper);
			tool = new Sprite();
			addChild(tool);
			
			// init
			init();
			
			// add test image in the background
			setBitmap(Bitmap(new ImageData));
			
			// browse
			SystemUtil.addContext(this, "Open Image", function ():void{FileUtil.openImage(onImageReady)});
		}
		
		private function init():void
		{
			// set up FLARToolKit
			canvas = new BitmapData(320, 240, false, 0);
			size = 100;
			param = new FLARParam;
			param.loadARParam(new CameraData);
			param.changeScreenSize(320, 240);
			code = new FLARCode(16, 16, 70, 70);
			code.loadARPatt(new MarkerData);
			raster = new FLARRgbRaster_BitmapData(canvas);
			detector = new FLARMultiMarkerDetector(param, [code], [size], 1);
			detector.setContinueMode(false);

			// set up sandy
			sandyScene = new Scene3D("scene", Sprite(addChild(new Sprite)), new FLARCamera3D(param, 0.001), new Group("root"));
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

			// set up QRCodeReader
			homography = new BitmapData(240, 240, false, 0);
			var hbmp:Bitmap = new Bitmap(homography);
			hbmp.x = 320;
			addChild(hbmp);
			qrImage = new GetQRimage(hbmp);
			qrImage.addEventListener(QRreaderEvent.QR_IMAGE_READ_COMPLETE, onQRCodeRead);
			qrDecoder = new QRdecode();
			qrDecoder.addEventListener(QRdecoderEvent.QR_DECODE_COMPLETE, onQRDecoded);

			qrInfo = new TextField();
			qrInfo.filters = [new DropShadowFilter(0, 0, 0, 1, 3, 3, 10)];
			qrInfo.x = 320;
			qrInfo.textColor = 0xFF00;
			qrInfo.autoSize = "left";
			addChild(qrInfo);

			qrResult = homography.clone();
			var rbmp:Bitmap = new Bitmap(qrResult);
			rbmp.x = 560;
			addChild(rbmp);

			//addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			//addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			
			addEventListener(Event.ENTER_FRAME, onRun);
		}
		
		private function onMouseDown(e:MouseEvent):void
		{
			addEventListener(Event.ENTER_FRAME, onRun);
		}
		
		private function onMouseUp(e:MouseEvent):void
		{
			removeEventListener(Event.ENTER_FRAME, onRun);
		}
		
		private function onRun(event:Event):void
		{
			//paper.rotationX = mouseX;
			sandyScene.render();
		}
		
		private function onImageReady(event:Event):void
		{
			if(_bitmap)
				paper.removeChild(_bitmap);
			
			setBitmap(event.target.content);
		}
		
		private function setBitmap(bitmap:Bitmap):void
		{
			if(_bitmap)
				paper.removeChild(_bitmap);
			
			_bitmap = bitmap;
			
			//3.2cm = 90px
			_bitmap.width = 90;
			_bitmap.height = 90;
			
			paper.x = 320/2-90/2;
			paper.y = 240/2-90/2;
			
			paper.addChild(_bitmap);
			
			paper.graphics.clear();
			paper.graphics.lineStyle();
			
			tool.graphics.clear();
			tool.graphics.lineStyle();
			
			// fake effect
			paper.filters = [new BlurFilter(3,3,1)];
			//paper.rotationX = 10;
			//paper.rotationZ = 15;
			
			// show time
			process();
		}

		private function process():void
		{
			// get image into canvas
			sandyScene.container.visible = false;
			canvas.fillRect(canvas.rect, 0);
			canvas.draw(this);
			sandyScene.container.visible = true;

			// flarkit pass
			var n:int = detector.detectMarkerLite(raster, 128)
			if (n > 2)
			{
				// we want 3 best matches
				var k:int, results:Array = [];
				for (k = 0; k < n; k++)
				{
					var r:FLARResult = new FLARResult;
					r.confidence = detector.getConfidence(k);
					detector.getTransmationMatrix(k, r.result);
					r.square = detector.getResult(k).square;
					results.push(r);
				}

				results.sortOn("confidence", Array.DESCENDING | Array.NUMERIC);
				results.splice(3, n - 3);

				// sort them into right triangle
				var A:FLARResult, B:FLARResult, C:FLARResult;
				for (k = 0; k < 3; k++)
				{
					A = FLARResult(results[(2 + k) % 3]);
					B = FLARResult(results[(3 + k) % 3]);
					C = FLARResult(results[(4 + k) % 3]);

					// I will use sandy math but not coordinates here (feel free to inline)
					var BA:Point3D = new Point3D((B.result.m03 - A.result.m03), (B.result.m13 - A.result.m13), (B.result.m23 - A.result.m23));
					var BC:Point3D = new Point3D((B.result.m03 - C.result.m03), (B.result.m13 - C.result.m13), (B.result.m23 - C.result.m23));
					// average distance is only meaningful for 1 vertex (you can compute it later)
					B.distance = 0.5 * (BA.getNorm() + BC.getNorm());
					BA.normalize();
					BC.normalize();
					B.cosine = Math.abs(BA.dot(BC));
				}

				results.sortOn("cosine", Array.NUMERIC);

				// display intermediate results
				for (k = 0; k < 3; k++)
				{
					// in 2D
					var i:int, sq:FLARSquare = FLARResult(results[k]).square;
					tool.graphics.lineStyle(0, 0xFF0000);
					for (i = 0; i < 4; i++)
					{
						var ix:int = sq.sqvertex[i].x;
						var iy:int = sq.sqvertex[i].y;
						tool.graphics.moveTo(ix - 3, iy + 0);
						tool.graphics.lineTo(ix + 4, iy + 0);
						tool.graphics.moveTo(ix + 0, iy - 3);
						tool.graphics.lineTo(ix + 0, iy + 4);
					}

					// or in 3D
					stuff[k].setTransformMatrix(FLARResult(results[k]).result);
				}

				// aggregate 3D results (this assumes all markers are oriented same way)
				A = FLARResult(results[2]);
				B = FLARResult(results[0]);
				C = FLARResult(results[1]);
				var scale3:Number = (1 + B.distance / size) / 3;
				var aggregate:FLARTransMatResult = new FLARTransMatResult;
				aggregate.m03 = (A.result.m03 + C.result.m03) * 0.5;
				aggregate.m13 = (A.result.m13 + C.result.m13) * 0.5;
				aggregate.m23 = (A.result.m23 + C.result.m23) * 0.5;
				aggregate.m00 = (A.result.m00 + B.result.m00 + C.result.m00) * scale3;
				aggregate.m10 = (A.result.m10 + B.result.m10 + C.result.m10) * scale3;
				aggregate.m20 = (A.result.m20 + B.result.m20 + C.result.m20) * scale3;
				aggregate.m01 = (A.result.m01 + B.result.m01 + C.result.m01) * scale3;
				aggregate.m11 = (A.result.m11 + B.result.m11 + C.result.m11) * scale3;
				aggregate.m21 = (A.result.m21 + B.result.m21 + C.result.m21) * scale3;
				aggregate.m02 = (A.result.m02 + B.result.m02 + C.result.m02) * scale3;
				aggregate.m12 = (A.result.m12 + B.result.m12 + C.result.m12) * scale3;
				aggregate.m22 = (A.result.m22 + B.result.m22 + C.result.m22) * scale3;
				stuff[3].setTransformMatrix(aggregate);

				// homography (I shall use 3D engine math - you can mess with FLARParam if you want to)
				var plane:Plane3D = Plane3D(stuff[3].children[0]);

				// since 3D fit is not perfect, we shall grab some extra area
				plane.scaleX = plane.scaleY = plane.scaleZ = 1.05;

				// I call render() to init sandy matrices - you can do matrix math by hand and
				// not render a thing, or use better engine :-p~
				sandyScene.render();

				var face1:Polygon = Polygon(plane.aPolygons[0]);
				sandyScene.camera.projectArray(face1.vertices);
				var face2:Polygon = Polygon(plane.aPolygons[1]);
				sandyScene.camera.projectArray(face2.vertices);

				var p0:Point = new Point(face1.b.sx, face1.b.sy);
				var p1:Point = new Point(face1.a.sx, face1.a.sy);
				var p2:Point = new Point(face1.c.sx, face1.c.sy);
				var p3:Point = new Point(face2.b.sx, face2.b.sy);

				plane.scaleX = plane.scaleY = plane.scaleZ = 1.0;

				homography.fillRect(homography.rect, 0);
				homography.applyFilter(canvas, canvas.rect, canvas.rect.topLeft, new HomographyTransformFilter(240, 240, p0, p1, p2, p3));

				// now read QR code
				qrInfo.text = "";
				qrResult.fillRect(qrResult.rect, 0);
				qrImage.process();
				
				//
				aVector3D = new Vector3D(face1.a.x, face1.a.y, face1.a.z);
				bVector3D = new Vector3D(face1.b.x, face1.b.y, face1.b.z);
				cVector3D = new Vector3D(face1.c.x, face1.c.y, face1.c.z);
				
				trace(aVector3D);
				trace(bVector3D);
				trace(cVector3D);
			}
		}

		private var plane:Plane;

		override protected function onInit():void
		{
			plane = new Plane(new WireColorMaterial());
			scene.addChild(plane);
			
			var _sphereA:Sphere = new Sphere(new ColorMaterial(0xFF0000), 10, 4, 4);
			scene.addChild(_sphereA);
			
			_sphereA.x = aVector3D.x;
			_sphereA.y = aVector3D.y;
			_sphereA.z = aVector3D.z;
			
			var _sphereB:Sphere = new Sphere(new ColorMaterial(0xFF0000), 10, 4, 4);
			scene.addChild(_sphereB);
			
			_sphereB.x = bVector3D.x;
			_sphereB.y = bVector3D.y;
			_sphereB.z = bVector3D.z;
			
			var _sphereC:Sphere = new Sphere(new ColorMaterial(0xFF0000), 10, 4, 4);
			scene.addChild(_sphereC);
			
			_sphereC.x = cVector3D.x;
			_sphereC.y = cVector3D.y;
			_sphereC.z = cVector3D.z;
		}
		
		private var aVector3D:Vector3D;
		private var bVector3D:Vector3D;
		private var cVector3D:Vector3D;
		
		private function onQRCodeRead(e:QRreaderEvent):void
		{
			// you don't have to draw qrResult, it's for debug ;)
			qrResult.draw(e.imageData, new Matrix(240 / e.imageData.width, 0, 0, 240 / e.imageData.height));

			qrDecoder.setQR(e.data);
			qrDecoder.startDecode();
		}

		private function onQRDecoded(e:QRdecoderEvent):void
		{
			qrInfo.text = "QR: " + e.data;
			trace(e.data);
			
			// here is your chance to make changes to 3D scene
			//scene.render();
		}

		private var file:FileReference;
		private var loader:Loader;

		[Embed(source='../bin/112233.png')]
		private var ImageData:Class;
		
		[Embed(source='flar.dat',mimeType='application/octet-stream')]
		private var CameraData:Class;
		
		[Embed(source='flar.pat',mimeType='application/octet-stream')]
		private var MarkerData:Class;

		private var canvas:BitmapData;
		private var size:Number;
		private var param:FLARParam;
		private var code:FLARCode;
		private var raster:FLARRgbRaster_BitmapData;
		private var detector:FLARMultiMarkerDetector;

		private var sandyScene:Scene3D;
		private var stuff:Vector.<FLARBaseNode>;

		private var homography:BitmapData;

		private var qrImage:GetQRimage;
		private var qrDecoder:QRdecode;
		private var qrResult:BitmapData;

		private var qrInfo:TextField;
	}
}

import org.libspark.flartoolkit.core.FLARSquare;
import org.libspark.flartoolkit.core.transmat.FLARTransMatResult;
import flash.events.MouseEvent;

class FLARResult
{
	public var confidence:Number;
	public var cosine:Number;
	public var distance:Number;
	public var result:FLARTransMatResult;
	public var square:FLARSquare;

	public function FLARResult()
	{
		confidence = 0;
		result = new FLARTransMatResult;
	}
}