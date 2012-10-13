package com.desktop.system.events
{
	import flash.events.Event;
	
	public class ServiceStatusChangedEvent extends Event
	{
		public function ServiceStatusChangedEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}