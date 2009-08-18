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

package com.derschmale.wick3d.core.data
{
	import com.derschmale.wick3d.core.geometry.Triangle3D;
	import com.derschmale.wick3d.core.geometry.Vertex3D;
	import com.derschmale.wick3d.view.Viewport;
	
	/**
	 * The RenderPipelineData contains data used by the RenderPipeline, and which are shared throughout different steps of the pipeline.
	 * 
	 * @see com.derschmale.wick3d.core.pipeline.RenderPipeline
	 * 
	 * @author David Lenaerts
	 */
	public class RenderPipelineData extends GeometryData
	{
		/**
		 * The current viewport used to render to.
		 */
		public var viewPort : Viewport;
		
		/**
		 * Resets the data used in the rendering loop. Usually called at the beginning of the render pipeline to clear out the data from the previous cycle.
		 */
		override public function reset() : void
		{
			super.reset();
		}
	}
}