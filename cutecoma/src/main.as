package 
{
	import com.greensock.plugins.*;
	import com.sleepydesign.application.core.SDApplication;
	import com.sleepydesign.site.ApplicationFacade;

	/**
	 * ___________________________________________________________________________
	 *  
	 * Sleepy FrameWork
	 * 
	 * o-[System]
	 * |
	 * +-- [Modal] : Alert Box, Authen
	 * |
	 * o-[XML]
	 * |
	 * o-[Site]
	 * |
	 * o-[Links] : Global link
	 * |
	 * o-[Pages] : Transition
	 * |
	 * +--o-[Page]
	 * |
	 * +--o-[Page]
	 * |
	 * +--o-[Content]
	 *    |
	 *    +-- [Text]
	 *    +-- [Image]
	 *    +-- [Button]
	 *    +-- [Form]
	 * 
	 * ___________________________________________________________________________
	 * 
	 * [Feature]
	 *  » Minimalism both Memory and File size
	 *  » Design assets via Flash IDE and Coding via Flex
	 *  » Configurable by XML 
	 *  » Simple Loader
	 *  » Garbage collection
	 *  » Got basic component : TextField, TextInput, ScrollBar, Tree
	 *  » Support Thai language ;)
	 * ___________________________________________________________________________
	 * 
	 * Sleepy Site
	 * ___________________________________________________________________________
	 * 
	 * [Feature]
	 *  » Use PureMVC concept for some reason :P
	 *  » Support SWFObject, SWFAddress, SEO, Google Analytic
	 *  » Got basic Form validation/encypt/checksum
	 * 
	 * [Structure]
	 *  » Browser(External Interface)
	 *  » SWFObject | SWFAddress 
	 *  » SDApplication (System, Dialog, Debug)
	 *    + PureMVC (ApplicationFacade)
	 *      - Navigator(SDMenu)
	 *      - Site(SDGroup)
	 * 	    - Content(SDContainer)
	 * ___________________________________________________________________________
	 * 
	 * @author katopz
	 * 
	 */
	
	[SWF(backgroundColor="0xFFFFFF", frameRate="30", width="800", height="600")]
	public class main extends SDApplication
	{
		public function main()
		{
			TweenPlugin.activate([
			
			//ACTIVATE (OR DEACTIVATE) PLUGINS HERE...
			
			AutoAlphaPlugin,			//tweens alpha and then toggles "visible" to false if/when alpha is zero
			//EndArrayPlugin,			//tweens numbers in an Array
			FramePlugin,				//tweens MovieClip frames
			//RemoveTintPlugin,			//allows you to remove a tint
			//TintPlugin,				//tweens tints
			//VisiblePlugin,			//tweens a target's "visible" property
			//VolumePlugin,				//tweens the volume of a MovieClip or SoundChannel or anything with a "soundTransform" property
			
			//BevelFilterPlugin,		//tweens BevelFilters
			//BezierPlugin,				//enables bezier tweening
			//BezierThroughPlugin,		//enables bezierThrough tweening
			BlurFilterPlugin,			//tweens BlurFilters
			//ColorMatrixFilterPlugin,	//tweens ColorMatrixFilters (including hue, saturation, colorize, contrast, brightness, and threshold)
			//ColorTransformPlugin,		//tweens advanced color properties like exposure, brightness, tintAmount, redOffset, redMultiplier, etc.
			//DropShadowFilterPlugin,	//tweens DropShadowFilters
			//FrameLabelPlugin,			//tweens a MovieClip to particular label
			//GlowFilterPlugin,			//tweens GlowFilters
			//HexColorsPlugin,			//tweens hex colors
			//RoundPropsPlugin,			//enables the roundProps special property for rounding values (ONLY for TweenMax!)
			//ShortRotationPlugin,		//tweens rotation values in the shortest direction
			
			//QuaternionsPlugin,		//tweens 3D Quaternions
			//ScalePlugin,				//Tweens both the _xscale and _yscale properties
			//ScrollRectPlugin,			//tweens the scrollRect property of a DisplayObject
			//SetSizePlugin,			//tweens the width/height of components via setSize()
			//SetActualSizePlugin,		//tweens the width/height of components via setActualSize()
			//TransformMatrixPlugin,	//Tweens the transform.matrix property of any DisplayObject
				
			//DynamicPropsPlugin,		//tweens to dynamic end values. You associate the property with a particular function that returns the target end value **Club GreenSock membership benefit**
			//MotionBlurPlugin,			//applies a directional blur to a DisplayObject based on the velocity and angle of movement. **Club GreenSock membership benefit**
			//Physics2DPlugin,			//allows you to apply basic physics in 2D space, like velocity, angle, gravity, friction, acceleration, and accelerationAngle. **Club GreenSock membership benefit**
			//PhysicsPropsPlugin,		//allows you to apply basic physics to any property using forces like velocity, acceleration, and/or friction. **Club GreenSock membership benefit**
			//TransformAroundCenterPlugin,//tweens the scale and/or rotation of DisplayObjects using the DisplayObject's center as the registration point **Club GreenSock membership benefit**
			//TransformAroundPointPlugin,	//tweens the scale and/or rotation of DisplayObjects around a particular point (like a custom registration point) **Club GreenSock membership benefit**
			{}]); 
			
			super();
			var facade:ApplicationFacade = ApplicationFacade.getInstance();
			facade.startup( content );
		}
	}
}