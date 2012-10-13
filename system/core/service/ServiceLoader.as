package com.desktop.system.core.service
{
	import com.desktop.system.core.SystemSession;
	import com.desktop.system.core.service.events.ServiceEvent;
	import com.desktop.system.core.service.parsers.WebServiceXmlDataParser;
	import com.desktop.system.interfaces.IService;
	import com.desktop.system.interfaces.IServiceReqester;
	import com.desktop.system.interfaces.IServiceReturnData;
	import com.desktop.system.vos.ResourceConfigVo;
	import com.desktop.system.vos.WebServiceRequestVo;
		
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	import mx.events.Request;
	
	public class ServiceLoader extends URLLoader implements IService
	{
		private var __index:uint;
		
		private var __urlLoader:URLLoader;
		private var __request:URLRequest;
		private var __web:WebServiceRequestVo;
		private var __resourceConfig:ResourceConfigVo;
		private var __serviceCompleted:Boolean;
		private var __response:IServiceReturnData;
		private var __session:SystemSession;
		private var __requester:IServiceReqester;
		private var __name:String;
		
		public function ServiceLoader(request:URLRequest=null)
		{
			super(request);
			
			__urlLoader = new URLLoader();
			__urlLoader.addEventListener( Event.COMPLETE, _completeEventHandler );
			__urlLoader.addEventListener( IOErrorEvent.IO_ERROR, _ioErrorEventHandler );
			__request = new URLRequest();
			
			__session = SystemSession.instance;
		}
		
		public function set index( i:uint ):void
		{
			__index = i;
		}
		
		public function get index():uint
		{
			return __index;
		}
		
		public function get response():IServiceReturnData
		{
			return __response;
		}
		
		public function get status():int
		{
			return -1;
		}
		
		public function set requester( value:IServiceReqester ):void
		{
			__requester = value;
		}
		
		public function get requester():IServiceReqester
		{
			return __requester;
		}
		
		public function set name( value:String ):void
		{
			__name = value;
		}
		
		public function get name():String
		{
			return __name;
		}
		
		public function abort():void
		{
			
		}
		
		public function loadService( webService:WebServiceRequestVo, resourceConfig:ResourceConfigVo ):void
		{
			if( ! webService || ! resourceConfig )
			{
				
				dispatchEvent( new ServiceEvent( ServiceEvent.ERROR ) );
			}
			else
			{
				// store current webService and resource config that is being loaded
				__web = webService;
				__resourceConfig = resourceConfig;
			}
			
			__request.url = _builWebServiceUrl( webService, __resourceConfig );
			__request.data = webService.data;
			__request.method = URLRequestMethod.POST;
			
			
			if( ! __request.data )
			{
				__request.data = new URLVariables();
			}
			
			// From AS3 Docs: "If the value of the data property is a URLVariables object, the value of contentType must be application/x-www-form-urlencoded."
			if( webService.data is URLVariables )
			{
				__request.contentType = "application/x-www-form-urlencoded";
			}
			else if( webService.data )
			{
				__request.url += "?";
				for( var o:Object in webService.data )
				{
					__request.url += o + "=" + webService.data[ o ] + "&";
				}
			}
			
			var sess_id:String = String( __session.get( SystemSession.sessionIdName ) ); 
				
			if( sess_id )
			{
				// sending custom header session header
				var ch:URLRequestHeader = new URLRequestHeader(  SystemSession.sessionIdName,  sess_id );
				__request.requestHeaders = [ ch ];				
			}	
				
			//load service
			__serviceCompleted = false;
			__urlLoader.load( __request );
			
		}
		
		protected function _builWebServiceUrl( web:WebServiceRequestVo, sc:ResourceConfigVo ):String
		{
			var s:String = sc.serviceBasePath + web.module + "/" + web.action + "/";
			
			for each( var segment:String in web.segments )
			{
				s += segment + "/";
			}
			
			return s;
		}
		
		protected function _completeEventHandler( event:Event ):void
		{
			__serviceCompleted = true;
			
			switch( __resourceConfig.serviceReturnType )
			{
				case ServiceReturnType.XML:
					__response = new WebServiceXmlDataParser();
				break;
				
				case ServiceReturnType.JSON:
				break;
			}
			
			var parse_result:Boolean = __response.parseData( event.target.data, __web.voClasses );
			
			if( __response.metadata && __response.metadata.hasOwnProperty( SystemSession.sessionIdName ) )
			{
				__session.set( SystemSession.sessionIdName, __response.metadata[ SystemSession.sessionIdName ] );
			}
			
			var e:ServiceEvent = new ServiceEvent( ServiceEvent.COMPLETE );
			
			if( parse_result )
			{
				e = new ServiceEvent( ServiceEvent.COMPLETE );
			}
			else
			{
				e = new ServiceEvent( ServiceEvent.ERROR );
			}
			
			e.response = __response;
				
			dispatchEvent( e );	
			
		}
		
		protected function _ioErrorEventHandler( event:IOErrorEvent ):void
		{
			__serviceCompleted = true;
			var e:ServiceEvent = new ServiceEvent( ServiceEvent.COMPLETE );
				e.errorMessage = "System encounter an error. Please try again.";
			
			dispatchEvent( e );
		}
		
	}
}