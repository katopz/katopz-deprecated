package com.cutecoma.engine3d.api
{
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

	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.utils.*;

	public class Device extends Object
	{
		private var MATRIX_FACTORY:Matrix3DFactory;
		private const USE_PSTREAM_CACHE:Boolean = true; //DEV//
		private var _handler:DisplayObjectContainer;
		private var _pipeline:Pipeline;
		private var _pStreamCache:Dictionary;
		private var _viewport:Viewport;
		private var _initialized:Boolean = false;
		private var _nbPrimitives:int = 0;

		public function Device(handler:DisplayObjectContainer, viewport:Viewport)
		{
			this.MATRIX_FACTORY = Matrix3DFactory.instance;
			_handler = handler;
			_viewport = viewport;
			
			initialize();
		}

		public function set material(value:Material):void
		{
			_pipeline.ambient = value.ambient.toInt();
			_pipeline.diffuse = value.diffuse.toInt();
		}

		public function set texture(value:Texture):void
		{
			if (value == null)
			{
				_pipeline.bitmap = null;
			}
			else
			{
				_pipeline.bitmap = value.bitmap;
				_pipeline.textureRepeat = value.repeat;
			}
		}

		public function set viewport(value:Viewport):void
		{
			_viewport = value;
			this.reset();
		}

		public function get transform():TransformProxy
		{
			return _pipeline.transform;
		}

		public function get renderStates():RenderStateProxy
		{
			return _pipeline.renderStates;
		}

		public function get lights():Vector.<DirectionalLight>
		{
			return _pipeline.lights;
		}

		public function get nbPrimitives():int
		{
			return _nbPrimitives;
		}

		public function get viewport():Viewport
		{
			return _viewport;
		}

		private function initialize():void
		{
			_pipeline = new Pipeline(_handler);
			_pipeline.lights.push(new DirectionalLight(new Vector3D(0, 1, 0)));
			_pStreamCache = new Dictionary(true);
			
			transform.view = this.MATRIX_FACTORY.lookAtLH(new Vector3D(), new Vector3D(0, 0, 1), Vector3D.Y_AXIS);
			transform.world = new Matrix3D();
			
			_initialized = true;
			reset();
		}

		private function reset():void
		{
			_handler.scrollRect = new Rectangle((-_viewport.width) / 2, (-_viewport.height) / 2, _viewport.width, _viewport.height);
			this.transform.viewportWidth = _viewport.width;
			this.transform.viewportHeight = _viewport.height;
			this.transform.projection = this.MATRIX_FACTORY.perspectiveFovLH(Math.PI / 4, _viewport.width / _viewport.height, 0.01, 100);
		}

		public function beginScene():void
		{

		}

		public function endScene():void
		{

		}

		public function present():void
		{
			_pipeline.present();
		}

		public function clear():void
		{
			_pipeline.clear();
			_nbPrimitives = 0;
		}

		public function drawPrimitive(primitiveType:uint, vertices:Vector.<Vertex>, param3:Vector.<int> = null, bspTree:Class = null, param5:Sprite = null):void
		{
			var _loc_6:PrimitiveStream;
			var _loc_7:* = param3 ? (param3) : (vertices);
			if (!_initialized)
			{
				return;
			}
			_loc_6 = _pStreamCache[_loc_7];
			if (!this.USE_PSTREAM_CACHE || _loc_6 == null)
			{
				bspTree = BspTree;
				_loc_6 = new PrimitiveStream(primitiveType, vertices, param3, bspTree);
				_pStreamCache[_loc_7] = _loc_6;
			}
			_nbPrimitives = _nbPrimitives + _loc_6.indices.length / 3;
			_pipeline.accept(_loc_6, param5);
		}
	}
}