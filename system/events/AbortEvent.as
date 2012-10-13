package com.desktop.system.events
{
	import flash.events.Event;
	
	public class AbortEvent extends Event
	{
		
		public static const ABORT:String = "abort";
		
		private var __message:String;
		
		public function get message():String
		{
			return __message;
		}
		
		public function set message(message:String):void
		{
			__message = message;
		}
		
		public function AbortEvent(type:String, message:String = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			
			__message = message;
		}
		
		override public function clone():Event
		{
			return new AbortEvent(type, message, bubbles, cancelable);
				
		}
	}
}