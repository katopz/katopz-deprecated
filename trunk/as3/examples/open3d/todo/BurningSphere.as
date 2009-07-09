
package 
{
	/**
	 * 
	 * Petri Leskinen, Finland, Espoo, 1th June 2009
	 * leskinen[dot]petri[at]luukku[dot]com
	 * 
	 */
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.TriangleCulling;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Matrix3D;
	import flash.geom.PerspectiveProjection;
	import flash.geom.Utils3D;
	import flash.geom.Vector3D;
	
	import flash.text.TextField;
	
	import flash.utils.getTimer;
	
	import MeshParticle;
	import MeshConnection;
	import MeshTriangle;
	
	[SWF(width=1000, height=500, backgroundColor=0x101020, frameRate=24)]
	
	public class BurningSphere extends Sprite
	{
		
		public var particles:Vector.<MeshParticle>,
			connections:Vector.<MeshConnection>,
			triangs:Array,
			indices:Vector.<int>,
			vertices:Vector.<Number>,
			uvtData:Vector.<Number>,
			projectedVerts:Vector.<Number>,
			bmd:BitmapData,
			rotAxis:Vector3D,
			rotSpeed:Number,
			mtrx:Matrix3D,
			light:Object,
			showGrid:Boolean = false;
		
		internal var i:int, j:int, id:int;
		internal var tmp:Number, txt:TextField, side:Number, radius:Number,
			clickTime:Number =0.0;
		
		
		public function BurningSphere ():void {
			init();
		}
		
		private function init():void {
			txt = new TextField();
			txt.x = txt.y = 100.0;
			addChild(txt);
			txt.text = "";
			txt.textColor = 0xFFFFFFFF;
			//txt.selectable = false;
			
			x = stage.stageWidth >>1;
			y = stage.stageHeight >>1;
			
			createMesh();
			
			bmd = initBitmapData();
			
			var perspective:PerspectiveProjection = new PerspectiveProjection();
			perspective.fieldOfView = 4.0; // = almost isometric
			
			mtrx = perspective.toMatrix3D();
			mtrx.prependTranslation(0, 0, -20*400);
			
			light = { x:0.3, y:0.7, z:0.6 };
			normalize(light);
			
			rotAxis = new Vector3D(0, -1, 0);
			rotSpeed = 1.0;
			
			enterFrame();
			addEventListener(Event.ENTER_FRAME, enterFrame);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoved);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyPressed);
			
		}
		
		private function createMesh():void {
			var po:MeshParticle, 
				tr:MeshTriangle;
			triangs = [];
			/*
			 
			//	vertices for an octahedron
			radius = 200;
			var r2:Number = 0.707 * radius;
			
			
			
			particles = Vector.<MeshParticle>([
				new MeshParticle(0.0,0.0,-radius,	id++  ),
				new MeshParticle(-(tmp=1.0)*r2,-r2,0.0,		id++   ),
				new MeshParticle(tmp*r2,-r2,0.0,		id++   ),
				new MeshParticle(tmp*r2,r2,0.0, 		id++   ),
				new MeshParticle(-tmp*r2,r2,0.0,		id++   ),
				new MeshParticle(0.0,0.0, radius,	id++  )
			]);
			
			var pointTriangs:Array = 
				[
					[5, 2, 1 ],
					[5, 3, 2 ],
					[5, 4, 3 ],
					[5, 1, 4 ],
					[0, 1, 2 ],
					[0, 2, 3 ],
					[0, 3, 4 ],
					[0, 4, 1 ]
				];
				
		
			*/
			  
			//	vertices for a icosahedron 
			side = 200;
			radius = side * Math.sqrt(2 * (tmp = Math.sqrt(5.0)) * (1.0 + tmp)) / 4.0;
			var oneFifth:Number = 2.0 * Math.PI / 5;
			//	r2 = radius on the 'pentagonal level'
			var r2:Number = side/Math.sqrt(2.0-2.0*Math.cos(oneFifth));
			//	z of the 'pentagonal level'
			var level0:Number = Math.sqrt(radius*radius-r2*r2);
			
			particles = Vector.<MeshParticle>([
			//	'north pole'
				new MeshParticle(0.0, 0.0, radius, id++), 
			
			//	'tropic of cancer'
				new MeshParticle(0.0, r2, level0,	//	1
								id++ ),
				new MeshParticle(r2 * Math.sin(tmp = oneFifth), r2 * Math.cos(tmp), level0,	//	2
								id++ ),
				new MeshParticle(r2 * Math.sin(tmp += oneFifth), r2 * Math.cos(tmp), level0,	//	3
								id++ ),
				new MeshParticle(r2 * Math.sin(tmp += oneFifth), r2 * Math.cos(tmp), level0,	//	4
								id++ ),
				new MeshParticle(r2 * Math.sin(tmp += oneFifth), r2 * Math.cos(tmp), level0,	//	5
								id++ ),
				
			//	'tropic of capricorn'	
				new MeshParticle(r2 * Math.sin(tmp = 0.5*oneFifth), r2 * Math.cos(tmp), -level0,	//	6
								id++ ),
				new MeshParticle(r2 * Math.sin(tmp += oneFifth), r2 * Math.cos(tmp), -level0,	//	7
								id++ ),
				new MeshParticle(r2 * Math.sin(tmp += oneFifth), r2 * Math.cos(tmp), -level0,	//	8
								id++ ),
				new MeshParticle(r2 * Math.sin(tmp += oneFifth), r2 * Math.cos(tmp), -level0,	//	9
								id++ ),
				new MeshParticle(r2 * Math.sin(tmp += oneFifth), r2 * Math.cos(tmp), -level0,	//	10
								id++ ),
								
			//	'south pole'					
				new MeshParticle(0.0, 0.0, -radius,	id++) 
				]);
			
			var pointTriangs:Array =[
				[i=1, 0, ++i ],
				[i, 0, ++i ],
				[i, 0, ++i ],
				[i, 0, ++i ],
				[i, 0, 1 ],
				
				[1, 2, 6 ],
				[2, 7, 6 ],
				[2, 3, 7 ],
				[3, 8, 7 ],
				[3, 4, 8 ],
				[4, 9, 8 ],
				[4, 5, 9 ],
				[5, 10, 9 ],
				[5, 1, 10 ],
				[1, 6, 10 ],
				
				[i=6, ++i, 11 ],
				[i, ++i, 11 ],
				[i, ++i, 11 ],
				[i, ++i, 11 ],
				[i, 6, 11 ]
			];
			
			
			triangs = [];
			for each(var face:Array in pointTriangs) {
				triangs.push(
					new MeshTriangle(
						particles[face[0]], 
						particles[face[1]], 
						particles[face[2]]
					)
				)
			}
			
			
			//	subdivided four times, final number of triangles 20x4x4x4x4, 5120
			triangs = tessalate(triangs, particles);
			triangs = tessalate(triangs, particles);
			triangs = tessalate(triangs, particles);
			triangs = tessalate(triangs, particles);
			
			
			//	Link the vertices to each other by triangles
			for each( tr in triangs) {
				tr.point0.connect(tr.point1);
				tr.point0.connect(tr.point2);
				tr.point1.connect(tr.point2)
			}
			
			//	for the animation, we'll need some info also on how points connect each other
			connections = new Vector.<MeshConnection>();
			for each (po in particles) {
				for each (var mc:MeshConnection in po.connections) {
					// this condition is to avoid having a connection twice, (a,b) and (b,a)
					if (po == mc.point1) {
						connections.push(mc);
					}
				}
			}
			/*
			txt.htmlText = "Vertices: " + particles.length +
				"\nTriangles: " + triangs.length +
				"\nEdges: " + connections.length;
			
			 characterics:
			  	Vertices: 2562
				Triangles: 5120
				Edges: 7680
				V +F - E = 2562 + 5120 - 7680 = 2 (2: topologically it's a sphere with zero holes ! )
				
			*/
		}
		
		
		private function initBitmapData():BitmapData {
			//	u-dimension is for shading	
			// 	v-dimension is the 'heat' on that particular vertex
			var bmd:BitmapData = new BitmapData(64, 5, false, 0xFF200020),
				pxl:uint;
				
			for (i = 0; i != bmd.width; i++) {
				pxl = 0x80 * i / bmd.width;
				//bmd.setPixel32(i, 0, 0xFF200020 );
				bmd.setPixel32(i, 1, 0xFF200000 );
				bmd.setPixel32(i, 2, 0xFF000000 | (pxl<<16) | ((pxl<<6) &0xFF00));
				bmd.setPixel32(i, 3, 0xFFFFA000);
				bmd.setPixel32(i, 4, 0xFFFFF0F0);
			}
			return bmd;
		}
		
		//private var tick:Number = 0.0;
		
		private function enterFrame(e:Event = null):void {
			
			vertices = new Vector.<Number>();
			uvtData = new Vector.<Number>();
			projectedVerts = new Vector.<Number>(particles.length <<1);
			
			var u:Number, v:Number, startT:Number = -getTimer();
			
			//	for smooter animation
			//	each enterframe the animation takes actually two steps:
			//	functions po.renew();mc.evaluate() and po.step() are all called twice
			
			//	po.renew sets the default acceleration
			//	mc.evaluate counts the forces dragging points towards or from each other
			//	po.step updates the position 
			
			for each (var po:MeshParticle in particles) po.renew();
			for each (var mc:MeshConnection in connections) mc.evaluate();
			for each (po in particles) {
				po.step(0.02);
				
				po.renew();
			}
			for each (mc in connections) mc.evaluate();
			for each (po in particles) {
				po.step(0.02);
				
				po.pushVertices(vertices);
				
				//	u-coordinate is by the angle between point and light direction
				u = light.x * po.x + light.y * po.y + light.z * po.z;
				u /= po.distance; 
				u = 0.49 * u + 0.5;
				
				//	v-coordinate is by the distance how far from equilibrium this point's gotten
				v = po.distanceSquared / 
					(po.xOrig * po.xOrig +po.yOrig * po.yOrig +po.zOrig * po.zOrig);
				v = 2.5 * v  -2.0;	
				v = (v > 0.99) ? 0.99 : (v < 0.10) ? 0.10 : v;
				
				//	wouldn't work witout t=1.0
				uvtData.push(u,v,1.0);
				
			}
			var animTime:Number = startT + getTimer();
			startT = -getTimer();
			
			//	rotate the scene
			mtrx.prependRotation (rotSpeed, rotAxis);
			
			//	3D to 2D
			Utils3D.projectVectors(mtrx, vertices, projectedVerts, uvtData);
			
			//	sort the triangles for the correct display order
			//	notice I'm using uvtData's t-coordinate instead of z
			for each (var tr:MeshTriangle in triangs) {
				tmp = uvtData[tr.id0 * 3 + 2];
				
				i = tr.id1 * 3 + 2;
				tmp = (uvtData[i] < tmp) ? uvtData[i] : tmp;
				
				i = tr.id2 * 3 + 2;
				tr.z = (uvtData[i] < tmp) ? uvtData[i] : tmp;
			}
			triangs.sortOn("z", Array.NUMERIC | Array.DESCENDING );
			
			indices = new Vector.<int>();
			for each (tr in triangs) tr.pushIndices(indices);
			
			//	the final touch
			with (graphics) {
				clear();
				
				if (showGrid) lineStyle(1.0, 0xFFFFFF, 0.25);
				
				beginBitmapFill(bmd ,
								null, 	//	no matrix
								true,	//	= repeat
								true);	//	= smooth
				
				drawTriangles(projectedVerts, 
							  indices,
							  uvtData, 
							  TriangleCulling.NEGATIVE);
							  
				endFill();
			}
			
			//	var drawTime:Number = startT + getTimer();
			//	txt.htmlText = "" + animTime + "\n" + drawTime +"\n" +clickTime;
		}
		
		private function detectMouse(e:Event = null) :void {
			//	how to find out of 5000 triangles the ones under the mouse
			
			var checkX:Vector.<Boolean> = new Vector.<Boolean>(particles.length),
				checkY:Vector.<Boolean> = new Vector.<Boolean>(particles.length),
				checkPo:Vector.<Boolean> = new Vector.<Boolean>(particles.length),
				j:int=0;
			
			//	for faster performance
			//	checkX = array of booleans if point's x is smaller/larger than mouseX
			//	checkY likewise for mouseY
			//	remember that projectedVerts consists of x-y-pairs
			for (var i:int = 0; i != particles.length; i++) {
				checkX[i] = (projectedVerts[j++] > mouseX);
				checkY[i] = (projectedVerts[j++] > mouseY);
			}
			
			//	filters out the triangles completely on the left or right side of the mouse 
			//	Out of a spherical mesh something like 50-70 triangles will pass
			for each (var tr:MeshTriangle in triangs) {
				//	check if x passes
				//	Out of a spherical mesh something like 50-70 triangles will pass
				if (!(checkX[tr.id0] == checkX[tr.id1] &&
					checkX[tr.id0] == checkX[tr.id2])) {
						
					//	check if y passes
					//	now the number of triangles is reduced to ~5-10
					if (!(checkY[tr.id0] == checkY[tr.id1] &&
						checkY[tr.id0] == checkY[tr.id2])) {
						
						//	cross product, check if triangle's facing the view point
						i = tr.id0 << 1;
						var dx0:Number = projectedVerts[tr.id1 << 1] - projectedVerts[i],
							dx1:Number = projectedVerts[tr.id2 << 1] - projectedVerts[i],
							dy0:Number = projectedVerts[(tr.id1 << 1) + 1] - projectedVerts[++i],
							dy1:Number = projectedVerts[(tr.id2 << 1) + 1] - projectedVerts[i];
							
						if (dx0 * dy1 > dx1 * dy0) checkPo[tr.id0] = checkPo[tr.id1] = checkPo[tr.id2] = true;
					
						}
				}
			}
			
			//	add some velocity to points found near the mouse
			//	tmp controls how high the flames might get
			tmp = -4.0; 
			for (i = 0; i != particles.length; i++) {
				if (checkPo[i]) {
					particles[i].vx = tmp*particles[i].x;
					particles[i].vy = tmp*particles[i].y;
					particles[i].vz = tmp*particles[i].z;
				}
			}
			
			//	Results for time testing was something less than 10 ms
			//clickTime += getTimer();
			//txt.htmlText = "" + clickTime;
			
		}
		
		//	some interesting approach I wanted to keep here:
		private function detectMouseOld(e:Event = null):void {
			
			var s:Sprite = new Sprite(), j:int;
			
			clickTime = -getTimer();
			
			for (var i:int = 0; i != triangs.length; i++) {
				s.graphics.beginFill(i + 1, 1.0);
				s.graphics.lineStyle(0, 0, 0);
				
				s.graphics.moveTo(projectedVerts[j=triangs[i].id0<<1], projectedVerts[++j]);
				s.graphics.lineTo(projectedVerts[j=triangs[i].id1<<1], projectedVerts[++j]);
				s.graphics.lineTo(projectedVerts[j=triangs[i].id2<<1], projectedVerts[++j]);
							  
				s.graphics.endFill();
			}
			
			var checkBmd:BitmapData = new BitmapData(1, 1, true, 0x00);
			checkBmd.draw(s, new Matrix(1,0,0,1, -mouseX,-mouseY));
			i = checkBmd.getPixel(0, 0);
			
			clickTime += getTimer();
			
			if (i != 0) {
				i--;
				s.graphics.clear();
				s.graphics.beginFill(0xFFFFFF, 1.0);
				j = triangs[i].id0 <<1;
				s.graphics.moveTo(projectedVerts[j], projectedVerts[++j]);
				j = triangs[i].id1 <<1;
				s.graphics.lineTo(projectedVerts[j], projectedVerts[++j]);
				j = triangs[i].id2 <<1;
				s.graphics.lineTo(projectedVerts[j], projectedVerts[++j]);
				
				s.graphics.endFill();
				//addChild(s);
				addRandom(i);
				//txt.htmlText = "i =" + i;
			}
			//addChild(new Bitmap(checkBmd));
			
		}
		
		
		
		//	subdivides the triangle mesh once:
		public function tessalate(triangles:Array, particles:Vector.<MeshParticle>):Array {
			var newTriangles:Array = [],
				po1:MeshParticle, po2:MeshParticle, po3:MeshParticle;
			
			for each (var tr:MeshTriangle in triangles) {
				
				po1 = tr.point0;
				po2 = tr.point1;
				po3 = tr.point2;
				
				//	divide each edge, parameter midPointTo used for checking if the middle point is already defined
				if (po1.midPointTo[po2.id] == null) middlepolate(po1, po2, particles);
				if (po2.midPointTo[po3.id] == null) middlepolate(po2, po3, particles);
				if (po3.midPointTo[po1.id] == null) middlepolate(po1, po3, particles);
				
				//	divide each old triangle into four new ones
				newTriangles.push(
					new MeshTriangle(po1, po1.midPointTo[po2.id], po3.midPointTo[po1.id]),
					new MeshTriangle(po2, po2.midPointTo[po3.id], po1.midPointTo[po2.id]),
					new MeshTriangle(po3, po3.midPointTo[po1.id], po2.midPointTo[po3.id]),
					new MeshTriangle(po1.midPointTo[po2.id], po2.midPointTo[po3.id], po3.midPointTo[po1.id])
				
				);
				
			}
			
			return newTriangles; // usually replaces the old ones
		}
		
		private function middlepolate(po1:MeshParticle, po2:MeshParticle, particles:Vector.<MeshParticle>):MeshParticle {
			//	create a midpoint
			var poNew:MeshParticle = po1.midPoint(po2);
			
			//	normalized to a sphere
			poNew.normalize(radius);
			poNew.setOriginalPosition();
			
			//	id's used for easier indexing, tells the position on a list
			//	id's so that particles[poNew.id] == poNew
			poNew.id = particles.length;
			particles.push( poNew);
			
			return poNew;
		}
		
		private function mouseMoved(e:MouseEvent):void {
			
			rotAxis.x = -mouseY;
			rotAxis.y = mouseX;
			rotAxis.z = 0.0;
			normalize(rotAxis);
			
			rotSpeed = 2.0*Math.sqrt(mouseX * mouseX + mouseY * mouseY) / radius;
			
			
			detectMouse();
		}
		
		private function keyPressed(e:KeyboardEvent):void {
			
			// txt.text = "" + e.keyCode; // enter =13
			//	pressing esc or delete
			if (	e.keyCode == 27 
				||	e.keyCode==46) destroy() else showGrid = !showGrid;
		}
		
		private function destroy():void {
			var tmp:Number = 6;
			for each (var po:MeshParticle in particles) {
				po.vx = tmp * (Math.random() * Math.random())  * po.x;
				po.vy = tmp * (Math.random() * Math.random())  * po.y;
				po.vz = tmp * (Math.random() * Math.random())  * po.z
			}
		}
		
		
		
		private function addRandom(i:int):void {
			addRandom2(triangs[i]);
		}
		
		private function addRandom2(tr:MeshTriangle):void {
			
			//	this adds some action on the surface, when hovered
			var tmp:Number = -2.0;
			var j:int = tr.id0;
				particles[j].vx = tmp*particles[j].x;
				particles[j].vy = tmp*particles[j].y;
				particles[j].vz = tmp*particles[j].z;
			j = tr.id1;
				particles[j].vx = tmp*particles[j].x;
				particles[j].vy = tmp*particles[j].y;
				particles[j].vz = tmp*particles[j].z;
			j = tr.id2;
				particles[j].vx = tmp*particles[j].x;
				particles[j].vy = tmp*particles[j].y;
				particles[j].vz = tmp*particles[j].z;
			
		}
		
		private function normalize(o:*):void {
			tmp = 1.0 / Math.sqrt(o.x * o.x + o.y * o.y + o.z * o.z);
			o.x *= tmp;
			o.y *= tmp;
			o.z *= tmp;
		}
		
	}
	
}