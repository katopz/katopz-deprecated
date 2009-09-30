package
{
	import away3dlite.materials.*;
	import away3dlite.primitives.*;
	import away3dlite.templates.*;
	
	import flash.geom.Vector3D;

	[SWF(backgroundColor="#000000",frameRate="30",quality="MEDIUM",width="800",height="600")]

	public class ExRegularPolygon extends BasicTemplate
	{
		/**
		 * @inheritDoc
		 */
		override protected function onInit():void
		{
			var max:int=600;
			var i:int=0;
			for (var j:int = 0; j < max; j++)
			{
				var polygon:Plane = new Plane(new ColorMaterial(int(0xFFFFFF*j/max)),10,10);
				
				polygon.x = 200*Math.cos(i*2*Math.PI/200);
				polygon.y = -max/2+i;
				polygon.z = 200*Math.sin(i*2*Math.PI/200);
				
				i++;
				
				scene.addChild(polygon);
			}
			
			camera.y = -1000;
			camera.lookAt(new Vector3D(0,0,0));
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