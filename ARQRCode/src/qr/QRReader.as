package qr
{
	import com.logosware.event.QRdecoderEvent;
	import com.logosware.event.QRreaderEvent;
	import com.logosware.utils.QRcode.GetQRimage;
	import com.logosware.utils.QRcode.QRdecode;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Point;
	import flash.utils.*;

	public class QRReader extends EventDispatcher
	{
		public static var result:String = "";
		
		public var homography:BitmapData;
		
		private var qrImage:GetQRimage;
		private var qrDecoder:QRdecode;
		
		public function QRReader(homography:BitmapData)
		{
			this.homography = homography;
			
			// Read
			qrImage = new GetQRimage(new Bitmap(homography));
			qrImage.addEventListener(QRreaderEvent.QR_IMAGE_READ_COMPLETE, onQRCodeRead);
			
			// Parse
			qrDecoder = new QRdecode();
			qrDecoder.addEventListener(QRdecoderEvent.QR_DECODE_COMPLETE, onQRDecoded);
		}
		
		public function reset():void
		{
			result = "";
		}
		
		public function processHomography(bitmapData:BitmapData, width:Number, height:Number, p0:Point, p1:Point, p2:Point, p3:Point):void
		{
			homography.fillRect(homography.rect, 0);
			homography.applyFilter(bitmapData, bitmapData.rect, bitmapData.rect.topLeft, new HomographyTransformFilter(width, height, p0, p1, p2, p3));
			
			// Debug
			//qrResult.fillRect(qrResult.rect, 0);
			
			qrImage.process();
		}
		
		private function onQRCodeRead(e:QRreaderEvent):void
		{
			// Debug
			// qrResult.draw(e.imageData, new Matrix(240 / e.imageData.width, 0, 0, 240 / e.imageData.height));
			
			qrDecoder.setQR(e.data);
			qrDecoder.startDecode();
		}

		private function onQRDecoded(e:QRdecoderEvent):void
		{
			if(result != String(e.data) && String(e.data).length==6)
			{
				trace(" ^ onQRDecoded : " + e.data);
				result = String(e.data);
				dispatchEvent(new Event(Event.COMPLETE));
			}
		}
	}
}