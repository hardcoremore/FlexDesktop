package com.desktop.ui.Controls.Events
{
	import flash.events.Event;
	
	public class TaskBarEvent extends Event
	{
		
		public static const TASK_BAR_POSITION_CHANGED:String = "taskBarPositionChanged";
		public static const TASK_BAR_LABEL_VISIBLE_CHANGED:String = "taskBarLabelVisibleChanged";
		
		private var __position:String;
		
		private var __labelVisible:Boolean;
		
		public function get position():String
		{
			return __position;
		}
		
		public function get labelVisible():Boolean
		{
			return __labelVisible;
		}
		
		public function TaskBarEvent( type:String, position:String, labelVisible:Boolean, bubbles:Boolean=false, cancelable:Boolean=false )
		{
			super(type, bubbles, cancelable);
			
			__position  = position;
			__labelVisible = labelVisible;
			
		}
	}
}