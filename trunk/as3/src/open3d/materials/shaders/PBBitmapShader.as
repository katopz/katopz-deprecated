package open3d.materials.shaders 
{
	import flash.utils.ByteArray;
	import flash.display.Shader;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.geom.Matrix3D;
	import flash.display.BitmapData;
	import open3d.materials.BitmapMaterial;
	
	/**
	 * @author kris@neuroproductions
	 */
	public class PBBitmapShader extends BitmapMaterial implements IShader
	{
		[Embed("../../pixelbender/LocalGlobalNormalBlend.pbj", mimeType="application/octet-stream")]
		private var BlendShader : Class;
		
		
		protected var _uvtData : Vector.<Number>;
		protected var _difuseBitmapData:BitmapData ;
		protected var _normalmapBitmapData:BitmapData ;
		public function PBBitmapShader(difuseBitmapData : BitmapData = null,normalmapBitmapData : BitmapData = null) 
		{
			_difuseBitmapData =difuseBitmapData;
			_normalmapBitmapData =normalmapBitmapData;
			super(difuseBitmapData);
		}
		
		public function calculateNormals(verticesIn : Vector.<Number>,indices : Vector.<int>,uvtData:Vector.<Number> =null,vertexNormals:Vector.<Number> =null) : void
		{
			
			var normalMapBuilder:NormalMapBuilder =new NormalMapBuilder();
			
			var targetMap:BitmapData= _normalmapBitmapData ? _normalmapBitmapData : _texture;
			// build a world map
			var normalWorldMap:BitmapData  =normalMapBuilder.getWorldNormalMap(targetMap,verticesIn,indices,uvtData,vertexNormals);
			// blend the local and world normals
			if (_normalmapBitmapData != null)
			{
				var shader:Shader =new Shader(new BlendShader() as ByteArray);
				
				var tempSprite:Sprite =new Sprite();
				var bmWorld:Bitmap =new Bitmap(normalWorldMap);
				tempSprite.addChild(bmWorld);
				var bmLocal:Bitmap =new Bitmap(_normalmapBitmapData);
				bmLocal.blendShader = shader;
				tempSprite.addChild(bmLocal);
				normalWorldMap.draw(tempSprite);
			}
		
			texture = normalWorldMap;
		
			this._uvtData  = uvtData;
		}
		
		public function getUVData(m : Matrix3D) : Vector.<Number> 
		{
			//update _texture
			
			return _uvtData;
		}
	}
}
