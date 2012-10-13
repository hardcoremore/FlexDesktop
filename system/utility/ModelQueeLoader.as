package com.desktop.system.utility
{
	import avmplus.getQualifiedClassName;
	
	import com.desktop.system.core.BaseModel;
	import com.desktop.system.vos.ModelLoaderQueeRequestVo;
	import com.desktop.system.events.ModelDataChangeEvent;
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	
	public class ModelQueeLoader extends EventDispatcher 
	{
		private var __requestDict:Dictionary;
		
		public function ModelQueeLoader(target:IEventDispatcher=null)
		{
			super(target);
			__requestDict = new Dictionary( true );
		}
		
		public function addToQuee( request:ModelLoaderQueeRequestVo ):void
		{
			__requestDict[ getRequestKeyName( request ) ] = request;
		}
		
		public function removeFromQuee( request:ModelLoaderQueeRequestVo ):void
		{
			__requestDict[ getRequestKeyName( request ) ] = null;
		}
		
		public function loadQuee():void
		{
			var r:ModelLoaderQueeRequestVo;
			for( var i:String in __requestDict )
			{
				r = __requestDict[ i ] as ModelLoaderQueeRequestVo;
				trace( "KEY: " + i );
			}
		}
		
		public function length():uint
		{
			
			return 0;
		}
		
		public function getRequestKeyName( request:ModelLoaderQueeRequestVo ):String
		{
			return  getQualifiedClassName( request.model ) + "_" + request.model.queeLoaderId;
		}
		
		protected function _modelLoadingDataComplete( event:ModelDataChangeEvent ):void
		{
			
		}
		
		protected function _modelLoadingData( event:ModelDataChangeEvent ):void
		{
			
		}
		
		protected function _modelLoadingDataError( event:ModelDataChangeEvent ):void
		{
			
		}
	}
}