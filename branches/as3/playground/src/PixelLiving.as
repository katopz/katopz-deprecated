package
{
	import com.cutecoma.game.core.*;
	import com.cutecoma.game.data.*;
	import com.cutecoma.playground.core.*;
	import com.cutecoma.playground.data.*;
	import com.greensock.plugins.*;
	import com.sleepydesign.components.*;
	import com.sleepydesign.events.*;
	import com.sleepydesign.utils.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.filters.*;
	import flash.geom.Point;
	import flash.utils.*;
	
	public class PixelLiving
	{
		/*
		public static var config87:AreaData = new AreaData
		(
			"87", "areas/87_bg.swf", 40, 40,
			new SceneData(new CameraData(190.43, 188.76, -1073.33, -0.05, -7.55, -0.55, 43.02, 8.70, 70.00)),
			new MapData(
				[
					0, 0, 86, 86, 86, 0, 0,
					0, 0, 86, 86, 86, 0, 0,
					1, 1, 1, 1, 1, 0, 0,
					1, 1, 1, 1, 1, 0, 0,
					1, 1, 1, 1, 1, 0, 0,
					1, 1, 1, 1, 1, 0, 0,
					0, 1, 1, 1, 1, 0, 0,
					0, 2, 1, 1, 1, 0, 0,
					0, 0, 1, 1, 1, 0, 0,
					0, 0, 88, 88, 88, 0, 0,
					0, 0, 0, 0, 0, 0, 0,
					0, 0, 0, 0, 0, 0, 0,
				],
				7,4,4
			)
		);
		
		public static var config88:AreaData = new AreaData
		(
			"88", "areas/88_bg.swf", 40, 40,
			new SceneData(new CameraData(338.61, 116.50, -801.01, -2.21, -26.09, -0.11, 39.42, 8.70, 77.00)),
			new MapData(
				[
					0, 0, 0, 87, 87, 87, 0,
					0, 0, 0, 87, 87, 87, 0,
					0, 0, 0, 87, 87, 87, 0,
					0, 0, 0, 1, 1, 1, 0,
					0, 0, 0, 1, 1, 1, 0,
					2, 1, 1, 1, 1, 1, 0,
					0, 0, 0, 1, 1, 1, 0,
					0, 0, 0, 1, 1, 1, 0,
					0, 0, 0, 1, 1, 1, 0,
					0, 0, 0, 1, 1, 1, 0,
					0, 0, 0, 1, 1, 1, 0,
					0, 0, 0, 1, 1, 1, 0
				],
				7,3,4
			)
		);
		*/

		public static var DEFAULT_SCENE_DATA:SceneData = new SceneData(new CameraData(500, 100, -500));
		
		public static var DEFAULT_MAP_DATA:MapData = new MapData(new BitmapData(40, 40, true, 0xFF000000), new Point(20,20));
	}
}