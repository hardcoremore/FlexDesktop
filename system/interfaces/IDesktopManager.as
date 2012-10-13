package com.desktop.system.interfaces
{
	import com.desktop.ui.Components.DesktopComponent;

	public interface IDesktopManager
	{
		function registerDesktop( desktop:DesktopComponent ):void;
		function set activeDesktop( desktop:DesktopComponent ):void;
		function get activeDesktop():DesktopComponent;
		function unloadDesktop( desktop:DesktopComponent ):void;
	}
}