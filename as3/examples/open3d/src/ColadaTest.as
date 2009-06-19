package  
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.TriangleCulling;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix3D;
	import flash.geom.PerspectiveProjection;
	import flash.geom.Utils3D;
	import flash.geom.Vector3D;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import open3d.view.SimpleView;	
	
	[SWF(width=800, height=600, backgroundColor=0x666666, frameRate=30)]
	
	/**
	 * @author kris@neuroproductions.be
	 */
	public class ColadaTest  extends SimpleView
	{
		private var indices : Vector.<int>
		private var uvts : Vector.<Number>
		private var vertices : Vector.<Number>
		private var materials : Object
		private  var __triangles : Array
		private var holder3D : Sprite = new Sprite()
		private var defaultBmd : BitmapData 
		private var gradientSprite : Sprite = new Sprite()
		private var stateCount : int = 1
		private var m : Matrix3D
		private var back : Sprite = new Sprite()
		private var drawcount : uint;
		private var __trianglesperDraw : uint = 10000
		private var resultBmd : BitmapData
		private var bitmap : Bitmap = new Bitmap()

		public function ColadaTest()
		{
			stage.align = StageAlign.TOP_LEFT
			//stage.scaleMode = StageScaleMode.NO_SCALE
			
			defaultBmd = new BitmapData(5, 5, true, 0)

			
			back.graphics.beginFill(0)
			back.graphics.drawRect(0, 0, 1000, 1000)
			back.buttonMode = true
			
			this.addChild(back)
			
			
			
			
			holder3D.x = 0
			holder3D.y = 0
			holder3D.mouseChildren = false
			holder3D.mouseEnabled = false
			this.addChild(holder3D)
			
			
			var urlLoader : URLLoader = new URLLoader()
			urlLoader.addEventListener(Event.COMPLETE, urlComplete)
			urlLoader.load(new URLRequest(ColladaParser.LOCATION+ "Chameleon.dae"))
			
			this.addChild(bitmap)
			
			var btn : Sprite = new Sprite()
			btn.graphics.beginFill(0x2eabff)
			btn.graphics.drawCircle(50, 50, 40)
			btn.buttonMode =true
			this.addChild(btn)
			btn.addEventListener(MouseEvent.CLICK, switchModel)
		}

		private var scale : Number = 0.007
		//10
		private var ypos : Number = 500
		
		//2000
		public function switchModel(e : MouseEvent) : void
		{
			this.removeEventListener(Event.ENTER_FRAME, project)
			this.removeEventListener(Event.ENTER_FRAME, render)
			
			stateCount == 1
			bitmap.visible = false
			
			if (ypos == 500)
			{
				ypos = 2000
				scale = 10
				var url : String =ColladaParser.LOCATION+ "male.dae"
			}
			else
			{
				ypos = 500
				scale = 0.007
				url =ColladaParser.LOCATION+ "Chameleon.dae"
			}
		
			var urlLoader : URLLoader = new URLLoader()
			urlLoader.addEventListener(Event.COMPLETE, urlComplete)
			urlLoader.load(new URLRequest(url))
		}
private var colladaParser: ColladaParser 
		private function urlComplete(event : Event) : void
		{
			var loader : URLLoader = event.currentTarget as URLLoader
			colladaParser = new ColladaParser()
			colladaParser.parse(new XML(loader.data), scale)
			
			renderer.addChild(colladaParser);
			renderer.world.z = 5000;
			//colladaParser.scaleX = colladaParser.scaleY = colladaParser.scaleZ = .5
			
			indices = colladaParser.indicesFull
			uvts = colladaParser.uvtsFull
			vertices = colladaParser.verticesFull
			__triangles = colladaParser.__triangles
			materials = colladaParser.materials
			
			resultBmd = new BitmapData(1000, 1000, true, 0)
			this.addEventListener(Event.ENTER_FRAME, project)
			
			back.buttonMode = true
			back.addEventListener(MouseEvent.CLICK, switchState)
		}

		private function switchState(event : MouseEvent) : void
		{
			
			if (stateCount == 0)
			{
				stateCount = 1
				//resultBmd = new BitmapData(1000, 1000, true, 0)
				this.removeEventListener(Event.ENTER_FRAME, project)
				this.addEventListener(Event.ENTER_FRAME, render)
				//bitmap.visible = true
			}
			else
			{
				this.addEventListener(Event.ENTER_FRAME, project)
				this.removeEventListener(Event.ENTER_FRAME, render)
				stateCount = 0
				//bitmap.visible = false
			}
		}

		private function render(event : Event=null) : void
		{ 
			resultBmd = new BitmapData(1000, 1000, true, 0)
			//return;
			stateCount = 1
			//if (stateCount == 1)
			{
				drawcount = 0
				sortTriangles()
				stateCount++
				holder3D.graphics.clear();
				holder3D.graphics.beginBitmapFill(defaultBmd)
			}
			//if (stateCount == 2)
			{
				var num : int = __trianglesperDraw + drawcount
				if (num > __triangles.length)
				{
					num = __triangles.length
					stateCount = 3
				}
				holder3D.graphics.clear();
				var currentMat : String
				
				var triangle_arr : Array = new Array()
				
				for (var i : Number = 0;i < __triangles.length; i++)
				{
					
					var vertices2D : Vector.<Number> = new Vector.<Number>();
					var t : Triangle = __triangles[i];
					var mat : String = t.mat
					
					//test
					/*var triangle_arr:Array =new Array()
					if (currentMat != mat)
					{
					draw(triangle_arr,mat)
					triangle_arr =new Array()
					
					}
					triangle_arr.push(t)
					 **/
					
					// endtest
					Utils3D.projectVectors(m, t.vertices, vertices2D, t.uvData) ;
					
					var bmdmat : BitmapData
					var material : Material2 = materials[t.mat]
					if (material == null)
					{
						bmdmat = defaultBmd
					}
					else
					{
						bmdmat = material.bmd
					}
					
					
					holder3D.graphics.beginBitmapFill(bmdmat, null, true, true);
					holder3D.graphics.drawTriangles(vertices2D, t.indices, t.uvData, TriangleCulling.NEGATIVE); 
				}
				drawcount += __trianglesperDraw
				resultBmd.draw(holder3D, null, null, null, null, true)
			
				bitmap.bitmapData = resultBmd
			}
			//if (stateCount == 3)
			{
				holder3D.graphics.clear();
				bitmap.bitmapData = resultBmd
				stateCount = 1
			}
		}
/*
		private function __draw(triangle_arr : Array,mat : String) : void
		{
			var verticesDraw : Vector.<Number> = new Vector.<Number>();
			var uvDataDraw : Vector.<Number> = new Vector.<Number>();
			var vertices2D : Vector.<Number> = new Vector.<Number>();
			var indicesDraw : Vector.<int> = new Vector.<int>();
			for (var i : uint = 0 ;i < triangle_arr.length; i++)
			{
				var t : Triangle = triangle_arr[i]
				verticesDraw.push(t.vertices)
				uvDataDraw .push(t.uvData)
				indicesDraw.push(i * 3)
				indicesDraw.push(i * 3 + 1)
				indicesDraw.push(i * 3 + 2)
			}
			Utils3D.projectVectors(m, verticesDraw, vertices2D, uvDataDraw) ;
			
			var bmdmat : BitmapData
			var material : Material2 = materials[mat]
			if (material == null)
			{
				bmdmat = defaultBmd
			}
			else
			{
				bmdmat = material.bmd
			}
			holder3D.graphics.beginBitmapFill(bmdmat, null, true, true);
			holder3D.graphics.drawTriangles(vertices2D, indicesDraw, uvDataDraw, TriangleCulling.NEGATIVE); 
		}
*/
		private function sortTriangles() : void
		{
			for (var i : Number = 0;i < __triangles.length; i++)
			{
				var t : Triangle = __triangles[i]
				t.project(m)
			}
			__triangles.sortOn("screenZ", Array.NUMERIC)//| Array.DESCENDING);
		}

		private function project(e : Event = null) : void
		{
			//return;
			var vertices2D : Vector.<Number> = new Vector.<Number>();
			
	
			m = new Matrix3D()
			//
			var pp : PerspectiveProjection = new PerspectiveProjection()   
			pp.focalLength = 3000
			//pp.fieldOfView = 30
			m = pp.toMatrix3D()
			m.prependTranslation(1050, ypos, 7000)
		
			var rotPoint2 : Vector3D = new Vector3D(0, 0, 0)
			m.prependRotation(((mouseY) / 20) + 50, Vector3D.X_AXIS, rotPoint2)
			m.prependRotation(((mouseX) / 2) + 90, Vector3D.Z_AXIS, rotPoint2)
		
		
			Utils3D.projectVectors(m, vertices, vertices2D, uvts)  
			
			
			
			holder3D.graphics.clear();
			
			holder3D.graphics.lineStyle(1, 0x2eabff, 1)
		
		
			holder3D.graphics.drawTriangles(vertices2D, indices, uvts, TriangleCulling.NEGATIVE); 
			//holder3D.graphics.drawTriangles(vertices2D, null, null, TriangleCulling.NEGATIVE); 
			holder3D.graphics.endFill();
			
			
			render();
		}
	}
}
