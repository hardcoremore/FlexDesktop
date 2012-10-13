package com.desktop.system.vos
{
	import flash.events.IEventDispatcher;

	public class ResourceModuleVo
	{
		public var type:String;
		public var url:String;
		public var status:ResourceLoadStatusVo;
		public var resourceEventDispatcher:IEventDispatcher;
		public var locale:String;
		
		public function ResourceModuleVo()
		{
		}
	}
}