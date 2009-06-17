/**
 * VERSION: 1.1
 * DATE: 5/2/2009
 * ACTIONSCRIPT VERSION: 3.0 
 * UPDATES & MORE DETAILED DOCUMENTATION AT: http://www.TweenMax.com
 **/
package gs.plugins {
	import flash.display.*;
	import flash.geom.ColorTransform;
	import gs.*;
	import gs.core.tween.*;
/**
 * To change a DisplayObject's tint/color, set this to the hex value of the tint you'd like
 * to end up at (or begin at if you're using <code>TweenMax.from()</code>). An example hex value would be <code>0xFF0000</code>.<br /><br />
 * 
 * To remove a tint completely, use the RemoveTintPlugin (after activating it, you can just set <code>removeTint:true</code>) <br /><br />
 * 
 * <b>USAGE:</b><br /><br />
 * <code>
 * 		import gs.TweenLite; <br />
 * 		import gs.plugins.TintPlugin; <br />
 * 		TweenPlugin.activate([TintPlugin]); //activation is permanent in the SWF, so this line only needs to be run once.<br /><br />
 * 
 * 		TweenLite.to(mc, 1, {tint:0xFF0000}); <br /><br />
 * </code>
 *
 * Bytes added to SWF: 436 (not including dependencies)<br /><br />
 * 
 * <b>Copyright 2009, GreenSock. All rights reserved.</b> This work is subject to the terms in <a href="http://www.greensock.com/terms_of_use.html">http://www.greensock.com/terms_of_use.html</a> or for corporate Club GreenSock members, the software agreement that was issued with the corporate membership.
 * 
 * @author Jack Doyle, jack@greensock.com
 */
	public class TintPlugin extends TweenPlugin {
		/** @private **/
		public static const VERSION:Number = 1.1;
		/** @private **/
		public static const API:Number = 1.0; //If the API/Framework for plugins changes in the future, this number helps determine compatibility
		/** @private **/
		protected static var _props:Array = ["redMultiplier", "greenMultiplier", "blueMultiplier", "alphaMultiplier", "redOffset", "greenOffset", "blueOffset", "alphaOffset"];
		
		/** @private **/
		protected var _target:DisplayObject;
		/** @private **/
		protected var _ct:ColorTransform;
		/** @private **/
		protected var _ignoreAlpha:Boolean;
		
		/** @private **/
		public function TintPlugin() {
			super();
			this.propName = "tint"; 
			this.overwriteProps = ["tint"];
		}
		
		/** @private **/
		override public function onInitTween($target:Object, $value:*, $tween:TweenLite):Boolean {
			if (!($target is DisplayObject)) {
				return false;
			}
			var end:ColorTransform = new ColorTransform();
			if ($value != null && $tween.vars.removeTint != true) {
				end.color = uint($value);
			}
			_ignoreAlpha = true;
			init($target as DisplayObject, end);
			return true;
		}
		
		/** @private **/
		public function init($target:DisplayObject, $end:ColorTransform):void {
			_target = $target;
			_ct = _target.transform.colorTransform;
			var i:int, p:String;
			for (i = _props.length - 1; i > -1; i--) {
				p = _props[i];
				if (_ct[p] != $end[p]) {
					_tweens[_tweens.length] = new PropTween(_ct, p, _ct[p], $end[p] - _ct[p], "tint", false);
				}
			}
		}
		
		/** @private **/
		override public function set changeFactor($n:Number):void {
			updateTweens($n);
			if (_ignoreAlpha) {
				var ct:ColorTransform = _target.transform.colorTransform;
				_ct.alphaMultiplier = ct.alphaMultiplier;
				_ct.alphaOffset = ct.alphaOffset;
			}
			_target.transform.colorTransform = _ct;			
		}
		
	}
}