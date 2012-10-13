package com.desktop.system.events
{
	import com.desktop.system.vos.NotificationResponseVo;
	import com.desktop.system.vos.NotificationVo;
	
	import flash.events.Event;
	
	public class NotificationResponseEvent extends Event
	{
		private var __response:NotificationResponseVo;
		public function set response( r:NotificationResponseVo ):void
		{
			__response = r;
		}
		
		public function get response():NotificationResponseVo
		{
			return __response;
		}
		
		private var __notificationVo:NotificationVo;
		public function set notificationVo( nvo:NotificationVo ):void
		{
			__notificationVo = nvo;
		}
		
		public function get notificationVo():NotificationVo
		{
			return __notificationVo;
		}
		
		public static const NOTIFICATION_RESPONSE_EVENT:String = "notificationResponseEvent";
		
		public function NotificationResponseEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		
		override public function clone():Event
		{
			var e:NotificationResponseEvent = new NotificationResponseEvent( type, bubbles, cancelable );
				e.response = response;
				e.notificationVo = notificationVo;
				
			return e;	
		}
	}
}