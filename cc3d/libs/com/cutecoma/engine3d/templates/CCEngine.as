package com.cutecoma.engine3d.templates
{
	import com.cutecoma.engine3d.api.*;
	import com.cutecoma.engine3d.engine.*;
	import com.cutecoma.engine3d.engine.camera.*;

	public class CCEngine extends GraphicsEngine
	{

		public function CCEngine(param1:Viewport)
		{
			super(param1);
			camera = new FreeChaseCamera();
			camera.yaw = Math.PI / 2;
			device.renderStates.textureSmoothing = true;
		}

		override protected function updateCamera():void
		{
			super.updateCamera();
			camera.yaw = camera.yaw + cameraSpeed.y * elapsedTime;
			camera.pitch = camera.pitch + cameraSpeed.x * elapsedTime;
			cameraSpeed.scaleBy(0.5);
		}
	}
}