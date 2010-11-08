package com.codeazur.as3swf
{
	import com.codeazur.as3swf.data.SWFRectangle;
	import com.codeazur.as3swf.tags.ITag;
	
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	public class SWF
	{
		public var version:int = 10;
		public var fileLength:uint = 0;
		public var fileLengthCompressed:uint = 0;
		public var frameSize:SWFRectangle;
		public var frameRate:Number = 50;
		public var frameCount:uint = 1;
		
		public var compressed:Boolean;
		
		public var timeline:SWFTimeline;
		
		protected var bytes:SWFData;
		
		public function SWF(ba:ByteArray = null) {
			bytes = new SWFData();
			timeline = new SWFTimeline(this);
			if (ba != null) {
				loadBytes(ba);
			} else {
				frameSize = new SWFRectangle();
			}
		}
		
		// Convenience getters
		public function get tags():Vector.<ITag> { return timeline.tags; }
		public function get dictionary():Dictionary { return timeline.dictionary; }
		
		public function getTagByCharacterId(characterId:uint):ITag {
			return tags[dictionary[characterId]];
		}
		
		public function loadBytes(ba:ByteArray):void {
			bytes.length = 0;
			ba.position = 0;
			ba.readBytes(bytes);
			parse(bytes);
		}
		
		public function parse(data:SWFData):void {
			bytes = data;
			parseHeader();
			timeline.parse(bytes, version);
		}
		
		protected function parseHeader():void {
			compressed = false;
			bytes.position = 0;
			var signatureByte:uint = bytes.readUI8();
			if (signatureByte == 0x43) {
				compressed = true;
			} else if (signatureByte != 0x46) {
				throw(new Error("Not a SWF. First signature byte is 0x" + signatureByte.toString(16) + " (expected: 0x43 or 0x46)"));
			}
			signatureByte = bytes.readUI8();
			if (signatureByte != 0x57) {
				throw(new Error("Not a SWF. Second signature byte is 0x" + signatureByte.toString(16) + " (expected: 0x57)"));
			}
			signatureByte = bytes.readUI8();
			if (signatureByte != 0x53) {
				throw(new Error("Not a SWF. Third signature byte is 0x" + signatureByte.toString(16) + " (expected: 0x53)"));
			}
			version = bytes.readUI8();
			fileLength = bytes.readUI32();
			fileLengthCompressed = bytes.length;
			if (compressed) {
				// The following data (up to end of file) is compressed, if header has CWS signature
				bytes.swfUncompress();
			}
			frameSize = bytes.readRECT();
			frameRate = bytes.readFIXED8();
			frameCount = bytes.readUI16();
		}
		
		
		
		public function toString():String {
			return "[SWF]\n" +
				"  Header:\n" +
				"    Version: " + version + "\n" +
				"    FileLength: " + fileLength + "\n" +
				"    FileLengthCompressed: " + fileLengthCompressed + "\n" +
				"    FrameSize: " + frameSize + "\n" +
				"    FrameRate: " + frameRate + "\n" +
				"    FrameCount: " + frameCount + "\n" +
				timeline.toString();
		}
	}
}
