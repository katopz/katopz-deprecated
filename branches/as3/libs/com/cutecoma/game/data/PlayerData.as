package com.cutecoma.game.data
{
	import com.cutecoma.game.core.Position;
	
	import flash.net.registerClassAlias;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	
	public class PlayerData implements IExternalizable 
	{
		registerClassAlias( "com.cutecoma.game.data.PlayerData", PlayerData );
		
		// who
		public var id		:String;
		public var nick		:String;
		public var src		:String;
		
		// where
		public var pos		:Object;
		public var des		:Object;
		public var spd		:Number;
		
		// how
		public var act		:String;
		
		// what
		public var mouth	:Object;
		public var msg		:String;
		
		// when
		public var ms		:Number;
		
		//public var chr		:CharacterData;
		
		public function PlayerData(id:String="", pos:Position=null, src:String="", act:String="", spd:Number=1, des:Position=null) 
		{
			this.ms = Number(new Date().valueOf());
			this.id = id;
			this.pos = pos?pos.toObject():new Position();
			this.src = src;
			this.act = act;
			this.spd = spd;
			this.des = des?des.toObject():new Position(this.pos.x, this.pos.y, this.pos.z-.01);
			
			//this.chr = chr?chr:new CharacterData();
		}
		
		// _______________________________________________________internal
		
		public function parse( raw:* ): void
		{
			ms 	= raw.ms?Number(raw.ms):Number(new Date().valueOf());
			id 	= raw.id?String(raw.id):id;
			
			pos = raw.pos?Position.parse(raw.pos).toObject():pos;
			des = raw.des?Position.parse(raw.des).toObject():des;
			
			src = raw.src?String(raw.src):src;
			act = raw.act?String(raw.act):act;
			spd = raw.spd?Number(raw.spd):spd;
			
			msg = raw.msg?String(raw.msg):msg;
			
			/*
			chr = new CharacterData
			(
				raw.chr.source,
				raw.chr.frames,
				raw.chr.labels,
				raw.chr.skins,
				raw.chr.type
			);*/
		}
		
		public function toObject():Object
		{
			return {
				ms:ms,
				id:id,
				pos:pos,
				src:src,
				act:act,
				spd:spd,
				des:des,
				msg:msg
				//chr:chr
			}
		}
		
		// _______________________________________________________ external
		
		public function writeExternal( output: IDataOutput ): void
		{
			output.writeObject(toObject());
		}
		
		public function readExternal( input: IDataInput ): void
		{
			parse(input.readObject());
		}
		
		public function toString():String
		{
			return String("ms:"+ms+", id:"+id+", pos:"+pos+", src:"+src+", act:"+act+", spd:"+spd+", des:"+des+", msg:"+msg);
		}
	}
}