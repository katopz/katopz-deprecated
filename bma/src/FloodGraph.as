package
{
	import com.sleepydesign.containers.Cursor;
	import com.sleepydesign.site.*;
	import com.sleepydesign.utils.*;
	import com.yahoo.astra.fl.charts.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.*;
	import flash.system.Security;
	
	import gs.TweenMax;

	public class FloodGraph extends Content
	{

		//TODO path config
		public var rootPath:String = "Flood/";


		public var type:String = "Graph";

		public var graph0:ColumnChart;
		public var graph1:ColumnChart;

		public var isTest:Boolean = false;

		public function FloodGraph()
		{
			Security.allowDomain("*");

			graph0 = iGraphContainer0;
			graph1 = iGraphContainer1;

			graph0.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler0);
			graph0.mouseEnabled = !true;
			graph0.useHandCursor = !true;
			graph0.buttonMode = !true;

			graph1.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler1);
			graph1.mouseEnabled = !true;
			graph1.useHandCursor = !true;
			graph1.buttonMode = !true;

			addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			addEventListener(MouseEvent.MOUSE_OUT, mouseUpHandler);

			//test();

			var cursor1:Cursor = new Cursor(this, iGraphContainer0);
			var cursor2:Cursor = new Cursor(this, iGraphContainer1);

			// tab
			Global.tabIDChangeSignal.add(resetGraph);
		}

		private function resetGraph(tabID:String):void
		{
			if (_data)
				parseData(_data, tabID);
		}

		private function mouseUpHandler(param1:MouseEvent):void
		{
			if (graph0)
				graph0.stopDrag();

			if (graph1)
				graph1.stopDrag();
		}

		public function test()
		{
			trace("Self Test")

			isTest = true;

			var dataPath:String = "../serverside/FloodmonAllStation.xml";

			Global.tabID = Global.TUNNEL_TAB;

			/*if (Global.tabID == Global.TUNNEL_TAB)
				setGraph("VALUE_IN");
			else*/
			setGraph("VALUE");
		}

		//_________________________________________________________________ Graph

		private var type2:String;

		public function createGraph(graph, type, type2 = null)
		{
			graph.horizontalField = "LABEL";
			graph.verticalField = type;
			this.type2 = type2;
		}

		public function setGraph(type, type2 = null)
		{
			createGraph(graph0, type, type2);
			createGraph(graph1, type, type2);

			var dataPath = XMLUtil2.getNodeById(config, "FloodGraphData").@src;
			var method = String(XMLUtil2.getNodeById(config, "FloodGraphData").@method).toUpperCase();

			trace("all color : " + XMLUtil2.getNodeById(config, "FloodGraphData").@allColor);

			// color
			Global.FLOOD_GRAPH_COLOR = XMLUtil2.getNodeById(config, "FloodGraphData").@floodColor || Global.FLOOD_GRAPH_COLOR;
			Global.TUNNEL_GRAPH_COLOR = XMLUtil2.getNodeById(config, "FloodGraphData").@tunnelColor || Global.TUNNEL_GRAPH_COLOR;

			if (isTest)
				dataPath = "../serverside/FloodmonAllStation.xml";

			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, xmlLoadCompleteHandler);

			var request = new URLRequest(URLUtil.killCache(dataPath))
			loader.load(request);
		}

		public function xmlLoadCompleteHandler(event:Event):void
		{
			var loader:URLLoader = event.target as URLLoader;
			_data = new XML(loader.data);
			parseData(_data, Global.tabID);

			//all done
			var mom = (parent as Content)
			if (mom)
				mom.ready();
		}

		private function parseData(data:XML, tabID:String):void
		{
			trace(" * parseData : " + tabID);

			var data0:Array = [];
			var data1:Array = [];
			var i:int;

			switch (tabID)
			{
				case Global.ALL_TAB:
				{
					for (i = 0; i < data.STATION.length(); i++)
					{
						// proxy vin VALUE_IN -> VALUE
						var stationXML:XML = data.STATION[i].copy();
						
						if (String(stationXML.VALUE).length > 0)
						{
							// normal value case
							data0.push(stationXML);
							data1.push(stationXML);
						}else{
							if (String(stationXML.VALUE_IN).length > 0)
							{
								stationXML.VALUE = Number(stationXML.VALUE_IN);
								stationXML.LABEL = String(stationXML.LABEL) + " (เข้า)";
								data0.push(stationXML);
								data1.push(stationXML);
							}
							
							// proxy vout VALUE_OUT -> VALUE
							if (String(stationXML.VALUE_OUT).length > 0)
							{
								stationXML = data.STATION[i].copy();
								stationXML.VALUE = Number(stationXML.VALUE_OUT);
								stationXML.LABEL = String(stationXML.LABEL) + " (ออก)";
								data0.push(stationXML);
								data1.push(stationXML);
							}
						}
					}
						
					data0.sortOn("VALUE", Array.DESCENDING | Array.NUMERIC);

					//sort alphabet
					var data3:Array = [];
					var _data0:Array = [];
					var _value:Number = -1;

					for each (var _data:* in data0)
					{
						//new group
						if (_value != Number(_data.VALUE))
						{
							//mem value
							_value = Number(_data.VALUE);

							//mem data
							if (_data0)
							{
								//sort alphabet
								_data0.sortOn("@id");

								//concat
								data3 = data3.concat(_data0);

								//reset
								_data0 = [];
							}
						}
						_data0.push(_data);
					}

					_data0.sortOn("@id");
					data3 = data3.concat(_data0);

					graph0.width = data.STATION.length() * 760 / 20;
					graph0.width = .5 * Math.max(graph0.width, 760);

					graph1.width = data.STATION.length() * 760 / 20;
					graph1.width = .5 * Math.max(graph1.width, 760);

					TweenMax.to(tunnel_0_mc, 0, {x: 887.95, alpha: 1, tint: Global.TUNNEL_GRAPH_COLOR});
					TweenMax.to(tunnel_1_mc, 0, {x: 887.95, alpha: 1, tint: Global.TUNNEL_GRAPH_COLOR});
					TweenMax.to(flood_0_mc, 0, {x: 925.90, alpha: 1, tint: Global.FLOOD_GRAPH_COLOR});
					TweenMax.to(flood_1_mc, 0, {x: 925.90, alpha: 1, tint: Global.FLOOD_GRAPH_COLOR});

					TweenMax.to(tunnel_desc_0_mc, 0, {x: 875.8, alpha: 1});
					TweenMax.to(tunnel_desc_1_mc, 0, {x: 875.8, alpha: 1});
					TweenMax.to(flood_desc_0_mc, 0, {x: 918.8, alpha: 1});
					TweenMax.to(flood_desc_1_mc, 0, {x: 918.8, alpha: 1});

					// rotation
					Global.GRAPH_ROTATION = 80;

					graph0.dataProvider = [data3];
					graph1.dataProvider = [data1];

					break;
				}
				case Global.FLOOD_TAB:
				{
					for (i = 0; i < data.STATION.length(); i++)
					{
						if (String(data.STATION[i].@id).indexOf(tabID) == 0)
						{
							data0.push(data.STATION[i]);
							data1.push(data.STATION[i]);
						}
					}

					data1.sortOn("@id");
					data0.sortOn("VALUE", Array.DESCENDING | Array.NUMERIC);

					graph0.width = data.STATION.length() * 760 / 20;
					graph0.width = .5 * Math.max(graph0.width, 760);

					graph1.width = data.STATION.length() * 760 / 20;
					graph1.width = .5 * Math.max(graph1.width, 760);

					// color
					ColumnChart.getStyleDefinition().seriesColors[0] = Global.FLOOD_GRAPH_COLOR;

					TweenMax.to(tunnel_0_mc, 0, {x: 887.95, alpha: 0, tint: Global.TUNNEL_GRAPH_COLOR});
					TweenMax.to(tunnel_1_mc, 0, {x: 887.95, alpha: 0, tint: Global.TUNNEL_GRAPH_COLOR});
					TweenMax.to(flood_0_mc, 0, {x: 925.90, alpha: 1, tint: Global.FLOOD_GRAPH_COLOR});
					TweenMax.to(flood_1_mc, 0, {x: 925.90, alpha: 1, tint: Global.FLOOD_GRAPH_COLOR});

					TweenMax.to(tunnel_desc_0_mc, 0, {x: 875.8, alpha: 0});
					TweenMax.to(tunnel_desc_1_mc, 0, {x: 875.8, alpha: 0});
					TweenMax.to(flood_desc_0_mc, 0, {x: 918.8, alpha: 1});
					TweenMax.to(flood_desc_1_mc, 0, {x: 918.8, alpha: 1});

					// rotation
					Global.GRAPH_ROTATION = 80;

					graph0.dataProvider = [data0];
					graph1.dataProvider = [data1];

					break;
				}
				case Global.TUNNEL_TAB:
				{
					var data0_out:Array = [];
					var data1_out:Array = [];

					var STATION_LENGTH:int = data.STATION.length();
					
					for (i = 0; i < STATION_LENGTH; i++)
					{
						if (String(data.STATION[i].@id).indexOf(tabID) == 0)
						{
							// one way?
							if ((String(data.STATION[i].VALUE_IN).length <= 0) || (String(data.STATION[i].VALUE_OUT).length <= 0))
							{
								data.STATION[i].ONEWAY = "true";
							}else{
								data.STATION[i].ONEWAY = "false";
							}
							
							// proxy vin VALUE_IN -> VALUE
							var stationXML:XML = data.STATION[i].copy();
							stationXML.VALUE = Number(stationXML.VALUE_IN);
							stationXML.LABEL = "(เข้า) (ออก)\n" + String(stationXML.LABEL);
							
							data0.push(stationXML);
							data1.push(stationXML);

							// proxy vout VALUE_OUT -> VALUE
							stationXML = data.STATION[i].copy();
							stationXML.VALUE = Number(stationXML.VALUE_OUT);
							stationXML.LABEL = "(เข้า) (ออก)\n" + String(stationXML.LABEL);

							data0_out.push(stationXML);
							data1_out.push(stationXML);
						}
					}

					// vin
					data0.sortOn("VALUE", Array.DESCENDING | Array.NUMERIC);
					
					// vout
					// sort by sorted vin
					var data0_out_sorted:Array = [];
					for (i=0 ;i<data0.length;i++)
					{
						for (var j:int = 0; j < data0_out.length; j++) 
						{
							if(data0_out[j].@id == data0[i].@id)
							{
								data0_out_sorted.push(data0_out[j]);
							}
						}
					}
							
					// vin
					data1.sortOn("@id");
					
					// vout
					data1_out.sortOn("@id");
					
					var w:Number = data0.length * 760 / 10;
					graph1.width = graph0.width = Math.max(w, 760);

					// color
					ColumnChart.getStyleDefinition().seriesColors[0] = Global.TUNNEL_GRAPH_COLOR;

					TweenMax.to(tunnel_0_mc, 0, {x: 925.90, alpha: 1, tint: Global.TUNNEL_GRAPH_COLOR});
					TweenMax.to(tunnel_1_mc, 0, {x: 925.90, alpha: 1, tint: Global.TUNNEL_GRAPH_COLOR});
					TweenMax.to(flood_0_mc, 0, {alpha: 0, tint: Global.FLOOD_GRAPH_COLOR});
					TweenMax.to(flood_1_mc, 0, {alpha: 0, tint: Global.FLOOD_GRAPH_COLOR});

					TweenMax.to(tunnel_desc_0_mc, 0, {x: 915, alpha: 1});
					TweenMax.to(tunnel_desc_1_mc, 0, {x: 915, alpha: 1});
					TweenMax.to(flood_desc_0_mc, 0, {alpha: 0});
					TweenMax.to(flood_desc_1_mc, 0, {alpha: 0});
					
					// rotation
					Global.GRAPH_ROTATION = 0;

					graph0.dataProvider = [data0, data0_out_sorted];
					graph1.dataProvider = [data1, data1_out];
					break;
				}
			}

			// draw left
			if (fake0)
				fake0.visible = false;

			if (fake1)
				fake1.visible = false;

			TweenMax.to(this, 0.5, {onComplete: draw});
		}

		private var fake0:Sprite;
		private var fake1:Sprite;

		private var _data:XML;

		private function mouseDownHandler0(param1:MouseEvent):void
		{
			var min = graph0.x;
			var max = -(graph0.width - 760);

			graph0.startDrag(false, new Rectangle(min, graph0.y, max, 0));
			//draw();
		}

		private function mouseDownHandler1(param1:MouseEvent):void
		{
			var min = graph1.x;
			var max = -(graph1.width - 760);

			graph1.startDrag(false, new Rectangle(min, graph1.y, max, 0));
		}

		//_________________________________________________________________ Update

		private function draw():void
		{
			var graphBitmap:BitmapData = GraphicUtil.getBitmapData(graph0, false);
			var axisBitmap:BitmapData = new BitmapData(33, graphBitmap.height);
			axisBitmap.copyPixels(graphBitmap, new Rectangle(0, 0, 33, 190), new Point());

			if (fake0)
			{
				fake0.parent.removeChild(fake0);
				fake0 = null;
			}

			fake0 = new Sprite();
			addChild(fake0);
			fake0.x = graph0.x;
			fake0.y = graph0.y;
			fake0.addChild(new Bitmap(axisBitmap));

			//
			var graphBitmap:BitmapData = GraphicUtil.getBitmapData(graph1, false);
			var axisBitmap:BitmapData = new BitmapData(33, graphBitmap.height);
			axisBitmap.copyPixels(graphBitmap, new Rectangle(0, 0, 33, 190), new Point());

			if (fake1)
			{
				fake1.parent.removeChild(fake1);
				fake1 = null;
			}

			fake1 = new Sprite();
			addChild(fake1);
			fake1.x = graph1.x;
			fake1.y = graph1.y;
			fake1.addChild(new Bitmap(axisBitmap));
		}

		public override function onUpdate(event:ContentEvent):void
		{
			if (event.content.name == "FloodGraph")
				setGraph("VALUE");
		}
		
		private function removeItemAt(arr:Array, index:int):*
		{
			if (index == -1)
				return index;
			
			const item:* = arr[index];
			
			arr.splice(index, 1);
			
			return item;
		}
		
		private function removeItem(arr:Array, item:*):*
		{
			return removeItemAt(arr, arr.indexOf(item));
		}
	}
}