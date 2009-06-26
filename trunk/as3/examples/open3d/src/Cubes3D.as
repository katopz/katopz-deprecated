package
{

	import flash.display.BitmapData;
	import flash.display.GraphicsSolidFill;
	import flash.display.GraphicsTrianglePath;
	import flash.display.IGraphicsData;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.display.TriangleCulling;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix3D;
	import flash.geom.Utils3D;
	import flash.geom.Vector3D;
	
	import open3d.utils.ProfilerUtil;
	
	/**
	 * @author kris@neuroproductions.be
	 * 12-13fps
	 */
	[SWF(width=800, height=600, backgroundColor=0x000000, frameRate=30)]

	public class Cubes3D extends Sprite
	{
		public var cube_arr:Array = new Array()
		public var triangles_arr:Array
		public var cubeFactory:CubeFactory = new CubeFactory()
		private var bmd:BitmapData
		private var indicies:Vector.<int> = new Vector.<int>()
		private var holder:Sprite = new Sprite()
		private var lightX:Number = 255
		private var lightY:Number = 255
		private var lightZ:Number = 255
		private var rotXLight:Number = 0
		private var rotYLight:Number = 0
		private var rotX:Number = 150
		private var rotY:Number = 140
		private var isDown:Boolean = false
		private var mouseStartX:Number
		private var mouseStartY:Number
		private var sun:Sprite = new Sprite()
		private var sunHolder:Sprite = new Sprite()

		public function Cubes3D()
		{
			stage.scaleMode = StageScaleMode.NO_SCALE
			stage.align = StageAlign.TOP_LEFT









			sun.graphics.beginFill(0xfff8cc)
			sun.graphics.drawCircle(0, 0, 20)
			sun.filters = [new GlowFilter(0xFFFFFF, 1, 24, 24, 2, 3)]

			indicies.push(0, 1, 2)

			//		bmd = new BitmapData(40, 40, false, 0xFF0000)

			//bmd.fillRect(new Rectangle(0, 10, 10, 10), 0xCC0000)
			//bmd.fillRect(new Rectangle(10, 10, 10, 10), 0x990000)

			mouseStartX = mouseX
			mouseStartY = mouseY



			this.addChild(holder)

			buildCubes()
			this.graphics.beginFill(0x303040)
			this.graphics.drawRect(0, 0, 2000, 3000)
			this.addEventListener(Event.ENTER_FRAME, loop)
			stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown)
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUp)
			
			ProfilerUtil.addStat(this);
		}

		private function mouseDown(event:MouseEvent):void
		{

			isDown = true
			mouseStartX = mouseX + (rotX * 10)
			mouseStartY = mouseY + (rotY * 10)
		}

		private function mouseUp(event:MouseEvent):void
		{

			isDown = false
		}

		public function buildCubes():void
		{
			cube_arr = new Array()
			var size:int = 14
			for (var i:int = 0; i < size; i++)
			{
				var x_arr:Array = new Array()
				cube_arr.push(x_arr)
				for (var j:int = 0; j < size; j++)
				{
					var y_arr:Array = new Array()
					x_arr.push(y_arr)
					for (var k:int = 0; k < size; k++)
					{
						if (Math.random() > 0.15)
						{
							y_arr.push(0)
						}
						else
						{
							y_arr.push(1)
						}
					}
				}
			}
			cubeFactory.setCubes(cube_arr)
			triangles_arr = cubeFactory.triangle_arr
		}

		private function setMouseStuff():void
		{
			if (isDown)
			{
				rotX = (mouseStartX - mouseX) / 10
				rotY = (mouseStartY - mouseY) / 10
			}
			rotXLight += 5 //(mouseStartX-mouseX)/4
			rotYLight += 7 //(mouseStartY-mouseY)/4
			var radX:Number = (rotXLight / 180) * Math.PI
			var radY:Number = (rotYLight / 180) * Math.PI
			lightX = Math.cos(radX) * Math.cos(radY) * 200
			lightY = -Math.sin(radY) * 200
			lightZ = Math.sin(radX) * Math.cos(radY) * 200
		}

		private function loop(event:Event):void
		{

			setMouseStuff()


			holder.graphics.clear()
			holder.x = stage.stageWidth / 2
			holder.y = stage.stageHeight / 2



			var m:Matrix3D = new Matrix3D()

			var pp:Vector3D = new Vector3D(0, 0, 0)
			m.prependTranslation(0, 0, 0)

			m.prependRotation(rotY, Vector3D.X_AXIS, pp)
			m.prependRotation(rotX, Vector3D.Y_AXIS, pp)

			var mLight:Matrix3D = new Matrix3D()
			mLight.interpolateTo(m, 100)
			mLight.prependTranslation(lightX, lightY, lightZ)

			var lightVec:Vector3D = new Vector3D(lightX, lightY, lightZ)
			Utils3D.projectVector(m, lightVec)


			var vSun3D:Vector.<Number> = new Vector.<Number>()
			vSun3D.push(lightVec.x, lightVec.y, lightVec.z)

			var vSunuvt:Vector.<Number> = new Vector.<Number>()
			vSunuvt.push(0, 0)
			var vSun:Vector.<Number> = new Vector.<Number>()
			Utils3D.projectVectors(mLight, vSun3D, vSun, vSunuvt)
			sun.x = vSun[0] + stage.stageWidth / 2
			sun.y = vSun[1] + stage.stageHeight / 2


			Utils3D.projectVectors(mLight, vSun3D, vSun, vSunuvt)
			var lz:Number = Utils3D.projectVector(mLight, new Vector3D(lightX, lightY, lightZ)).z
			if (lz > 0)
			{
				this.addChild(sun)
			}
			else
			{
				this.addChildAt(sun, 0)
			}
			var dist:Number = Vector3D.distance(lightVec, new Vector3D())
			var lightVecN:Vector3D = new Vector3D()
			lightVecN.x = lightVec.x / dist
			lightVecN.y = lightVec.y / dist
			lightVecN.z = lightVec.z / dist
			var graphicsData:Vector.<IGraphicsData> = new Vector.<IGraphicsData>();

			triangles_arr = triangles_arr.sortOn("screenZ", Array.NUMERIC)
			for (var i:int = 0; i < triangles_arr.length; i++)
			{
				var tri:Triangle3D = triangles_arr[i]
				tri.project2(m, lightVecN, lightVec)

				//graphicsData.push(new GraphicsBitmapFill(bmd, null));
				//graphicsData.push(new GraphicsTrianglePath(tri.vertices, indicies, tri.uvts, TriangleCulling.POSITIVE));

				graphicsData.push(new GraphicsSolidFill(tri.color, 1));
				graphicsData.push(new GraphicsTrianglePath(tri.vout, indicies, null, TriangleCulling.POSITIVE));
			}


			holder.graphics.drawGraphicsData(graphicsData);
		}
	}
}
