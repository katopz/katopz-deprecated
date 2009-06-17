/**
 * VERSION: 1.0
 * DATE: 5/2/2009
 * ACTIONSCRIPT VERSION: 3.0 
 * UPDATES & MORE DETAILED DOCUMENTATION AT: http://www.TweenMax.com
 **/
package gs.plugins {
	import flash.filters.*;
	import flash.display.*;
	import gs.*;
/**
 * Tweens a GlowFilter. The following properties are available (you only need to define the ones you want to tween):
 * <code>
 * <ul>
 * 		<li> color : uint [0x000000]
 * 		<li> alpha :Number [0]
 * 		<li> blurX : Number [0]
 * 		<li> blurY : Number [0]
 * 		<li> strength : Number [1]
 * 		<li> quality : uint [2]
 * 		<li> inner : Boolean [false]
 * 		<li> knockout : Boolean [false]
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
 * 		import gs.plugins.GlowFilterPlugin; <br />
 * 		TweenPlugin.activate([GlowFilterPlugin]); //activation is permanent in the SWF, so this line only needs to be run once.<br /><br />
 * 
 * 		TweenLite.to(mc, 1, {glowFilter:{color:0x00FF00, blurX:10, blurY:10, strength:1, alpha:1}});<br /><br />
 * </code>
 *
 * Bytes added to SWF: 187 (not including dependencies)<br /><br />
 * 
 * <b>Copyright 2009, GreenSock. All rights reserved.</b> This work is subject to the terms in <a href="http://www.greensock.com/terms_of_use.html">http://www.greensock.com/terms_of_use.html</a> or for corporate Club GreenSock members, the software agreement that was issued with the corporate membership.
 * 
 * @author Jack Doyle, jack@greensock.com
 */
	public class GlowFilterPlugin extends FilterPlugin {
		/** @private **/	
		public static const VERSION:Number = 1.0;
		/** @private **/	
		public static const API:Number = 1.0; //If the API/Framework for plugins changes in the future, this number helps determine compatibility
		
		/** @private **/	
		public function GlowFilterPlugin() {
			super();
			this.propName = "glowFilter";
			this.overwriteProps = ["glowFilter"];
		}
		
		/** @private **/	
		override public function onInitTween($target:Object, $value:*, $tween:TweenLite):Boolean {
			_target = $target;
			_type = GlowFilter;
			initFilter($value, new GlowFilter(0xFFFFFF, 0, 0, 0, $value.strength || 1, $value.quality || 2, $value.inner, $value.knockout));
			return true;
		}
		
	}
}