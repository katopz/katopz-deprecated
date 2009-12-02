package 
{
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
			super();
			var facade:ApplicationFacade = ApplicationFacade.getInstance();
			facade.startup( content );
		}
	}
}