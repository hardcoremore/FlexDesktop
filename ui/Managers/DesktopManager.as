package com.desktop.ui.Managers
{
	import com.desktop.system.interfaces.IDesktopManager;
	import com.desktop.ui.Components.DesktopComponent;
	
	import flash.display.Sprite;
	
	public class DesktopManager extends Sprite implements IDesktopManager
	{
		private var __desktops:Array;
		private var __activeDesktop:DesktopComponent;
		
		public function DesktopManager()
		{
			super();
		}
		
		public function registerDesktop( desktop:DesktopComponent ):void
		{
			
			var ar:Boolean = false; // if desktop is already registered
			for( var i:uint = 0; i < __desktops.length; i++ )
			{
				if( __desktops[i] == desktop )
				{
					ar = true;
					break;
				}
			}
			
			if( !ar ) __desktops.push( desktop );
			
		}
		
		public function set activeDesktop( desktop:DesktopComponent ):void
		{
			if( desktop != __activeDesktop ) 
				__activeDesktop = desktop;
		}
		
		public function get activeDesktop():DesktopComponent
		{
			return __activeDesktop;
		}
		
		public function unloadDesktop( desktop:DesktopComponent ):void
		{
			for( var i:int = 0; i < __desktops.length; i ++ )
			{
				if( desktop == __desktops[i] )
				{
					__desktops.splice( i, 1 );
				}
			}
		}
	}
}