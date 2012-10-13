package com.desktop.system.vos
{
	import flash.events.EventDispatcher;

	[Bindable("__NoChangeEvent__")]
	public class LocaleConfigVo extends EventDispatcher
	{
		
		private var __dictonaryResourceName:String;
		private var __messagesResourceName:String;
		
		private var __resourceModulePath:String;
		
		private var __skinsResourceName:String;
		private var __systemIconsResourceName:String;
		
		
		
		public function get dictonaryResourceName():String
		{
			return __dictonaryResourceName;
		}
		
		public function get messagesResourceName():String
		{
			return __messagesResourceName;
		}
	
		
		
		public function get resourceModulePath():String
		{
			return __resourceModulePath;
		}
		
		public function get skinsResourceName():String
		{
			return __skinsResourceName;
		}
		
		public function get systemIconsResourceName():String
		{
			return __systemIconsResourceName;
		}
		
		
		public function set dictonaryResourceName( srn:String ):void
		{
			if( ! __dictonaryResourceName )
			 __dictonaryResourceName = srn;
		}
		
		public function set messagesResourceName( mrn:String ):void
		{
			if( ! __messagesResourceName )
			 __messagesResourceName = mrn;
		}
		
		public function set resourceModulePath( rmp:String ):void
		{
			if( ! __resourceModulePath )
			 __resourceModulePath = rmp;
		}
		
		public function set skinsResourceName( srn:String ):void
		{
			if( ! __skinsResourceName )
			 __skinsResourceName = srn;
		}
		
		public function set systemIconsResourceName( sirn:String ):void
		{
			if( ! __systemIconsResourceName )
			 __systemIconsResourceName = sirn;
		}
		
		public function LocaleConfigVo()
		{
		}
	}
}