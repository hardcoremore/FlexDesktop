package com.desktop.system.core.service.RPC
{
	import com.desktop.system.events.AbortEvent;
	import com.desktop.system.events.DesktopServiceResponseEvent;
	import com.desktop.system.core.SystemSession;
	
	import com.desktop.system.interfaces.IConfig;
	import com.desktop.system.interfaces.IControllerToServiceManager;
	import com.desktop.system.interfaces.IService;
	import com.desktop.system.interfaces.IServiceReturnData;
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	
	import mx.events.CloseEvent;
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;


	public class DesktopRemoteCall extends EventDispatcher implements IControllerToServiceManager
	{
		private var __resourceManager:IResourceManager = ResourceManager.getInstance();
		
		private var __useDefaultActionOnError:Boolean = true;
		
		private var __service:DesktopService;
		
		private var __abortMessage:String;
		
		private var __returnDataFormat:String;
		
		private var __dataParser:IServiceReturnData;
		
		private var __sendDataFormat:String = URLLoaderDataFormat.VARIABLES;
		
		private var __method:String = URLRequestMethod.POST;
		
//----------------------------------------------------------------------------		
		/*
		* ***************************
		* 
		*  Getters and Setters
		* 
		***************************
		*/
		
		//************ METHOD **************************
		public function set method(value:String):void
		{
			__method = value;
		}
		
		public function get method():String
		{
			return __method;
		}
		
		//************ SEND DATA FORMAT **************************
		public function set sendDataFormat(value:String):void
		{
			__sendDataFormat = value;
		}
		
		public function get sendDataFormat():String
		{
			return __sendDataFormat;
		}
			
		//************ RETURN DATA FORMAT **************************
		public function set returnDataFormat(value:String):void
		{
			__returnDataFormat = value;
		}
		
		public function get returnDataFormat():String
		{
			return __returnDataFormat;
		}
		
		//************ USE DEFAULT ACTION ON ERROR **************************
		public function set useDefaultActionOnError(value:Boolean):void
		{
			__useDefaultActionOnError = value;
		}
		
		public function get useDefaultActionOnError():Boolean
		{
			return __useDefaultActionOnError;
		}
		/*
		*-------------------------------*
		* 						 		*
		* END of Getters and Setters    *
		* 						        *
		*-------------------------------*
		*/	
		
//------------------------------------------------------------------------------------		
		
		public function DesktopRemoteCall(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		public function send( cName:String, aName:String, postData:Object = null, getData:Object = null ):void
		{
			if( !cName || !aName || cName.length == 0 || aName.length == 0 )
			{
				throw new Error("Error: Controller name || action name invalid. Please supply valid controller and action name at " +
					"ControllerToServiceManager::send()");
			}

// 				@TODO parse getData into __service.url
			
				__service = new DesktopService();
				
				//__service.url = ConfigManager.getInstance().getConfigInstance().SCRIPT_ROOT_URI + cName + "/" + aName + "/";
					
				__service.addEventListener(DesktopServiceResponseEvent.RESULT, _onServiceResult);
				__service.addEventListener(DesktopServiceResponseEvent.FAULT, _onServiceFault);
				__service.addEventListener(AbortEvent.ABORT, _onServiceAbort);
				
				
				__service.sendDataFormat = __sendDataFormat;
				__service.returnFormat = __returnDataFormat;
				__service.method = __method;
				
				
				
				var s:Object = SystemSession.instance;
				
				
				if( s )
				{
					/*
					var cH:URLRequestHeader = new URLRequestHeader( 
					'Set-Cookie',
					DesktopSession.sessionIdName + '=' + s[ DesktopSession.sessionIdName ]  + ';' + 'expires=Fri, 31-Dec-2010 23:59:59 GMT' 
					);
					*/
					
					// sending custom header instead Set-Cookie like above
					var ch:URLRequestHeader = new URLRequestHeader(  SystemSession.sessionIdName, s[ SystemSession.sessionIdName ] );
					
					
//					@todo if request method is actually get pass session id into get and set method to the requested one
					__service.method = URLRequestMethod.POST;
					__service.requestHeaders = [ ch ]; 
				}
				
				__service.send( postData );
				
		}
		
		public function abort(message:String = null):void
		{
			__removeListeners();
			__abortMessage = message;
			__service.abort();
		}
		
		public function unload():void
		{
			__removeListeners();
		}
		
		protected function _onServiceAbort(event:AbortEvent):void
		{
			__removeListeners()
			
			event.message = __abortMessage;
			dispatchEvent( event.clone() );
		}
		
		protected function _onServiceResult(event:DesktopServiceResponseEvent):void
		{
			__removeListeners();
			
			var error:Boolean = false;
			
			var message:String;
			
			if( !event.result  )
			{
				error = true;
				message =  'serverError';
			}
			else if( !event.result.metadata || String( event.result.metadata.status ) != 'ok' || String( event.result.metadata.errorCode )  != '0' )
			{
				error = true;
					
				if( event.result.metadata )
				{
					//message = ErrorMessageHandler.getMessageKeyString( int( event.result.metadata.errorCode ) );	
				}
				else
				{
					message = 'programError';
				}
						
				
			}
			
			if( error )
			{
				if( useDefaultActionOnError )
				{
					showError( __resourceManager.getString( 'myResources', 'errorOccured' ), message );
				}
				
				var e:DesktopServiceResponseEvent = new DesktopServiceResponseEvent( DesktopServiceResponseEvent.FAULT );
					e.messageKeyString = message;
					
					dispatchEvent(e);
			}
			else
			{
				//var dataParserClass:Object = ConfigManager.getInstance().getConfigInstance().SERVICE_RETURN_DATA_TO_FLEX_DATA_PROVIDER_PARSER_CLASS; 
				
			//	__dataParser = new dataParserClass();
				
				__dataParser.parseData( event.result );
				
				event.result = __dataParser;
				dispatchEvent(  event.clone() );
			}
			
			
		}
		
		protected function _onServiceFault(event:DesktopServiceResponseEvent):void
		{
			__removeListeners();
			
			if( useDefaultActionOnError )
			{
				showError( 
								__resourceManager.getString( "myResources", "errorOccured"),
								__resourceManager.getString( "myResources", "serverError") 
					    );
			}
			
			dispatchEvent( event.clone() );
		}
		
		private function __removeListeners():void
		{
			__service.removeEventListener(DesktopServiceResponseEvent.RESULT, _onServiceResult);
			__service.removeEventListener(DesktopServiceResponseEvent.FAULT, _onServiceFault);
			__service.removeEventListener(AbortEvent.ABORT, _onServiceAbort);
			
		}
		
		public function showError( title:String, message:String ):void
		{
			/*DesktopAlert.show( 
								"error",
								message,
								title
							 );	*/
		}
		
	}
}