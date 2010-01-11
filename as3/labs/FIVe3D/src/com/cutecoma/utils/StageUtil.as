/*
	CASA Lib for ActionScript 3.0
	Copyright (c) 2009, Aaron Clinger & Contributors of CASA Lib
	All rights reserved.
	
	Redistribution and use in source and binary forms, with or without
	modification, are permitted provided that the following conditions are met:
	
	- Redistributions of source code must retain the above copyright notice,
	  this list of conditions and the following disclaimer.
	
	- Redistributions in binary form must reproduce the above copyright notice,
	  this list of conditions and the following disclaimer in the documentation
	  and/or other materials provided with the distribution.
	
	- Neither the name of the CASA Lib nor the names of its contributors
	  may be used to endorse or promote products derived from this software
	  without specific prior written permission.
	
	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
	AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
	IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
	ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
	LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
	CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
	SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
	INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
	CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
	ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
	POSSIBILITY OF SUCH DAMAGE.
*/
package com.cutecoma.utils {
	import flash.display.Stage;
	import flash.utils.Dictionary;
	
	/**
		Stores a reference to Stage for classes that cannot easily access it. This class allows you to stored multiple references by ID to different <code>Stage</code>}s which is helpful in an AIR environment.
		
		@author Aaron Clinger
		@version 09/06/09
		@usageNote You must first initialize the class by setting a reference to Stage. See example below:
		@example
			<code>
				package {
					import com.cutecoma.display.CasaMovieClip;
					import com.cutecoma.utils.StageUtil;
					
					
					public class MyExample extends CasaMovieClip {
						
						
						public function MyExample() {
							super();
							
							StageUtil.setStage(this.stage);
							
							trace(StageUtil.getStage().stageWidth);
						}
					}
				}
			</code>
	*/
	public class StageUtil {
		public static const STAGE_DEFAULT:String = 'stageDefault';
		protected static var _stageMap:Dictionary;
		
		/**
			Returns a reference to Stage.
			
			@param id: The identifier for the Stage instance.
			@return The Stage instance.
			@throws Error if you try to get a Stage that has not been defined.
		*/
		public static function getStage(id:String = StageUtil.STAGE_DEFAULT):Stage {
			if (!(id in StageUtil._getMap()))
				throw new Error('Cannot get Stage ("' + id + '") before it has been set.');
			
			return StageUtil._getMap()[id];
		}
		
		/**
			Stores a reference to Stage.
			
			@param stage: The Stage you wish to store.
			@param id: The identifier for the Stage.
		*/
		public static function setStage(stage:Stage, id:String = StageUtil.STAGE_DEFAULT):void {
			StageUtil._getMap()[id] = stage;
		}
		
		/**
			Removes a stored reference to a Stage.
			
			@param id: The identifier for the Stage.
			@return Returns <code>true</code> if the Stage reference was found and removed; otherwise <code>false</code>.
		*/
		public static function removeStage(id:String = StageUtil.STAGE_DEFAULT):Boolean {
			if (!(id in StageUtil._getMap()))
				return false;
			
			StageUtil.setStage(null, id);
			
			return true;
		}
		
		/**
			Finds all the Stage reference ids.
			
			@return An Array comprised of all the Stage reference identifiers.
		*/
		public static function getIds():Array {
			return ObjectUtil.getKeys(StageUtil._getMap());
		}
		
		/**
			Finds the identifier for a stored Stage reference.
			
			@param stage: The Stage you wish to find the identifier of.
			@return The id for the stored Stage reference or <code>null</code> if it doesn't exist.
		*/
		public static function getStageId(stage:Stage):String {
			var map:Dictionary = StageUtil._getMap();
			
			for (var i:String in map)
				if (map[i] == stage)
					return i;
			
			return null;
		}
		
		protected static function _getMap():Dictionary {
			if (StageUtil._stageMap == null)
				StageUtil._stageMap = new Dictionary();
			
			return StageUtil._stageMap;
		}
	}
}