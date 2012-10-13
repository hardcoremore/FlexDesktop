package com.desktop.system.events
{
	import flash.events.Event;
	
	public class ComponentCRUDEvent extends Event
	{
		public static const SAVE:String = "ComponentCRUDEvent.save";
		public static const DELETE:String = "ComponentCRUDEvent.delete";
		public static const UPDATE:String = "ComponentCRUDEvent.update";
		public static const READ:String = "ComponentCRUDEvent.read";
		public static const RESET:String = "ComponentCRUDEvent.reset";
		
		
		private var __data:*;
		
		public function set data( d:* ):void
		{
			__data = d;
		}
		
		public function get data():*
		{
			return __data;
		}
		
		public function ComponentCRUDEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		
		override public function clone():Event
		{
			var e:ComponentCRUDEvent = new ComponentCRUDEvent( type, bubbles, cancelable );
				e.data = data;
				
			return e;
		}
	}
}