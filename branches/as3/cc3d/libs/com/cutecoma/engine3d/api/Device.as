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
		private const USE_PSTREAM_CACHE:Boolean = !true;
		private var _Handler:DisplayObjectContainer = null;
		private var _Pipeline:Pipeline = null;
		private var _PStreamCache:Dictionary = null;
		private var _Viewport:Viewport = null;
		private var _Initialized:Boolean = false;
		private var _NbPrimitives:int = 0;

		public function Device(param1:DisplayObjectContainer, param2:Viewport)
		{
			this.MATRIX_FACTORY = Matrix3DFactory.instance;
			this._Handler = param1;
			this._Viewport = param2;
			this.initialize();
			
		}

		public function set material(param1:Material):void
		{
			this._Pipeline.ambient = param1.ambient.toInt();
			this._Pipeline.diffuse = param1.diffuse.toInt();
			
		}

		public function set texture(param1:Texture):void
		{
			if (param1 == null)
			{
				this._Pipeline.bitmap = null;
			}
			else
			{
				this._Pipeline.bitmap = param1.bitmap;
				this._Pipeline.textureRepeat = param1.repeat;
			}
			
		}

		public function set viewport(param1:Viewport):void
		{
			this._Viewport = param1;
			this.reset();
			
		}

		public function get transform():TransformProxy
		{
			return this._Pipeline.transform;
		}

		public function get renderStates():RenderStateProxy
		{
			return this._Pipeline.renderStates;
		}

		public function get lights():Vector.<DirectionalLight>
		{
			return this._Pipeline.lights;
		}

		public function get nbPrimitives():int
		{
			return this._NbPrimitives;
		}

		public function get viewport():Viewport
		{
			return this._Viewport;
		}

		private function initialize():void
		{
			this._Pipeline = new Pipeline(this._Handler);
			this._Pipeline.lights.push(new DirectionalLight(new Vector3D(0, 1, 0)));
			this._PStreamCache = new Dictionary(true);
			this.transform.view = this.MATRIX_FACTORY.lookAtLH(new Vector3D(), new Vector3D(0, 0, 1), Vector3D.Y_AXIS);
			this.transform.world = new Matrix3D();
			this._Initialized = true;
			this.reset();
			
		}

		private function reset():void
		{
			this._Handler.scrollRect = new Rectangle((-this._Viewport.width) / 2, (-this._Viewport.height) / 2, this._Viewport.width, this._Viewport.height);
			this.transform.viewportWidth = this._Viewport.width;
			this.transform.viewportHeight = this._Viewport.height;
			this.transform.projection = this.MATRIX_FACTORY.perspectiveFovLH(Math.PI / 4, this._Viewport.width / this._Viewport.height, 0.01, 100);
			
		}

		public function beginScene():void
		{
			
		}

		public function endScene():void
		{
			
		}

		public function present():void
		{
			this._Pipeline.present();
			
		}

		public function clear():void
		{
			this._Pipeline.clear();
			this._NbPrimitives = 0;
			
		}

		public function drawPrimitive(param1:uint, param2:Vector.<Vertex>, param3:Vector.<int> = null, param4:Class = null, param5:Sprite = null):void
		{
			var _loc_6:PrimitiveStream = null;
			var _loc_7:* = param3 ? (param3) : (param2);
			if (!this._Initialized)
			{
				return;
			}
			_loc_6 = this._PStreamCache[_loc_7];
			if (!this.USE_PSTREAM_CACHE || _loc_6 == null)
			{
				param4 = BspTree;
				_loc_6 = new PrimitiveStream(param1, param2, param3, param4);
				this._PStreamCache[_loc_7] = _loc_6;
			}
			this._NbPrimitives = this._NbPrimitives + _loc_6.indices.length / 3;
			this._Pipeline.accept(_loc_6, param5);
			
		}
	}
}