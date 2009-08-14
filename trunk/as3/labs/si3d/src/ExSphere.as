// forked from keim_at_Si's Depth buffer test
// forked from keim_at_Si's Regular Solid Structures
// forked from keim_at_Si's Code based Structure Synth
// Code based Structure Synth
//  Structure Synth; http://structuresynth.sourceforge.net/
//------------------------------------------------------------
package
{
	import com.si3d.geom.*;
	import com.si3d.lights.*;
	import com.si3d.materials.*;
	import com.si3d.objects.*;
	import com.si3d.render.*;
	import com.si3d.ui.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.filters.*;
	import flash.geom.*;
	import flash.text.*;
	import flash.utils.*;
	
	import net.hires.debug.Stats;
	
	import structuresynth.*;

	[SWF(width='465', height='465', backgroundColor='#000000', frameRate='30')]
	public class ExSphere extends Sprite
	{
        [Embed(source = "images/cube_texture.png")]
        private var image:Class;
        private var texture:BitmapData = Bitmap(new image()).bitmapData;
		
		private const WIDTH:int=450;
		// 3D renders
		private var _materials:Vector.<Material>=new Vector.<Material>();
		private var _light:Light=new Light(1, 0.5, 0.25);
		private var _screen:BitmapData=new BitmapData(WIDTH, WIDTH, false, 0);
		private var _matbuf:Matrix=new Matrix(1, 0, 0, 1, 225, 225);
		private var gl:Render3D=new Render3D(300, 1);
		private var ss:StructureSynth=new StructureSynth();
		private var tf:TextField=new TextField();

		// objects
		private var camera:Vector3D;
		private var struct:Vector.<ProjectionMesh>=new Vector.<ProjectionMesh>(5, true);
		private var _depth:BitmapData;
		private var _ssao:BitmapData;
		private var _mask:BitmapData;

		// motions
		private var clicked:Boolean=false;
		private var frame:int=0;

		// entry point
		function ExSphere()
		{
			stage.scaleMode = StageScaleMode.NO_SCALE

			camera=new Vector3D(0, 0, -50);
			_depth=new BitmapData(WIDTH, WIDTH, false, 0);
			_ssao=new BitmapData(WIDTH, WIDTH, false, 0);
			_mask=new BitmapData(WIDTH, WIDTH, false, 0);

			_materials.push(
				(new Material()).setColor(0xff8080, 64, 192, 8, 40), 
				(new Material()).setColor(0xd0d080, 64, 192, 8, 40), 
				(new Material()).setColor(0x80ff80, 64, 192, 8, 40), 
				(new Material()).setColor(0x80c0c0, 64, 192, 8, 40), 
				(new Material()).setColor(0x8080ff, 64, 192, 8, 40)
			);

			tf.autoSize="left";
			//tf.htmlText="<font face='_typewriter'>Click to switch on/off ambient occlusion.</font>";
			addChild(gl).visible=false;
			with (addChild(new Bitmap(_screen)))
			{
				x=y=7;
			}
			with (addChild(tf))
			{
				x=y=7;
			}
			addEventListener("enterFrame", _onEnterFrame);

			// register meshes
			/*
			ss.primitive("sphere", SolidFactory.sphere(new Mesh(), 4, 4)); // 4vertices/4triangles
			ss.root("md1", "{s5}sphere");
			struct[0]=new ProjectionMesh(ss.exec(new Mesh(_materials)).updateFaces());
			*/
			
			var plane:Mesh = SolidFactory.plane(new Mesh(), 4, 4);
			ss.primitive("plane", plane); // 4vertices/4triangles
			ss.root("md1", "{s5}plane");
			struct[0]=new ProjectionMesh(ss.exec(new Mesh(_materials)).updateFaces(false,180,plane.texCoord));
			
			addChild(new Stats());
		}

		private function _onEnterFrame(e:Event):void
		{
			frame++;

			// projection
			_light.transformBy(gl.id().tv(camera).rx((400 - mouseY) * 0.25).ry((232 - mouseX) * 0.75).matrix);
			var render3D:Render3D = gl.push().rx(frame).project(struct[0]).pop();
			struct[0].nearZ=-10;
			struct[0].farZ=-80;

			// draw
			_screen.fillRect(_screen.rect, 0xffffff);
			//_screen.draw(gl.renderSolid(struct[0], _light), _matbuf);
			_screen.draw(gl.renderTexture(struct[0], texture), _matbuf);
		}
	}
}