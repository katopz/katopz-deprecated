package com.sleepydesign.game.data
{
	import flash.net.registerClassAlias;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	
	public class CharacterData implements IExternalizable 
	{
		registerClassAlias( "com.sleepydesign.game.data.CharacterData", CharacterData );
		
		public var id		:String;
		public var source	:String;
		public var scale	:Number;
		
		public var fps		:uint;
		public var labels	:Array;
		public var frames	:Array;
		public var skins	:Array;
		
		public var type		:String;
		public var height	:Number;
		
		public function CharacterData(id:String="default", source:String="default.md2", scale:Number=1, height:Number=100, fps:uint=15, labels:Array=null, frames:Array=null, skins:Array=null, type:String="") 
		{
			this.id = id;
			this.source = source;
			this.scale = scale;
			this.height = height;
			
			this.fps = fps;
			this.labels = labels?labels:[];
			this.frames = frames?frames:[];
			this.skins = labels?skins:[];
			
			this.type = String(type?type:source.substr(source.lastIndexOf(".")+1)).toLowerCase();
		}
		
		// _______________________________________________________internal
		
		public function parse( raw:* ): void
		{
			id = raw.id;
			source = raw.source;
			scale = raw.scale;
			height = raw.height;
			
			fps = raw.fps;
			labels = raw.labels;
			frames = raw.frames;
			skins = raw.skins;
			
			type = raw.type;
		}
		
		// _______________________________________________________ external
		
		public function writeExternal( output: IDataOutput ): void
		{
			output.writeObject(
			{
				id:id,
				source:source,
				scale:scale,
				height:height,
				
				fps:fps,
				labels:labels,
				frames:frames,
				skins:skins,
				
				type:type
			});
		}
		
		public function readExternal( input: IDataInput ): void
		{
			parse(input.readObject());
		}
		
		// _______________________________________________________ to
		
		public function toObject():Object 
		{
			return { id:id, source:source, scale:scale, height:height, fps:fps, labels:labels, frames:frames,  skins:skins, type:type };
		}
		
		public function toString():String
		{
			return String("id:"+id+", source:"+source+", scale:"+scale+", height:"+height+", fps:"+fps+", labels:"+labels+", frames:"+frames+", skins:"+skins+", type:"+type);
		}
	}
}