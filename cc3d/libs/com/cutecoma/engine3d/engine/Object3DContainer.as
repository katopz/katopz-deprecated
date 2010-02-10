package com.cutecoma.engine3d.engine
{

	import flash.display.*;
	import flash.geom.*;
	import com.cutecoma.engine3d.api.*;

	public class Object3DContainer extends Object implements IDrawable3D
	{
		private var _children:Vector.<Object3D>;
		private var _sprite:Sprite;
		private var _position:Vector3D;
		private var _rotation:Vector3D;
		private var _scale:Vector3D;
		private var _worldMatrix3D:Matrix3D;

		public function Object3DContainer(children:Vector.<Object3D> = null, sprite:Sprite = null)
		{
			_position = new Vector3D();
			_rotation = new Vector3D();
			_scale = new Vector3D(1, 1, 1);
			_worldMatrix3D = new Matrix3D();
			_children = children ? children : new Vector.<Object3D>;
			_sprite = sprite;
		}

		public function get children():Vector.<Object3D>
		{
			return _children;
		}

		public function get sprite():Sprite
		{
			return _sprite;
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

		public function set sprite(value:Sprite):void
		{
			_sprite = value;
		}

		public function draw(device:Device, sprite:Sprite = null):void
		{
			var _object3D:Object3D;
			if (!_children.length)
				return;
			
			_worldMatrix3D.recompose(Vector.<Vector3D>([_position, _rotation, _scale]));
			
			for each (_object3D in _children)
			{
				_object3D.transform = _worldMatrix3D;
				_object3D.draw(device, sprite?sprite:_sprite);
			}
		}
	}
}