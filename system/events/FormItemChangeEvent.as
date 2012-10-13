package com.desktop.system.events
{
	import flash.events.Event;
	
	public class FormItemChangeEvent extends Event
	{
		public static const FORM_ITEM_CHANGE:String = "formItemChange"; 
			
		public function FormItemChangeEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		protected var _vo:*;
		
		public function set vo( v:* ):void
		{
			_vo = v;
		}
		
		public function get vo():*
		{
			return _vo;
		}
	}
}