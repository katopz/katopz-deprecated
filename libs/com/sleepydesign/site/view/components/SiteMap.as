package com.sleepydesign.site.view.components
{
	import com.sleepydesign.components.SDTree;
	import com.sleepydesign.components.SDTreeNode;
	
	import flash.display.DisplayObjectContainer;
	
	/**
	 * 
	 * 
___________________________________________________________

[Sample]
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
</site>
var site:SiteMap = new SiteMap(this,100,100,xml);
___________________________________________________________

	 * @author katopz
	 * 
	 */	
	public class SiteMap extends SDTree
	{
		public function SiteMap(xml:XML = null)
		{
			super(xml, true, true, true);
		}
			
		override public function setFocusById(id:String) : SDTreeNode
		{
			return super.setFocusById("$"+id);
		}
		
        override public function getPathById(id:String) : String
        {
        	return super.getPathById("$"+id);
        }
	}
}