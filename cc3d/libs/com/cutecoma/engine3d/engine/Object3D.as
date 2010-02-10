package com.cutecoma.engine3d.engine
{
	import flash.display.*;
	import flash.geom.*;
	import com.cutecoma.engine3d.api.*;
	import com.cutecoma.engine3d.api.material.*;
	import com.cutecoma.engine3d.api.mesh.*;
	import com.cutecoma.engine3d.api.texture.*;
	import com.cutecoma.engine3d.common.*;

	public class Object3D extends Object implements IDrawable3D, IClonable
	{
		protected var _mesh:BaseMesh;
		protected var _texture:Texture;
		protected var _material:Material;
		protected var _sprite:Sprite;
		protected var _position:Vector3D;
		protected var _rotation:Vector3D;
		protected var _scale:Vector3D;
		protected var _worldMatrix3D:Matrix3D;
		protected var _transform:Matrix3D;
		
		private var _visible:Boolean = true;

		public function Object3D(baseMesh:BaseMesh = null, sprite:Sprite = null)
		{
			_material = new Material();
			_position = new Vector3D(0, 0, 0);
			_rotation = new Vector3D(0, 0, 0);
			_scale = new Vector3D(1, 1, 1);
			_worldMatrix3D = new Matrix3D();
			_mesh = baseMesh;
			_sprite = sprite;
		}

		public function get position():Vector3D
		{
			return _position;
		}

		public function get rotation():Vector3D
		{
			return _rotation;
		}

		public function get scale():Vector3D
		{
			return _scale;
		}

		public function get material():Material
		{
			return _material;
		}

		public function get sprite():Sprite
		{
			return _sprite;
		}

		public function get mesh():BaseMesh
		{
			return _mesh;
		}

		public function get texture():Texture
		{
			return _texture;
		}

		public function get visible():Boolean
		{
			return _visible;
		}

		public function set position(value:Vector3D):void
		{
			_position = value;
		}

		public function set rotation(value:Vector3D):void
		{
			_rotation = value;
		}

		public function set scale(value:Vector3D):void
		{
			_scale = value;
		}

		public function set material(value:Material):void
		{
			_material = value;
		}

		public function set mesh(value:BaseMesh):void
		{
			_mesh = value;
		}

		public function set texture(value:Texture):void
		{
			_texture = value;
		}

		public function set visible(value:Boolean):void
		{
			_visible = value;
		}

		public function set sprite(value:Sprite):void
		{
			_sprite = value;
		}

		public function set transform(value:Matrix3D):void
		{
			_transform = value;
		}

		public function set doubleSided(value:Boolean):void
		{
			this.mesh.subsets[1] = value ? (this.mesh.subsets[0].concat().reverse()) : (null);
		}

		protected function updateWorldMatrix(device:Device):void
		{
			_worldMatrix3D.recompose(Vector.<Vector3D>([_position, _rotation, _scale]));
		}

		public function draw(device:Device, sprite:Sprite = null):void
		{
			var _loc_3:Matrix3D;
			if (!_visible || _mesh == null)
				return;

			updateWorldMatrix(device);

			device.material = _material;
			device.texture = _texture;
			if (_transform)
			{
				_loc_3 = _worldMatrix3D.clone();
				_loc_3.append(_transform);
			}
			else
			{
				_loc_3 = _worldMatrix3D;
			}

			device.transform.world = _loc_3;
			_mesh.draw(device, sprite ? (sprite) : (_sprite));
		}

		public function clone():IClonable
		{
			var object3D:Object3D = new Object3D(_mesh, _sprite);
			object3D.position = _position.clone();
			object3D.rotation = _rotation.clone();
			object3D.scale = _scale.clone();
			object3D.texture = _texture;
			object3D.material = _material.clone() as Material;

			return object3D;
		}
	}
}