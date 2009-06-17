/**
 * VERSION: 1.0
 * DATE: 1/8/2009
 * ACTIONSCRIPT VERSION: 3.0 
 * UPDATES & MORE DETAILED DOCUMENTATION AT: http://www.TweenMax.com
 **/
package gs.plugins {
	import flash.filters.*;
	import flash.display.*;
	import gs.*;
/**
 * Tweens a BlurFilter. The following properties are available (you only need to define the ones you want to tween):
 * <code>
 * <ul>
 * 		<li> blurX : Number [0]
 * 		<li> blurY : Number [0]
 * 		<li> quality : uint [2]
 * 		<li> index : uint
 * 		<li> addFilter : Boolean [false]
 * 		<li> remove : Boolean [false]
 * </ul>
 * </code>
 * 	
 * Set <code>remove</code> to true if you want the filter to be removed when the tween completes. <br /><br />
 * 
 * <b>USAGE:</b><br /><br />
 * <code>
 * 		import gs.TweenLite; <br />
 * 		import gs.plugins.BlurFilterPlugin; <br />
 * 		TweenPlugin.activate([BlurFilterPlugin]); //activation is permanent in the SWF, so this line only needs to be run once.<br /><br />
 * 
 * 		TweenLite.to(mc, 1, {blurFilter:{blurX:10, blurY:10}}); <br /><br />
 * </code>
 *
 * Bytes added to SWF: 156 (not including dependencies)<br /><br />
 * 
 * <b>Copyright 2009, GreenSock. All rights reserved.</b> This work is subject to the terms in <a href="http://www.greensock.com/terms_of_use.html">http://www.greensock.com/terms_of_use.html</a> or for corporate Club GreenSock members, the software agreement that was issued with the corporate membership.
 * 
 * @author Jack Doyle, jack@greensock.com
 */
	public class BlurFilterPlugin extends FilterPlugin {
		/** @private **/	
		public static const VERSION:Number = 1.0;
		/** @private **/
		public static const API:Number = 1.0; //If the API/Framework for plugins changes in the future, this number helps determine compatibility
		
		/** @private **/
		public function BlurFilterPlugin() {
			super();
			this.propName = "blurFilter";
			this.overwriteProps = ["blurFilter"];
		}
		
		/** @private **/
		override public function onInitTween($target:Object, $value:*, $tween:TweenLite):Boolean {
			_target = $target;
			_type = BlurFilter;
			initFilter($value, new BlurFilter(0, 0, $value.quality || 2));
			return true;
		}
		
	}
}