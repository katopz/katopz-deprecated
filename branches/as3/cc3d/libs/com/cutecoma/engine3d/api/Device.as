package com.cutecoma.engine3d.api
{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.utils.*;

	import com.cutecoma.engine3d.*;
	import com.cutecoma.engine3d.api.light.*;
	import com.cutecoma.engine3d.api.material.*;
	import com.cutecoma.engine3d.api.texture.*;
	import com.cutecoma.engine3d.common.math.*;
	import com.cutecoma.engine3d.common.vertex.Vertex;
	import com.cutecoma.engine3d.core.bsp.*;
	import com.cutecoma.engine3d.core.primitive.*;
	import com.cutecoma.engine3d.core.render.*;
	import com.cutecoma.engine3d.core.transform.*;

	public class Device extends Object
	{
		private var MATRIX_FACTORY:Matrix3DFactory;
		private const USE_PSTREAM_CACHE:Boolean = true;//DEV//
		private var _Handler:DisplayObjectContainer = null;
		private var _Pipeline:Pipeline = null;
		private var _PStreamCache:Dictionary = null;
		private var _Viewport:Viewport = null;
		private var _Initialized:Boolean = false;
		private var _NbPrimitives:int = 0;

		public function Device(param1:DisplayObjectContainer, param2:Viewport)
		{
			this.MATRIX_FACTORY = Matrix3DFactory.instance;
			_Handler = param1;
			_Viewport = param2;
			this.initialize();
			
		}

		public function set material(value:Material):void
		{
			_Pipeline.ambient = value.ambient.toInt();
			_Pipeline.diffuse = value.diffuse.toInt();
			
		}

		public function set texture(value:Texture):void
		{
			if (value == null)
			{
				_Pipeline.bitmap = null;
			}
			else
			{
				_Pipeline.bitmap = value.bitmap;
				_Pipeline.textureRepeat = value.repeat;
			}
			
		}

		public function set viewport(value:Viewport):void
		{
			_Viewport = value;
			this.reset();
			
		}

		public function get transform():TransformProxy
		{
			return _Pipeline.transform;
		}

		public function get renderStates():RenderStateProxy
		{
			return _Pipeline.renderStates;
		}

		public function get lights():Vector.<DirectionalLight>
		{
			return _Pipeline.lights;
		}

		public function get nbPrimitives():int
		{
			return _NbPrimitives;
		}

		public function get viewport():Viewport
		{
			return _Viewport;
		}

		private function initialize():void
		{
			_Pipeline = new Pipeline(_Handler);
			_Pipeline.lights.push(new DirectionalLight(new Vector3D(0, 1, 0)));
			_PStreamCache = new Dictionary(true);
			this.transform.view = this.MATRIX_FACTORY.lookAtLH(new Vector3D(), new Vector3D(0, 0, 1), Vector3D.Y_AXIS);
			this.transform.world = new Matrix3D();
			_Initialized = true;
			this.reset();
			
		}

		private function reset():void
		{
			_Handler.scrollRect = new Rectangle((-_Viewport.width) / 2, (-_Viewport.height) / 2, _Viewport.width, _Viewport.height);
			this.transform.viewportWidth = _Viewport.width;
			this.transform.viewportHeight = _Viewport.height;
			this.transform.projection = this.MATRIX_FACTORY.perspectiveFovLH(Math.PI / 4, _Viewport.width / _Viewport.height, 0.01, 100);
			
		}

		public function beginScene():void
		{
			
		}

		public function endScene():void
		{
			
		}

		public function present():void
		{
			_Pipeline.present();
			
		}

		public function clear():void
		{
			_Pipeline.clear();
			_NbPrimitives = 0;
			
		}

		public function drawPrimitive(param1:uint, param2:Vector.<Vertex>, param3:Vector.<int> = null, param4:Class = null, param5:Sprite = null):void
		{
			var _loc_6:PrimitiveStream = null;
			var _loc_7:* = param3 ? (param3) : (param2);
			if (!_Initialized)
			{
				return;
			}
			_loc_6 = _PStreamCache[_loc_7];
			if (!this.USE_PSTREAM_CACHE || _loc_6 == null)
			{
				param4 = BspTree;
				_loc_6 = new PrimitiveStream(param1, param2, param3, param4);
				_PStreamCache[_loc_7] = _loc_6;
			}
			_NbPrimitives = _NbPrimitives + _loc_6.indices.length / 3;
			_Pipeline.accept(_loc_6, param5);
			
		}
	}
}