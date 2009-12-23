package com.sleepydesign.core
{
	import com.sleepydesign.components.SDInputText;
	import com.sleepydesign.events.SDEvent;
	import com.sleepydesign.utils.LoaderUtil;
	import com.sleepydesign.utils.StringUtil;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.SimpleButton;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.net.URLVariables;
	import flash.text.TextField;
	import flash.utils.Dictionary;

	public class SDForm extends SDContainer
	{
		//public var loader : SDLoader;
		
		public var inputs : Dictionary;
		public var action : String; 
		public var method : String = "POST";
		public var onIncompleteCommand : String;
		
		// source, xml
		public function SDForm(id:String=null, instance:DisplayObjectContainer=null, xml:XML=null)
		{
			super(id);
			
			//loader = SDApplication.getLoader();
			
			trace("\n / [Form."+id+"] ------------------------------- ");
			
			action = xml.@action;
			method = xml.@method;
			onIncompleteCommand = xml.@onIncomplete;
			
			inputs = new Dictionary(true);
			
			var xmlList:XMLList = xml.children();
			
			for (var i:uint = 0; i < xmlList.length(); i++ ) 
			{
				var name:String = String(xmlList[i].name()).toLowerCase();
				var itemXML:XML = xmlList[i];
				var instanceString:String = String(itemXML.@id);
				instanceString = !StringUtil.isNull(itemXML.@src)?String(itemXML.@src):instanceString;

				//var item:* = {};
				
				trace("   + " + name + "\t: " + String(itemXML.@id));
				
				switch(name) 
				{
					case "textfield":
						var _textField:TextField = instance.getChildByName(instanceString) as TextField;
						var item:SDInputText = new SDInputText(_textField.text, _textField);
						item.restrict
						if(item)
						{
							item.defaultText = (String(itemXML.@label) != "")? String(itemXML.@label):item.text;
							item.defaultText = (String(itemXML.text()) != "")? String(itemXML.text()):item.defaultText;
							item.text = item.defaultText;
							
							//manual override by server
							item.text = (String(itemXML.@value) != "")? String(itemXML.@value):item.text;
							
							item.id = String(itemXML.@id);
							item.isRequired = Boolean(String(itemXML.@required) == "true");
							item.disable = Boolean(String(itemXML.@disable) == "true");
							item.type = String(itemXML.@type);
							
							//item.displayAsPassword = (item.type=="password" || item.label.displayAsPassword); 
							
							item.isReset = Boolean(String(itemXML.@reset) == "true");
							
							item.maxChars = !StringUtil.isNull(itemXML.@maxlength)?int(itemXML.@maxlength):0;
							item.restrict = !StringUtil.isNull(itemXML.@restrict)?String(itemXML.@restrict):null;
							
							item.onInvalidCommand = (String(itemXML.@onInvalid) != "")? String(itemXML.@onInvalid):"";
							
							item.label.removeEventListener(FocusEvent.FOCUS_IN, focusListener);
							item.label.addEventListener(FocusEvent.FOCUS_IN, focusListener);
							
							//reg
							inputs[String(itemXML.@id)] = item;
						}
					break;
					case "button":
						// TODO : fancy button
						var button:SimpleButton = SimpleButton(instance.getChildByName(instanceString));
						
						switch(String(itemXML.@type)) 
						{
							case "submit":
								button.removeEventListener(MouseEvent.CLICK, buttonListener);
								button.addEventListener(MouseEvent.CLICK, buttonListener);
							break;
						}
					break;
				}
			}
			trace(" ------------------------------- [Form."+id+"] /\n");
		}
		
		// ____________________________________________ Field ____________________________________________
		
		private function focusListener(event:FocusEvent):void 
		{
			/*
			if(event.currentTarget.toString()=="SleepyTextArea"){
				item = event.currentTarget as SleepyTextArea;
			}else {
				item = event.currentTarget as SleepyTextInput;
			}
			*/
			//var label:TextField = TextField(event.currentTarget);
			
			//trace( " ^ " + event);
			
			var item:* = event.currentTarget;// as SleepyTextInput;
			
			//trace( " item.type : " + item.parent.type);
			//trace( " event.currentTarget.parent " + event.currentTarget.parent);
			
			switch(event.type) 
			{
				case FocusEvent.FOCUS_IN :
					if (item.text == item.parent.defaultText) item.text = "";
					
					switch(item.parent.type) 
					{
						case "password":
							item.text = "";
							item.displayAsPassword = true;
						break;
					}
					item.parent.setText(item.text);
					event.currentTarget.addEventListener(FocusEvent.FOCUS_OUT, focusListener);
				break;
				case FocusEvent.FOCUS_OUT :
					
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
		
		private function buttonListener(event:MouseEvent):void
		{
			trace( " ^ " + event.type);
			
			_data = validateData();
			
			if (_data) 
			{
				submit();
			}else {
				//dispatchEvent(new SDEvent(SDEvent.INVALID, {inputs:inputs}));
			}
		}
		
		// ____________________________________________ Validate ____________________________________________
		
		private function validateData():URLVariables
		{
			var formData:URLVariables 	= new URLVariables();
			var isRequired:Boolean 		= false;
			var isComplete:Boolean 		= true;
			var isValid:Boolean 		= true;
			var input:*
			
			// fill all?
			for each(input in inputs)
			{			
				//is edit?
				input.isEdit = (input.text != input.defaultText) && (input.text != "");
				
				// all edit mean complete
				isComplete = isComplete && input.isEdit;
				
				// only 1 required mean required
				isRequired = isRequired || input.isRequired;
			}
			
			if(isRequired)
			{
				if (!isComplete)
				{
					dispatchEvent(new SDEvent(SDEvent.INCOMPLETE,{inputs:inputs}));
					// no mercy!
					return null;
				}
			}
			
			//collect input
			for each(input in inputs)
			{
				//reset
				input.isValid = false;
				
				//is edit?
				input.isEdit = (input.text != input.defaultText) && (input.text != "");
				if (input.isEdit) 
				{
					//validate
					switch(input.type) 
					{
						/*
						case "password" :
							isValid = isValid && StringUtil.validateString(input.text);
						break;	
						case "string" :
							isValid = isValid && StringUtil.validateString(input.text);
						break;
						*/
						case "email" :
							isValid = isValid && StringUtil.validateEmail(input.text);
						break;
						/*
						case "phone" :
							isValid = isValid && StringUtil.validatePhone(input.text);
						break;
						case "number" :
							isValid = isValid && StringUtil.validateNumber(input.text);
						break;
						*/
						default :
							isValid = isValid && StringUtil.validateString(input.text);
						break;
					}
				}else {
					//not fill yet
					if (input.isRequired) 
					{
						isValid = false;
						//dispatchEvent(new SDEvent(SDEvent.INCOMPLETE,{inputs:inputs}));
						//return null;
					}
				}
				
				input.isValid = isValid; 
				
				if (isValid) 
				{
					if (input.isEdit) 
					{
						formData[input.id] = input.text;
						
					}
				}else {
					trace(" ! Invalid");
					dispatchEvent(new SDEvent(SDEvent.INVALID, {inputs:inputs}));
					return null;
				}
				
				//clear
				if (input.isEdit) 
				{
					switch(input.type) 
					{
						case "password" :
							input.text=input.defaultText;
						break;	
					}
				}
			}
			
			//finally
			if (isValid)
			{ 
				return formData;
			}else{
				dispatchEvent(new SDEvent(SDEvent.INCOMPLETE,{inputs:inputs}));
				return null;
			}
		}
		
		// ____________________________________________ Action ____________________________________________
		
		public function submit():void
		{
			trace(" ! Submit");
			
			//dispatchEvent(new SDEvent(SDEvent.LOAD, LoaderUtil.loadXML(action, onGetFormData)));
			
			/*
			loader.addEventListener(SDEvent.COMPLETE, onGetFormData);
			loader.addEventListener(SDEvent.ERROR, onGetFormData);
			
			loader.load(action, _data);
			*/
			//LoaderUtil.loadXML(action, onGetFormData);
			LoaderUtil.requestXML(action, _data, onGetFormData);
		}
		
		// ____________________________________________ Data ____________________________________________
		
		public function getContent(uri:String):*
		{
			//return loader.getContent(uri);
		}
		
		//public static var data:*;
		private function onGetFormData(event:Event):void
		{
			if(event.type!=Event.COMPLETE)return;
			
			trace(" ^ onGetFormData\t: "+event);
			var _dataEvent:DataEvent = new DataEvent(DataEvent.DATA, false, false, event.target.data);
			dispatchEvent(_dataEvent);
			dispatchEvent(event);
			//dispatchEvent(new SDEvent(SDEvent.VALID, {loader:event.target}));
			
			/*
			switch(event.type) 
			{
				case Event.COMPLETE:
					for each(var input:* in inputs) 
					{
						if (input.isReset) 
						{
							input.text=input.defaultText;
						}
					}
				break;
				case SDEvent.ERROR:
					//SystemUtil.alert(SDLoader(event.target).getContent(action));
				break;
			}
			//dispatchEvent(event.clone());
			dispatchEvent(new SDEvent(SDEvent.COMPLETE, {loader:event.target}));
			*/
		}
	}
}