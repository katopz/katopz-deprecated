package com.sleepydesign.game.core
{
	import com.sleepydesign.core.SDGroup;
	import com.sleepydesign.core.SDObject;
	import com.sleepydesign.events.SDEvent;
	import com.sleepydesign.game.data.CharacterData;
	import com.sleepydesign.text.SDTextField;
	
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	
	import org.papervision3d.core.geom.Particles;
	import org.papervision3d.core.geom.renderables.Particle;
	import org.papervision3d.events.FileLoadEvent;
	import org.papervision3d.materials.BitmapFileMaterial;
	import org.papervision3d.materials.special.SDParticleMaterial;
	import org.papervision3d.objects.parsers.DAE;
	import org.papervision3d.objects.parsers.MD2;

	public class Characters extends SDObject
	{
		private var lists:SDGroup;
		public static var models:SDGroup;
		
		public static var instance:Characters;
		public static function getInstance():Characters
		{
			if (instance == null)
				instance=new Characters();
			return instance as Characters;
		}
		
		public function Characters(modelURI:String=null)
		{
			instance = this;
			super();
		}

		public function addCharacter(data:CharacterData):void
		{
			if(!lists)lists = new SDGroup("Characters");
			lists.insert(data, data.id);
		}
		
		public function getModel(id:String=null):SDModel
		{
			//var charactor:Character = new Character(id);
			var model:SDModel = new SDModel();
			
			var data:CharacterData = lists.findBy(id);
			
			// TODO : can we merge this with lists?
			if(!models)models = new SDGroup("Models");
			models.insert(model, data.id);
			
			switch (data.type)
			{
				case "md2":
					var md2:MD2 = new MD2(false);
					//md2.addEventListener(SDEvent.COMPLETE, charactor.onModelComplete);
					md2.load(data.source, new BitmapFileMaterial(String(data.skins[0]).split(":")[1]), data.fps, data.scale);
					
					model.instance = md2;
					
					break;
				case "dae":
					var dae:DAE = new DAE(true, "", true);
					dae.addEventListener(FileLoadEvent.LOAD_COMPLETE, onModelComplete);
					dae.addEventListener(FileLoadEvent.ANIMATIONS_COMPLETE, onAnimationComplete);
					dae.load(data.source);
					//trace(" Load : " + data.source);
					dae.scale = data.scale;
					
					model.instance = dae;
					
					// TODO : get this from DAE
					//dae.setupLoop(data.labels, data.frames);
					
					//charactor.height;
					
					//charactor.height = dae.getChildByName("head").y;
					
					//charactor.model = charactor.instance.addChild(dae);
					break;
				case "swf":
					var sdLoader:Loader = new Loader();
					sdLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onSWFComplete);
					
					var ldrContext:LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain);
					var request:URLRequest = new URLRequest(data.source);
					sdLoader.load(request, ldrContext);
					
					var loaderText:SDTextField = new SDTextField("loading...");
					var spm:SDParticleMaterial = new SDParticleMaterial(loaderText, "loaderText");
					var particles3D:Particles = new Particles();
					var loaderClip:Particle = new Particle(spm, 1, 0, 200, 0);
					particles3D.addParticle(loaderClip);
					
					var daeSWF:DAE = new DAE(true, "", true);
					daeSWF.addEventListener(FileLoadEvent.LOAD_COMPLETE, onModelComplete);
					daeSWF.addEventListener(FileLoadEvent.ANIMATIONS_COMPLETE, onAnimationComplete);
					
					daeSWF.scale = data.scale;
					model.addChild(particles3D);
					
					//model.extra = {"sdLoader":sdLoader};
					
					model.instance = daeSWF;
				break;
			}
			
			model.type = data.type;
			
			return model;
		}
		
		private function onSWFComplete(event:Event):void
		{
			var _url:String = LoaderInfo(event.target).url;
			var _id:String = Sprite(event.target.content)["id"];
			//trace("onSWFComplete:"+_url);
			var _Class:Class = ApplicationDomain.currentDomain.getDefinition("model_Model") as Class;
			var _ByteArray:ByteArray = new _Class();
			
			var model:SDModel = models.find(_id);
			model.instance.load(_ByteArray);
		}
		
		private function onModelComplete(event:FileLoadEvent):void
		{
			trace("onModelComplete");
			dispatchEvent(new SDEvent(SDEvent.COMPLETE));
		}
		
		private function onAnimationComplete(event:FileLoadEvent):void
		{
			trace("onAnimationComplete#1");
			dispatchEvent(event.clone());
		}
		
		/*
		private function onModelComplete(event:SDEvent):void
		{
			var charactor:AbstractCharacter = event.target;
			
			charactor.height = md2.boundingBox().max.y;
			
			trace("charactor.height:"+charactor.height);
			
			dispatchEvent(new SDEvent(SDEvent.COMPLETE));
		}
		*/
	}
}