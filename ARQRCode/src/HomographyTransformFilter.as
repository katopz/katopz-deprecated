package {
	
	import flash.display.Shader;
	import flash.filters.ShaderFilter;
	import flash.geom.Point;
	import flash.utils.ByteArray;

	/**
	 * Homography with linear interpolation.
	 * @author saqoosha
	 * @see http://saqoosha.net/2009/05/25/1750/
	 */
	public class HomographyTransformFilter extends ShaderFilter {
		
		[Embed(source='homography_s.pbj', mimeType='application/octet-stream')]
		private static const ShaderByteClass2:Class;
		
		private var _shader:Shader;
		
		public var p0:Point;
		public var p1:Point;
		public var p2:Point;
		public var p3:Point;
		
		public function HomographyTransformFilter(outWidth:int, outHeight:int, p0:Point, p1:Point, p2:Point, p3:Point) {
			this._shader = new Shader();
			this._shader.byteCode = new ShaderByteClass2;
			this.outWidth = outWidth;
			this.outHeight = outHeight;
			this.p0 = p0;
			this.p1 = p1;
			this.p2 = p2;
			this.p3 = p3;
			this.recalcParam();
			super(this._shader);
		}
		
		public function recalcParam():void {
			var sx:Number = (this.p0.x - this.p1.x) + (this.p2.x - this.p3.x);
			var sy:Number = (this.p0.y - this.p1.y) + (this.p2.y - this.p3.y);
			var dx1:Number = this.p1.x - this.p2.x;
			var dx2:Number = this.p3.x - this.p2.x;
			var dy1:Number = this.p1.y - this.p2.y;
			var dy2:Number = this.p3.y - this.p2.y;
			var z:Number = (dx1 * dy2) - (dy1 * dx2);
			var g:Number = ((sx * dy2) - (sy * dx2)) / z;
			var h:Number = ((sy * dx1) - (sx * dy1)) / z;
			this._shader.data.A.value = [this.p1.x - this.p0.x + g * this.p1.x];
			this._shader.data.B.value = [this.p3.x - this.p0.x + h * this.p3.x];
			this._shader.data.C.value = [this.p0.x];
			this._shader.data.D.value = [this.p1.y - this.p0.y + g * this.p1.y];
			this._shader.data.E.value = [this.p3.y - this.p0.y + h * this.p3.y];
			this._shader.data.F.value = [this.p0.y];
			this._shader.data.G.value = [g];
			this._shader.data.H.value = [h];
		}
		
		public function get outWidth():int {
			return this._shader.data.outWidth.value[0];
		}
		public function set outWidth(value:int):void {
			this._shader.data.outWidth.value = [value];
		}
		
		public function get outHeight():int {
			return this._shader.data.outHeight.value[0];
		}
		public function set outHeight(value:int):void {
			this._shader.data.outHeight.value = [value];
		}
	}
}