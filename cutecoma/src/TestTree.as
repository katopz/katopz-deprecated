package 
{
	 import com.sleepydesign.components.SDTree;
	 import com.sleepydesign.core.SDSprite;
	 import com.sleepydesign.site.view.components.SiteMap;
	 
	[SWF(backgroundColor="0xFFFFFF", frameRate="30", width="400", height="300")]
	public class TestTree extends SDSprite
	{
		public function TestTree()
		{
			var xml1:XML = 
<site id="site" focus="page_3" style="style.css">
	<content id="page_1" label="page 1"/>
</site>
var xml:XML = 
<site id="site" focus="page_3" style="style.css">
	<!-- single jpg asset -->
	<content id="page_1" label="page 1">
		<asset src="705231219605502.jpg"></asset>
	</content>
	
	<!-- single swf asset -->
	<content id="page_2" label="page 2">
		<asset src="SimpleCube.swf"/>
	</content>
	
	<!-- multi jpg, swf asset -->
	<content id="page_3" label="page 3">
		<asset src="705231219605518.jpg"/>
		<asset src="TestTree.swf"/>
	</content>
	
	<!-- deeplink, TODO : focus -->
	<content id="page_4" label="page 4" focus="page_4_2">
		<asset src="705231219605518.jpg"/>
		<content id="page_4_1" label="page 4 1">
			<asset src="SimpleCube.swf"/>
		</content>
		<content id="page_4_2" label="page 4 2">
			<asset src="Tree.swf"/>
		</content>
	</content>
</site>
			var tree:SDTree = new SDTree(xml1);
			addChild(tree);
			//var site:SiteMap = new SiteMap(this,100,100,xml);
		}
	 }
}