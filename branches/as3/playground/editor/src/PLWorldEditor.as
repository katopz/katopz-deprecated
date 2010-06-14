package
{
	import com.cutecoma.playground.data.AreaData;
	import com.cutecoma.playground.data.CameraData;
	import com.cutecoma.playground.data.MapData;
	import com.cutecoma.playground.data.SceneData;
	import com.cutecoma.playground.data.ViewData;
	import com.cutecoma.playground.editors.WorldEditor;
	
	import flash.net.registerClassAlias;
	
	[SWF(backgroundColor="#FFFFFF", frameRate="30", width="800", height="480")]
	/**
	 *  
	 * @author katopz
	 * 
	 */	
	public class PLWorldEditor extends WorldEditor
	{
		/* 
		TODO : 
		
		+ editor
			- switch between area //reload other area -> destroy -> create
			- view FPS controller
			- flood fill
			- import/export external bitmap as map
			- load and save as other id 
			- clean up
			- MVC
		
		+ chat
			- load MDJ and test path finder, speed
			- test switch between area
			- login via opensocial
			- clean up
			- MVC
		
		+ lite
			- heightmap support, test with jiglib
			- 2.5D Clip, animation controller
			- infinite loop perlin noise fog, fire
			- lenflare
			- explode effect
		*/
		public function PLWorldEditor()
		{
			registerClassAlias("com.cutecoma.playground.data.AreaData", AreaData);
			registerClassAlias("com.cutecoma.playground.data.MapData", MapData);
			registerClassAlias("com.cutecoma.playground.data.SceneData", SceneData);
			registerClassAlias("com.cutecoma.playground.data.ViewData", ViewData);
			registerClassAlias("com.cutecoma.playground.data.CameraData", CameraData);
			
			alpha = .1;
		}
	}
}