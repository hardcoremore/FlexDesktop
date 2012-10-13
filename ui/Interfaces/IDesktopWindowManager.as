package com.desktop.ui.Interfaces
{
	import com.desktop.ui.Components.Window.DesktopWindow;

	public interface IDesktopWindowManager
	{
		function register(window:DesktopWindow):void;
		function unregister(window:DesktopWindow):void;
		function unregisterAll():void;
		function isRegistered(window:DesktopWindow):Boolean;
		function bringToFront(window:DesktopWindow):void;
		function sendToBack(window:DesktopWindow):void;
		function getActive():DesktopWindow;
		function getWindows():Vector.<DesktopWindow>;
		function minimizeAll():void;
		
	}
}