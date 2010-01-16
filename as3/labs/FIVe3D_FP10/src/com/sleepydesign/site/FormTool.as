package com.sleepydesign.site
{
	import com.sleepydesign.components.InputText;
	import com.sleepydesign.core.IDestroyable;
	import com.sleepydesign.data.DataProxy;
	import com.sleepydesign.events.FormEvent;
	import com.sleepydesign.net.LoaderUtil;
	import com.sleepydesign.system.SystemUtil;
	import com.sleepydesign.utils.ObjectUtil;
	import com.sleepydesign.utils.StringUtil;
	import com.sleepydesign.utils.ValidationUtil;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.SimpleButton;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.net.URLVariables;
	import flash.text.TextField;
	import flash.utils.Dictionary;

	public class FormTool extends EventDispatcher implements IDestroyable
	{
		private var _container:DisplayObjectContainer;
		private var _loader:Object/*URLLoader, Loader*/;
		private var _data:*;
		
		private var _eventHandler:Function;
		
		private var _items:Dictionary;
		
		public var action:String;
		public var method:String = "GET";
		
		private var onInvalidCommand:String;
		private var onIncompleteCommand:String;
		
		public var returnType:* = URLVariables;
		
		public static var useDebug:Boolean = false;
		
		private var alertText:TextField;
		private var _xml:XML;

		public function FormTool(container:DisplayObjectContainer = null, xml:XML = null, eventHandler:Function = null)
		{
			if(useDebug)trace("\n / [Form] ------------------------------- ");

			_container = container;
			_xml = xml;
			action = xml.@action;
			method = xml.@method;
			onInvalidCommand =  String(xml.@onInvalid);
			onIncompleteCommand =  String(xml.@onIncomplete);
			
			_eventHandler = eventHandler || trace;

			_items = new Dictionary(true);

			var xmlList:XMLList = xml.children();

			for (var i:uint = 0; i < xmlList.length(); i++)
			{
				var name:String = String(xmlList[i].name()).toLowerCase();
				var itemXML:XML = xmlList[i];
				var _containerID:String;
				// use src as id
				_containerID = StringUtil.getDefaultIfNull(itemXML.@src, String(itemXML.@id));

				if(useDebug)trace("   + " + name + "\t: " + _containerID);
				
				var _textField:TextField;
				var item:InputText;

				switch (name)
				{
					case "textfield":
						_textField = _container.getChildByName(_containerID) as TextField;
						if (String(itemXML.@type)=="alert")
							alertText = _textField;
					break;
					case "textinput":
						_textField = _container.getChildByName(_containerID) as TextField;
						item = new InputText(_textField.text, _textField);
						if (item)
						{
							item.defaultText = (String(itemXML.@label) != "") ? String(itemXML.@label) : item.text;
							item.defaultText = (String(itemXML.text()) != "") ? String(itemXML.text()) : item.defaultText;
							item.text = item.defaultText;

							item.text = (String(itemXML.@value) != "") ? String(itemXML.@value) : item.text;

							item.id = String(itemXML.@id);
							item.isRequired = Boolean(String(itemXML.@required) == "true");
							item.disable = Boolean(String(itemXML.@disable) == "true");
							item.type = String(itemXML.@type);

							item.isReset = Boolean(String(itemXML.@reset) == "true");

							item.maxChars = !StringUtil.isNull(itemXML.@maxlength) ? int(itemXML.@maxlength) : 0;
							item.restrict = !StringUtil.isNull(itemXML.@restrict) ? String(itemXML.@restrict) : null;

							item.label.removeEventListener(FocusEvent.FOCUS_IN, focusListener);
							item.label.addEventListener(FocusEvent.FOCUS_IN, focusListener);

							//reg
							_items[String(itemXML.@id)] = item;
						}
						break;
					case "button":
						var button:SimpleButton = SimpleButton(_container.getChildByName(_containerID));

						switch (String(itemXML.@type))
						{
							case "submit":
								button.removeEventListener(MouseEvent.CLICK, buttonHandler);
								button.addEventListener(MouseEvent.CLICK, buttonHandler);
								break;
						}

						button.visible = (String(itemXML.@visible) != "false");
						break;
				}
			}
			if(useDebug)trace(" ------------------------------- [Form] /\n");
		}

		// ____________________________________________ Field ____________________________________________

		private function focusListener(event:FocusEvent):void
		{
			var item:* = event.currentTarget;

			switch (event.type)
			{
				case FocusEvent.FOCUS_IN:
					if (item.text == item.parent.defaultText)
						item.text = "";

					switch (item.parent.type)
					{
						case "password":
							item.text = "";
							item.displayAsPassword = true;
							break;
					}
					item.parent.setText(item.text);
					event.currentTarget.addEventListener(FocusEvent.FOCUS_OUT, focusListener);
					break;
				case FocusEvent.FOCUS_OUT:

					if (item.text == "")
					{
						item.text = item.parent.defaultText;
						item.displayAsPassword = false;
					}
					item.parent.setText(item.text);
					event.currentTarget.removeEventListener(FocusEvent.FOCUS_OUT, focusListener);
					break;
			}
		}

		// ____________________________________________ Button ____________________________________________

		private function buttonHandler(event:MouseEvent):void
		{
			if(useDebug)trace(" ^ " + event.type);
			_data = validateData();
			if (_data)
			{
				submit();
			}
			/*else
			{
				var _formEvent:FormEvent = new FormEvent(FormEvent.INVALID, {items: _items}); 
				dispatchEvent(_formEvent);
				_eventHandler(_formEvent);
			}*/
		}

		// ____________________________________________ Validate ____________________________________________

		private function validateData():URLVariables
		{
			var formData:URLVariables = new URLVariables();
			var isRequired:Boolean = false;
			var isComplete:Boolean = true;
			var isValid:Boolean = true;
			var input:*
			
			var _formEvent:FormEvent;
			var _inCompleteList:Array = [];
			var _inValidNameList:Array = [];

			// fill all?
			for each (input in _items)
			{
				//is edit?
				input.isEdit = (input.text != input.defaultText) && (input.text != "");

				// all edit mean complete
				isComplete = isComplete && input.isEdit;

				// only 1 required mean required
				isRequired = isRequired || input.isRequired;
				
				if(!input.isEdit && input.isRequired)
					_inCompleteList.push(input);
			}

			if (isRequired)
			{
				if (!isComplete)
				{
					/*
					_formEvent = new FormEvent(FormEvent.INCOMPLETE, {items: _items});
					dispatchEvent(_formEvent);
					_eventHandler(_formEvent);
					*/
					
					showIncomplete(_inCompleteList);
					
					// no mercy!
					return null;
				}
			}

			//collect input
			for each (input in _items)
			{
				//reset
				input.isValid = false;

				//is edit?
				input.isEdit = (input.text != input.defaultText) && (input.text != "");
				if (input.isEdit)
				{
					//validate
					switch (input.type)
					{
						case "email":
							input.isValid = ValidationUtil.validateEmail(input.text);
							break;
						default:
							input.isValid = ValidationUtil.validateString(input.text);
							break;
					}
				}
				else
				{
					//not fill yet
					if (input.isRequired)
					{
						isValid = false;
						showIncomplete(input);
					}
				}

				if (input.isValid)
				{
					if (input.isEdit)
						formData[input.id] = input.text;
				}
				else
				{
					_inValidNameList.push(input.defaultText);
				}

				//clear
				if (input.isEdit)
				{
					switch (input.type)
					{
						case "password":
							input.text = input.defaultText;
							break;
					}
				}
				
				isValid = input.isValid && isValid;
			}

			//finally!
			if (isValid)
			{
				return formData;
			}
			else
			{
				showInvalid(_inValidNameList);
				return null;
			}
		}
		
		public function alert(msg:String):void
		{
			if(alertText)
				alertText.htmlText = msg;
		}
		
		private function showIncomplete(items:Array):void
		{
			if(useDebug)
				trace(" ! Incomplete");
				
			if(onIncompleteCommand)
				SystemUtil.doCommand(onIncompleteCommand, this);
				
			var _formEvent:FormEvent = new FormEvent(FormEvent.INCOMPLETE, {items: items});
			dispatchEvent(_formEvent);
			_eventHandler(_formEvent);
			
		}
		
		private function showInvalid(items:Array):void
		{
			if(useDebug)
				trace(" ! Invalid");
			
			if(onInvalidCommand)
				SystemUtil.doCommand(StringUtil.replace(onInvalidCommand, "$invalid_list", items.join(",")), this);
				
			var _formEvent:FormEvent = new FormEvent(FormEvent.INVALID, {items: items});
			dispatchEvent(_formEvent);
			_eventHandler(_formEvent);
		}

		// ____________________________________________ Action ____________________________________________

		public function submit():void
		{
			var url:String = action;
			
			//external get data
			if(!StringUtil.isNull(_xml.@get))
			{
				var _externalGETData:URLVariables = DataProxy.getDataByVars(_xml.@get);
				if(url.split("#")[0].indexOf("?")>-1)
					url += "&"+_externalGETData.toString();
			}
			
			//external post data
			if(!StringUtil.isNull(_xml.@post))
			{
				var _externalPOSTData:URLVariables = DataProxy.getDataByVars(_xml.@post);
				_data = ObjectUtil.addValue(_data, _externalPOSTData);
			}

			if(useDebug)
			{
				trace(" * Submit");
				ObjectUtil.print(_data);
			}
			
			LoaderUtil.SEND_METHOD = method;
			
			if(returnType == URLVariables)
			{
				_loader = LoaderUtil.requestVars(url, _data, onGetFormData);
			}else{
				_loader = LoaderUtil.request(url, _data, onGetFormData);
			}
			
			var _formEvent:FormEvent = new FormEvent(FormEvent.SUBMIT, _data); 
			dispatchEvent(_formEvent);
			_eventHandler(_formEvent);
		}

		// ____________________________________________ Server Data ____________________________________________

		private function onGetFormData(event:Event):void
		{
			//if(useDebug)
			trace(" ^ onGetFormData\t: " + event);
			if (event.type != Event.COMPLETE && event.type != DataEvent.DATA)
				return;

			// reset?
			for each (var input:*in _items)
				if (input.isReset)
					input.text = input.defaultText;
			
			// form data event
			//var _dataEvent:DataEvent = new DataEvent(DataEvent.DATA, false, false, event.target.data);
			dispatchEvent(event);
			_eventHandler(event);
		}
		
		// ____________________________________________ Gabage Collector ____________________________________________
		
		protected var _isDestroyed:Boolean;
		
		public function get destroyed():Boolean {
			return this._isDestroyed;
		}
		
		public function destroy():void
		{
			_loader = null;
			_eventHandler = null;
			_items = null;
		}
	}
}