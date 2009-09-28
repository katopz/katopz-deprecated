package away3dlite.core.base
{
	import flash.display.BitmapData;
	import flash.geom.Matrix3D;
	import flash.geom.Rectangle;
	import flash.geom.Utils3D;
	import flash.geom.Vector3D;
	
	public final class Particle extends Vector3D
	{
		public var id:uint = 0;
		public var next: Particle;
		/*
		public var x: Number = 0.0;
		public var y: Number = 0.0;
		public var z: Number = 0.0;
		*/
		public var width: Number = 1.0;
		public var height: Number = 1.0;
		
		public var scale: Number = 1.0;
		
		public var bitmapData:BitmapData;
		
		public var scales:Vector.<BitmapData>;
		public var rects:Vector.<Rectangle>;
		
		public var original:Vector3D;
		
		public function Particle(x:Number, y:Number, z:Number, bitmapData:BitmapData)
		{
			this.bitmapData = bitmapData;
			
			width = bitmapData.width; 
			height = bitmapData.height;
			
			original = new Vector3D(x, y, z);
		}
		/*
				particle.position = Utils3D.projectVector(parentSceneMatrix3D, particle);
				particle.scale = _zoom / (1 + (_screenZ+particle.position.z) / _focus);
		*/
		public function render(parentSceneMatrix3D:Matrix3D, screenZ:Number, zoom:Number, focus:Number):void
		{
			var _position:Vector3D = Utils3D.projectVector(parentSceneMatrix3D, original);
			scale = zoom / (1 + (screenZ+_position.z) / focus);
			
			x = _position.x;
			y = _position.y;
			z = _position.z;
		}
	}
}