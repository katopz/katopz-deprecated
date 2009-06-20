package com.sleepydesign.game.core
{
	import com.sleepydesign.core.SDObject;
	import com.sleepydesign.game.data.CharacterData;
	
	import org.papervision3d.materials.BitmapFileMaterial;
	import org.papervision3d.objects.parsers.DAE;
	import org.papervision3d.objects.parsers.MD2;

	public class Characters extends SDObject
	{
		private var data:CharacterData;
		
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
			//"man", "assets/man_test.dae", ["stand","walk","sit"], ["0,0", "1,16", "18,31"], ["angry:angry.png"]
			/*
			data = new CharacterData
			(
				"cat", "assets/cat.md2", 4, 100, 15,
				["stand", "walk", "sit"],
				["0,0", "1,16", "18,31"],
				["soso:assets/soso.png", "angry:assets/angry.png"]
			)
			
			data = new CharacterData
			(
				"man", "assets/man1/model.dae", 1, 100, 24,
				["stand", "walk", "sit"]
			)
			*/
		}

		public function addData(data:CharacterData):void
		{
			this.data = data;
		}
		
		public function getModel(id:String=null):SDModel
		{
			//var charactor:Character = new Character(id);
			var model:SDModel = new SDModel();
			
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
					dae.load(data.source);
					
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