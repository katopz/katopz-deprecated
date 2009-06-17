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
 * Tweens a BevelFilter. The following properties are available (you only need to define the ones you want to tween): <br />
 * <code>
 * <ul>
 * 		<li> distance : Number [0]
 * 		<li> angle : Number [0]
 * 		<li> highlightColor : uint [0xFFFFFF]
 * 		<li> highlightAlpha : Number [0.5]
 * 		<li> shadowColor : uint [0x000000]
 * 		<li> shadowAlpha :Number [0.5]
 * 		<li> blurX : Number [2]
 * 		<li> blurY : Number [2]
 * 		<li> strength : Number [0]
 * 		<li> quality : uint [2]
 * 		<li> index : uint
 * 		<li> addFilter : Boolean [false]
 * 		<li> remove : Boolean [false]
 * </ul>
 * </code>
 * 
 * 
 * <b>USAGE:</b><br /><br />
 * <code>
 * 		import gs.TweenLite; <br />
 * 		import gs.plugins.BevelFilterPlugin; <br />
 * 		TweenPlugin.activate([BevelFilterPlugin]); //activation is permanent in the SWF, so this line only needs to be run once.<br /><br />
 * 
 * 		TweenLite.to(mc, 1, {bevelFilter:{blurX:10, blurY:10, distance:6, angle:45, strength:1}});<br /><br />
 * </code>
 *
 * Bytes added to SWF: 166 (not including dependencies)<br /><br />
 * 
 * <b>Copyright 2009, GreenSock. All rights reserved.</b> This work is subject to the terms in <a href="http://www.greensock.com/terms_of_use.html">http://www.greensock.com/terms_of_use.html</a> or for corporate Club GreenSock members, the software agreement that was issued with the corporate membership.
 * 
 * @author Jack Doyle, jack@greensock.com
 */
	public class BevelFilterPlugin extends FilterPlugin {
		/** @private **/
		public static const VERSION:Number = 1.0;
		/** @private **/
		public static const API:Number = 1.0; //If the API/Framework for plugins changes in the future, this number helps determine compatibility
		
		/** @private **/
		public function BevelFilterPlugin() {
			super();
			this.propName = "bevelFilter";
			this.overwriteProps = ["bevelFilter"];
		}
		
		/** @private **/
		override public function onInitTween($target:Object, $value:*, $tween:TweenLite):Boolean {
			_target = $target;
			_type = BevelFilter;
			initFilter($value, new BevelFilter(0, 0, 0xFFFFFF, 0.5, 0x000000, 0.5, 2, 2, 0, $value.quality || 2));
			return true;
		}
		
	}
}