package com.desktop.system.interfaces
{
	import flash.events.IEventDispatcher;

	public interface IServiceReturnData extends IEventDispatcher
	{
		function parseData( serviceData:Object, voClasses:Object = null ):Boolean;
		function createObjectVo( data:Object, classVo:String ):Object;
		function get metadata():Object;
		function get data():Object;
	}
}