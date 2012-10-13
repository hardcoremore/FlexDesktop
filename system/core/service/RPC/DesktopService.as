package com.desktop.system.core.service.RPC
{
	import com.desktop.system.core.service.ServiceReturnType;
	import com.desktop.system.events.AbortEvent;
	import com.desktop.system.events.DesktopServiceResponseEvent;
	import com.desktop.system.interfaces.IService;
	import com.desktop.system.interfaces.IServiceReturnData;
	import com.desktop.system.managers.ConfigManager;
	import com.desktop.system.vos.ResourceConfigVo;
	import com.desktop.system.vos.WebServiceRequestVo;
	
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.ByteArray;
	
	import mx.collections.ArrayCollection;
	import mx.collections.ArrayList;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.InvokeEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	import mx.utils.ObjectProxy;
	
	/***********************
	 * 
	 * 		Events
	 * 
	 * ********************/
	
	[Event(name="result", type="mx.rpc.events.ResultEvent")]
	
	[Event(name="fault", type="mx.rpc.events.FaultEvent")]
	
	[Event(name="progress", type="flash.events.ProgressEvent")]
	
	[Event(name="statusChanged", type="")]
	
	///////////// End of Events ////////////////
	
	
	/////////////////////////////////////////////////
	//	
	//	
	// @ClassName: DesktopService
	//	
	// @Description: This class is wrapper for URLLoader class;
	// 
	//
	////////////////////////////////////////////////
	
	public class DesktopService extends EventDispatcher implements IService
	{
		
		/*
		* ***************************
		* 
		*  Properties
		* 
		***************************
		*/
		
		/* ----------- Private Properties -----------*/
		
		private var _url:String;
		
		private var _method:String = URLRequestMethod.GET;
		
		private var _urlLoader:URLLoader;
		
		private var _urlRequest:URLRequest;
		
		private var _contentType:String = 'application/x-www-form-urlencoded';
		
		private var _requestHeaders:Array = new Array();
		
		private var _dataFormat:String;
		
		private var _serverReturnDataFormat:String = URLLoaderDataFormat.TEXT;
		
		private var _returnFormat:String;
		
		private var _sendDataFormat:String = URLLoaderDataFormat.VARIABLES;
		
		private var __response:Object;
		
		private var __status:int;
		
		/* ============== End of  Private Properties ===============*/
		
				
		/*
		* ***************************
		* 
		*  CONSTRUCTOR
		* 
		***************************
		*/
		
		public function DesktopService()
		{
			
			_urlRequest = new URLRequest();
			
			_urlLoader = new URLLoader();
			_urlLoader.addEventListener(Event.COMPLETE, onComplete);
			_urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onError);
			_urlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, onHttpStatus);			
			_urlLoader.addEventListener(ProgressEvent.PROGRESS, onProgressEvent);
			_urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
		}
		
		/*
		*------------------------*
		* 						 *
		* END of CONSTRUCTOR     *
		* 						 *
		*------------------------*
		*/
//----------------------------------------------------------------------------		
		/*
		* ***************************
		* 
		*  Getters and Setters
		* 
		***************************
		*/
		
		public function set url(url:String):void
		{
			_url = url; 
		}
		
		public function get url():String
		{
			return _url;
		}
		
//***************************************************
		
		public function set method(method:String):void
		{
			_method = method; 
		}
		
		public function get method():String
		{
			return _method;
		}

//***************************************************
		
		public function set contentType(cType:String):void
		{
			if( cType != _contentType )
			{
				_contentType = cType;
			}
		}
		
		public function get contentType():String
		{
			return this._contentType;
		}
		
//***************************************************
		
		public function set sendDataFormat(value:String):void
		{
			_sendDataFormat = value;
		}
		
		public function get sendDataFormat():String
		{
			return _sendDataFormat;
		}
		

//***************************************************
		
		// THIS IS DOWNLOADED DATA FROM THE SERVER. IT CAN BE VARIABLES, TEXT OR BINARY
		public function set serverReturnDataFormat(value:String):void
		{
			_serverReturnDataFormat = value;
		}
		
		public function get serverReturnDataFormat():String
		{
			return _serverReturnDataFormat;
		}
		
//***************************************************
		
		public function set returnFormat(format:String):void
		{
			this._returnFormat = format;
		}
		
		public function get returnFormat():String
		{
			return this._returnFormat;
		}
		
//***************************************************
		
		public function set requestHeaders(headers:Array):void
		{
			this._requestHeaders = headers;
		}
		
		public function get requestHeaders():Array
		{
			return this._requestHeaders;
		}
		
		/*
		*-------------------------------*
		* 						 		*
		* END of Getters and Setters    *
		* 						        *
		*-------------------------------*
		*/	

