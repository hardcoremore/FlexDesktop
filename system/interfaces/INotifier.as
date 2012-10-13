package com.desktop.system.interfaces
{
	import com.desktop.system.vos.NotificationVo;

	public interface INotifier
	{
		function notify( nvo:NotificationVo ):INotification
	}
}