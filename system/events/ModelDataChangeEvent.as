package com.desktop.system.events
{
	import com.desktop.system.interfaces.IServiceReqester;
	import com.desktop.system.vos.ModelOperationResponseVo;
	
	import flash.events.Event;
	
	import com.desktop.system.core.BaseModel;
	
	public class ModelDataChangeEvent extends Event
	{
		public static const MODEL_LOADING_DATA:String = "ModelDataChangeEvent.model_loading_data";
		public static const MODEL_LOADING_DATA_COMPLETE:String = "ModelDataChangeEvent.model_loading_data_complete";
		public static const MODEL_LOADING_DATA_ERROR:String = "ModelDataChangeEvent.model_loading_data_error";
		
		public function ModelDataChangeEvent( type:String, bubbles:Boolean=false, cancelable:Boolean=false )
		{
			super(type, bubbles, cancelable);
		}
		
		protected var _operation:ModelOperationResponseVo;
		public function set response( op:ModelOperationResponseVo ):void
		{
			_operation = op;
		}
		
		public function get response():ModelOperationResponseVo
		{
			return _operation;
		}
		
		protected var _crud:int;
		public function set crud( c:int ):void
		{
			_crud = c;
		}
		
		public function get crud():int
		{
			return _crud;
		}
		
		protected var _operationName:String;
		public function set operationName( name:String ):void
		{
			_operationName = name;
		}
		
		public function get operationName():String
		{
			return _operationName;
		}
		
		protected var _requester:IServiceReqester;
		public function set requester( value:IServiceReqester ):void
		{
			_requester = value;
		}
		
		public function get requester():IServiceReqester
		{
			return _requester;
		}
		
		protected var _model:BaseModel;
		public function set model( m:BaseModel ):void
		{
			_model = m;
		}
		
		public function get model():BaseModel
		{
			return _model;
		}
	}
}
