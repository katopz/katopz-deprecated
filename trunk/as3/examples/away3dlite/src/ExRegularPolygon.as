package
{
	import away3dlite.materials.*;
	import away3dlite.primitives.*;
	import away3dlite.templates.*;
	
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;

	[SWF(backgroundColor="#000000",frameRate="30",quality="MEDIUM",width="800",height="600")]

	public class ExRegularPolygon extends BasicTemplate
	{
		private var max:int=600;
		private var polygons:Vector.<Plane>;
		
		/**
		 * @inheritDoc
		 */
		override protected function onInit():void
		{
			polygons = new Vector.<Plane>(max, true);
			
			var i:int=0;
			for (var j:int = 0; j < max; j++)
			{
				var polygon:Plane = new Plane(new ColorMaterial(int(0xFFFFFF*j/max)),10,10);
				
				polygon.x = 200*Math.cos(i*2*Math.PI/200);
				polygon.y = -max/2+i;
				polygon.z = 200*Math.sin(i*2*Math.PI/200);
				polygon.sortFaces = false;
				
				scene.addChild(polygon);
				polygons[i] = polygon;
				
				i++;
			}
			
			camera.y = -1000;
			camera.lookAt(new Vector3D(0,0,0));
			
			scene.addChild(new Sphere(null,100,6,6));
		}

		/**
		 * @inheritDoc
		 */
		override protected function onPreRender():void
		{
			scene.rotationY++;
		}
	}
}