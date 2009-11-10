/**
* ...
* @author katopz@sleepydesign.com
* @version 0.1
*/

package com.sleepydesign {

	public class SleepyDesign {
		
		/**
		* Determines whether debug printout is enabled. It also prints version information at startup.
		*/
		static public var VERBOSE  :Boolean = true;
		
		// ___________________________________________________________________ LOG

		/**
		* Sends debug information to the Output panel.
		*
		* @param	message		A String value to send to Output.
		*/
		static public function log( ...rest ):void
		{
			if( SleepyDesign.VERBOSE ) trace( rest );
		}
		
	}
	
}
