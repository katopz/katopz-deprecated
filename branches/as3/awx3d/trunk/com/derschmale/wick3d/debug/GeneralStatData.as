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
	/**
	 * GeneralStatData is a static class containing statistics of the current or last render.
	 * 
	 * @see com.derschmale.wick3d.debug.StatsDisplay
	 * 
	 * @author David Lenaerts
	 */
	public class GeneralStatData
	{
		/**
		 * The amount of renders executed in total since the start of the application.
		 */
		public static var renderCount : int = 0;
		
		/**
		 * The initial amount of source triangles fed to the pipeline.
		 */
		public static var polygons : uint = 0;
		
		/**
		 * The amount of polygons that are eventually drawn.
		 */
		public static var drawnPolygons : uint = 0;
		
		/**
		 * The initial amount of models fed to the pipeline.
		 */
		public static var models : uint = 0;
		
		/**
		 * The amount of models that are eventually drawn.
		 */
		public static var drawnModels : uint = 0;
		
		/**
		 * The initial amount of source vertices fed to the pipeline.
		 */
		public static var vertices : uint = 0;
		
		/**
		 * The time in milliseconds that the last render pass took.
		 */
		public static var renderTime : uint = 0;
		
		/**
		 * The frames per second during the last render pass.
		 */
		public static var fps : Number = 0;
		
		private static var _oldTime : uint = 0;
		
		/**
		 * Resets the data for a new render loop.
		 */
		public static function reset(milliseconds : uint) : void
		{
			polygons = 0;
			drawnPolygons = 0;
			models = 0;
			drawnModels = 0;
			vertices = 0;
			renderCount++;
			renderTime = milliseconds - _oldTime;
			fps = 1000/renderTime;
			_oldTime = milliseconds;
		}
	}
}