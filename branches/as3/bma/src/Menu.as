/**
* ...
* @author katopz@sleepydesign.com
* @version 0.1
*/

package  {
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.system.SecurityPanel;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import fl.controls.Button;
	import fl.events.ComponentEvent;

	import com.sleepydesign.SleepyDesign;
	import com.sleepydesign.site.*;
	import com.sleepydesign.utils.*;
	
	public class Menu extends Sprite{
		
		var config : Object;
		var group
		
		public var currentId : String = "";
		public var currentTarget : String = "_self";
		
		namespace custom;
		
		custom function setFocus(id:String) {
			this.setFocus(id)
		}	
		
		custom function getLinkId(iLink:String) {
			var link:String = iLink;
			//trace(link)
			link = link.replace("($id)", '("' + currentId + '")')
			//trace(link)
			link = link.replace("$id", currentId);
			//trace(link)
			URLUtil.goToURL(link, currentTarget);
		}			
		
		
		public function Menu(iConfig:Object=null) {
			if(iConfig){
				dataprovider = iConfig;
			}
			
		}
		
		public function get dataprovider():Object {
			return config
		}
		
		public function set dataprovider(iConfig) {
			config = iConfig;
			
			//clear
			if(group){
				removeChild(group)
			}
			group = addChild(new Sprite())
			
			var i = 0;
			var x = 0;
			var w = 140
			
			for each(var link in config.item){
				var mc=new MovieClip();
				var button:Button = new Button();
				mc.src = link.@src;
				
				mc.target = link.@target;
				
				if (String(mc.target).length==0) {
					mc.target = "_self";
				}
				
				button.label = link.@label;
				//var w =  button.label.length*10;
				
				button.move(x, 10);
				button.setSize(w, 24);
				
				button.addEventListener(ComponentEvent.BUTTON_DOWN, buttonDownHandler);
				
				mc.addChild(button)
				
				group.addChild(mc)
				
				i++
				x+=w+16
			}
			
			group.x= (988-group.width)*.5
			
		}
		
		public function buttonDownHandler(event:ComponentEvent):void {
			var button = (event.currentTarget as Button)
			linkParser(button.parent.src, button.parent.target)
			//setFocus(event.currentTarget.name)
		}

		public function setFocus(id:String) {
			trace(" >  Menu.setFocus:"+id)
			//trace(parent.parent)
			var shell = (parent.parent as Panel);
			//trace(shell.setFocusByName)
			shell.subFocus(id);
		}
		
		public function linkParser(iLink:String, iTarget:String="_self"):void {
			var link:String = iLink;
			currentTarget = iTarget;
			if (link.indexOf(":") > -1) {
				var src = link.split(":")
				var protocal = src[0];
				var functionString = link.substr(protocal.length+1)
				//trace(functionString)
				var functionName = functionString.split("(")[0];
				var argumentString = functionString.substring(1+functionString.indexOf("("),functionString.lastIndexOf(")"))
				//trace(argumentString)
				var argumentArray = argumentString.split(",");
				var argument;
				
				//TODO arguments
				var arg = argumentArray[0];

				if((arg.indexOf("'")==0)&&(arg.lastIndexOf("'")==arg.length-1)){
					//string
					argument = arg.substring(1,arg.length-1);
				}else{
					//number
					argument = int(arg);
				}
				
				switch(protocal){
					case "actionscript":
						if(argumentString.length>0){
							custom::[functionName](argument);
							//this[functionName].apply(this, [argument]);
						}else{
							custom::[functionName]();
						}
					break;
					default :
						URLUtil.goToURL(link, iTarget);
					break;
				}
			}else {
				URLUtil.goToURL(link, iTarget);
			}
        }
	}
	
}
