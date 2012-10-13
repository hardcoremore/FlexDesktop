package com.desktop.ui.Controls.Events
{
	import flash.events.Event;
	
	import spark.components.supportClasses.SliderBase;
	
	public class SliderValueChangeEvent extends Event
	{
		
		public static const SLIDER_VALUE_CHANGE:String = "sliderValueChange";
		
		private var __value:Number;
		
		private var __slider:SliderBase;
		
		public function get slider():SliderBase
		{
			return __slider;
		}
		
		public function get value():Number
		{
			return this.__value;
		}
		
		public function SliderValueChangeEvent(type:String, value:Number, slider:SliderBase, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			
			this.__value = value;
			this.__slider = slider;
			
		}
	}
}