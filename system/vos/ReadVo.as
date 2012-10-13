package com.desktop.system.vos
{
	public class ReadVo
	{
		public function ReadVo()
		{
		}
		
		public var pageNum:uint;
		public var numRows:uint;
		public var sortColumnName:String;
		public var sortColumnDirection:String;
		
		public var data_type:int;
		public var is_search:Boolean;
		public var search_paramters:Array;
		
	}
}