//------------------------------------------------------------------------------------		
		
		/*
		* ***************************
		* 
		*  Public Methods
		* 
		***************************
		*/
		
		public function send(data:Object):void
		{
			if( !_url ) throw new Error("Error: You must provide valid url at DesktopService::send()");
			
			if( _contentType )_urlRequest.contentType = _contentType;
			
			if( _requestHeaders ) _urlRequest.requestHeaders = _requestHeaders;
			
			_urlRequest.method = _method;
			_urlRequest.url = _url;
			_urlLoader.dataFormat = _serverReturnDataFormat;
			
			if( _sendDataFormat == URLLoaderDataFormat.VARIABLES )
			{
				_urlRequest.contentType = "application/x-www-form-urlencoded";// From AS3 Docs: "If the value of the data property is a URLVariables object, the value of contentType must be application/x-www-form-urlencoded." 
				
				var v:URLVariables = new URLVariables();
				
				for( var d:Object in data )
				{
					v[d] = data[d];
				}
				
				_urlRequest.data = v;
				
			}
			else
			{
				_urlRequest.data = data;
			}
			
			
			_urlLoader.load(_urlRequest);
			
		}
			
		public function abort():void
		{
			_urlLoader.close();
			
			var ae:AbortEvent = new AbortEvent(AbortEvent.ABORT);
			
			dispatchEvent( ae );
		}
		
		
		public function get status():int
		{
			return __status;
		}
		
		public function set index( i:uint ):void
		{
			
		}
		
		public function get index():uint
		{
			return 0;
		}
		
		public function get response():IServiceReturnData
		{
			return null;
		}
		
		public function loadService( webService:WebServiceRequestVo, config:ResourceConfigVo ):void
		{
			
		}
		
		/*
		*------------------------------- * 
		* 						 								  *	
		* END of Public Methods    				  *
		* 						        						  *
		*------------------------------- *
		*/	
//-----------------------------------------------------------------------------------------------------------
		/*
		* ***************************
		* 
		*  Private Methods
		* 
		***************************
		*/
		
		private function onComplete(event:Event):void
		{
			if( !this.hasEventListener( DesktopServiceResponseEvent.RESULT ) ) 
				return;
			
			var loader:URLLoader = event.target as URLLoader;
			
			var e:DesktopServiceResponseEvent = new DesktopServiceResponseEvent(DesktopServiceResponseEvent.RESULT);
				
			//Also here you can implement Json return format and others.
			switch( _returnFormat )
			{
				case ServiceReturnType.TEXT:
					
					e.result = loader.data as String;
					
				break;
				
				case ServiceReturnType.XML:
					
					if( loader.data )
					{
						var xml:XML =  new XML(loader.data);
						e.result = xml;
					}
					else
					{
						e.result =  null;
					}
					
				break;
				
				case ServiceReturnType.BINARY:
					
					if( loader.data )
					{
						e.result = loader.data as ByteArray;
					}
					else
					{
						e.result =  null;
					}
					
				break;
			}
			
			dispatchEvent( e );
		}
		
		private function onError(event:Event):void
		{
			if( !this.hasEventListener( DesktopServiceResponseEvent.FAULT ) ) 
				return;
			
			var loader:URLLoader = event.target as URLLoader;
			
			var e:DesktopServiceResponseEvent = new DesktopServiceResponseEvent(DesktopServiceResponseEvent.FAULT);
			
			if( event is IOErrorEvent )
			{
				e.detail = IOErrorEvent.IO_ERROR;
				e.messageKeyString = 'ioErrorOccured';
			}
			else if( event is SecurityErrorEvent )
			{
				e.detail = SecurityErrorEvent.SECURITY_ERROR;
				e.messageKeyString = "securityErrorOccured";
				
			}
			
			dispatchEvent( e );
			
		}
		
		private function onHttpStatus(event:HTTPStatusEvent):void
		{
			if( this.hasEventListener( HTTPStatusEvent.HTTP_STATUS ) )
				dispatchEvent( event.clone() );
		}
		
		private function onProgressEvent(event:ProgressEvent):void
		{
			if( this.hasEventListener( ProgressEvent.PROGRESS ) )
				dispatchEvent( event.clone() );
		}
		
		/*
		*-------------------------------*
		* 						 		*
		* END of Private Methods    	*
		* 						        *
		*-------------------------------*
		*/	
//-----------------------------------------------------------------------------------------------------------	
		
	}
}