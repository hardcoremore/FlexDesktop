package com.desktop.system.interfaces
{
	import com.desktop.system.vos.NotificationVo;

	public interface INotification
	{
		function set data( d:NotificationVo ):void;
		function get data():NotificationVo;
		
		function show():Boolean;
		function close():Boolean;
			
	}
}