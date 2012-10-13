package com.desktop.ui.Components.Group
{
	import com.desktop.system.Application.Library.ui.NotificationBase;
	
	public class ModuleNotification extends NotificationBase
	{
		public function ModuleNotification()
		{
			super();
		}	
		
		override protected function getCurrentSkinState():String
		{
			if( shown )
			{
				return "normal";
			}
			else
			{
				return "hidden";
			}
		}
	}
}