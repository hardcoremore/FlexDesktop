package com.desktop.system.events
{
	import flash.events.Event;
	
	public class ConfigChangeEvent extends Event
	{
		public static const CONFIG_CHANGE:String = 'configChange';
		
		private var __property:String;
		
		private var __value:Object;
		
		public function get property():String
		{
			return this.__property;
		}
		
		public function get value():Object
		{
			return this.__value;
		}
		
		public function ConfigChangeEvent(type:String, property:String, value:Object, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			
			this.__property = property;
			this.__value = value;
		}
	}
}