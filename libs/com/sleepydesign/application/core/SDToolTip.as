package com.sleepydesign.application.core
{
	import flash.geom.Point;
	import mx.transitions.Tween;
	import mx.transitions.easing.Regular;
	import flash.filters.DropShadowFilter;
	
	public class SDToolTip extends SDSprite
	{
		private var _tooltip_txt:TextField;
		private var interval_id:Number;
		
		public function SDToolTip(in_str:String, in_mc:MovieClip, initObject:Object=null):void
		{
			//------------------------------init
			var oRef = this;
			//------------------------------create
			if (_root["_tooltip_txt_"+in_mc._name] != undefined) {
				var depth = _root["_tooltip_txt_"+depth].getDepth();
			} else {
				var depth = _root.getNextHighestDepth();
			}
			var width = (initObject._width == undefined) ? 20 : initObject._width;
			var height = (initObject._height == undefined) ? 20 : initObject._height;
			
			width = 200
			
			_tooltip_txt = _root.createTextField("_tooltip_txt_"+depth, depth, _root._xmouse+5, _root._ymouse+18, width, height);
			_tooltip_txt._alpha = 0;
			_tooltip_txt.border = true;
			_tooltip_txt.multiline = true;
			if(initObject._width == undefined){
				_tooltip_txt.wordWrap = false;
			}else{
				_tooltip_txt.wordWrap = true;
			}
			_tooltip_txt.selectable = false;
			_tooltip_txt.background = true;
			_tooltip_txt.backgroundColor = 0xFFFFE1;
			_tooltip_txt.align = "left";
			_tooltip_txt.autoSize = true;
			//
			_tooltip_txt.text = in_str;
			//------------------------------fx
			setFormat();
			_tooltip_txt.filters = [new DropShadowFilter(2, 45, 0x000000, 0.5, 2, 2)];
			//------------------------------event
			in_mc._onPress = in_mc.onPress;
			in_mc.onPress = function() {
				clearInterval(oRef.interval_id);
				oRef.alphaTo(oRef._tooltip_txt, oRef._tooltip_txt._alpha, 0);
				this._onPress();
			};
			in_mc._onRollOut = in_mc.onRollOut;
			in_mc.onRollOut = function() {
				oRef.clear();
				this._onRollOut();
			};
			in_mc._onRollOver = in_mc.onRollOver;
			in_mc.onRollOver = function() {
				oRef.draw(0.5);
				this._onRollOver();
			};
			
			in_mc.useHandCursor = (initObject.useHandCursor == undefined) ? false : initObject.useHandCursor;
			
			//_tooltip = _tooltip_txt;
		}
		
		public function set text(in_txt) 
		{
			_tooltip_txt.text = in_txt;
			setFormat();
			_tooltip_txt.filters = [new DropShadowFilter(2, 45, 0x000000, 0.5, 2, 2)];
		}
		
		private function setFormat() 
		{
			var text_fmt:TextFormat = new TextFormat();
			text_fmt.font = "Tahoma";
			text_fmt.size = 11;
			_tooltip_txt.setTextFormat(text_fmt);
		}
		
		private function removeTextField() {
			_tooltip_txt.removeTextField();
		}
		
		private function alphaTo(in_mc, in_beg_alpha, in_end_alpha, in_transition, in_obj, in_func, in_params) {
			if (typeof (in_transition) != "object") {
				in_transition = {duration:in_transition};
			}
			in_transition.duration = (in_transition.duration == undefined) ? 0.5 : in_transition.duration;
			in_transition.easing = (in_transition.easing == undefined) ? Regular.easeOut : in_transition.easing;
			in_mc._alpha = in_beg_alpha;
			in_mc._visible = (in_mc._alpha>=0);
			in_mc.alpha_twn.stop();
			in_mc.alpha_twn = new Tween(in_mc, "_alpha", Regular.easeOut, in_beg_alpha, in_end_alpha, in_transition.duration, true);
			in_mc.alpha_twn.onMotionFinished = function() {
				if (in_obj != undefined) {
					in_func.apply(in_obj, in_params);
				}
				delete in_mc.alpha_twn;
				in_mc._visible = (in_mc._alpha != 0);
			};
			return in_mc.alpha_twn;
		}
		//------------------------------function
		private function activate(oRef) {
			clearInterval(oRef.interval_id);
			var x = _root._xmouse;
			var y = _root._ymouse+18;
			var w = oRef._tooltip_txt._width;
			var h = oRef._tooltip_txt._height;
			//right
			if (x+w>stage.width) {
				x = stage.width-w;
			}
			//bottom     
			if (y+h>stage.height) {
				y = y-h-18;
			}
			//set     
			oRef._tooltip_txt._x = x;
			oRef._tooltip_txt._y = y;
			//reveal
			oRef.alphaTo(oRef._tooltip_txt, oRef._tooltip_txt._alpha, 100, .1);
		}
		
		private function clear():void
		{
			clearInterval(this.interval_id);
			this.alphaTo(this._tooltip_txt, this._tooltip_txt._alpha, 0, .1);
		}
		
		private function draw(delay:Number):void 
		{
			this.interval_id = setInterval(activate, 1000/2, this);
		}
	}
}