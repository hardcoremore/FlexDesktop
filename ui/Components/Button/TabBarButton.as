package com.desktop.ui.Components.Button
{
	import spark.components.ButtonBarButton;
	
	/**
	 *  If label is visible on task bar buttons.
	 */
	[Style(name="labelVisible", inherit="yes", type="Boolean")]
	
	[Style(name="thickness", inherit="yes", type="Number")]
	
	public class TabBarButton extends ButtonBarButton 
	{
		public function TabBarButton()
		{
			super();
		}
	}
}