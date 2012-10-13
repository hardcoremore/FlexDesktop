package com.desktop.ui.Components.Button
{
	import com.desktop.ui.Components.Window.DesktopWindow;
	
	import flash.display.DisplayObject;
	
	import mx.core.IVisualElement;
	
	import spark.components.Group;
	import spark.components.Label;
	import spark.components.ToggleButton;
	
	/**
	 *  If label is visible on task bar buttons.
	 */
	[Style(name="labelVisible", inherit="yes", type="Boolean")]
	
	[Style(name="thickness", inherit="yes", type="Number")]
	
	public class TaskBarButton extends ToggleButton
	{
		
		private var __window:DesktopWindow;
		
		public function TaskBarButton()
		{
			super();
		}
		
		public function set window( w:DesktopWindow ):void
		{
			if( __window != w )
			{
				__window = w;
			}
		}
		
		public function get window():DesktopWindow
		{
			return __window;
		}
		
		public function unload():void
		{
			__window  = null;
		}
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded( partName, instance );
			
			if( instance == iconDisplay )
			{
				iconDisplay.smooth = true;
				iconDisplay.smoothingQuality="high";
			}
			
		}
	}
}