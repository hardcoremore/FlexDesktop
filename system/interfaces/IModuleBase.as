package com.desktop.system.interfaces
{
	import com.desktop.system.core.SystemSession;
	import com.desktop.ui.vos.ResourceHolderVo;
	
	import mx.core.IUIComponent;

	public interface IModuleBase extends IUIComponent
	{
		function init():void;
		
		function get session():SystemSession;
		
		function get allowMultipleInstances():Boolean;
		
		function set acl(value:Array):void;
		function get acl():Array;
		
		function set mode( m:uint ):void;
		
		function get mode():uint;
		
		function get id():String;
		
		function set resourceHolderConfig( rhc:ResourceHolderVo ):void;
		function get resourceHolderConfig():ResourceHolderVo;
		
		function set resourceHolder( rh:IResourceHolder ):void;
		
		function get resourceHolder():IResourceHolder;
								
		function set data( d:Object ):void;
		function get data():Object;
		
		function unload():void;
	}
}