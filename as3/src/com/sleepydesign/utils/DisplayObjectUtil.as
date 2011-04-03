﻿/*   CASA Lib for ActionScript 3.0   Copyright (c) 2009, Aaron Clinger & Contributors of CASA Lib   All rights reserved.   Redistribution and use in source and binary forms, with or without   modification, are permitted provided that the following conditions are met:   - Redistributions of source code must retain the above copyright notice,   this list of conditions and the following disclaimer.   - Redistributions in binary form must reproduce the above copyright notice,   this list of conditions and the following disclaimer in the documentation   and/or other materials provided with the distribution.   - Neither the name of the CASA Lib nor the names of its contributors   may be used to endorse or promote products derived from this software   without specific prior written permission.   THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"   AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE   IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE   ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE   LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR   CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF   SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS   INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN   CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)   ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE   POSSIBILITY OF SUCH DAMAGE. */package com.sleepydesign.utils{	import com.sleepydesign.core.IDestroyable;	import flash.display.DisplayObject;	import flash.display.DisplayObjectContainer;	import flash.display.Loader;	import flash.display.MovieClip;	import flash.display.SimpleButton;	import flash.display.Sprite;	import flash.display.Stage;	/**	   Provides utility functions for DisplayObjects/DisplayObjectContainers.	   @author Aaron Clinger	   @version 05/25/09	 */	public class DisplayObjectUtil	{		public static function freeze(target:DisplayObjectContainer):void		{			target.mouseEnabled = false;			target.mouseChildren = false;			target.cacheAsBitmap = true;		}		/**		   Removes and optionally destroys children of a DisplayObjectContainer or the states of a SimpleButton.		   @param parent: The DisplayObjectContainer from which to remove children or a SimpleButton from which to remove its states.		   @param destroyChildren: If a child implements {@link IDestroyable} call its {@link IDestroyable#destroy destroy} method <code>true</code>, or don't destroy <code>false</code>; defaults to <code>false</code>.		   @param recursive: Call this method with the same arguments on all of the children's children (all the way down the display list) <code>true</code>, or leave the children's children <code>false</code>; defaults to <code>false</code>.		 */		public static function removeChildren(parent:DisplayObject, destroyChildren:Boolean = false, recursive:Boolean = false):void		{			if (parent is SimpleButton)			{				DisplayObjectUtil._removeButtonStates(parent as SimpleButton, destroyChildren, recursive);				return;			}			else if (parent is Loader || !(parent is DisplayObjectContainer))				return;			var container:DisplayObjectContainer = parent as DisplayObjectContainer;			while (container.numChildren)				DisplayObjectUtil._checkChild(container.removeChildAt(0), destroyChildren, recursive);		}		protected static function _removeButtonStates(parent:SimpleButton, destroyStates:Boolean, recursive:Boolean):void		{			if (parent.downState != null)			{				DisplayObjectUtil._checkChild(parent.downState, destroyStates, recursive);				parent.downState = null;			}			if (parent.hitTestState != null)			{				DisplayObjectUtil._checkChild(parent.hitTestState, destroyStates, recursive);				parent.hitTestState = null;			}			if (parent.overState != null)			{				DisplayObjectUtil._checkChild(parent.overState, destroyStates, recursive);				parent.overState = null;			}			if (parent.upState != null)			{				DisplayObjectUtil._checkChild(parent.upState, destroyStates, recursive);				parent.upState = null;			}		}		protected static function _checkChild(child:DisplayObject, destroy:Boolean, recursive:Boolean):void		{			var dest:IDestroyable;			if (destroy && child is IDestroyable)			{				dest = child as IDestroyable;				if (!dest.destroyed)					dest.destroy();			}			if (recursive)				DisplayObjectUtil.removeChildren(child, destroy, recursive);		}		public static function skinOf(container:DisplayObject, clazz:Class):DisplayObject		{			if (!container)				return null;			if (container is Stage || container.parent is Stage)				return null;			if (container is clazz)				return container;			return skinOf(container.parent, clazz);		}		public static function stopAll(clip:DisplayObjectContainer):void		{			// static stuff			if (!clip)				return;			// stop itself			if (clip is MovieClip)				MovieClip(clip).gotoAndStop(1);			// stop it own child(s)			var numChildren:int = clip.numChildren;			while (numChildren--)				stopAll(clip.getChildAt(numChildren) as DisplayObjectContainer);		}	}}