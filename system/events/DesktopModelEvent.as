package com.desktop.system.events
{
	import flash.events.Event;
	
	public class DesktopModelEvent extends Event
	{
		
		public static const LOADING:String = "loading";
		public static const LOADING_COMPLETE:String = "loadingComplete";
		
		private var __state:uint;
		
		public function get state():uint
		{
			return __state;
		}
		
		public function DesktopModelEvent(type:String, state:uint,  bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			
			__state = state;
		}
	}
}