package com.sleepydesign.game.core
{
	import com.sleepydesign.core.SDGroup;
	import com.sleepydesign.core.SDObject;
	import com.sleepydesign.events.SDEvent;
	import com.sleepydesign.game.data.CharacterData;
	import com.sleepydesign.game.events.PlayerEvent;
	
	public class Characters2D extends SDObject
	{
		private var lists:SDGroup;
		//public static var models:SDGroup;
		
		public static var instance:Characters2D;
		public static function getInstance():Characters2D
		{
			if (instance == null)
				instance=new Characters2D();
			return instance as Characters2D;
		}
		
		public function Characters2D(modelURI:String=null)
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
		
		private function onModelComplete(event:PlayerEvent):void
		{
			trace("onModelComplete");
			dispatchEvent(new SDEvent(SDEvent.COMPLETE));
		}
		
		private function onAnimationComplete(event:PlayerEvent):void
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