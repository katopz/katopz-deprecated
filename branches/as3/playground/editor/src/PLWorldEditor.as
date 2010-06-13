package
{
	import com.cutecoma.playground.data.AreaData;
	import com.cutecoma.playground.data.CameraData;
	import com.cutecoma.playground.data.MapData;
	import com.cutecoma.playground.data.SceneData;
	import com.cutecoma.playground.editors.WorldEditor;
	
	import flash.net.registerClassAlias;
	
	[SWF(backgroundColor="#000000", frameRate="30", width="800", height="480")]
	/**
	 *  
	 * @author katopz
	 * 
	 */	
	public class PLWorldEditor extends WorldEditor
	{
		/* 
		TODO : 
			- test w from lite
			- 
		*/
		public function PLWorldEditor()
		{
			registerClassAlias("com.cutecoma.playground.data.AreaData", AreaData);
			registerClassAlias("com.cutecoma.playground.data.MapData", MapData);
			registerClassAlias("com.cutecoma.playground.data.SceneData", SceneData);
			registerClassAlias("com.cutecoma.playground.data.CameraData", CameraData);
		}
	}
}