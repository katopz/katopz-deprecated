package com.codeazur.as3swf
{
	import com.codeazur.as3swf.data.SWFRawTag;
	import com.codeazur.as3swf.data.SWFRecordHeader;
	import com.codeazur.as3swf.tags.*;
	import flash.utils.Dictionary;
	
	public class SWFTimeline
	{
		protected var _tags:Vector.<ITag>;
		protected var _tagsRaw:Vector.<SWFRawTag>;
		protected var _dictionary:Dictionary;
		
		protected var swf:SWF;
		
		protected var hasSoundStream:Boolean = false;
		
		protected var data:SWFData;
		protected var version:uint;
		protected var eof:Boolean;
		
		public function SWFTimeline(swf:SWF)
		{
			this.swf = swf;
			
			_tags = new Vector.<ITag>();
			_tagsRaw = new Vector.<SWFRawTag>();
			_dictionary = new Dictionary();
		}
		
		public function get tags():Vector.<ITag> { return _tags; }
		public function get tagsRaw():Vector.<SWFRawTag> { return _tagsRaw; }
		public function get dictionary():Dictionary { return _dictionary; }
		
		public function getTagByCharacterId(characterId:uint):ITag {
			return swf.getTagByCharacterId(characterId);
		}
		
		public function parse(data:SWFData, version:uint):void {
			parseInit(data, version);
			while (parseTag(data)) {};
		}
		
		protected function parseInit(data:SWFData, version:uint):void {
			tags.length = 0;
			_dictionary = new Dictionary();
			hasSoundStream = false;
			this.data = data;
			this.version = version;
		}
		
		protected function parseTag(data:SWFData):Boolean {
			var pos:uint = data.position;
			// Bail out if eof
			eof = (pos > data.length);
			if(eof) {
				trace("WARNING: end of file encountered, no end tag.");
				return false;
			}
			var tagRaw:SWFRawTag = data.readRawTag();
			var tagHeader:SWFRecordHeader = tagRaw.header;
			var tag:ITag;
			if(tagHeader.type == 76)
				tag = new TagSymbolClass();
			
			try {
				tag.parse(data, tagHeader.contentLength, version);
			} catch(e:Error) {
				// If we get here there was a problem parsing this particular tag.
				// Corrupted SWF, possible SWF exploit, or obfuscated SWF.
				// TODO: register errors and warnings
				trace("WARNING: parse error: " + e.message + ", Tag: " + tag.name + ", Index: " + tags.length);
			}
			// Register tag
			if(tag)
				tags.push(tag);
			
			tagsRaw.push(tagRaw);
			
			// Build dictionary and display list etc
			if(tag)
				processTag(tag);
			
			// Adjust position (just in case the parser under- or overflows)
			if(data.position != pos + tagHeader.tagLength) {
				trace("WARNING: excess bytes: " + 
					(data.position - (pos + tagHeader.tagLength)) + ", " +
					"Tag: " + tag.name + ", " +
					"Index: " + (tags.length - 1)
				);
				data.position = pos + tagHeader.tagLength;
			}
			return (tagHeader.type != TagEnd.TYPE);
		}
		
		protected function processTag(tag:ITag):void {
			var currentTagIndex:uint = tags.length - 1;
			// Register definition tag in dictionary (key: character id, value: definition tag index)
			if(tag is IDefinitionTag) {
				var definitionTag:IDefinitionTag = tag as IDefinitionTag;
				if(definitionTag.characterId > 0) {
					dictionary[definitionTag.characterId] = currentTagIndex;
				}
			}
		}
		
		public function toString():String {
			return String(tags);
		}
	}
}
