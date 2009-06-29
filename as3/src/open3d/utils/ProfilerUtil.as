package open3d.utils
{
	import flash.display.DisplayObjectContainer;
	import flash.events.ContextMenuEvent;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	import open3d.debug.Stats;	
	
	public class ProfilerUtil
	{
		public static function addStat(container:DisplayObjectContainer):Stats
		{
			return container.addChild(new Stats()) as Stats;
		}
		
		public static function addContext(container:DisplayObjectContainer, label:String, eventHandler:Function):void
		{
			var _contextMenu:ContextMenu = container.contextMenu = new ContextMenu();
			//_contextMenu.hideBuiltInItems();
			
			var item:ContextMenuItem = new ContextMenuItem(label);
            _contextMenu.customItems.push(item);
            item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, eventHandler);
		}
	}
}