package com.desktop.ui.Events
{
	import flash.events.Event;
	
	public class DesktopEvent extends Event
	{
		public static const DESKTOP_INITIALISED:String = "desktopInitialised";
		public static const DESKTOP_ICON_ADDED:String = "desktopIconAdded";
		public static const DESKTOP_ICON_REMOVED:String = "desktopIconRemoved";
		
		public static const DESKTOP_WINDOW_ADDED:String = "desktopWindowAdded";
		
		public function DesktopEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}