﻿package com.cutecoma.game.player
{
	import away3dlite.animators.MovieMeshContainer3D;
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
	import flash.geom.Vector3D;
	
	import org.osflash.signals.Signal;

	//import org.papervision3d.objects.SDObject3D;

	public class Player extends RemovableEventDispatcher
	{
		public var id			: String;
		public var instance		: *;
		
		//private var clip:Clip3D;
		
		public var dolly:Vector3D;
		public var decoy:Vector3D;
		
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
		
		public function get model():MovieMeshContainer3D
		{
			return character.model;
		}
		
		public function get position():Vector3D
		{
			return character.model.transform.matrix3D.position;
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
			
			positions = [];
			
			// auto create
			create(data);
		}
		
		// ______________________________ Create ______________________________
		
		private var _character:Character;

		public function get character():Character
		{
			return _character;
		}

		public var playerCompleteSignal:Signal = new Signal(Player);
		
		public function create(config:Object=null):void
		{
			//instance = new Sphere(new WireframeMaterial(0xFF00FF), 50, 2, 2);
			
			_character =  new Character();
			_character.completeSignal.addOnce(onCharComplete);
				
			//instance = char.instance;
			//instance.alpha = 0;
			//instance.visible = false;
			
			dolly = new Vector3D();
			decoy = new Vector3D();
			
			if(config)
			{
				//char.addEventListener(SDEvent.COMPLETE, onCharacterComplete);
				//char.addEventListener(PlayerEvent.ANIMATIONS_COMPLETE, onAnimationComplete);
				_character.create(config);
	
				//instance.transform = Matrix3D.fromPosition(data.pos);
				//instance.copyPosition(config.pos);
				//dolly.copyPosition(config.pos);
				//decoy.copyPosition(config.des);
				
				if(balloonClip)
					balloonClip.y = character.height;
			}
			
			// ready to roll
			//dispatchEvent(new SDEvent(SDEvent.COMPLETE, config));
		}
		
		private function onCharComplete(model:MovieMeshContainer3D):void
		{
			playerCompleteSignal.dispatch(this);
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
		public function walkTo(targetPosition:Position):void
		{
			trace(" ! walkTo : "+targetPosition);
			if(map)
			{
				// Mr. map please find path for "me"
				//map.addEventListener(SDEvent.UPDATE, onWalkTo);
				//map.findPath(id, Position.parse(position), targetPosition);
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
				model.transform.matrix3D.position = Position.getVector3D(positions[0]);
				decoy = Position.getVector3D(positions[1]);

				trace(" ! Length : "+ positions.length);
				
				var factor:Number = (Map.factorX+Map.factorZ)*.5;
				var time:Number = Vector3D.distance(position, decoy)/speed/factor;
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
				
				TweenLite.killTweensOf(this);
				
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
				
				TweenLite.to(this, time, 
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
			
			model.lookAt(dolly);
			
			position.x += (dolly.x - position.x) * .1;
			position.z += (dolly.z - position.z) * .1;
		}
		
		private function onWalkComplete():void
		{
			trace(" ^ onWalkComplete");
			//dolly.copyPosition(instance);
			act(PlayerEvent.STAND);
			
			//dirty = true;
			
			// drop command point?
			var commandData:* = map.getCommand(position);
			
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
			if(character.model)
				character.model.play(action);
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
			if(playerData.act==PlayerEvent.WALK)
				walkTo(Position.parse(playerData.des));
			
			// message dirty 	: talk, whisper, shout
			talk(playerData.msg);
			
			dirty = true;
		}
		
		public function warp(position:Position):void
		{
			//dolly.copyPosition(pos);
			//decoy.copyPosition(pos);
			
			//instance.copyPosition(pos);
			character.model.transform.matrix3D.position = position.clone();
			
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