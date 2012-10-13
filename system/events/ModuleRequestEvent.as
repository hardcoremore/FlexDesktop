package com.desktop.system.events
{	
	import com.desktop.system.interfaces.IModuleBase;
	
	import flash.events.Event;

	public class ModuleRequestEvent extends Event
	{
		public static const MODULE_REQUEST:String  = "moduleRequest";
		public static const MODULE_REQUEST_DENIED:String = "requestedModuleDenied";
		public static const MODULE_REQUEST_RESPONSE:String = "requestedModuleResponse";
		public static const MODULE_UNLOAD_REQUEST:String = "moduleUnloadRequest";
				
		private var _moduleId:String;
		
		private var _module:IModuleBase;
		
		private var _errorMessage:String;
		
		
		public function get moduleId():String
		{
			return this._moduleId;
		}
		
		public function get module():IModuleBase
		{
			return this._module;
		}
		
		public function get errorMessage():String
		{
			return this._errorMessage;
		}
		
		public function ModuleRequestEvent(type:String, modululeId:String, module:IModuleBase = null, errorMessage:String = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			
			this._moduleId = modululeId;
			this._module = module;
			this._errorMessage = errorMessage;
		}
		
	}
}