﻿package away3dlite.loaders.utils{   	import away3dlite.core.utils.Debug;	import away3dlite.loaders.data.*;		import flash.utils.Dictionary;        /**    * Store for all animation channels associated with an externally loaded file.    */    public dynamic class ChannelLibrary extends Dictionary    {	    private var _channelArray:Array;	    private var _channelArrayDirty:Boolean;	    	    private function updateChannelArray():void	    {	    	_channelArray = [];	    	for each (var _channel:ChannelData in this) {	    		_channelArray.push(_channel);	    	}	    }	        	/**    	 * Adds an animation channel name reference to the library.    	 */        public function addChannel(name:String, xml:XML):ChannelData        {        	//return if animation already exists        	if (this[name])        		return this[name];        	        	_channelArrayDirty = true;        	        	var channelData:ChannelData = new ChannelData();        	channelData.xml = xml;            this[channelData.name = name] = channelData;            return channelData;        }            	/**    	 * Returns an animation channel data object for the given name reference in the library.    	 */        public function getChannel(name:String):ChannelData        {        	//return if animation exists        	if (this[name])        		return this[name];        	        	Debug.warning("Channel '" + name + "' does not exist");        	        	return null;        }            	/**    	 * Returns an array of all animation channels.    	 */        public function getChannelArray():Array        {        	if (_channelArrayDirty)        		updateChannelArray();        		        	return _channelArray;        }    }}