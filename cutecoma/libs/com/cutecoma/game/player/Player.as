﻿﻿package com.cutecoma.game.player
{
	import away3dlite.core.base.Object3D;
	import away3dlite.core.base.Particle;
	
	import com.cutecoma.game.core.Character;
	import com.cutecoma.game.core.Game;
	import com.cutecoma.game.core.Position;
	import com.cutecoma.game.data.PlayerData;
	import com.cutecoma.game.events.PlayerEvent;
	import com.cutecoma.playground.core.Map;
	import com.greensock.*;
	import com.greensock.easing.Linear;
	import com.sleepydesign.components.SDDialog;
	import com.sleepydesign.events.RemovableEventDispatcher;
	
	import flash.events.Event;

	//import org.papervision3d.objects.SDObject3D;

	public class Player extends RemovableEventDispatcher
	{
		public var id			: String;
		public var instance		: *;
		
		//private var clip:Clip3D;
		
		private var dolly:*;
		public var decoy:*;
		
		public var balloon:SDDialog; 
		
		public var positions:Array;
		//public var speed:Number;
		
		//____________________________________________________________ Data
		
		private var _dirty:Boolean = false;
		
		public var data:PlayerData;
		
		public function get msg():String
		{
			return data.msg;
		}
		
		public function set msg(value:String):void
		{
			if(!data || data.msg == value)
				return;
			
			data.msg = value;
			dirty = true;
		}
		
		public function get action():String
		{
			return data.act;
		}
		
		public function set action(value:String):void
		{
			//if(data.act == value)return;
			if(data)
				data.act = value;
		}
		
		public function get speed():Number
		{
			return data.spd;
		}
		
		public function set dirty(value:Boolean):void
		{
			if(!value)return;
			if(data.act==PlayerEvent.STAND)return;
			
			// update position
			data.pos = Position.parse(dolly).toObject();
			data.des = Position.parse(decoy).toObject();
			
			// tell mom i'm dirty!
			dispatchEvent(new PlayerEvent(PlayerEvent.UPDATE, PlayerData(data).toObject()));
			
			// all clean now
			_dirty = false;
		}
		
		//____________________________________________________________ Contructor
		
		public function Player(playerData:PlayerData=null)//id:String=null, source:*=null, playerVO:PlayerVO)
		{
			super();
			
			if(playerData)
			{
				this.id = playerData.id?playerData.id:String(new Date().valueOf());
				data = PlayerData(playerData);
			}
			init();
		}
		
        // ______________________________ Initialize ______________________________
        
		protected function init():void
		{
			positions = [];
			
			// auto create
			create(data);
		}
		
		// ______________________________ Create ______________________________
		
		private var char:Character
		public function create(config:Object=null):void
		{
			//instance = new Sphere(new WireframeMaterial(0xFF00FF), 50, 2, 2);
			
			char =  new Character();
			//instance = char.instance;
			instance.alpha = 0;
			instance.visible = false;
			
			dolly = new Object3D();
			decoy = new Object3D();
			
			if(config)
			{
				//char.addEventListener(SDEvent.COMPLETE, onCharacterComplete);
				//char.addEventListener(PlayerEvent.ANIMATIONS_COMPLETE, onAnimationComplete);
				char.create(config);
	
				//instance.transform = Matrix3D.fromPosition(data.pos);
				instance.copyPosition(config.pos);
				dolly.copyPosition(config.pos);
				decoy.copyPosition(config.des);
				
				if(balloonClip)
					balloonClip.y = char.height;
			}
			
			// ready to roll
			//dispatchEvent(new SDEvent(SDEvent.COMPLETE, config));
		}
		
		/*
		private function onCharacterComplete(event:SDEvent):void
		{
			// i'm taller?
			if(balloonClip)
				balloonClip.y = char.height;

			//trace("onCharacterComplete");
		}
		
		private function onAnimationComplete(event:*):void
		{
			//trace("onAnimationComplete#3");
			//balloonClip.y = 70;
			TweenLite.to(instance, 1, {autoAlpha:1});
			dispatchEvent(event.clone());
		}
		*/
		
		// ______________________________ Action ______________________________
		
		public function talk(msg:String=""):void
		{
			if(!balloon)
			{
				balloon = new SDDialog();
				/*
				balloon = new SDBalloon(msg?msg:"");
				balloon.addEventListener(SDEvent.DRAW, onBalloonChange);
			
				var spm:SDParticleMaterial = new SDParticleMaterial(balloon,"bc");
				var particles3D:Particles = new Particles();
				
				balloonClip = new Particle(spm, 1, 0, 200, 0);
				*/
				
				//particles3D.addParticle(balloonClip);
				//particles3D.useOwnContainer = true;
				//particles3D.filters = [ new GlowFilter( 0x999999, 1, 4, 4, 1, 1) ];
				//particles3D.addEventListener(InteractiveScene3DEvent.OBJECT_CLICK, onBalloonClick);
				//particles3D.addEventListener(InteractiveScene3DEvent.OBJECT_OVER, onBalloonClick);
				
				//instance.addChild(particles3D);
				act(PlayerEvent.TALK);
			}
			else if(msg && balloon.text != msg)
			{
				balloonClip.visible = true;
				balloon.text = msg;
				act(PlayerEvent.TALK);
			}else{
				balloonClip.visible = false;
			}
			
			this.msg = msg;
		}
		
		private var balloonClip:Particle;
		private function onBalloonChange( event:Event ):void
		{
			if(event.type!=Event.CHANGE)
				return;
			balloonClip.visible = balloon.visible;
			//balloonClip.material.updateBitmap();
		}
		
		// TODO : getset
		public var map:Map;
		public function walkTo(position:Position):void
		{
			trace(" ! walkTo : "+position);
			if(map)
			{
				// Mr. map please find path for "me"
				//map.addEventListener(SDEvent.UPDATE, onWalkTo);
				map.findPath(id, Position.parse(dolly), position);
			}else{
				// no map? wooooot? why????
			}
		}
		
		private function onWalkTo( event:Event ):void
		{
			/*
			if(event.data.id == id)
			{
				trace(" ! onWalkTo : "+event.data.id);
				map.removeEventListener(SDEvent.UPDATE, onWalkTo);
				walk(event.data.positions);
			}
			*/
		}
		
		public function walk(positions:Array):void
		{
			this.positions = positions;
			
			trace(" ! positions : "+positions);
			
			if (positions.length>1)
			{
				dolly.copyPosition(positions[0]);
				decoy.copyPosition(positions[1]);

				trace(" ! Length : "+ positions.length);
				
				var factor:Number = (Map.factorX+Map.factorZ)*.5;
				var time:Number= dolly.distanceTo(decoy)/speed/factor;
				/*
				if(positions.length==2)
				{
					time = dolly.distanceTo(decoy)/speed/factor;
				}else{
					time = positions.length/speed;
				}
				*/
				trace(" ! Time : "+time);
				
				positions.shift();
				
				TweenLite.killTweensOf(dolly);
				
				act(PlayerEvent.WALK);
				
				/*
				_temp.copyPosition(dolly);
				_temp.lookAt(decoy);
				
				//trace("rotationY:"+_temp.rotationY);
				var _rotationY:Number = -90+180*Math.atan2(decoy.z-dolly.z,decoy.x-dolly.x)/Math.PI 
				trace("rotationY:"+_rotationY);
				
				.to(instance, 0.5, 
				{
					rotationY:_rotationY
				})
				*/
				
				//instance.lookAt(decoy);
				
				TweenLite.to(dolly, time, 
				{
					x:decoy.x, y:decoy.y, z:decoy.z,
					//bezier:positions,
					//onStart:function():void { act(PlayerEvent.WALK) },
					onUpdate:onWalk,
					onComplete:walk,
					onCompleteParams:[positions],
					ease:Linear.easeNone
				});
				
			}else {
				//TODO : recheck condition, idle
				onWalkComplete();
			}
			
			dirty = true;
		}
		
		private function onWalk():void
		{
			/*
			if(int(_temp.rotationY) != int(instance.rotationY))
			{
				trace("rotationY:"+_temp.rotationY);
				trace("*rotationY:"+instance.rotationY);
				
				instance.rotationY += ((instance.rotationY+_temp.rotationY) - instance.rotationY) * .5;
			}
			*/
			
			//instance.localRotationY += (_temp.localRotationY - instance.localRotationY) * .5;
			

			/*
			if(_temp.rotationY > instance.rotationY)
			{
				instance.rotationY += (_temp.rotationY - instance.rotationY) * .5;
				
			}else{
				instance.rotationY += (_temp.rotationY - instance.rotationY) * .5;
			}
			*/
			instance.lookAt(dolly);
			instance.x += (dolly.x - instance.x) * .1;
			instance.z += (dolly.z - instance.z) * .1;
		}
		
		private function onWalkComplete():void
		{
			trace(" ^ onWalkComplete");
			dolly.copyPosition(instance);
			act(PlayerEvent.STAND);
			
			//dirty = true;
			
			// drop command point?
			var commandData:* = map.getCommand(dolly.position);
			
			if(commandData.args)
			{
				// it's my command
				commandData.args.push(this);
				
				// apply
				Game.applyCommand(commandData.command, commandData.args);
			}
		}
		
		public function act(action:String):void
		{
			//if (this.action == action)return;
			
			///trace(" ! Action	:"+action);
			if(char.model)
				char.model.play(action);
			this.action = action;
		}
		
		public function enter():void
		{
			data.act = PlayerEvent.ENTER;
			dispatchEvent(new PlayerEvent(PlayerEvent.UPDATE, PlayerData(data).toObject()));
		}
		
		public function exit():void
		{
			data.act = PlayerEvent.EXIT;
			dispatchEvent(new PlayerEvent(PlayerEvent.UPDATE, PlayerData(data).toObject()));
		}
		
		// ______________________________ Update ____________________________
		
		public function update(data:Object=null):void
		{
			trace(" Player.update : " + data);
			var playerData:PlayerData = PlayerData(this.data);
			playerData.parse(data);
			
			// update list?
			// group dirty		: in, out
			// status dirty		: online, away
			// player dirty		: nick, source {model, texture}
			
			// action dirty		: idle, walk, talk
			act(playerData.act);
			
			// position dirty	: position
			if(playerData.act=="walk")
				walkTo(Position.parse(playerData.des));
			
			// message dirty 	: talk, whisper, shout
			talk(playerData.msg);
			
			dirty = true;
		}
		
		public function warp(pos:Position):void
		{
			dolly.copyPosition(pos);
			decoy.copyPosition(pos);
			
			instance.copyPosition(pos);
			
			dirty = true;
		}
		
		override public function destroy():void
		{
			TweenLite.killTweensOf(dolly);
			/*
			id = null;
			instance = null;
			
			clip = null;
			
			dolly = null;
			decoy = null;
			
			if(balloon)
			{
				balloon.destroy();
				balloon = null;
			}
			
			positions = null;
			*/
			super.destroy();
		}
	}
}