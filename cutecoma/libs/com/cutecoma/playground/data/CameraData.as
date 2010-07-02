package com.cutecoma.playground.data
{
	import com.sleepydesign.utils.ObjectUtil;
	
	import flash.net.registerClassAlias;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;

	public class CameraData implements IExternalizable
	{
		registerClassAlias("com.cutecoma.playground.data.CameraData", CameraData);

		public var x:Number;
		public var y:Number;
		public var z:Number;

		public var rotationX:Number;
		public var rotationY:Number;
		public var rotationZ:Number;

		public var focus:Number;
		public var zoom:Number;

		public function CameraData(x:Number = 0, y:Number = 0, z:Number = -500, rotationX:Number = 0, rotationY:Number = 0, rotationZ:Number = 0, focus:Number = 500, zoom:Number = 2)
		{
			this.x = x;
			this.y = y;
			this.z = z;

			this.rotationX = rotationX;
			this.rotationY = rotationY;
			this.rotationZ = rotationZ;

			this.focus = focus;
			this.zoom = zoom;
		}

		// _______________________________________________________internal

		public function parse_v0(raw:*):CameraData
		{
			x = raw.x ? Number(raw.x) : x;
			y = raw.y ? -Number(raw.y) : -y;
			z = raw.z ? Number(raw.z) : z;
			
			rotationX = raw.rotationX ? -Number(raw.rotationX) : -rotationX;
			rotationY = raw.rotationY ? Number(raw.rotationY) : rotationY;
			rotationZ = raw.rotationZ ? -Number(raw.rotationZ) : -rotationZ;
			
			focus = raw.focus ? Number(raw.focus) : focus;
			zoom = raw.zoom ? Number(raw.zoom) : zoom;
			
			return this;
		}
		
		public function parse(raw:*):CameraData
		{
			x = raw.x ? Number(raw.x) : x;
			y = raw.y ? Number(raw.y) : y;
			z = raw.z ? Number(raw.z) : z;

			rotationX = raw.rotationX ? Number(raw.rotationX) : rotationX;
			rotationY = raw.rotationY ? Number(raw.rotationY) : rotationY;
			rotationZ = raw.rotationZ ? Number(raw.rotationZ) : rotationZ;

			focus = raw.focus ? Number(raw.focus) : focus;
			zoom = raw.zoom ? Number(raw.zoom) : zoom;
			
			ObjectUtil.print(raw);

			return this;
		}

		// _______________________________________________________ external

		public function writeExternal(output:IDataOutput):void
		{
			output.writeObject({x: x.toFixed(2), y: y.toFixed(2), z: z.toFixed(2),
					rotationX: rotationX.toFixed(2), rotationY: rotationY.toFixed(2), rotationZ: rotationZ.toFixed(2),
					focus: focus.toFixed(2), zoom: zoom.toFixed(2)});
		}

		public function readExternal(input:IDataInput):void
		{
			parse(input.readObject());
		}
	}
}