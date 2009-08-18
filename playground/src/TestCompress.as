package
{
	import com.sleepydesign.playground.core.Engine3D;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.utils.ByteArray;
	
	import org.papervision3d.materials.WireframeMaterial;
	import org.papervision3d.objects.parsers.DAE;
	import org.papervision3d.objects.primitives.Sphere;
	
	[SWF(backgroundColor="0xFFFFFF", frameRate="30", width="640", height="480")]
	public class TestCompress extends Sprite
	{
		//[Embed(source="../bin-debug/assets/man1/model.dae", mimeType="application/octet-stream")]
		//private var Model:Class;
		
		public function TestCompress():void
		{
		    //var model:ByteArray = new Model();
		    var dae:DAE = new DAE();
		    
		      
			var engine3d:Engine3D = new Engine3D(this);
			engine3d.addChild(dae);
			dae.load("assets/man1/model.swf");
			var _sp:Sphere = new Sphere(new WireframeMaterial());
			engine3d.addChild(_sp);
			
			var shape:Shape = new Shape();
			shape.x = 640/2;
			shape.y = 480/2;
			shape.graphics.beginFill(0xFF0000, .1);
			shape.graphics.drawCircle(0,0,200);
			addChild(shape);
			
			engine3d.camera.lookAt(_sp);
			 
			engine3d.start();
			
			alpha = .1
		}
	}
}