package  
{
	import flash.geom.Vector3D;
	
	/**
	 * @author kris@neuroproductions.be
	 */
	public class CubeFactory 
	{
		
	//	private var indicesCount : int = 0
		private	var size : int =30
		private	var startX : int = 0
		private	var startY : int = 0
		private	var startZ : int = 0
		public var triangle_arr:Array =new Array()
		public function setCubes(cube_arr : Array,size:int =30) : void
		{
			this.size =size
		
			triangle_arr =new Array()
			var l:int =(cube_arr.length/2) *size
			for (var i : int = 0;i < cube_arr.length; i++) 
			{
				var y_arr : Array = cube_arr[i]
				for (var j : int = 0;j < y_arr.length; j++)
				{
					var z_arr : Array = y_arr[j]
					for (var k : int = 0;k < z_arr.length; k++) 
					{
						if (z_arr[k] == 1)
						{
							startX = i * size -l
							startY = j * size -l
							startZ = k * size -l
						
						
							if (z_arr[k - 1] != 1)
							{
								addFront(i, j, k)
							}
							if (z_arr[k + 1] != 1)
							{
								addBack(i, j, k)
							}
						
							if (j > 1)
							{
								if (y_arr[j - 1][k] != 1)
								{
									addTop(i, j, k)
								}
							}
							else
							{
								addTop(i, j, k)
							}
							if (j < y_arr.length - 1)
							{
								if (y_arr[j + 1][k] != 1)
								{
									addBottem(i, j, k)
								}
							}
							else
							{
								addBottem(i, j, k)
							}
						
						
						
							if (i > 1 )
							{
								if (cube_arr[i - 1][j][k] != 1)
								{
									addLeft(i, j, k)
								}
							}
							else
							{
								addLeft(i, j, k)
							}
						
						
							if (i < cube_arr.length - 1 )
							{
								if (cube_arr[i + 1][j][k] != 1)
								{
									addRight(i, j, k)
								}
							}
							else
							{
								addRight(i, j, k)
							}
						}
					}
				}
			}
			
		}
		private function setTriangle(p0 : Vector3D, p1 : Vector3D, p2 : Vector3D) : Triangle3D
		{
			var triangle:Triangle3D = new Triangle3D()
			triangle.setPoints(p0,p1,p2)
			triangle_arr.push(triangle)
			return triangle;
		}
		private function addLeft(i : int, j : int, k : int) : void
		{
			var p0 : Vector3D = new Vector3D(startX, startY, startZ)
			var p1 : Vector3D = new Vector3D(startX, startY - size, startZ)
			var p2 : Vector3D = new Vector3D(startX, startY, startZ - size)
			var p3 : Vector3D = new Vector3D(startX, startY - size, startZ - size)
			setTriangle(p0, p1, p2).uvts.push(0,0,0,0.1,0.1,0.1)
			setTriangle(p1, p3, p2).uvts.push(0,0,0,0.1,0.1,0.1)
		}
		
		

		private function addRight(i : int, j : int, k : int) : void
		{
			var p0 : Vector3D = new Vector3D(startX + size, startY, startZ)
			var p1 : Vector3D = new Vector3D(startX + size, startY - size, startZ)
			var p2 : Vector3D = new Vector3D(startX + size, startY, startZ - size)
			var p3 : Vector3D = new Vector3D(startX + size, startY - size, startZ - size)
			setTriangle(p1, p0, p2).uvts.push(0,0,0,0.1,0.1,0.1)
			setTriangle(p3, p1, p2).uvts.push(0,0,0,0.1,0.1,0.1)
		}

		private function addBack(i : int, j : int, k : int) : void
		{
			var p0 : Vector3D = new Vector3D(startX, startY - size, startZ)
			var p1 : Vector3D = new Vector3D(startX + size, startY - size, startZ)
			var p2 : Vector3D = new Vector3D(startX, startY, startZ)
			var p3 : Vector3D = new Vector3D(startX + size, startY, startZ)
			setTriangle(p1, p0, p2).uvts.push(0.05,0.27,0 ,0.24,0.24,0 ,0.24,0.48,0)
			setTriangle(p3, p1, p2).uvts.push(0.05,0.27,0 ,0.24,0.24,0 ,0.24,0.48,0)
		}

		private function addFront(i : int, j : int, k : int) : void
		{
			var p0 : Vector3D = new Vector3D(startX, startY - size, startZ - size)
			var p1 : Vector3D = new Vector3D(startX + size, startY - size, startZ - size)
			var p2 : Vector3D = new Vector3D(startX, startY, startZ - size)
			var p3 : Vector3D = new Vector3D(startX + size, startY, startZ - size)
			setTriangle(p0, p1, p2).uvts.push(0.05,0.27,0 ,0.24,0.24,0 ,0.24,0.48,0)
			setTriangle(p1, p3, p2).uvts.push(0.05,0.27,0 ,0.24,0.24,0 ,0.24,0.48,0)
		}

		private function addTop(i : int, j : int, k : int) : void
		{
		
			var p0 : Vector3D = new Vector3D(startX, startY - size, startZ)
			var p1 : Vector3D = new Vector3D(startX + size, startY - size, startZ)
			var p2 : Vector3D = new Vector3D(startX, startY - size, startZ - size)
			var p3 : Vector3D = new Vector3D(startX + size, startY - size, startZ - size)
			setTriangle(p0, p1, p2).uvts.push(0.26,0.26,0,0.26,0.49,0,0.49,0.49,0)
			setTriangle(p1, p3, p2).uvts.push(0.26,0.26,0,0.26,0.49,0,0.49,0.49,0)
		}

		private function addBottem(i : int, j : int, k : int) : void
		{
		
			var p0 : Vector3D = new Vector3D(startX, startY, startZ)
			var p1 : Vector3D = new Vector3D(startX + size, startY, startZ)
			var p2 : Vector3D = new Vector3D(startX, startY, startZ - size)
			var p3 : Vector3D = new Vector3D(startX + size, startY, startZ - size)
			setTriangle(p1, p0, p2).uvts.push(0.26,0.26,0,0.26,0.49,0,0.49,0.49,0)
			setTriangle(p3, p1, p2).uvts.push(0.26,0.26,0,0.26,0.49,0,0.49,0.49,0)
		}

		
		
	}
}
