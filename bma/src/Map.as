/**
 * ...
 * @author katopz@sleepydesign.com
 * @version 0.1
 */

package
{
	import com.sleepydesign.SleepyDesign;
	import com.sleepydesign.containers.Balloon;
	import com.sleepydesign.site.*;
	import com.sleepydesign.utils.*;

	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.net.*;
	import flash.system.Security;
	import flash.text.*;
	import flash.utils.Dictionary;

	import gs.TweenMax;

	//import caurina.transitions.Tweener;

	public class Map extends Content
	{
		public var contentParentName = "Canal";

		public var isTest:Boolean = false;
		public var houses:Array;
		public var balloon:Balloon;
		public var housesMovieClip;
		public var isChk:Boolean = true;

		public function Map()
		{
			Security.allowDomain("*");
			//init();

			//test();
		}

		public function test()
		{
			trace("Self Test")
			isTest = true
			setMap();
		}

		//_________________________________________________________________ Map
		var houseDict:Dictionary

		public function init():void
		{
			houses = getChildArray(housesMovieClip);
			houseDict = new Dictionary();
			var balloons = housesMovieClip.addChild(new Sprite())

			for (var i in houses)
			{
				var house = houses[i] as MovieClip;

				house.visible = false;
				house.isChk = true;

				//house.buttonMode = true;
				//house.useHandCursor = true
				//house.hitArea = house.hit

				house.balloon = new Balloon("");
				house.balloon.extra = {desc: ""};

				balloons.addChild(house.balloon);

				house.balloon.visible = false;
				house.balloon.copyPosition(house);
				house.balloon.y -= 12;
				house.balloon.extra.y = house.balloon.y;
				house.balloon.alpha = 0.75;
				//house.balloon.blendMode = BlendMode.SCREEN
				house.balloon.extra.house = house;

				house.balloon.mouseEnabled = false;
				house.balloon.useHandCursor = false;
				house.balloon.buttonMode = false;
				house.balloon.mouseChildren = false;

				house.hit = GraphicUtil.createRect(house, housesMovieClip);
				house.hit.x = house.x - house.width * .5 - 3
				house.hit.y = house.y - house.height * .5 - 3
				house.hit.alpha = 0;
				house.hit.buttonMode = true;
				house.hit.useHandCursor = true


				house.scaleX = 1.3;
				house.scaleY = 1.3;
				house.balloon.scaleX = 1.3;
				house.balloon.scaleY = 1.3;

				houseDict[house.hit] = house;
			}
		}

		public function setMap():void
		{
			var dataPath = StringUtil.getNodeById(config, contentParentName + "MapData").@src;
			var method = String(StringUtil.getNodeById(config, contentParentName + "MapData").@method).toUpperCase();

			if (isTest)
			{
				dataPath = "http://localhost/yourpath/SCADA/serverside/getMapData.php";
				dataPath = "../serverside/CanalAllStation.xml";
			}

			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, onComplete);

			var request = new URLRequest(URLUtil.killCache(dataPath))

			loader.load(request);
		}

		//_________________________________________________________________ Data

		public function onComplete(event:Event):void
		{
			SleepyDesign.log(" ^ " + event.type);
			var loader:URLLoader = event.target as URLLoader;
			var xml:XML = new XML(loader.data);

			createMap(xml);

		}

		public function createMap(xml:XML):void
		{
			var item = xml;
			//var canelArray = new Array();
			/*
			   for each(var station in item..STATION){
			   //trace(station.CANAL_NAME);
			   }
			 */
			for each (var house:MovieClip in houses)
			{
				house.id = house.name;
				house.config = StringUtil.getNodeById(item, house.id);

				if (!house.config)
					continue;

				//trace(house.config.@id)
				if (house.config.@id == house.id)
				{
					house.hit.addEventListener(MouseEvent.MOUSE_DOWN, mouseHandler);
					house.hit.addEventListener(MouseEvent.MOUSE_OVER, mouseHandler);
					house.hit.addEventListener(MouseEvent.MOUSE_OUT, mouseHandler);

					house.visible = true;
					house.balloon.visible = true && isChk;
				}
				else
				{
					house.visible = false;
					house.balloon.visible = false && isChk;
				}

				if (house.balloon.visible)
					house.balloon.alpha = 1;
				else
					house.balloon.alpha = 0;
				house.gotoAndStop(1 + Number(house.config.STATUS));
				//trace(1 + Number(house.config.STATUS));
				//house.gotoAndStop(3);
				/*
				   //special request
				   if (String(house.name).charAt(0) == "E") {
				   //trace(String(house.name).charAt(0) )
				   house.visible = true;
				   house.gotoAndStop(2);
				   house.hit.addEventListener(MouseEvent.MOUSE_OVER, mouseHandler);
				   house.hit.addEventListener(MouseEvent.MOUSE_OUT, mouseHandler);
				   }
				   //cancel 2008_03_27
				 */

				//show all
				house.balloon.extra.text = house.balloon.text = String(house.config.LABEL);//!=""?String(house.config.LABEL):String(house.id);
				house.balloon.extra.desc = String(house.id) + " : " + String(house.config.NAME);

				//house.balloon.visible = true;
				//house.balloon.addEventListener(MouseEvent.CLICK, mouseHandler);
				//house.balloon.show();

				house.balloon.scaleX = house.balloon.scaleY = 0.99609375;
				house.scaleX = house.scaleY = house.balloon.scaleX;
			}

			setup(xml);

			//all done
			var mom = (parent as Content)
			if (mom)
			{
				trace("ready")
				mom.ready();
			}
		}

		public function setup(xml)
		{

		}

		public function getChildArray(container:DisplayObjectContainer)
		{
			var child:MovieClip;
			var childs:Array = new Array();

			for (var i:uint = 0; i < container.numChildren; i++)
			{
				child = container.getChildAt(i) as MovieClip
				if (child && child.name != "iMap")
				{
					//trace(child.name)if (house.name != "iMap")
					childs.push(child)
				}
			}
			return childs;
		}

		//_________________________________________________________________ Handler

		private function mouseHandler(event:MouseEvent):void
		{
			//var house = event.currentTarget;
			var house = houseDict[event.currentTarget]
			//trace(house)
			/*
			   trace(event.target, event.currentTarget)

			   var house
			   if (event.currentTarget is MovieClip) {
			   trace("MovieClip");
			   house = event.currentTarget as MovieClip;
			   }else {
			   trace("Balloon");
			   house = event.currentTarget.extra.house
			   }
			 */
			var i:*;
			switch (event.type)
			{
				case MouseEvent.CLICK:
				case MouseEvent.MOUSE_DOWN:
					try
					{
						var shell = parent.parent.parent as Panel;
						var panel = shell.currentContent as Panel;
						//var item = shell.getItemById(event.target.id)
						var index = shell.getIndexById(house.id)

						shell.setFocusIndex(panel, index);
						shell.subFocus("station");
							//shell.setItem(item);
					}
					catch (e:*)
					{
					}
					break;
				case MouseEvent.MOUSE_OVER:
					//if(house.hit.mouseEnabled)
					if (!house.isMouseOver)
					{
						house.isMouseOver = true
						house.body.gotoAndPlay(1);
						//Tweener.addTween(house, { scaleX:1.5, scaleY:1.5, time:1 } );

						house.balloon.visible = true;
						/*
						   house.balloon.alpha = 0;
						   house.balloon.visible = true;
						   house.balloon.show();
						   house.balloon.text = String(house.id)
						   house.balloon.copyPosition(house);
						 */

						//if(balloon.y>balloon.height){
						var oy:Number = house.balloon.y;
						//house.balloon.y = oy-5*house.scaleX;

						house.balloon.text = house.balloon.extra.desc;

						for (i in houses)
						{
							//houses[i].balloon.alpha = .1;
							if (houses[i] != house)
								TweenMax.to(houses[i].balloon, 0.2, {alpha: 0})
						}
						house.balloon.alpha = .75;
							//Tweener.addTween(house.balloon, { y:oy, time:1 } );
							//TweenMax.to(house.balloon, 1, { y:oy} );
					}
					break;
				case MouseEvent.MOUSE_OUT:

					house.isMouseOver = false
					//house.balloon.hide();
					house.body.gotoAndStop(1);

					house.balloon.text = house.balloon.extra.text;

					for (i in houses)
					{
						//houses[i].balloon.alpha = .1;
						if (houses[i] != house)
							TweenMax.to(houses[i].balloon, 0.2, {alpha: 0.75})
					}

					//Tweener.addTween(house, {scaleX:1, scaleY:1, time:1});

					house.balloon.visible = isChk;
					break;
			}
		}

		//_________________________________________________________________ Update

		public override function onUpdate(event:ContentEvent):void
		{
			if (event.content.name == contentParentName + "Map")
			{
				//trace("CanalMap:"+event.data.@id)
				setMap();
			}
		}
	}
}