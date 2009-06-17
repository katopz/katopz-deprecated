/**
 * VERSION: 0.63
 * DATE: 5/7/2009
 * AS3 (AS2 version will also be available)
 * UPDATES AND DOCUMENTATION AT: http://blog.greensock.com/timelinemax/
 **/
package gs {
	import flash.events.*;
	import flash.utils.*;
	
	import gs.core.tween.*;
	import gs.events.TweenEvent;
/**
 * 	TimelineMax is an intuitive timeline class for building and managing sequences of 
 * 	TweenLite, TweenMax, TimelineLite, and/or TimelineMax instances. It extends the 
 *  TimelineLite class, adding convenient (but non-essential) features like AS3 event 
 *  dispatching, repeat, repeatDelay, yoyo, addCallback(), removeCallback(), and getActive() 
 *  (and probably more in the future). You can treat a TimelineMax much like a MovieClip 
 *  timeline in the Flash IDE. You can:
 * 	
 * <ul>
 * 		<li> build sequences easily by adding tweens with the append(), prepend(), and insert() methods.
 * 
 * 		<li> add labels, play(), stop(), gotoAndPlay(), gotoAndStop(), restart(), and even reverse()! 
 * 		
 * 		<li> nest timelines within timelines as deeply as you want. When you pause or change the 
 * 		  timeScale of a timeline, it affects all of its descendents.
 * 		  
 * 		<li> reverse() smoothly anytime. 
 * 		
 * 		<li> set the progress of the timeline using its "progress" property. For example, to skip to
 * 		  the halfway point, set myTimeline.progress = 0.5. 
 * 		  
 * 		<li> tween the "totalTime" or "progress" property to fastforward/rewind the timeline. You could 
 * 		  even attach a slider to one of these properties to give the user the ability to drag 
 * 		  forwards/backwards through the whole timeline.
 * 		  
 * 		<li> add onStart, onUpdate, onComplete, onReverseComplete, and/or onRepeat callbacks using the 
 * 		  constructor's "vars" object.
 * 		
 * 		<li> speed up or slow down the entire timeline with its timeScale property. You can even tween
 * 		  this property to gradually speed up or slow down the timeline.
 * 		  
 * 		<li> use the insertMultiple() method to create complex sequences including various alignment
 * 		  modes and staggering capabilities. You can optionally use a new shorthand syntax too, 
 * 		  like "[mc, 1, {x:100}]" instead of "new TweenLite(mc, 1, {x:100})". 
 * 		  
 * 		<li> base the timing on frames instead of seconds if you prefer. Please note, however, that
 * 		  the timeline's timing mode dictates its childrens' timing mode as well. 
 * 		
 * 		<li> kill the tweens of a particular object with killTweensOf() or get the tweens of an object
 * 		  with getTweensOf() or get all the tweens/timelines in the timeline with getChildren()
 * 		  
 * 		<li> set the timeline to repeat any number of times or indefinitely. You can even set a delay
 * 		  between each repeat cycle and/or cause the repeat cycles to yoyo, appearing to reverse
 * 		  every other cycle. 
 * 		
 * 		<li> listen for START, UPDATE, and COMPLETE events.
 * 		
 * 		<li> get the active tweens in the timeline.
 * 	</ul>
 * 	
 * <b>EXAMPLE:</b><br /><br /><code>
 * 		
 * 		import gs.TweenLite;<br />
 * 		import gs.TimelineMax;<br /><br />
 * 		
 * 		//create the timeline<br />
 * 		var myTimeline:TimelineMax = new TimelineMax();<br /><br />
 * 		
 * 		//add a tween<br />
 * 		myTimeline.append(new TweenLite(mc, 1, {x:200, y:100}));<br /><br />
 * 		
 * 		//add another tween at the end of the timeline (makes sequencing easy)<br />
 * 		myTimeline.append(new TweenLite(mc, 0.5, {alpha:0}));<br /><br />
 * 		
 * 		//repeat the whole timeline twice.<br />
 * 		myTimeline.repeat = 2;<br /><br />
 * 		
 * 		//delay the repeat by 0.5 seconds each time.<br />
 * 		myTimeline.repeatDelay = 0.5;<br /><br />
 * 		
 * 		//stop/pause the timeline.<br />
 * 		myTimeline.stop();<br /><br />
 * 		
 * 		//reverse it anytime...<br />
 * 		myTimeline.reverse();<br /><br />
 * 		
 * 		//Add a "spin" label 3-seconds into the timeline.<br />
 * 		myTimeline.addLabel("spin", 3);<br /><br />
 * 		
 * 		//insert a rotation tween at the "spin" label (you could also define the insert point as the time instead of a label)<br />
 * 		myTimeline.insert(new TweenLite(mc, 2, {rotation:"360"}), "spin"); <br /><br />
 * 		
 * 		//go to the "spin" label and play the timeline from there...<br />
 * 		myTimeline.gotoAndPlay("spin");<br /><br />
 * 		
 * 		//add a tween to the beginning of the timeline, pushing all the other existing tweens back in time<br />
 * 		myTimeline.prepend(new TweenLite(mc, 1, {tint:0xFF0000}));<br /><br />
 * 		
 * 		//nest another TimelineMax inside your timeline...<br />
 * 		var nestedTimeline:TimelineMax = new TimelineMax();<br />
 * 		nestedTimeline.append(new TweenLite(mc2, 1, {x:200}));<br />
 * 		myTimeline.append(nestedTimeline);<br /><br /></code>
 * 		
 * 		
 * 	insertMultiple() provides some very powerful sequencing tools as well, allowing you to add an Array of 
 * 	tweens (using TweenLite/Max instances or the new shorthand syntax, like <code>[mc, 1, {x:100}]</code>) and align them
 * 	as ALIGN_SEQUENCE or ALIGN_START or ALIGN_INIT, and even stagger them if you want. For example, to insert
 * 	3 tweens into the timeline, aligning their start times but staggering them by 0.2 seconds, <br /><br /><code>
 * 	
 * 		myTimeline.insertMultiple([new TweenLite(mc, 1, {y:"100"}),
 * 								   new TweenLite(mc2, 1, {y:"100"}),
 * 								   new TweenLite(mc3, 1, {y:"100"})], 
 * 								   0, 
 * 								   TimelineMax.ALIGN_START, 
 * 								   0.2);</code><br /><br />
 * 								   
 * 	You can use the constructor's "vars" object to do all the setup too, like:<br /><br /><code>
 * 	
 * 		var myTimeline:TimelineMax = new TimelineMax({tweens:[[mc1, 1, {y:"100"}], [mc2, 1, {y:"100"}]], align:TimelineMax.ALIGN_SEQUENCE, onComplete:myFunction, repeat:2, repeatDelay:1});</code><br /><br />
 * 	
 * 	If that confuses you, don't worry. Just use the append(), insert(), and prepend() methods to build your
 * 	sequence. But power users will likely appreciate the quick, compact way they can set up sequences now. <br /><br />
 *  	
 * 	
 * <b>SPECIAL PROPERTIES THAT CAN BE PASSED IN VIA THE CONSTRUCTOR'S "VARS" OBJECT:</b>
 * <ul>
 * 	<li><b> delay : Number</b>				Amount of delay before the timeline should begin (in seconds unless "useFrames" is set 
 * 											to true in which case the value is measured in frames).
 * 								
 * 	<li><b> useFrames : Boolean</b>			If useFrames is set to true, the timeline's timing mode will be based on frames. 
 * 											Otherwise, it will be based on seconds/time. NOTE: a TimelineLite's timing mode is 
 * 											always determined by its parent timeline. 
 * 
 *  <li><b> paused : Boolean</b>			If true, the timeline will be paused initially.
 * 
 * 	<li><b> reversed : Boolean</b>			If true, the timeline will be reversed initially.
 * 									
 * 	<li><b> tweens : Array</b>				To immediately insert several tweens into the timeline, use the "tweens" special property
 * 											to pass in an Array of TweenLite or TweenMax instances, or use the shorthand syntax like
 * 											<code>[mc, 1, {x:100}]</code> instead of <code>new TweenLite(mc, 1, {x:100})</code>. You can use this in conjunction
 * 											with the align and stagger special properties to set up complex sequences with minimal code.
 * 											These values simply get passed to the insertMultiple() method.
 * 	
 * 	<li><b> align : String</b>				Only used in conjunction with the "tweens" special property when multiple tweens are
 * 											to be inserted immediately. The value simply gets passed to the 
 * 											insertMultiple() method. Options are:
 * 											<ul>
 * 												<li><b> TimelineLite.ALIGN_SEQUENCE:</b> aligns the tweens one-after-the-other in a sequence
 * 												<li><b> TimelineLite.ALIGN_START:</b>aligns the start times of all of the tweens (ignores delays)
 * 												<li><b> TimelineLite.ALIGN_INIT:</b> aligns the start times of all the tweens (honors delays)
 * 											</ul>
 * 											The default is ALIGN_INIT.
 * 										
 * 	<li><b> stagger : Number</b>			Only used in conjunction with the "tweens" special property when multiple tweens are
 * 											to be inserted immediately. It staggers the tweens by a set amount of time (in seconds) (or
 * 											in frames if "useFrames" is true). For example, if the stagger value is 0.5 and the "align" 
 * 											property is set to ALIGN_START, the second tween will start 0.5 seconds after the first one 
 * 											starts, then 0.5 seconds later the third one will start, etc. If the align property is 
 * 											ALIGN_SEQUENCE, there would be 0.5 seconds added between each tween. This value simply gets 
 * 											passed to the insertMultiple() method. Default is 0.
 * 									
 * 	<li><b> tweenClass : Class</b>			Only used in conjunction with the "tweens" special property when multiple tweens are
 * 											to be inserted immediately and you're using the shorthand syntax for the tweens in the
 * 											Array (like "[mc, 1, {x:100}]" instead of "new TweenMax(mc, 1, {x:100})"). The parsed 
 * 											tweens must be either TweenLite or TweenMax tweens. The "tweenClass" property allows you
 * 											to specify which you prefer. Choices are either TweenLite or TweenMax. TweenLite is the default.
 * 											The only time you need to specify TweenMax is if you require special features that are only
 * 											available in TweenMax like repeat, pause/resume, etc. Make sure you pass the actual class, 
 * 											NOT a String. <br />
 * 												<b>BAD:</b>  <code>new TimelineLite({tweens:[[mc, 1, {x:100}], [mc, 1, {y:100}]], tweenClass:"TweenMax"});</code><br />
 * 												<b>GOOD:</b> <code>new TimelineLite({tweens:[[mc, 1, {x:100}], [mc, 1, {y:100}]], tweenClass:TweenMax});</code>
 * 	
 * 	<li><b> onStart : Function</b>			A function that should be called when the timeline begins (the "progress" won't necessarily
 * 											be zero when onStart is called. For example, if the timeline is created and then its "progress"
 * 											property is immediately set to 0.5 or if its "time" property is set to something other than zero,
 * 											onStart will still get fired because it is the first time the timeline is getting rendered.)
 * 	
 * 	<li><b> onStartParams : Array</b>		An Array of parameters to pass the onStart function.
 * 	
 * 	<li><b> onUpdate : Function</b>			A function that should be called every time the timeline's time/position is updated 
 * 											(on every frame while the timeline is active)
 * 	
 * 	<li><b> onUpdateParams : Array</b>		An Array of parameters to pass the onUpdate function
 * 	
 * 	<li><b> onComplete : Function</b>		A function that should be called when the timeline has finished 
 * 	
 * 	<li><b> onCompleteParams : Array</b>	An Array of parameters to pass the onComplete function
 * 	
 * 	<li><b> onReverseComplete : Function</b> A function that should be called when the timeline has reached its starting point again after having been reversed 
 * 	
 * 	<li><b> onReverseCompleteParams : Array</b> An Array of parameters to pass the onReverseComplete functions
 *  
 * 	<li><b> onRepeat : Function</b>			A function that should be called every time the timeline repeats 
 * 	
 * 	<li><b> onRepeatParams : Array</b>		An Array of parameters to pass the onRepeat function
 * 	
 * 	<li><b> autoRemoveChildren : Boolean</b> If autoRemoveChildren is set to true, as soon as child tweens/timelines complete,
 * 											they will automatically get killed/removed. This is normally undesireable because
 * 											it prevents going backwards in time (like if you want to reverse() or set the 
 * 											"progress" value to a lower value, etc.). It can, however, improve speed and memory
 * 											management. TweenLite's root timelines use autoRemoveChildren:true.
 * 
 * 	<li><b> repeat : int</b>				Number of times that the timeline should repeat. To repeat indefinitely, use -1.
 * 	
 * 	<li><b> repeatDelay : Number</b>		Amount of time in seconds (or frames for frames-based timelines) between repeats.
 * 	
 * 	<li><b> yoyo : Boolean</b> 				Works in conjunction with the repeat property, determining the behavior of each 
 * 											cycle. When yoyo is true, the timeline will go back and forth, appearing to reverse 
 * 											every other cycle (this has no affect on the "reversed" property though).  
 * 									
 * 	<li><b> onStartListener : Function</b>	A function to which the TimelineMax instance should dispatch a TweenEvent when it begins.
 * 	  										This is the same as doing <code>myTimeline.addEventListener(TweenEvent.START, myFunction);</code>
 * 	
 * 	<li><b> onUpdateListener : Function</b>	A function to which the TimelineMax instance should dispatch a TweenEvent every time it 
 * 											updates values.	This is the same as doing <code>myTimeline.addEventListener(TweenEvent.UPDATE, myFunction);</code>
 * 	  
 * 	<li><b> onCompleteListener : Function</b>	A function to which the TimelineMax instance should dispatch a TweenEvent when it completes.
 * 	  											This is the same as doing <code>myTimeline.addEventListener(TweenEvent.COMPLETE, myFunction);</code>
 * 	</ul>
 *
 * <b>NOTES:</b>
 * <ul>
 * 	<li> TimelineMax automatically inits the OverwriteManager class to prevent unexpected overwriting behavior in sequences.
 * 	  The default mode is AUTO, but you can set it to whatever you want with OverwriteManager.init() (see http://blog.greensock.com/overwritemanager/)
 * 	<li> TimelineMax adds about 4k to your SWF including OverwriteManager.
 * </ul>
 * 
 * <b>Copyright 2009, GreenSock. All rights reserved.</b> This work is subject to the terms in <a href="http://www.greensock.com/terms_of_use.html">http://www.greensock.com/terms_of_use.html</a> or for corporate Club GreenSock members, the software agreement that was issued with the corporate membership.
 * 
 * @author Jack Doyle, jack@greensock.com
 **/
	public class TimelineMax extends TimelineLite implements IEventDispatcher {
		/** @private **/
		public static const version:Number = 0.63;
		public static const ALIGN_SEQUENCE:String = "sequence";
		public static const ALIGN_START:String = "start";
		public static const ALIGN_INIT:String = "init";
		
		/** @private **/
		protected var _repeat:int;
		/** @private **/
		protected var _repeatDelay:Number;
		/** @private **/
		protected var _cyclesComplete:uint;
		/** @private **/
		protected var _dispatcher:EventDispatcher;
		/** @private **/
		protected var _hasUpdateListener:Boolean;
		
		/** Works in conjunction with the repeat property, determining the behavior of each cycle. When yoyo is true, the timeline will go back and forth, appearing to reverse every other cycle (this has no affect on the "reversed" property though). **/
		public var yoyo:Boolean;
		
		/**
		 * Constructor 
		 * 
		 * @param $vars optionally pass in special properties like useFrames, onComplete, onCompleteParams, onUpdate, onUpdateParams, onStart, onStartParams, tweens, align, stagger, tweenClass, delay, autoRemoveChildren, onCompleteListener, onStartListener, onUpdateListener, repeat, repeatDelay, and/or yoyo.
		 */
		public function TimelineMax($vars:Object=null) {
			super($vars);
			_repeat = this.vars.repeat || 0;
			_repeatDelay = this.vars.repeatDelay || 0;
			_cyclesComplete = 0;
			this.yoyo = this.vars.yoyo || false;
			this.cacheIsDirty = true;
			if (this.vars.onCompleteListener != null || this.vars.onUpdateListener != null || this.vars.onStartListener != null || this.vars.onRepeatListener != null || this.vars.onReverseCompleteListener != null) {
				initDispatcher();
			}
		}
		
		/**
		 * If you want a function to be called at a particular time or label, use addCallback.
		 * 
		 * @param $function the function to be called
		 * @param $timeOrLabel the time in seconds (or frames for frames-based timelines) or label at which the callback should be inserted. For example, myTimeline.addCallback(myFunction, 3) would call myFunction() 3-seconds into the timeline, and myTimeline.addCallback(myFunction, "myLabel") would call it at the "myLabel" label.
		 * @param $params an Array of parameters to pass the callback
		 * @return TweenLite instance
		 */
		public function addCallback($function:Function, $timeOrLabel:*, $params:Array=null):TweenLite {
			var cb:TweenLite = new TweenLite($function, 0, {onComplete:$function, onCompleteParams:$params, overwrite:0, immediateRender:false});
			insert(cb, $timeOrLabel);
			return cb;
		}
		
		/**
		 * Removes a callback from a particular time or label. If timeOrLabel is null, all callbacks of that
		 * particular function are removed from the timeline.
		 * 
		 * @param $function callback function to be removed
		 * @param $timeOrLabel the time in seconds (or frames for frames-based timelines) or label from which the callback should be removed. For example, myTimeline.removeCallback(myFunction, 3) would remove the callback from 3-seconds into the timeline, and myTimeline.removeCallback(myFunction, "myLabel") would remove it from the "myLabel" label, and myTimeline.removeCallback(myFunction, null) would remove ALL callbacks of that function regardless of where they are on the timeline.
		 * @return true if any callbacks were successfully found and removed. false otherwise.
		 */
		public function removeCallback($function:Function, $timeOrLabel:*=null):Boolean {
			var a:Array = getTweensOf($function, false), i:int, success:Boolean;
			if (typeof($timeOrLabel) == "string") {
				if (!($timeOrLabel in _labels)) {
					return false;
				}
				$timeOrLabel = _labels[$timeOrLabel] || 0;
			}
			for (i = a.length - 1; i > -1; i--) {
				if ($timeOrLabel == null || a[i].startTime == $timeOrLabel) {
					remove(a[i] as Tweenable);
					success = true;
				}
			}
			return success;
		}
		
		/**
		 * Renders all tweens and sub-timelines in the state they'd be at a particular time (or frame for frames-based timelines). 
		 * 
		 * @param $time time in seconds (or frames for frames-based timelines) that should be rendered. It's based on the totalTime (includes repeats and repeatDelays)
		 * @param $force Normally the tween will skip rendering if the $time matches the cachedTotalTime (to improve performance), but if $force is true, it forces a render. This is primarily used internally for tweens with durations of zero in TimelineLite/Max instances.
		 */
		override public function renderTime($time:Number, $force:Boolean=false):void {
			if (this.gc) {
				this.setEnabled(true, false);
			} else if (!this.active && !this.cachedPaused) {
				this.active = true; 
			}
			var totalDur:Number = (this.cacheIsDirty) ? this.totalDuration : this.cachedTotalDuration, prevTime:Number = this.cachedTime, tween:Tweenable, isComplete:Boolean, rendered:Boolean, repeated:Boolean, isFirstRun:Boolean;
			if ($time >= totalDur) {
				if (this.cachedTotalTime != totalDur) {
					if (!this.cachedReversed && this.yoyo && _repeat % 2 != 0) {
						forceChildrenToBeginning(prevTime);
						this.cachedTime = 0;
					} else {
						forceChildrenToEnd(prevTime);
						this.cachedTime = this.cachedDuration;
					}
					this.cachedTotalTime = totalDur;
					isComplete = rendered = true;
				}
				
			} else if ($time <= 0) {
				if ($time < 0) {
					this.active = false;
				}
				if (this.cachedTotalTime != 0) {
					this.cachedTotalTime = 0;
					if (!this.cachedReversed && this.yoyo && _repeat % 2 != 0) {
						forceChildrenToEnd(prevTime);
						this.cachedTime = this.cachedDuration;
					} else {
						forceChildrenToBeginning(prevTime);
						this.cachedTime = 0;
					}
					rendered = true;
					if (this.cachedReversed) {
						isComplete = true;
					}
				}
			} else {
				this.cachedTotalTime = this.cachedTime = $time;
			}
			if (_repeat != 0) {
				var cycleDuration:Number = this.cachedDuration + _repeatDelay;
				this.cachedTime = ((this.yoyo && (this.cachedTotalTime / cycleDuration) % 2 >= 1) || (!this.yoyo && !((this.cachedTotalTime / cycleDuration) % 1))) ? this.cachedDuration - (this.cachedTotalTime % cycleDuration) : this.cachedTotalTime % cycleDuration;
				if (this.cachedTime >= this.cachedDuration) {
					this.cachedTime = this.cachedDuration;
				} else if (this.cachedTime <= 0) {
					this.cachedTime = 0;
				}
				
				if (_cyclesComplete != int(this.cachedTotalTime / cycleDuration) && !isComplete && (this.cachedTime != prevTime || $force)) {
					repeated = true;
					_cyclesComplete = int(this.cachedTotalTime / cycleDuration);
					
					/*
					  make sure tweenables at the end/beginning of the timeline are rendered properly. If, for example, 
					  a 3-second long timeline rendered at 2.9 seconds previously, and now renders at 3.2 seconds (which
					  would get transated to 2.8 seconds if the timeline yoyos or 0.2 seconds if it just repeats), there
					  could be a callback or a short tween that's at 2.95 or 3 seconds in which wouldn't render. So 
					  we need to push the timeline to the end (and/or beginning depending on its yoyo value).
					*/
					
					var forward:Boolean = Boolean(!this.yoyo || (_cyclesComplete % 2 == 1));
					if (this.cachedReversed) {
						forward = !forward;
					}
					
					if (forward) {
						forceChildrenToEnd(prevTime, false);
						if (!this.yoyo) {
							forceChildrenToBeginning(this.cachedDuration, true);
						}
					} else {
						forceChildrenToBeginning(prevTime, false);
						if (!this.yoyo) {
							forceChildrenToEnd(0, true);
						}
					}
				}
			}
			
			if (!this.initted) {
				this.initted = isFirstRun = true;
				if (this.vars.onStart != null) {
					this.vars.onStart.apply(null, this.vars.onStartParams);
				}
				if (_dispatcher != null) {
					_dispatcher.dispatchEvent(new TweenEvent(TweenEvent.START));
				}
			} else if (this.cachedTime == prevTime && !$force) {
				return;
			}
			
			if (rendered) {
				//already rendered, so ignore
			} else if (this.cachedTime - prevTime > 0) {
				tween = _firstChild;
				while (tween != null) {
					if (tween.active || (!tween.cachedPaused && tween.cachedDuration != 0 && tween.startTime <= this.cachedTime && tween.startTime + (tween.totalDuration / tween.cachedTimeScale) >= this.cachedTime)) {
						
						if (!tween.cachedReversed) {
							tween.renderTime((this.cachedTime - tween.startTime) * tween.cachedTimeScale);
						} else {
							tween.renderTime(tween.cachedTotalDuration - ((this.cachedTime - tween.startTime) * tween.cachedTimeScale));
						}
						
					} else if (tween.cachedDuration == 0 && !tween.cachedPaused && (tween.startTime > prevTime || isFirstRun) && tween.startTime <= this.cachedTime) {
						tween.renderTime(0, true);
					}
					tween = tween.nextNode;
				}
			} else {
				tween = _lastChild;
				while (tween != null) {
					if (tween.active || (!tween.cachedPaused && tween.cachedDuration != 0 && tween.startTime <= this.cachedTime && tween.startTime + (tween.totalDuration / tween.cachedTimeScale) >= this.cachedTime)) {
						
						if (!tween.cachedReversed) {
							tween.renderTime((this.cachedTime - tween.startTime) * tween.cachedTimeScale);
						} else {
							tween.renderTime(tween.cachedTotalDuration - ((this.cachedTime - tween.startTime) * tween.cachedTimeScale));
						}
						
					} else if (tween.cachedDuration == 0 && !tween.cachedPaused && tween.startTime < prevTime && tween.startTime >= this.cachedTime) {
						tween.renderTime(0, true);
					}
					tween = tween.prevNode;
				}
			}
			if (_hasUpdate) {
				this.vars.onUpdate.apply(null, this.vars.onUpdateParams);
			}
			if (_hasUpdateListener) {
				_dispatcher.dispatchEvent(new TweenEvent(TweenEvent.UPDATE));
			}
			if (isComplete) {
				complete(true);
			} else if (repeated) {
				if (this.vars.onRepeat != null) {
					this.vars.onRepeat.apply(null, this.vars.onRepeatParams);
				}
				if (_dispatcher != null) {
					_dispatcher.dispatchEvent(new TweenEvent(TweenEvent.REPEAT));
				}
			}
		}
		
		/**
		 * Forces the timeline to completion.
		 * 
		 * @param $skipRender to skip rendering the final state of the timeline, set skipRender to true. 
		 */
		override public function complete($skipRender:Boolean=false):void {
			super.complete($skipRender);
			if (_dispatcher != null) {
				if (this.cachedReversed && this.cachedTotalTime == 0 && this.cachedDuration != 0) {
					_dispatcher.dispatchEvent(new TweenEvent(TweenEvent.REVERSE_COMPLETE));
				} else {
					_dispatcher.dispatchEvent(new TweenEvent(TweenEvent.COMPLETE));
				}
			}
		}
		
		/**
		 * Returns the tweens/timelines that are currently active in the timeline.
		 * 
		 * @param $nested determines whether or not tweens and/or timelines that are inside nested timelines should be returned. If you only want the "top level" tweens/timelines, set this to false.
		 * @param $tweens determines whether or not tweens (TweenLite and TweenMax instances) should be included in the results
		 * @param $timelines determines whether or not timelines (TimelineLite and TimelineMax instances) should be included in the results
		 * @return an Array of active tweens/timelines
		 */
		public function getActive($nested:Boolean=true, $tweens:Boolean=true, $timelines:Boolean=false):Array {
			var a:Array = [], tweens:Array = getChildren($nested, $tweens, $timelines), i:int;
			var l:uint = tweens.length;
			for (i = 0; i < l; i++) {
				if (tweens[i].active) {
					a[a.length] = tweens[i];
				}
			}
			return a;
		}
		

//---- EVENT DISPATCHING ----------------------------------------------------------------------------------------------------------
		
		/** @private **/
		protected function initDispatcher():void {
			if (_dispatcher == null) {
				_dispatcher = new EventDispatcher(this);
				if (this.vars.onStartListener is Function) {
					_dispatcher.addEventListener(TweenEvent.START, this.vars.onStartListener, false, 0, true);
				}
				if (this.vars.onUpdateListener is Function) {
					_dispatcher.addEventListener(TweenEvent.UPDATE, this.vars.onUpdateListener, false, 0, true);
					_hasUpdateListener = true;
				}
				if (this.vars.onCompleteListener is Function) {
					_dispatcher.addEventListener(TweenEvent.COMPLETE, this.vars.onCompleteListener, false, 0, true);
				}
				if (this.vars.onRepeatListener is Function) {
					_dispatcher.addEventListener(TweenEvent.REPEAT, this.vars.onRepeatListener, false, 0, true);
				}
				if (this.vars.onReverseCompleteListener is Function) {
					_dispatcher.addEventListener(TweenEvent.REVERSE_COMPLETE, this.vars.onReverseCompleteListener, false, 0, true);
				}
			}
		}
		/** @private **/
		public function addEventListener($type:String, $listener:Function, $useCapture:Boolean = false, $priority:int = 0, $useWeakReference:Boolean = false):void {
			if (_dispatcher == null) {
				initDispatcher();
			}
			if ($type == TweenEvent.UPDATE) {
				_hasUpdateListener = true;
			}
			_dispatcher.addEventListener($type, $listener, $useCapture, $priority, $useWeakReference);
		}
		/** @private **/
		public function removeEventListener($type:String, $listener:Function, $useCapture:Boolean = false):void {
			if (_dispatcher != null) {
				_dispatcher.removeEventListener($type, $listener, $useCapture);
			}
		}
		/** @private **/
		public function hasEventListener($type:String):Boolean {
			return (_dispatcher == null) ? false : _dispatcher.hasEventListener($type);
		}
		/** @private **/
		public function willTrigger($type:String):Boolean {
			return (_dispatcher == null) ? false : _dispatcher.willTrigger($type);
		}
		/** @private **/
		public function dispatchEvent($e:Event):Boolean {
			return (_dispatcher == null) ? false : _dispatcher.dispatchEvent($e);
		}
		
		
//---- GETTERS / SETTERS -------------------------------------------------------------------------------------------------------
		
		/**
		 * Duration of the timeline in seconds (or frames for frames-based timelines) including any repeats
		 * or repeatDelays. "duration", by contrast, does NOT include repeats and repeatDelays.
		 **/
		override public function get totalDuration():Number {
			if (this.cacheIsDirty) {
				var temp:Number = super.totalDuration; //just forces refresh
				//Instead of Infinity, we use 999999999999 so that we can accommodate reverses.
				this.cachedTotalDuration = (_repeat == -1) ? 999999999999 : this.cachedDuration * (_repeat + 1) + (_repeatDelay * _repeat);
			}
			return this.cachedTotalDuration;
		}
		
		/** @private **/
		override public function set time($n:Number):void {
			if (_cyclesComplete == 0) {
				this.totalTime = $n;
			} else {
				this.totalTime = $n + (_cyclesComplete * this.duration);
			}
		}
		
		/** Number of times that the timeline should repeat. -1 repeats indefinitely. **/
		public function get repeat():int {
			return _repeat;
		}
		
		public function set repeat($n:int):void {
			_repeat = $n;
			setDirtyCache(true);
		}
		
		/** Amount of time in seconds (or frames for frames-based timelines) between repeats **/
		public function get repeatDelay():Number {
			return _repeatDelay;
		}
		
		public function set repeatDelay($n:Number):void {
			_repeatDelay = $n;
			setDirtyCache(true);
		}
		
	}
}