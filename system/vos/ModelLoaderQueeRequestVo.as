package com.desktop.system.vos
{
	import com.desktop.system.core.BaseModel;

	public class ModelLoaderQueeRequestVo
	{
		public var model:BaseModel;
		public var method:Function;
		public var functionParams:Array;
		public var response:ModelOperationResponseVo;
		public var monitorOnly:Boolean;
		
		public function ModelLoaderQueeRequestVo()
		{
		}
	}
}