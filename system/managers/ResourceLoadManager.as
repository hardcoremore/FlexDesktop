package com.desktop.system.managers
{
	import com.desktop.system.core.SystemObject;
	import com.desktop.system.core.service.ServiceLoader;
	import com.desktop.system.events.ResourceEvent;
	import com.desktop.system.interfaces.IConfig;
	import com.desktop.system.interfaces.IModuleBase;
	import com.desktop.system.interfaces.IResourceLoader;
	import com.desktop.system.interfaces.IService;
	import com.desktop.system.utility.ErrorCodes;
	import com.desktop.system.utility.ResourceLoadStatus;
	import com.desktop.system.utility.ResourceTypes;
	import com.desktop.system.vos.LoadResourceRequestVo;
	import com.desktop.system.vos.ResourceConfigVo;
	import com.desktop.system.vos.ResourceLoadStatusVo;
	import com.desktop.system.vos.WebServiceRequestVo;
	
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.utils.describeType;
	import flash.utils.getQualifiedClassName;
	
	import mx.core.IFlexModuleFactory;
	import mx.core.Singleton;
	import mx.events.ModuleEvent;
	import mx.events.ResourceEvent;
	import mx.modules.IModule;
	import mx.modules.IModuleInfo;
	import mx.modules.ModuleManager;
	import mx.resources.IResourceBundle;
	
	public class ResourceLoadManager extends SystemObject implements IResourceLoader
	{
		private static var __instance:ResourceLoadManager;
		
		private var __config:IConfig;
		
		private var __loadingResources:Vector.<LoadResourceRequestVo>;
		
		private var __moduleFactory:IFlexModuleFactory;
		
		private var __loadResourceVoProperties:XML;
		
		private var __serviceData:Object;
		
		public function ResourceLoadManager(singleton:Singleton,  target:IEventDispatcher=null  )
		{
			super(target);
			
			__loadingResources = new Vector.<LoadResourceRequestVo>();
			__loadResourceVoProperties = describeType( LoadResourceRequestVo );
			
		}
		
		
		public static function get instance():IResourceLoader
		{
			if( ! __instance ) __instance = new ResourceLoadManager( new Singleton(), null );
			
			return __instance;
		}
		
		public function get numResources():uint
		{
			return __loadingResources.length;
		}
	
		public function set config( config:IConfig ):void
		{
			if( ! __config )
			{
				__config = config;
			}
			else
			{
				throw new Error( "Config already set at ResourceLoadManager::config(). Config can be set only once!", ErrorCodes.INTERNAL_APPLICATION_ERROR );
			}
		}
		
		protected function get _loadingResources():Vector.<LoadResourceRequestVo>
		{
			return __loadingResources;
		}
		
		
		
/******************************
 * 
 * 	PUBLIC METHODS
 * 
 ******************************/
		
		public function loadResource( resource:LoadResourceRequestVo ):void
		{
			if( resource && resource.resourceUrl && resource.resourceUrl.length > 0 )
			{
				var e:com.desktop.system.events.ResourceEvent;
				var re:LoadResourceRequestVo = _getResourceFromIndex( resource.index );
				
				if( ! re )
					re = _getResource( resource.resourceUrl, "resourceUrl" );
				
				
				if( re && re.status.statusCode == ResourceLoadStatus.RESOURCE_LOAD_COMPLETED && re.type != ResourceTypes.WEB_SERVICE && ! re.getNew )
				{	
					// resource is loading already and since new instance was not
					// requested return the existing resource
					if( re.requester )
						re.requester.updateResourceLoadStatus( re );
					
					
						var ev:com.desktop.system.events.ResourceEvent = new com.desktop.system.events.ResourceEvent( com.desktop.system.events.ResourceEvent.RESOURCE_LOADED );
						ev.resourceInfo = re;
						
						dispatchEvent( ev );
					
					return;
				}
				
				
				
				resource.status = new ResourceLoadStatusVo();
				resource.status.percentLoaded = 0;
				
				__loadingResources.push( resource );
				
				if( __loadingResources.length > 0 )
				{
					resource.index = __loadingResources.length - 1;
				}
				else
				{
					resource.index = 0;
				}
				
				switch(resource.type)
				{
					case ResourceTypes.MODULE:
					{
						resource.resource = ModuleManager.getModule( resource.resourceUrl );
						//resource.resource.addEventListener( ModuleEvent.SETUP, _moduleSetupEventHandler );
						resource.resource.addEventListener( ModuleEvent.READY, _loadCompleteEventHandler );
						resource.resource.addEventListener( ModuleEvent.ERROR, _loadingErrorEventHandler );
						resource.resource.addEventListener( ModuleEvent.PROGRESS, _loadProgressEventHandler );
						resource.resource.data = resource;
						
						resource.status.statusCode = ResourceLoadStatus.RESOURCE_LOADING;
						
						resource.resource.load( null, null, null );
						
						break;
					}
					
					case ResourceTypes.RESOURCE_MODULE:
						
						resource.resource = resourceManager.loadResourceModule( resource.resourceUrl );
						resource.resource.addEventListener( mx.events.ResourceEvent.COMPLETE, _loadCompleteEventHandler );
						resource.resource.addEventListener( mx.events.ResourceEvent.PROGRESS, _loadProgressEventHandler );
						resource.resource.addEventListener( mx.events.ResourceEvent.ERROR, _loadingErrorEventHandler );
							
						resource.status.statusCode = ResourceLoadStatus.RESOURCE_LOADING;
						
					break;
					
					
					case ResourceTypes.GRAPHICS_SWF:
						
						var l:Loader = new Loader();
						
							resource.resource = l.contentLoaderInfo;
							
							resource.resource.addEventListener( Event.COMPLETE, _loadCompleteEventHandler );
							resource.resource.addEventListener( ProgressEvent.PROGRESS, _loadProgressEventHandler );
							resource.resource.addEventListener( IOErrorEvent.IO_ERROR, _loadingErrorEventHandler );
							
							resource.status.statusCode = ResourceLoadStatus.RESOURCE_LOADING;
							
							l.load( _buildUrlRequest( resource ) );
						
					break;
					
					case ResourceTypes.WEB_SERVICE:
						
						var urll:IService = new ServiceLoader();
							urll.index = resource.index;
							urll.addEventListener( Event.COMPLETE, _loadCompleteEventHandler );
							urll.addEventListener( Event.OPEN, _loadStartEventHandler );
							urll.addEventListener( ProgressEvent.PROGRESS, _loadProgressEventHandler );
							urll.addEventListener( IOErrorEvent.IO_ERROR, _loadingErrorEventHandler )
						
						
						if( ! re || (  re && resource.getNew ) )
						{
							resource.status.statusCode = ResourceLoadStatus.RESOURCE_LOADING;
							urll.loadService( re.service, this._config.RESOURCE_CONFIG );
						}
						else if( re && re.status.statusCode == ResourceLoadStatus.RESOURCE_LOAD_COMPLETED && ! resource.getNew )
						{
							if( __serviceData.hasOwnProperty( resource.resourceUrl ) )
							{
								var r:Object = __serviceData[ resource.resourceUrl ];
								
								if( r.data == resource.service.data )
								{
									
								}
							}
							
						}
						else
						{
							resource.status.statusCode = ResourceLoadStatus.RESOURCE_LOADING;
							urll.loadService( re.service, this._config.RESOURCE_CONFIG );
						}
						
					break;
					
					
					default:
						resource.status.statusCode = ResourceLoadStatus.RESOURCE_LOAD_ERROR;
						throw new Error( "Unknow resource at ResourceLoadManager::loadResource().", ErrorCodes.LOADING_ERROR );
					break;
				}
			}
			else
			{
				resource.status.statusCode = ResourceLoadStatus.RESOURCE_LOAD_ERROR;
				throw new Error( "Resource url invalid at ResourceLoadManager::loadResource().", ErrorCodes.LOADING_ERROR );
			}

			
			if( resource.requester )
				resource.requester.updateResourceLoadStatus( resource );
			
			if( resource.status.statusCode == ResourceLoadStatus.RESOURCE_LOADING )
			{	
				e = new com.desktop.system.events.ResourceEvent( com.desktop.system.events.ResourceEvent.RESOURCE_LOADING );
				e.resourceInfo = resource;
				dispatchEvent( e );
			}
		
		}
		
		public function unloadResource( resource:Object ):void
		{
			if( ! resource ) return;
			
			var re:LoadResourceRequestVo;
			
			if( ! ( resource is LoadResourceRequestVo ) )
			{
				re = _getResource( resource, "resource" );
				
				if( ! re ) re = _getResource( resource, "resourceId" ); 
			}
			else
			{
				re = resource as LoadResourceRequestVo;
			}
			
			if( ! re ) return;
			
			switch( re.type )
			{
				case ResourceTypes.MODULE:
				{
					( re.resource as IModuleBase ).unload();
					re.resource = null;
					re.status.statusCode = ResourceLoadStatus.RESOURCE_NOT_LOADING;
						
					break;
				}
					
				case ResourceTypes.RESOURCE_MODULE:
				{
					break;
				}
					
				case ResourceTypes.GRAPHICS_SWF:
				{
					break;
				}	
			}
		}
		
		public function getResourceIndex( resource:LoadResourceRequestVo ):int
		{ 
			if( ! resource ) return -1;
			
			for( var i:uint = 0; i < __loadingResources.length; i++ )
			{
				if( __loadingResources[ i ] ==  resource )
				{
					return i;
				}
			}
			
			return -1;
		}
		
		
/*-----------------				END OF PUBLIC METHODS 			-------------------*/	
		
		
		
/******************************
 * 
 * 	PROTECTED METHODS
 * 
 ******************************/
		protected function _buildUrlRequest( r:LoadResourceRequestVo ):URLRequest
		{
			var urlr:URLRequest = new URLRequest();
				urlr.url = r.resourceUrl;
			
				
			return urlr;
		}
		
		protected function _getResource( content:*, attribute:String ):LoadResourceRequestVo
		{
			if( ! __loadResourceVoProperties.variable.( @id == attribute ) )
				return null;
			
			for each( var lvo:LoadResourceRequestVo in __loadingResources )
			{
				if( lvo[ attribute ] === content )
				{	
					return lvo;
					break;
				}
			}
			
			return null;
		}
		
		protected function _getResourceFromIndex( index:uint ):LoadResourceRequestVo
		{
			if( index >= 0 && index <= __loadingResources.length - 1 )
			{
				return __loadingResources[ index ];
			}
			
			return null;
		}
		
		protected function _getResourceFromEvent( event:Event ):LoadResourceRequestVo
		{	
			if( event is ModuleEvent )
			{
				var mi:IModuleInfo = event.target as IModuleInfo;
				return  __loadingResources[ ( mi.data as LoadResourceRequestVo ).index ];
			}
			else if( event.target is IService )
			{
				return __loadingResources[ ( event.target as IService ).index ]; 
			}
			else if( event is mx.events.ResourceEvent || event.target is LoaderInfo )
			{
				return _getResource( event.target, "resource" );
			}
			
			
			return null;
		}
		
		
		
		protected function get _config():IConfig
		{
			return __config;
		}
/*--------------------				END OF PROTECTED METHODS 				-------------------------*/	

		
		
/******************************
 * 
 * 	LOAD EVENTS
 * 
 ******************************/
		
		protected function _loadStartEventHandler( event:Event ):void
		{
			
		}
		
		protected function _moduleSetupEventHandler( event:ModuleEvent ):void
		{
		}
		
		protected function _loadProgressEventHandler( event:ProgressEvent ):Number
		{
			var p:Number;	
			var r:LoadResourceRequestVo = _getResourceFromEvent( event );

			if( ! r ) throw new Error( "LoadResourceRequest could not be found at ResourceLoadManager::_loadProgressEventHandler()", ErrorCodes.INTERNAL_APPLICATION_ERROR );
			
			r.status.statusCode = ResourceLoadStatus.RESOURCE_LOADING;
			r.status.bytesLoaded = event.bytesLoaded;
			r.status.bytesTotal = event.bytesTotal;
			r.status.percentLoaded = event.bytesLoaded / event.bytesTotal * 100;
			
			var e:com.desktop.system.events.ResourceEvent = new com.desktop.system.events.ResourceEvent( com.desktop.system.events.ResourceEvent.RESOURCE_LOADING );
				e.resourceInfo = r;
			
			dispatchEvent( e );
			
			if( r.requester )
				r.requester.updateResourceLoadStatus( r ); 
			
			return p;
		}
		
		protected function _loadCompleteEventHandler( event:Event ):void
		{
			
			var r:LoadResourceRequestVo = _getResourceFromEvent( event );
			
			if( ! r ) return;
			
			r.status.percentLoaded = 100;
			r.status.statusCode = ResourceLoadStatus.RESOURCE_LOAD_COMPLETED;
		
			switch( r.type )
			{
				case ResourceTypes.MODULE:
				{
					
					var baseModule:IModuleBase = event.target.factory.create() as IModuleBase;
					
					if( r.resourceHolderConfig && baseModule.resourceHolderConfig )
					{
						baseModule.resourceHolderConfig.parent = r.resourceHolderConfig.parent;
						baseModule.resourceHolderConfig.cObject = r.resourceHolderConfig.cObject;
						baseModule.resourceHolderConfig.child = r.resourceHolderConfig.child;
						baseModule.resourceHolderConfig.hideOnClose = r.resourceHolderConfig.hideOnClose;
					}
			
					if( baseModule.resourceHolderConfig )
						r.resourceHolderConfig = baseModule.resourceHolderConfig;
					
					r.resource = baseModule;
					
					break;
				}
					
				case ResourceTypes.RESOURCE_MODULE:
					
					var la:Array = new Array();
						la.push( r.resourceModuleLocale );
						
					var cla:Array = resourceManager.getLocales();
					
					for each( var locale:String in cla )
					{
						la.push( locale );
					}
					
					resourceManager.localeChain = la;
					resourceManager.update();
						
				break;
				
				case ResourceTypes.GRAPHICS_SWF:
					
					var l:Loader = ( event.target as LoaderInfo ).loader;
					
					r.resource.removeEventListener( Event.COMPLETE, _loadCompleteEventHandler );
					r.resource.removeEventListener( ProgressEvent.PROGRESS, _loadProgressEventHandler );
					r.resource.removeEventListener( IOErrorEvent.IO_ERROR, _loadingErrorEventHandler );
					
					r.resource = l.content;
					
					l.unload();
					
					
					
				break;
			}

			var e:com.desktop.system.events.ResourceEvent = new com.desktop.system.events.ResourceEvent( com.desktop.system.events.ResourceEvent.RESOURCE_LOADED );
				e.resourceInfo = r;
			
			dispatchEvent( e );
			
			if( r.requester )
				r.requester.updateResourceLoadStatus( r );
		}
		
		protected function _loadingErrorEventHandler( event:Event ):void
		{
			var r:LoadResourceRequestVo = _getResourceFromEvent( event );
			
			if( ! r ) throw new Error( "LoadResourceRequest could not be found at ResourceLoadManager::_loadingErrorEventHandler()", ErrorCodes.INTERNAL_APPLICATION_ERROR );
			
			r.status.statusCode = ResourceLoadStatus.RESOURCE_LOAD_ERROR;
			
			if( event is IOErrorEvent )
			{
				r.status.message = IOErrorEvent( event ).text;
			}
			else if( event is ModuleEvent )
			{
				r.status.message = ModuleEvent( event ).errorText;
			}
			else if( event is mx.events.ResourceEvent )
			{
				r.status.message = mx.events.ResourceEvent( event ).errorText;
			}
			
				
			if( r.requester )
				r.requester.updateResourceLoadStatus( r );
			
			var e:com.desktop.system.events.ResourceEvent = new com.desktop.system.events.ResourceEvent( com.desktop.system.events.ResourceEvent.RESOURCE_LOADING_ERROR );
				e.resourceInfo = r;
			
			dispatchEvent( e );
		}
		
/*--------------				 END OF LOAD EVENTS 				----------------*/		

		
	}
}

class Singleton{}