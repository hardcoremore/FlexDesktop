package com.desktop.system.vos
{
	import flash.events.EventDispatcher;
	
	public class ResourceConfigVo
	{
		private var __serviceBasePath:String;
		private var __moduleBasePath:String;
		private var __serviceReturnType:int;
		private var __postArrayDelimiter:String;
		
		public function get serviceBasePath():String
		{
			return __serviceBasePath;
		}
		
		public function set serviceBasePath( sbp:String ):void
		{
			if( ! __serviceBasePath )
				__serviceBasePath = sbp;
		}
		
		
		
		public function get moduleBasePath():String
		{
			return __moduleBasePath;
		}
		
		public function set moduleBasePath( mbp:String ):void
		{
			if( ! __moduleBasePath )
				__moduleBasePath = mbp;
		}
		
		
		public function get serviceReturnType():int
		{
			return __serviceReturnType;
		}
		
		public function set serviceReturnType( srt:int ):void
		{
			if( ! __serviceReturnType )
				__serviceReturnType = srt;
		}
		
		public function get postArrayDelimiter():String
		{
			return __postArrayDelimiter;
		}
		
		public function set postArrayDelimiter( del:String ):void
		{
			if( ! __postArrayDelimiter )
				__postArrayDelimiter = del;
		}
		
		
		public function ResourceConfigVo()
		{
		}
	}
}