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
	public class ExScreenSpaceAmbientOcclusion extends Sprite
	{
        [Embed(source = "images/grid2.jpg")]
        private var image:Class;
		
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
		function ExScreenSpaceAmbientOcclusion()
		{
			//stage.quality="low";
			stage.scaleMode = "noScale";

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
			tf.htmlText="<font face='_typewriter'>Click to switch on/off ambient occlusion.</font>";
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
			stage.addEventListener("click", _onClick);

			// register meshes
			ss.primitive("tetra", SolidFactory.tetrahedron(new Mesh(), 1, 0)); // 4vertices/4triangles
			ss.primitive("box", SolidFactory.hexahedron(new Mesh(), 1, 1)); // 8vertices/12triangles
			ss.primitive("octa", SolidFactory.octahedron(new Mesh(), 1, 2)); // 6vertices/8triangles
			ss.primitive("dodeca", SolidFactory.dodecahedron(new Mesh(), 1, 3)); // 12vertices/36triangles
			ss.primitive("icosa", SolidFactory.icosahedron(new Mesh(), 1, 4)); // 20vertices/20triangles
			// struct[0]
			ss.root("md6", "{s4}{x-4y-4z-4}s4rx");
			ss.rule("s4rx", "", "{s1.5}icosa{z2x2}s4rz{y2z2}s4ry{x2y2}s4rx");
			ss.rule("s4ry", "", "{s1.5}icosa{z2x2}s4rz{y2z2}s4ry");
			ss.rule("s4rz", "", "{s1.5}icosa{z2x2}s4rz");
			struct[0]=new ProjectionMesh(ss.exec(new Mesh(_materials)).updateFaces());
			
			addChild(new Stats());
		}

		private function _onEnterFrame(e:Event):void
		{
			frame++;

			// projection
			_light.transformBy(gl.id().tv(camera).rx((400 - mouseY) * 0.25).ry((232 - mouseX) * 0.75).matrix);
			gl.push().rx(frame).project(struct[0]).pop();
			struct[0].nearZ=-10;
			struct[0].farZ=-80;

			// calculate screen space mbient occlusion
			_depth.fillRect(_depth.rect, 0);
			_depth.draw(gl.renderDepth(struct[0]), _matbuf);
			
			if (!clicked)
			{
				_ssao.applyFilter(_depth, _depth.rect, _depth.rect.topLeft, blur);
				_ssao.draw(_depth, null, null, "subtract");
				_ssao.threshold(_depth, _depth.rect, _depth.rect.topLeft, "==", 0, 0, 255);
			}
			
			// draw
			_screen.fillRect(_screen.rect, 0x000000);
			_screen.draw(gl.renderSolid(struct[0], _light), _matbuf);
			//_screen.draw(gl.renderTexture(struct[0],Bitmap(new image()).bitmapData), _matbuf);
			//_screen.draw(gl.renderWire(struct[0], 0xFF0000));
			if (!clicked)
			{
				_screen.draw(_ssao, null, colt, "multiply");
			}
		}
		private var blur:BlurFilter=new BlurFilter(64, 64);
		private var colt:ColorTransform=new ColorTransform(-8, -8, -8, 1, 255, 255, 255, 0);

		private function _onClick(e:Event):void
		{
			clicked=!clicked;
		}
	}
}