package com.codeazur.as3swf
{
	import com.codeazur.as3swf.data.*;
	import com.codeazur.utils.BitArray;
	
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	public class SWFData extends BitArray
	{
		public static const FLOAT16_EXPONENT_BASE:Number = 15;
		
		public function SWFData() {
			endian = Endian.LITTLE_ENDIAN;
		}
		
		/////////////////////////////////////////////////////////
		// Integers
		/////////////////////////////////////////////////////////
		
		public function readSI8():int {
			resetBitsPending();
			return readByte();
		}
		
		public function readSI16():int {
			resetBitsPending();
			return readShort();
		}
		
		public function readSI32():int {
			resetBitsPending();
			return readInt();
		}
		
		public function readUI8():uint {
			resetBitsPending();
			return readUnsignedByte();
		}
		
		public function readUI16():uint {
			resetBitsPending();
			return readUnsignedShort();
		}
		
		public function readUI24():uint {
			resetBitsPending();
			var loWord:uint = readUnsignedShort();
			var hiByte:uint = readUnsignedByte();
			return (hiByte << 16) | loWord;
		}
		
		public function readUI32():uint {
			resetBitsPending();
			return readUnsignedInt();
		}
		
		/////////////////////////////////////////////////////////
		// Fixed-point numbers
		/////////////////////////////////////////////////////////
		
		public function readFIXED():Number {
			resetBitsPending();
			return readInt() / 65536;
		}
		
		public function readFIXED8():Number {
			resetBitsPending();
			return readShort() / 256;
		}
		
		/////////////////////////////////////////////////////////
		// Floating-point numbers
		/////////////////////////////////////////////////////////
		
		public function readFLOAT():Number {
			resetBitsPending();
			return readFloat();
		}
		
		public function readDOUBLE():Number {
			resetBitsPending();
			return readDouble();
		}
		
		public function readFLOAT16():Number {
			resetBitsPending();
			var word:uint = readUnsignedShort();
			var sign:int = ((word & 0x8000) != 0) ? -1 : 1;
			var exponent:uint = (word >> 10) & 0x1f;
			var significand:uint = word & 0x3ff;
			if (exponent == 0) {
				if (significand == 0) {
					return 0;
				} else {
					// subnormal number
					return sign * Math.pow(2, 1 - FLOAT16_EXPONENT_BASE) * (significand / 1024);
				}
			}
			if (exponent == 31) { 
				if (significand == 0) {
					return (sign < 0) ? Number.NEGATIVE_INFINITY : Number.POSITIVE_INFINITY;
				} else {
					return Number.NaN;
				}
			}
			// normal number
			return sign * Math.pow(2, exponent - FLOAT16_EXPONENT_BASE) * (1 + significand / 1024);
		}
		
		/////////////////////////////////////////////////////////
		// Encoded integer
		/////////////////////////////////////////////////////////
		
		public function readEncodedU32():uint {
			resetBitsPending();
			var result:uint = readUnsignedByte();
			if (result & 0x80) {
				result = (result & 0x7f) | (readUnsignedByte() << 7);
				if (result & 0x4000) {
					result = (result & 0x3fff) | (readUnsignedByte() << 14);
					if (result & 0x200000) {
						result = (result & 0x1fffff) | (readUnsignedByte() << 21);
						if (result & 0x10000000) {
							result = (result & 0xfffffff) | (readUnsignedByte() << 28);
						}
					}
				}
			}
			return result;
		}
		
		/////////////////////////////////////////////////////////
		// Bit values
		/////////////////////////////////////////////////////////
		
		public function readUB(bits:uint):uint {
			return readBits(bits);
		}
		
		public function readSB(bits:uint):int {
			var shift:uint = 32 - bits;
			return int(readBits(bits) << shift) >> shift;
		}
		
		public function readFB(bits:uint):Number {
			return Number(readSB(bits)) / 65536;
		}
		
		/////////////////////////////////////////////////////////
		// String
		/////////////////////////////////////////////////////////
		
		public function readString():String {
			var index:uint = position;
			while (this[index++]) {}
			resetBitsPending();
			return readUTFBytes(index - position);
		}
		
		/////////////////////////////////////////////////////////
		// Labguage code
		/////////////////////////////////////////////////////////
		
		public function readLANGCODE():uint {
			resetBitsPending();
			return readUnsignedByte();
		}
		
		/////////////////////////////////////////////////////////
		// Rectangle record
		/////////////////////////////////////////////////////////
		
		public function readRECT():SWFRectangle {
			return new SWFRectangle(this);
		}
		
		/////////////////////////////////////////////////////////
		// Symbols
		/////////////////////////////////////////////////////////
		
		public function readSYMBOL():SWFSymbol {
			return new SWFSymbol(this);
		}
		
		/////////////////////////////////////////////////////////
		// Tag header
		/////////////////////////////////////////////////////////
		
		public function readTagHeader():SWFRecordHeader {
			var pos:uint = position;
			var tagTypeAndLength:uint = readUI16();
			var tagLength:uint = tagTypeAndLength & 0x003f;
			if (tagLength == 0x3f) {
				// The SWF10 spec sez that this is a signed int.
				// Shouldn't it be an unsigned int?
				tagLength = readSI32();
			}
			return new SWFRecordHeader(tagTypeAndLength >> 6, tagLength, position - pos);
		}
		
		/////////////////////////////////////////////////////////
		// SWF Compression
		/////////////////////////////////////////////////////////
		
		public function swfUncompress():void {
			var pos:uint = position;
			var ba:ByteArray = new ByteArray();
			readBytes(ba);
			ba.position = 0;
			ba.uncompress();
			length = position = pos;
			writeBytes(ba);
			position = pos;
		}
		
		public function swfCompress():void {
			var pos:uint = position;
			var ba:ByteArray = new ByteArray();
			readBytes(ba);
			ba.position = 0;
			ba.compress();
			length = position = pos;
			writeBytes(ba);
		}
		
		/////////////////////////////////////////////////////////
		// etc
		/////////////////////////////////////////////////////////
		
		public function readRawTag():SWFRawTag {
			return new SWFRawTag(this);
		}
		
		public function skipBytes(length:uint):void {
			position += length;
		}
	}
}
