package com.desktop.system.vos
{
	public class WebServiceRequestVo
	{
		public var module:String;
		public var action:String;
		public var segments:Vector.<String>;
		
		public var data:Object;
		public var headers:Array;
		
		public var pageNumber:uint;
		public var rowsPerPage:uint;
		
		public var voClasses:Object;
		
		public function WebServiceRequestVo()
		{
		}
	}
}