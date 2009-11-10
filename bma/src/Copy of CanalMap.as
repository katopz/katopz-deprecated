/**
* ...
* @author katopz@sleepydesign.com
* @version 0.1
*/

package {
	
	import flash.filters.DropShadowFilter;
	import flash.system.Security;
	import flash.geom.*
	import flash.display.*
	import flash.events.*;
	import flash.net.*;
	import flash.system.SecurityPanel;
	import flash.text.*;
	import flash.utils.Dictionary;
	
	import caurina.transitions.Tweener;
	
	import com.sleepydesign.site.*;
	import com.sleepydesign.text.*;
	
	public class CanalMap extends Map{
		var dic
		var panel
		
		public function CanalMap(){
			
			contentParentName = "Canal"
			housesMovieClip = iHouses as MovieClip;
			
			init();
			
			panel = new Panel(this);
			panel.extra = new Object();
			panel.filters = [new DropShadowFilter(4,45,0,.5)]
			
			//test();
		}
		
		public override function setup(xml) {
			
			dic = new Dictionary();
			
			dic["คลองบางเขน"]="BK"
			dic["คลองบางซื่อ"]="BS"
			dic["คลองเปรมประชากร"]="KP"
			dic["คลองลาดพร้าว"]="LP"
			dic["คลองสามเสน"]="SA"
			dic["คลองแสนแสบ"]="SS"
			dic["คลองคูเมืองเดิม"]="PK"
			dic["แม่น้ำเจ้าพระยา"]="PK"
			
			var item = xml;
			
			var canalNames = new Array();
			var currentCaption 
			for each(var station in item..STATION){
				try{
				var canal = iCanal[dic[String(station.CANAL_NAME)]] as MovieClip
				var house = iHouses[String(station.@id)] as MovieClip
				var canalName = dic[String(station.CANAL_NAME)]
				
				//not 've yet
				if(canalNames.indexOf(String(station.CANAL_NAME))==-1){
					//trace(station.CANAL_NAME);
					
					
					var caption = new Content(panel,canalName);
					caption.extra = {num:0}
					caption.content = caption.addChild(new iLabel())
					//caption.content.label.text = String(station.CANAL_NAME)
					caption.content.gotoAndStop(canalName);
					
					caption.x = 740;
					caption.y = 200;
					
					currentCaption = panel.extra.caption = panel.addContent(caption);
					
					//caption.content.visible = false;
					
					//trace(dic[String(station.CANAL_NAME)]);
					
					canalNames.push(String(station.CANAL_NAME));
					canal.panel = panel;
					canal.childs = new Array();
				}else{
					currentCaption = panel.getContentByName(canalName)
				}
				
				
				var wtfText = String(station.@id)+" "+String(station.NAME).split(" ")[0];
				//var wtf = currentCaption.addChild()
				//wtf.x = 5
				//wtf.y = 50+16*currentCaption.extra.num++
				//wtf.filters = [new DropShadowFilter(0,0,0,0)]
				
				//trace(currentCaption.name)
				canal.childs.push(house);
				}catch(e:*){
					//
				}
			}
			
			
			
			var canals = getChildArray(iCanal)
			for(var i in canals){
				var child = canals[i] as MovieClip;
				if(child){
					child.buttonMode = true;
					child.useHandCursor = true
					child.addEventListener(MouseEvent.CLICK, canalOver);
					child.addEventListener(MouseEvent.MOUSE_OVER, canalOver);
					child.addEventListener(MouseEvent.MOUSE_OUT, canalOut);
					//trace(child.name)
					
				}
			}
			
		}
		
		//_________________________________________________________________ Handler
		
		public function canalOut(event:MouseEvent):void {
			for(var i in houses){
				//(houses[i] as MovieClip).alpha = 1
				showWTF(houses[i])
			}
			
			panel.setFocusAt(-1);
		}
		
		public function canalOver(event:MouseEvent):void {
			
			var canal = event.target as MovieClip;
			
			panel.setFocusByName(canal.name)
			
			//trace("canalOver:"+canal.name)
			
			for(var i in houses){
				//(houses[i] as MovieClip).alpha = 0
				hideWTF(houses[i])
			}
			
			for(i in canal.childs){
				var house = canal.childs[i] as MovieClip
				//trace(house.name)
				//house.alpha = 1
				showWTF(house)
			}
			
			
		}
		
		//_________________________________________________________________ Transition
		
		public function hideWTF(wtf,time:Number=0.5) {
			Tweener.addTween(wtf, { alpha:0, time:time, delay:0, transition:"easeoutquad" } );
			wtf.balloon.visible = false
		}
		
		public function showWTF(wtf,time:Number=0.5) {
			Tweener.addTween(wtf, { alpha:1, time:time, delay:0, transition:"easeoutquad" } );
			wtf.balloon.visible = true
		}
		
	}

}