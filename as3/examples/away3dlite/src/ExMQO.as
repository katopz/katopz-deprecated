/*

Basic Metasequoia loading in Away3dLite

Demonstrates:

How to load a Metasequoia file.
How to load a texture from an external image.
How to clone a laoded model.

Code by Rob Bateman & Katopz
rob@infiniteturtles.co.uk
http://www.infiniteturtles.co.uk
katopz@sleepydesign.com
http://sleepydesign.com/

This code is distributed under the MIT License

Copyright (c)  

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the “Software”), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

*/

package
{
	import away3dlite.core.base.*;
	import away3dlite.events.*;
	import away3dlite.loaders.*;
	import away3dlite.templates.*;
	
	import flash.display.*;
	import flash.geom.Vector3D;

	[SWF(backgroundColor="#000000", frameRate="60", quality="MEDIUM", width="800", height="600")]

	/**
	 * Metasequoia example.
	 */
	public class ExMQO extends BasicTemplate
	{
		private var mqo:MQO;
		private var loader:Loader3D;
		
		/**
		 * @inheritDoc
		 */
		override protected function onInit():void
		{
			title += " : Metasequoia Example.";
			
			useHandCursor = false;
			mouseEnabled = false;
			mouseChildren = false;
			
			/*
			camera.y = -3000;
			camera.z = -3000;
			camera.lookAt(new Vector3D(0,0,0));
			*/
			
			mqo = new MQO();
			
			loader = new Loader3D();
			loader.loadGeometry("mqo/L_R_vinet.mqo", mqo);
			scene.addChild(loader);
		}
		
		override protected function onPreRender():void
		{
			scene.rotationY++;
		}
	}
}