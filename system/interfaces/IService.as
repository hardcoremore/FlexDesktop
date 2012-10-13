package com.desktop.system.interfaces
{
	import com.desktop.system.vos.ResourceConfigVo;
	import com.desktop.system.vos.WebServiceRequestVo;
	
	import flash.events.IEventDispatcher;

	public interface IService extends IEventDispatcher
	{
		function loadService( webService:WebServiceRequestVo, config:ResourceConfigVo ):void;
		function abort():void;
		
		function set index( i:uint ):void
		function get index():uint;
			
		function get response():IServiceReturnData;
		function get status():int;
	}
}