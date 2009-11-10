/*
Copyright (c) 2007, Yahoo! Inc. All rights reserved.
Code licensed under the BSD License:
http://developer.yahoo.com/flash/license.html
*/
package com.yahoo.astra.fl.managers
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	
	//--------------------------------------
	//  Class description
	//--------------------------------------
	/**
	 *  A utility for dealing with popups
	 *
	 */
	public class PopUpManager
	{
	//--------------------------------------------------------------------------
    //
    //  Class methods
    //
    //--------------------------------------------------------------------------
    /**
     *  Pops up a top-level window.
     *
     *  <p><b>Example</b></p> 
     *
     *  <pre>var sp = new Sprite();
     *  PopUpManager.addPopUp(sp, stage);</pre>
     *
     *  
     *  @param popUp The DisplayObject to be popped up.
     *
     *  @param parent DisplayObject to pop up above.
     *
     */
    public static function addPopUp(popUp:DisplayObject, parent:DisplayObjectContainer):void
    {
    	parent.addChild(popUp);
    }
    
     /**
     *  Removes a popup window popped up by 
     *  the <code>addPopUp()</code> method.
     *  
     *  @param window The DisplayObject representing the popup window.
     */
    public static function removePopUp(popUp:DisplayObject):void
    {
		popUp.parent.removeChild(popUp);
    }
	}
}