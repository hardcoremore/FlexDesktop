package com.desktop.system.vos
{
	import com.desktop.system.utility.ModelReadParameters;
	
	import flashx.textLayout.tlf_internal;

	public class SearchParameterVo
	{
		public var name:String;
		public var value:String;
		public var operand:String;
		
		public function SearchParameterVo( name:String, value:String, operand:String = ModelReadParameters.SEARCH_OPERAND_EQUAL )
		{
			this.name = name;
			this.value = value;
			this.operand = operand;
		}
	}
}