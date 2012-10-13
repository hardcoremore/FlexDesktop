package com.desktop.ui.Components
{
	import com.desktop.system.core.SystemSession;
	import com.desktop.system.interfaces.IConfig;
	
	import spark.components.supportClasses.SkinnableComponent;
	
	[Style(name="fontSize", inherit="yes", type="String")]
	
	public class ComponentBase extends SkinnableComponent
	{		
		public function ComponentBase()
		{
			super();
		}
		
		public function unload():void
		{
			
		}
		
		public function get session():SystemSession
		{
			return SystemSession.instance;
		}
	}
}