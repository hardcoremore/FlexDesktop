package com.desktop.system.events
{
	import flash.events.Event;
	
	public class SystemEvent extends Event
	{
		
		public static const SHOW_CONFIG:String = "showSystemConfig";
		public static const LOCK_PROGRAM:String = "lockProgram";
		public static const LOG_OFF:String = "logOff";
		
		public function SystemEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}