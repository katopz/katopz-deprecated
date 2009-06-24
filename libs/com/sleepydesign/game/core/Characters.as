package com.sleepydesign.game.core
{
	import com.sleepydesign.core.SDGroup;
	import com.sleepydesign.core.SDObject;
	import com.sleepydesign.events.SDEvent;
	import com.sleepydesign.game.data.CharacterData;
	
	import org.papervision3d.events.FileLoadEvent;
	import org.papervision3d.materials.BitmapFileMaterial;
	import org.papervision3d.objects.parsers.DAE;
	import org.papervision3d.objects.parsers.MD2;

	public class Characters extends SDObject
	{
		private var lists:SDGroup;
		
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
					trace(" Load : " + data.source);
					dae.scale = data.scale;
					
					model.instance = dae;
					
					// TODO : get this from DAE
					//dae.setupLoop(data.labels, data.frames);
					
					//charactor.height;
					
					//charactor.height = dae.getChildByName("head").y;
					
					//charactor.model = charactor.instance.addChild(dae);
					break;
			}
			
			model.type = data.type;
			
			return model;
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