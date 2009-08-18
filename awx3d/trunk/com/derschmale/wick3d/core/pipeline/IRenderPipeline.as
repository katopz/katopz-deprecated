package com.derschmale.wick3d.core.pipeline
{
	import com.derschmale.wick3d.cameras.Camera3D;
	import com.derschmale.wick3d.display3D.World3D;
	import com.derschmale.wick3d.view.Viewport;
	
	public interface IRenderPipeline
	{
		function render(world : World3D, camera : Camera3D, target : Viewport) : void;
	}
}