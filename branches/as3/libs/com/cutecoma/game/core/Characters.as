package com.cutecoma.game.core
{
	import com.sleepydesign.core.SDGroup;
	import com.sleepydesign.core.SDObject;
	import com.sleepydesign.events.SDEvent;
	import com.cutecoma.game.data.CharacterData;
	import com.cutecoma.game.events.PlayerEvent;
	
	import org.papervision3d.materials.BitmapFileMaterial;
	import org.papervision3d.objects.parsers.DAE;
	import org.papervision3d.objects.parsers.MD2;

	public class Characters extends SDObject
	{
		private var lists:SDGroup;
		//public static var models:SDGroup;
		
		private static var instance:Characters;
		public static function getInstance():Characters
		{
			if (instance == null)
				instance=new Characters();
			return instance as Characters;
		}
		
		public function Characters()
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
			data.model = model;
			
			/*
			// TODO : can we merge this with lists?
			if(!models)models = new SDGroup("Models");
			models.insert(model, data.id);
			*/
			
			switch (data.type)
			{
				case "md2":
					var md2:MD2 = new MD2(false);
					//md2.addEventListener(SDEvent.COMPLETE, charactor.onModelComplete);
					md2.load(data.source, new BitmapFileMaterial(String(data.skins[0]).split(":")[1]), data.fps, data.scale);
					
					model.instance = md2;
					
					break;
				case "swf":
				case "dae":
					var dae:DAE = new DAE(true, "", true);
					dae.addEventListener(PlayerEvent.LOAD_COMPLETE, onModelComplete);
					dae.addEventListener(PlayerEvent.ANIMATIONS_COMPLETE, onAnimationComplete);
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
				/*
				case "swf2":
					var sdLoader:SDLoader = new SDLoader();
					sdLoader.addEventListener(SDEvent.COMPLETE, onSWFComplete);
					
					//var ldrContext:LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain);
					//var request:URLRequest = new URLRequest(data.source);
					sdLoader.load(data.source);
					
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
				*/
			}
			
			model.type = data.type;
			
			return model;
		}
		
		/*
		private function onSWFComplete(event:SDEvent):void
		{
			// finish load model? let's chk in list
			var swf:Sprite;
			var characterData:CharacterData;
			for each(var _characterData:CharacterData in lists.childs)
			{
				if(SDLoader(event.target).isContent(_characterData.source))
				{
					// TODO : keep object pooling
					swf = SDLoader(event.target).getContent(_characterData.source) as Sprite;
					characterData = _characterData;
				}
			}
			
			var _id:String = swf["id"];
			var _className:String = URLUtil.getFileName(characterData.source)+"_Model";
			var _Class:Class = swf.loaderInfo.applicationDomain.getDefinition(_className) as Class;
			var _ByteArray:ByteArray = new _Class();
			
			characterData.model.instance.load(_ByteArray);
		}
		*/
		
		private function onModelComplete(event:*):void
		{
			//trace("onModelComplete");
			dispatchEvent(new SDEvent(SDEvent.COMPLETE));
		}
		
		private function onAnimationComplete(event:*):void
		{
			//trace("onAnimationComplete#1");
			//dispatchEvent(new PlayerEvent(PlayerEvent.ANIMATIONS_COMPLETE, event.file));
			//trace("onAnimationComplete#1");
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