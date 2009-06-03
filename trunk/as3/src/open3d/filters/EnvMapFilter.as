package open3d.filters
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Shader;
	import flash.display.Stage;
	import flash.filters.ShaderFilter;
	import flash.geom.Rectangle;

	/**
	 * The EnvMapFilter class creates a cubic environment mapping effect on a DisplayObject. The DisplayObject MUST
	 * have a transform.matrix3D object and its z coordinate must be > 0
	 * 
	 * @author David Lenaerts
	 * http://www.derschmale.com
	 */
	public class EnvMapFilter extends ShaderFilter
	{
		public static const LEFT : String = "left";
		public static const RIGHT : String = "right";
		public static const TOP : String = "top";
		public static const BOTTOM : String = "bottom";
		public static const BACK : String = "back";
		public static const FRONT : String = "front";
		
		[Embed(source="pbj/CubicEnvNormalMapShader.pbj", mimeType="application/octet-stream")]
		private var NormalMapKernel : Class;
		
		[Embed(source="pbj/CubicEnvMapShader.pbj", mimeType="application/octet-stream")]
		private var FlatKernel : Class;
		
		private var _faces : Array;
		private var _alpha : Number;
		private var _normalMapStrength : Number;
		
		private var _hasNormalMap : Boolean;
		
		/**
		 * Create an EnvMapFilter instance.
		 * 
		 * @param faces An key-value array of BitmapData objects. Use the constants LEFT, RIGHT, TOP, BOTTOM, BACK, FRONT as keys.
		 * @param alpha The opacity of the environment map, ie: how reflective the surface is. 1 is a perfect mirror.
		 * @param normalMap A normal map in tangent space. If not provided, the surface will appear flat.
		 * @param normalMapStrength Indicates how strong the normal map affects the surface relief.
		 */
		public function EnvMapFilter(faces : Array, alpha : Number = 0.5, normalMap : BitmapData = null, normalMapStrength : Number = 0.5)
		{
			var shader : Shader;
			_hasNormalMap = normalMap != null;
			shader = _hasNormalMap ? new Shader(new NormalMapKernel()) : new Shader(new FlatKernel())
			super(shader);

			_alpha = alpha;
			_faces = faces;
			_normalMapStrength = normalMapStrength;
			shader.data.left.input = faces[LEFT];
			shader.data.right.input = faces[RIGHT];
			shader.data.top.input = faces[TOP];
			shader.data.bottom.input = faces[BOTTOM];
			shader.data.front.input = faces[FRONT];
			shader.data.back.input = faces[BACK];
			shader.data.cubeDim.value = [ faces[LEFT].width ];
			shader.data.alpha.value = [ alpha ];
			
			if (_hasNormalMap) {
				shader.data.normalMap.input = normalMap;
				shader.data.normalMapStrength.value = [ normalMapStrength ];
			}
		}
		
		/**
		 * The opacity of the environment map, ie: how reflective the surface is. 1 is a perfect mirror.
		 */
		public function get alpha() : Number
		{
			return _alpha;
		}
		
		public function set alpha(value : Number) : void
		{
			_alpha = value;
			shader.data.alpha.value = [ value ];
		}
		
		/**
		 * Indicates how strong the normal map affects the surface relief.
		 */
		public function get normalMapStrength() : Number
		{
			return _normalMapStrength;
		}
		
		public function set normalMapStrength(value : Number) : void
		{
			if (_hasNormalMap) {
				_normalMapStrength = value;
				shader.data.normalMapStrength.value = [ value ];
			}
		}
		
		/**
		 * Updates the environment map effect. This function needs to be called whenever the target displayObject changes position, rotation or scale.
		 * 
		 * @param target The DisplayObject for which the environment map needs to be updated.
		 */
		public function update(target : DisplayObject) : void
		{
			var bounds : Rectangle = target.getBounds(target);
			var stage : Stage = target.stage;
			var transform : Vector.<Number> =  target.transform.matrix3D.rawData;
			shader.data.upperLeft.value = [ bounds.x, bounds.y ];
			
			// pixel bender float4x4 and Matrix3D are stored in column-major
			shader.data.transformation.value = [ 	transform[0], transform[1], transform[2], transform[3], 
													transform[4], transform[5], transform[6], transform[7], 
													transform[8], transform[9], transform[10], transform[11], 
													transform[12]-stage.stageWidth*.5, transform[13]-stage.stageHeight*.5, transform[14], transform[15]
												];
			
			shader.data.normal.value = [ -transform[8], -transform[9], -transform[10] ];
		}
	}
}