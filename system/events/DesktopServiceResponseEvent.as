package com.desktop.system.events
{
	import flash.events.Event;
	
	public class DesktopServiceResponseEvent extends Event
	{
		
		public static const RESULT:String = 'result';
		public static const FAULT:String = 'fault';
		
		private var _result:Object;
		
		private var _detail:String;
		
		private var _messageKeyString:String;
		
		public function get result():Object
		{
			return _result;
		}
		
		public function set result(result:Object):void
		{
			this._result = result;
		}
		
		public function set detail(detail:String):void
		{
			_detail = detail;
		}
		
		public function get detail():String
		{
			return _detail;
		}
		
		public function set messageKeyString(msg:String):void
		{
			_messageKeyString = msg;
		}
		
		public function get messageKeyString():String
		{
			return _messageKeyString;
		}
		
		public function DesktopServiceResponseEvent(type:String, result:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			
			_result = result;
		}
		
		override public function clone():Event
		{
			return new DesktopServiceResponseEvent(type, result, bubbles, cancelable);
				
		}
	}
}