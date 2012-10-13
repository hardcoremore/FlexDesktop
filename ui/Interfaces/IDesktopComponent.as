package com.desktop.ui.Interfaces
{
	import com.desktop.system.interfaces.INotification;
	import com.desktop.system.interfaces.IResourceHolder;
	import com.desktop.system.vos.NotificationVo;
	import com.desktop.ui.Components.Button.Icon;
	import com.desktop.ui.vos.ButtonVo;
	import com.desktop.ui.vos.ResourceHolderVo;

	public interface IDesktopComponent
	{
		function addResourceHolder( wvo:ResourceHolderVo = null ):IResourceHolder;
		
		function addIcon( ivo:ButtonVo ):Icon;
		function notify( nvo:NotificationVo ):INotification;
		
		function constrainResourceHolder( w:IResourceHolder ):void;
		function centerResourceHolder( w:IResourceHolder ):void;
	}
}