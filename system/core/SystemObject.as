package com.desktop.system.core
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;
	
	public class SystemObject extends EventDispatcher
	{
		public function SystemObject(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		private var __resourceMenager:IResourceManager = ResourceManager.getInstance();
		
		public function get resourceManager():IResourceManager
		{
			return __resourceMenager;
		}
	}
}