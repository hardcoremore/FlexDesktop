package com.desktop.system.interfaces
{
	import flash.events.IEventDispatcher;

	public interface IControllerToServiceManager extends IEventDispatcher
	{
		function send(cName:String, aName:String, postData:Object = null, getData:Object = null):void;
		function abort(message:String = null):void;
		function set returnDataFormat(value:String):void;
		function get returnDataFormat():String;
		function get useDefaultActionOnError():Boolean;
		function set useDefaultActionOnError(value:Boolean):void;
	}
}