/*
Copyright (c) 2008 David Lenaerts.  See:
    http://code.google.com/p/wick3d
    http://www.derschmale.com

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/

package com.derschmale.wick3d.debug
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	/**
	 * The StatsDisplay class uses the data in GeneralStatsData to display statistical information.
	 * 
	 * @see com.derschmale.wick3d.debug.GeneralStatsData
	 * 
	 * @author David Lenaerts
	 * 
	 */
	public class StatsDisplay extends MovieClip
	{
		private var _fpsField : TextField;
		private var _verticesField : TextField;
		private var _polygonsField : TextField;
		private var _drawnPolygonsField : TextField;
		private var _modelsField : TextField;
		private var _drawnModelsField : TextField;
		
		/**
		 * Creates a new StatsDisplay object.
		 * 
		 * @param colour The colour of the text fields.
		 * 
		 */
		public function StatsDisplay(colour : uint = 0xffffff)
		{
			super();
			_fpsField = new TextField();
			_verticesField = new TextField();
			_polygonsField = new TextField();
			_drawnPolygonsField = new TextField();
			_modelsField = new TextField();
			_drawnModelsField = new TextField();
			_verticesField.textColor = colour;
			_fpsField.textColor = colour;
			_polygonsField.textColor = colour;
			_drawnPolygonsField.textColor = colour;
			_modelsField.textColor = colour;
			_drawnModelsField.textColor = colour;
			_verticesField.y = 15;
			_polygonsField.y = 30;
			_drawnPolygonsField.y = 45;
			_modelsField.y = 60;
			_drawnModelsField.y = 75;
			_fpsField.autoSize = TextFieldAutoSize.LEFT;
			_verticesField.autoSize = TextFieldAutoSize.LEFT;
			_polygonsField.autoSize = TextFieldAutoSize.LEFT;
			_drawnPolygonsField.autoSize = TextFieldAutoSize.LEFT;
			_modelsField.autoSize = TextFieldAutoSize.LEFT;
			_drawnModelsField.autoSize = TextFieldAutoSize.LEFT;
			addChild(_fpsField);
			addChild(_verticesField);
			addChild(_polygonsField);
			addChild(_drawnPolygonsField);
			addChild(_modelsField);
			addChild(_drawnModelsField);
			this.addEventListener(Event.ENTER_FRAME, handleEnterFrame);
		}
		
		private function handleEnterFrame(event : Event) : void
		{
			_fpsField.text = "FPS: "+GeneralStatData.fps.toPrecision(4);
			_verticesField.text = "Total Vertices: "+GeneralStatData.vertices;
			_polygonsField.text = "Total Polygons: "+GeneralStatData.polygons;
			_drawnPolygonsField.text = "Drawn Polygons: "+GeneralStatData.drawnPolygons;
			_modelsField.text = "Total Models: "+GeneralStatData.models;
			_drawnModelsField.text = "Drawn Models: "+GeneralStatData.drawnModels;
		}
	}
}