/**
 * VERSION: 1.5
 * DATE: 5/2/2009
 * ACTIONSCRIPT VERSION: 3.0 
 * UPDATES & MORE DETAILED DOCUMENTATION AT: http://www.TweenMax.com
 **/
package gs.plugins {
	import flash.display.*;
	import flash.geom.ColorTransform;
	import gs.*;
/**
 * Ever wanted to tween ColorTransform properties of a DisplayObject to do advanced effects like overexposing, altering
 * the brightness or setting the percent/amount of tint? Or maybe tween individual ColorTransform 
 * properties like redMultiplier, redOffset, blueMultiplier, blueOffset, etc. ColorTransformPlugin gives you an easy way to 
 * do just that. <br /><br />
 * 
 * <b>PROPERTIES:</b><br />
 * <ul>
 * 		<li><code> tint (or color) : uint</code> - Color of the tint. Use a hex value, like 0xFF0000 for red.
 * 		<li><code> tintAmount : Number</code> - Number between 0 and 1. Works with the "tint" property and indicats how much of an effect the tint should have. 0 makes the tint invisible, 0.5 is halfway tinted, and 1 is completely tinted.
 * 		<li><code> brightness : Number</code> - Number between 0 and 2 where 1 is normal brightness, 0 is completely dark/black, and 2 is completely bright/white
 * 		<li><code> exposure : Number</code> - Number between 0 and 2 where 1 is normal exposure, 0, is completely underexposed, and 2 is completely overexposed. Overexposing an object is different then changing the brightness - it seems to almost bleach the image and looks more dynamic and interesting (subjectively speaking). 
 * 		<li><code> redOffset : Number</code>
 * 		<li><code> greenOffset : Number</code>
 * 		<li><code> blueOffset : Number</code>
 * 		<li><code> alphaOffset : Number</code>
 * 		<li><code> redMultiplier : Number</code>
 * 		<li><code> greenMultiplier : Number</code>
 * 		<li><code> blueMultiplier : Number</code>
 * 		<li><code> alphaMultiplier : Number</code> 
 * </ul><br /><br />
 * 
 * <b>USAGE:</b><br /><br />
 * <code>
 * 		import gs.TweenLite; <br />
 * 		import gs.plugins.ColorTransformPlugin; <br />
 * 		TweenPlugin.activate([ColorTransformPlugin]); //activation is permanent in the SWF, so this line only needs to be run once.<br /><br />
 * 
 * 		TweenLite.to(mc, 1, {colorTransform:{tint:0xFF0000, tintAmount:0.5}); <br /><br />
 * </code>
 *
 * Bytes added to SWF: 371 (not including dependencies)<br /><br />
 * 
 * <b>Copyright 2009, GreenSock. All rights reserved.</b> This work is subject to the terms in <a href="http://www.greensock.com/terms_of_use.html">http://www.greensock.com/terms_of_use.html</a> or for corporate Club GreenSock members, the software agreement that was issued with the corporate membership.
 * 
 * @author Jack Doyle, jack@greensock.com
 */
	public class ColorTransformPlugin extends TintPlugin {
		/** @private **/
		public static const VERSION:Number = 1.5;
		/** @private **/
		public static const API:Number = 1.0; //If the API/Framework for plugins changes in the future, this number helps determine compatibility
		
		/** @private **/
		public function ColorTransformPlugin() {
			super();
			this.propName = "colorTransform"; 
		}
		
		/** @private **/
		override public function onInitTween($target:Object, $value:*, $tween:TweenLite):Boolean {
			if (!($target is DisplayObject)) {
				return false;
			}
			var end:ColorTransform = $target.transform.colorTransform;
			if ($value.isTV == true) {
				$value = $value.exposedVars; //for compatibility with TweenLiteVars and TweenMaxVars
			}
			for (var p:String in $value) {
				if (p == "tint" || p == "color") {
					if ($value[p] != null) {
						end.color = int($value[p]);
					}
				} else if (p == "tintAmount" || p == "exposure" || p == "brightness") {
					//handle this later...
				} else {
					end[p] = $value[p];
				}
			}
			
			if (!isNaN($value.tintAmount)) {
				var ratio:Number = $value.tintAmount / (1 - ((end.redMultiplier + end.greenMultiplier + end.blueMultiplier) / 3));
				end.redOffset *= ratio;
				end.greenOffset *= ratio;
				end.blueOffset *= ratio;
				end.redMultiplier = end.greenMultiplier = end.blueMultiplier = 1 - $value.tintAmount;
			} else if (!isNaN($value.exposure)) {
				end.redOffset = end.greenOffset = end.blueOffset = 255 * ($value.exposure - 1);
				end.redMultiplier = end.greenMultiplier = end.blueMultiplier = 1;
			} else if (!isNaN($value.brightness)) {
				end.redOffset = end.greenOffset = end.blueOffset = Math.max(0, ($value.brightness - 1) * 255);
				end.redMultiplier = end.greenMultiplier = end.blueMultiplier = 1 - Math.abs($value.brightness - 1);
			}
			
			_ignoreAlpha = Boolean($tween.vars.alpha != undefined && $value.alphaMultiplier == undefined);
			
			init($target as DisplayObject, end);
			
			return true;
		}
		
	}
}