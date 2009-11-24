package com.sleepydesign.site.controller
{
	import com.sleepydesign.site.model.PageDataProxy;

	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	public class DataChangeCommand extends SimpleCommand implements ICommand
	{
		override public function execute(notification:INotification):void
		{
			super.execute(notification);
			var pageDataProxy:PageDataProxy = facade.retrieveProxy(PageDataProxy.NAME) as PageDataProxy;
			pageDataProxy.updateData(notification.getBody());

			facade.registerProxy(new PageDataProxy());
		}
	}
}