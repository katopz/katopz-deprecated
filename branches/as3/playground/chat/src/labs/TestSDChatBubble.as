package labs
{
	import away3dlite.containers.Particles;
	import away3dlite.core.base.Particle;
	import away3dlite.materials.ParticleMaterial;
	import away3dlite.templates.BasicTemplate;
	
	import com.cutecoma.playground.components.SDChatBubble;
	
	import flash.display.BitmapData;
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

			var position:Vector3D = new Vector3D(100, 100, 0);

			var _bitmapData:BitmapData = new BitmapData(_chatBubble.width, _chatBubble.height);
			_particleMaterial = new ParticleMaterial(_bitmapData);

			var _chatBubbleParticle:Particle = new Particle(position.x, position.y, position.z, _particleMaterial);
			_chatBubbleParticle.id = "0";
			
			_balloonParticles = new Particles();
			_balloonParticles.addParticle(_chatBubbleParticle);
			scene.addChild(_balloonParticles);

			// listen for draw
			_chatBubble.drawSignal.add(onBubbleDraw);
		}

		private function onBubbleDraw():void
		{
			var _bitmapData:BitmapData = _particleMaterial.bitmapData;
			_bitmapData.dispose();
			_bitmapData.draw(_chatBubble);
		}

		override protected function onPreRender():void
		{
			_chatBubble.text = mouseX + "," + mouseY;
		}
	}
}