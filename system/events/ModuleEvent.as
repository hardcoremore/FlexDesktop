package com.desktop.system.events
{
	import com.desktop.system.vos.NotificationVo;
	
	import flash.events.Event;
	
	public class ModuleEvent extends Event
	{
		
		public static const RESOURCE_HOLDER_CHANGE:String = "ModuleEvent.ResourceHolderChange";
		public static const MODULE_NOTIFIES:String = "ModuleEvent.ModuleNotifies";
		public static const MODULE_UNLOAD:String = "ModuleEvent.ModuleUnload";
		
		private var __nvo:NotificationVo;
		public function set notificationVo( nvo:NotificationVo ):void
		{
			__nvo = nvo;
		}
		
		public function get notificationVo():NotificationVo
		{
			return __nvo;
		}
		
		
		public function ModuleEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}