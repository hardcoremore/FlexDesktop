package com.desktop.system.vos
{
	import flash.events.EventDispatcher;

	public class ApplicationConfigVo extends EventDispatcher
	{
		
		public var loginRequired:Boolean;
		
		public var autoLock:Boolean;
	
		
		public function ApplicationConfigVo()
		{
		}
	}
}