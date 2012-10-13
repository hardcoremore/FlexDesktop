package com.desktop.system.vos
{
	public class ModelOperationResponseVo
	{
		public function ModelOperationResponseVo()
		{
		}
		
		public var status:String;
		public var errorCode:uint;
		public var message:String;
		
		/***
		* Data result from operation if operation went successfuly
		* 
		*/
		public var result:Object;
		
		/***
		 * metadata from operation if operation went successfuly
		 * 
		 */
		public var metadata:Object;
		
		/****
		 * int num rows if operation was of read type
		 * 
		 ****/
		public var numRows:uint;
		
		/****
		 * int total num rows if operation was of read type
		 * 
		 ****/
		public var totalRows:uint;
		
		
		/***
		 * int affected rows if operation was of create type
		 * 
		 ***/
		public var affectedRows:uint;
		
		public var alreadyExistsFields:Object;
		
		public var dataUpdated:Boolean;
		
	}
}