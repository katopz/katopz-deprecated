package open3d.materials.shaders 
{
	import flash.geom.Vector3D;
	import open3d.materials.BitmapMaterial;
	import open3d.objects.Light;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shader;
	import flash.display.Sprite;
	import flash.geom.Matrix3D;
	import flash.utils.ByteArray;

	/**
	 * @author kris@neuroproductions
	 */
	public class PBBitmapShader extends BitmapMaterial implements IShader
	{

		[Embed("../../pixelbender/LocalGlobalNormalBlend.pbj", mimeType="application/octet-stream")]
		private var BlendShader : Class;

		[Embed("../../pixelbender/NormalMapBlendModeTest.pbj", mimeType="application/octet-stream")]
		private var NormalShader : Class;

		protected var _uvtData : Vector.<Number>;
		protected var _difuseBitmapData : BitmapData ;
		protected var _normalmapBitmapData : BitmapData ;
		protected var _light : Light;
		protected var shader : Shader;

		
	public var drawSprite : Sprite = new Sprite();
		protected var difuseBitmap : Bitmap;
		protected var normalBitmap : Bitmap;
		protected var normalSprite:Sprite =new Sprite();
		protected var difuseSprite:Sprite =new Sprite();
		
		public function PBBitmapShader(light : Light,difuseBitmapData : BitmapData = null,normalmapBitmapData : BitmapData = null) 
		{
			_light = light;
			_difuseBitmapData = difuseBitmapData;
			_normalmapBitmapData = normalmapBitmapData;
			shader = new Shader(new NormalShader() as ByteArray);
			
			difuseBitmap = new Bitmap(difuseBitmapData);
			normalSprite.addChild(difuseBitmap);
			super(difuseBitmapData);
		}

		public function calculateNormals(verticesIn : Vector.<Number>,indices : Vector.<int>,uvtData : Vector.<Number> = null,vertexNormals : Vector.<Number> = null) : void
		{
			
			var normalMapBuilder : NormalMapBuilder = new NormalMapBuilder();
			
			var targetMap : BitmapData = _normalmapBitmapData ? _normalmapBitmapData : _texture;
			// build a world map
			var normalWorldMap : BitmapData = normalMapBuilder.getWorldNormalMap(targetMap, verticesIn, indices, uvtData, vertexNormals);
			// blend the local and world normals
			if (_normalmapBitmapData != null)
			{
				var blendshader : Shader = new Shader(new BlendShader() as ByteArray);
				
				var tempSprite : Sprite = new Sprite();
				var bmWorld : Bitmap = new Bitmap(normalWorldMap);
				tempSprite.addChild(bmWorld);
				var bmLocal : Bitmap = new Bitmap(_normalmapBitmapData);
				bmLocal.blendShader = blendshader;
				tempSprite.addChild(bmLocal);
				normalWorldMap.draw(tempSprite);
			}
		
			//texture = normalWorldMap;

			normalBitmap = new Bitmap(normalWorldMap);
			drawSprite.addChild(difuseSprite);
			normalSprite.addChild(normalBitmap);
			//drawSprite.addChild(normalSprite);
			normalSprite.blendShader = shader;
			
		
		
			this._uvtData = uvtData;
		}

		public function getUVData(m : Matrix3D) : Vector.<Number> 
		{
			var vec3:Vector3D = _light.halfVector.clone();
			vec3.normalize();
			
			shader.data.x.value=[vec3.x];
			shader.data.y.value=[vec3.y];
			shader.data.z.value=[vec3.z];
			drawSprite.addChild(difuseSprite);
			normalSprite.addChild(normalBitmap);
			drawSprite.addChild(normalSprite);
			normalSprite.blendShader = shader;
			texture.draw(drawSprite);
			return _uvtData;
		}
	}
}
