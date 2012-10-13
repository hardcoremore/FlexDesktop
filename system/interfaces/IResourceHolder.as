package com.desktop.system.interfaces
{
	import com.desktop.system.vos.LoadResourceRequestVo;
	import com.desktop.system.vos.NotificationVo;
	import com.desktop.ui.Interfaces.IDesktopComponent;
	
	import mx.core.IUIComponent;
	import mx.core.IVisualElement;
	import mx.core.IVisualElementContainer;

	public interface IResourceHolder extends IVisualElement, IVisualElementContainer
	{
		function set id( value:String ):void;
		function get id():String;
		
		function set resourceInfo( resourceRequest:LoadResourceRequestVo ):void;
		function get resourceInfo():LoadResourceRequestVo;
		
		function set beforeCloseFunction( fn:Function ):void;
			
		function set controllComponent( comp:IVisualElement ):void;
		function get controllComponent():IVisualElement;
		
		function set desktop( desktop:IDesktopComponent ):void;
		function get desktop():IDesktopComponent;
							  
		function show():Boolean;
		function hide():void;
		function close():Boolean;
		function restore():void;
		function toFront():void;
		function unload():void;
		
	}
}