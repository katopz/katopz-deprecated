package labs
{
	import away3dlite.containers.Particles;
	import away3dlite.core.base.Particle;
	import away3dlite.materials.ParticleMaterial;
	import away3dlite.templates.BasicTemplate;
	
	import com.cutecoma.playground.components.SDChatBubble;
	import com.sleepydesign.system.DebugUtil;
	
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;

	[SWF(backgroundColor="#CCCCCC", frameRate="30", width="800", height="600")]
	public class TestSDChatBubble extends BasicTemplate
	{
		private var _chatBubble:SDChatBubble;
		private var _particleMaterial:ParticleMaterial;
		private var _balloonParticles:Particles;

		override protected function onInit():void
		{
			_chatBubble = new SDChatBubble("test");
			addChild(_chatBubble);

			var position:Vector3D = new Vector3D(100, 100, 0);

			var _bitmapData:BitmapData = new BitmapData(_chatBubble.width, _chatBubble.height, true, 0x00000000);
			_bitmapData.draw(_chatBubble);
			_particleMaterial = new ParticleMaterial(_bitmapData);

			var _chatBubbleParticle:Particle = new Particle(_particleMaterial, position.x, position.y, position.z);
			_chatBubbleParticle.id = "0";

			_balloonParticles = new Particles();
			_balloonParticles.addParticle(_chatBubbleParticle);
			scene.addChild(_balloonParticles);

			// listen for draw
			_chatBubble.drawSignal.add(onBubbleDraw);

			stage.addEventListener(MouseEvent.CLICK, onClick);
		}

		private function onBubbleDraw():void
		{
			DebugUtil.trace(_chatBubble.width, _chatBubble.height);

			var _bitmapData:BitmapData = _particleMaterial.bitmapData;

			if (_bitmapData)
				_bitmapData.dispose();

			_bitmapData.dispose();
			_bitmapData = new BitmapData(_chatBubble.width, _chatBubble.height, true, 0x00000000);
			_particleMaterial.rect = new Rectangle(0, 0, _bitmapData.width, _bitmapData.height);
			_bitmapData.draw(_chatBubble);

			_particleMaterial.bitmapData = _bitmapData;
		}

		protected function onClick(e:*):void
		{
			_chatBubble.text = mouseX + "," + mouseY;
		}

		override protected function onPreRender():void
		{
			//_chatBubble.text = mouseX + "," + mouseY;
			scene.rotationY++;
		}
	}
}