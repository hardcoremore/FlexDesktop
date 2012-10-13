package com.desktop.system.interfaces
{
	import com.desktop.system.vos.LoadResourceRequestVo;
	
	import flash.events.IEventDispatcher;
	
	public interface IResourceLoader extends IEventDispatcher
	{
		function set config( config:IConfig ):void;
		function get numResources():uint;
		
		function loadResource( resource:LoadResourceRequestVo ):void;
		function unloadResource( resource:Object ):void;
	}
}