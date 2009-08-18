package {
	import com.sleepydesign.application.core.SDApplication;
	import com.sleepydesign.site.ApplicationFacade;

	/**
	 * ___________________________________________________________________________
	 *  
	 * Sleepy FrameWork
	 * ___________________________________________________________________________
	 * 
	 * [Feature]
	 *  » Minimalism both Memory and File size
	 *  » Build with Flash IDE and Compile by Flex
	 *  » Easy to config by XML with HTML syntax like, 
	 *  » StyleSheet, Skin support
	 *  » Developer handy injection/proxy
	 *  » Lazy Load/Unload with Progress/Cache/Garbage collection
	 *  » Got basic component : MinimalComps, Fancy TextField, ScrollBar, Tree
	 *  » Dependencies RIA, RESTful, RPC, WebService, ETC.
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
	 * Sleepy 3D
	 * ___________________________________________________________________________
	 * 
	 * [Feature]
	 *  » Use pure Flash 10
	 *  » Basic z-sort
	 * 
	 * @author katopz
	 * 
	 */
	
	[SWF(backgroundColor="0xFFFFFF", frameRate="30", width="800", height="600")]
	public class CuteComa extends SDApplication
	{
		public function CuteComa()
		{
			super();
			var facade:ApplicationFacade = ApplicationFacade.getInstance();
			facade.startup( content );
		}
	}
}
