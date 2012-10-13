package com.desktop.system.core.service.events
{
	import com.desktop.system.interfaces.IServiceReturnData;
	
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	public class ServiceEvent extends Event
	{
		public static const COMPLETE:String = "ServiceEvent.complete";
		public static const ERROR:String = "ServiceEvent.error";
		public static const ABORTED:String = "ServiceEvent.error";
		
		public function ServiceEvent( type:String, bubbles:Boolean = false, cancelable:Boolean = false  )
		{
			super( type, bubbles, cancelable );
		}
		
		protected var _response:IServiceReturnData;
		public function set response( r:IServiceReturnData ):void
		{
			_response = r;
		}
		
		public function get response():IServiceReturnData
		{
			return _response;
		}
		
		protected var _errorMessage:String;
		public function set errorMessage( msg:String ):void
		{
			_errorMessage = msg;
		}
		
		public function get errorMessage():String
		{
			return _errorMessage;	
		}
	}
}