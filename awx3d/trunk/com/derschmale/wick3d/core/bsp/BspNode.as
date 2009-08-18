package com.derschmale.wick3d.core.bsp
{
	import com.derschmale.wick3d.cameras.Camera3D;
	import com.derschmale.wick3d.core.geometry.Plane;
	import com.derschmale.wick3d.core.geometry.Triangle3D;
	import com.derschmale.wick3d.core.geometry.Vertex3D;
	import com.derschmale.wick3d.core.objects.SpatialObject3D;
	import com.derschmale.wick3d.debug.GeneralStatData;
	
	import flash.display.Graphics;
	import flash.geom.Vector3D;
	
	/**
	 * A BspNode object can be either a branch or a leaf in a BSP tree. A branch is divided into two half-spaces: a positive and a negative one, each on the side of a dividing plane.
	 * Those half-spaces form new BSP nodes, either another branch or a leaf. That way, the whole space is subdivided into smaller recursive regions.
	 * A leaf is the end of a branch, containing triangles present in that region. It is not divided any further.
	 */
	public class BspNode
	{
		private var _positiveChild : BspNode;
		private var _negativeChild : BspNode;
		
		private var _parent : BspNode;
		
		private var _triangles : Vector.<Triangle3D>;
		
		// temporary values
		private var _trianglesPos : Vector.<Triangle3D>;
		private var _trianglesNeg : Vector.<Triangle3D>;
		private var _trianglesSplit : Vector.<Triangle3D>;
		private var _loopTrianglesPos : Vector.<Triangle3D>;
		private var _loopTrianglesNeg : Vector.<Triangle3D>;
		private var _loopTrianglesSplit : Vector.<Triangle3D>;
		
		private var _partitionPlane : Plane;
		
		/**
		 * Creates a new BspNode object.
		 * 
		 * @param parent The parent BspNode which contains the current node.
		 */
		public function BspNode(parent : BspNode = null)
		{
			_parent = parent;
		}
		
		/**
		 * Traverses the bsp-node with this node as a starting point and draws the triangles contained within.
		 * 
		 * @param camera The camera used to determine on which side of the dividing plane it is, defining the order in which the BSP tree is traversed.
		 * @param graphics The target Graphics object to draw to.
		 * 
		 * @see com.derschmale.wick3d.cameras.Camera3D
		 */
		public function render(camera : Camera3D, graphics : Graphics) : void
		{
			if (_triangles) {
				drawTriangles(graphics);
			}
			else {
				var side : int;
				
				if (camera.frustum) {
					side = testFrustumSide(camera);
				}
				
				if (side == 0) {
					var dot : Number = _partitionPlane.normal.dotProduct(camera.position)+_partitionPlane.d;
					
					if (dot < 0) {
						_positiveChild.render(camera, graphics);
						_negativeChild.render(camera, graphics);
					}
					else {
						_negativeChild.render(camera, graphics);
						_positiveChild.render(camera, graphics);
					}
				}
				// only positive side is visible
				else if (side > 0) {
					_positiveChild.render(camera, graphics);
				}
				// only negative side is visible
				else {
					_negativeChild.render(camera, graphics);
				}
			}
			
		}
		
		/**
		 * Adds a triangle to the node.
		 * 
		 * @param triangle The triangle to add.
		 * 
		 * @see com.derschmale.wick3d.core.geometry.Triangle3D
		 */
		public function addTriangle(triangle : Triangle3D) : void
		{
			if (!_triangles) _triangles = new Vector.<Triangle3D>();
			_triangles.push(triangle);
		}
		
		/**
		 * Adds an array of triangles to the node.
		 *
		 * @param triangles The triangles to add.
		 * 
		 * @see com.derschmale.wick3d.core.geometry.Triangle3D
		 */
		public function addTriangles(triangles : Vector.<Triangle3D>) : void
		{
			var triangle : Triangle3D;
			var i : int = triangles.length;
			if (!_triangles) _triangles = new Vector.<Triangle3D>();
			while ((i>0)&&(triangle = triangles[--i] as Triangle3D)) {
				_triangles.push(triangle);
			}
		}
		
		/**
		 * Builds the BSP tree from this node on. It creates new child nodes if necessary, and invokes the function on the new children.
		 */
		public function build() : void
		{
			_partitionPlane = pickPartitionPlane();
			
			if (!_partitionPlane) {
				clearTempData();
				return;
			}

			_positiveChild = new BspNode();
			_negativeChild = new BspNode();
			splitTriangles();
			_positiveChild.addTriangles(_trianglesPos);
			_negativeChild.addTriangles(_trianglesNeg);
			
			clearTempData();
			_triangles = null;
			_positiveChild.build();
			_negativeChild.build();
		}
		
		/**
		 * Return the leaf (most specific) node containing an object's origin point.
		 * 
		 * @param object The SpatialObject3D of which the position needs to be checked.
		 * @returns The most specific BspNode containing this object.
		 * 
		 * @see com.derschmale.wick3d.core.objects.SpatialObject3D
		 */
		public function childNodeContaining(object : SpatialObject3D) : BspNode
		{
			if (_partitionPlane) {
				// this is a branch
				var dot : Number = _partitionPlane.normal.dotProduct(object.position)+_partitionPlane.d;
				
				if (dot < 0)
					return _negativeChild.childNodeContaining(object);
				else
					return _positiveChild.childNodeContaining(object);
			}
			else {
				// this is a leaf
				return this;
			}
		}
		
		/**
		 * The partition plane used to divide this node. This will be null if the node is a leaf.
		 * 
		 * @see com.derschmale.wick3d.core.geometry.Plane
		 */
		public function get partitionPlane() : Plane
		{
			return _partitionPlane;
		}
		
		public function set partitionPlane(value : Plane) : void
		{
			_partitionPlane = value;
		}
		
		/**
		 * This node's child node on the positive side of the partition plane.
		 */
		public function get positiveChild() : BspNode
		{
			return _positiveChild;
		}
		
		public function set positiveChild(value : BspNode) : void
		{
			_positiveChild = value;
		}
		
		/**
		 * This node's child node on the negative side of the partition plane.
		 */
		public function get negativeChild() : BspNode
		{
			return _negativeChild;
		}
		
		public function set negativeChild(value : BspNode) : void
		{
			_negativeChild = value;
		}
		
		private function pickPartitionPlane() : Plane
		{
			var bestChoice : Plane;
			var currentPlane : Plane;
			var bestScore : Number = Number.MAX_VALUE;
			var currentScore : Number;
			var triangle : Triangle3D;
			var i : int = _triangles.length;
			
			while ((i>0) && (triangle = _triangles[--i] as Triangle3D)) {
				currentPlane = triangle.plane;
				currentScore = getPlaneScore(currentPlane);
				
				if (currentScore > 0 && (currentScore < bestScore)) {
					bestScore = currentScore;
					bestChoice = currentPlane;
					_trianglesPos = _loopTrianglesPos;
					_trianglesNeg = _loopTrianglesNeg;
					_trianglesSplit = _loopTrianglesSplit;
				}
			}
			//trace ("partition plane: "+bestChoice);
			return bestChoice;
		}
		
		
		private function getPlaneScore(plane : Plane) : Number
		{
			var n : Vector3D = plane.normal;
			var dot1 : Number, dot2 : Number, dot3 : Number;
			var sideCount : int = 0;
			var doubtCount : int = 0;
			var triangle : Triangle3D;
			var i : int = _triangles.length;
			
			_loopTrianglesSplit = new Vector.<Triangle3D>();
			_loopTrianglesPos = new Vector.<Triangle3D>();
			_loopTrianglesNeg = new Vector.<Triangle3D>();
			
			while ((i>0) && (triangle = _triangles[--i] as Triangle3D)) {
				sideCount = 0;
				doubtCount = 0;
				dot1 = n.dotProduct(triangle.v1)+plane.d;
				dot2 = n.dotProduct(triangle.v2)+plane.d;
				dot3 = n.dotProduct(triangle.v3)+plane.d;
				
				if (Math.abs(dot1) < 0.01) dot1 = 0;
				if (Math.abs(dot2) < 0.01) dot2 = 0;
				if (Math.abs(dot3) < 0.01) dot3 = 0;
				
				if (dot1 == 0 && dot2 == 0 && dot3 == 0) {
					if (n.subtract(triangle.normal).length < 0.01) {
						_loopTrianglesPos.push(triangle);
					}
					else {
						_loopTrianglesNeg.push(triangle);
					}
					// triangle lies on the plane, determine which side
				}
				else {
					if (dot1 < 0) sideCount--;
					else if (dot1 > 0) sideCount++;
					else doubtCount++;
					
					if (dot2 < 0) sideCount--;
					else if (dot2 > 0) sideCount++;
					else doubtCount++;
					
					if (dot3 < 0) sideCount--;
					else if (dot3 > 0) sideCount++;
					else doubtCount++;
					
					if (sideCount == 3 || (sideCount > 0 && sideCount+doubtCount == 3)) {
						_loopTrianglesPos.push(triangle);
					}
					else if (sideCount == -3 || (sideCount < 0 && sideCount-doubtCount == -3)) {
						_loopTrianglesNeg.push(triangle);
					}
					else {
						_loopTrianglesSplit.push(triangle);
					}
				}
			}
			
			// all polys are on one side
			if ((_loopTrianglesPos.length == 0 || _loopTrianglesNeg.length == 0) && _loopTrianglesSplit.length == 0) return -1;
			
			// calculating score:
			// we want an even distribution of polygons, but more importantly, as least splits as possible
			return Math.abs(_loopTrianglesNeg.length-_loopTrianglesPos.length)+_loopTrianglesSplit.length*3;
		}
		
		private function drawTriangles(graphics : Graphics) : void
		{
			var i : Number = _triangles.length;
			var triangle : Triangle3D;
			
			while ((i>0) && (triangle = _triangles[--i] as Triangle3D)) {
				if (!triangle.isCulled) {
					triangle.material.drawTriangle(triangle, graphics);
					GeneralStatData.drawnPolygons++;
				}
			}
		}
		
		private function splitTriangles() : void
		{
			var triangle : Triangle3D;
			var i : int = _trianglesSplit.length;
			var newTriangles : Vector.<Vector.<Triangle3D>>;
			
			while ((i>0) && (triangle = _trianglesSplit[--i] as Triangle3D)) {
				newTriangles = triangle.splitInViewCoords(_partitionPlane);
				insertNewTriangles(newTriangles[0], _trianglesPos);
				insertNewTriangles(newTriangles[1], _trianglesNeg);
			}
		}
		
		private function insertNewTriangles(source : Vector.<Triangle3D>, target : Vector.<Triangle3D>) : void
		{
			var triangle : Triangle3D;
			var i : int = source.length;
			while ((i>0) && (triangle = source[--i] as Triangle3D)) {
				target.push(triangle);
			}
		}
		
		private function clearTempData() : void
		{
			_trianglesPos = null;
			_trianglesNeg = null;
			_trianglesSplit = null;
			_loopTrianglesPos = null;
			_loopTrianglesNeg = null;
			_loopTrianglesSplit = null;
		}
		
		// returns:
		//	-1 -> frustum entirely in negative halfspace
		//	 0 -> plane intersects frustum
		// 	 1 -> frustum entirely in positive halfspace
		private function testFrustumSide(camera : Camera3D) : int
		{
			var side : int;
			var dist : Number;
			var corners : Vector.<Vertex3D> = camera.frustum.worldCorners;
			var corner : Vertex3D;
			var i : int = corners.length;
			
			while ((i>0) && (corner = corners[--i] as Vertex3D)) {
				// check orientation of frustum corners compared to
				dist = corner.dotProduct(_partitionPlane.normal)+_partitionPlane.d;
				if (Math.abs(dist) < 0.01) dist = 0;
				
				// until on different side of first non-coplanar hit
				if (side == 0) side = dist;
				else if (side*dist < 0) return 0;
			}
			
			return side > 0? 1 : -1;
		}
	}
}