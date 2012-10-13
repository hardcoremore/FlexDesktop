package com.desktop.ui.Controls.Events
{
	import com.desktop.ui.Components.Window.DesktopWindow;
	
	import flash.events.Event;
	
	public class DesktopWindowEvent extends Event
	{
		public static const HIDE:String 						= 'DesktopWindowEvent.hide';
		public static const SHOW:String 						= 'DesktopWindowEvent.show';
		public static const TO_FRONT:String 					= 'DesktopWindowEvent.toFront';
		public static const RESTORE:String 						= 'DesktopWindowEvent.restore';
		public static const MAXIMIZE:String 					= 'DesktopWindowEvent.maximize';
		public static const MINIMIZE:String 					= 'DesktopWindowEvent.minimize';
		public static const CLOSE:String 						= 'DesktopWindowEvent.close';
		public static const UNLOAD:String 						= 'DesktopWindowEvent.unload';
		public static const CONTROLL_COMPONENT_CHANGED:String	= 'DesktopWindowEvent.controllComponentChanged';
		
		private var _desktop_window:DesktopWindow;
		
		public function get desktopWindow():DesktopWindow
		{
			return _desktop_window;
		}
		
		public function DesktopWindowEvent(type:String, window:DesktopWindow, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			
			_desktop_window = window;
		}
	}
}