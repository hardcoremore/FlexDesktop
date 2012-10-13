package com.desktop.system.utility
{
	import com.desktop.system.events.ResourceEvent;
	import com.desktop.system.interfaces.IResourceLoader;
	import com.desktop.system.managers.ResourceLoadManager;
	import com.desktop.system.vos.LoadResourceRequestVo;
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class QueeLoader extends EventDispatcher
	{
		private var __resourceLoadManager:IResourceLoader;
		
		private var __loadingQuee:Vector.<LoadResourceRequestVo>;
		
		private var __max_sim_loading:uint = 3;
		
		private var __startIndex:int = -1;
		
		private var __loadedResources:uint;
		
		private var __reloadOnError:Boolean = true;
		
		private var __queeLoadProgress:Number;
		
		public function QueeLoader( target:IEventDispatcher=null )
		{
			super(target);
			
			__loadingQuee = new Vector.<LoadResourceRequestVo>;
			
			__resourceLoadManager = ResourceLoadManager.instance;
			
			__loadedResources = 0;
			__queeLoadProgress = 0;
		}
		
		public function addToQuee( resource:LoadResourceRequestVo ):void
		{
			if(  __loadingQuee.indexOf( resource )  == -1 )
			{
				__loadingQuee.push( resource );
			}
		}
		
		public function load( offset:uint = 0 ):void
		{
			__resourceLoadManager.addEventListener( ResourceEvent.RESOURCE_LOADED, _resourceLoadedEventHandler );
			__resourceLoadManager.addEventListener( ResourceEvent.RESOURCE_LOADING, _resourceLoadingEventHandler );
			__resourceLoadManager.addEventListener( ResourceEvent.RESOURCE_LOADING_ERROR, _resourceLoadingErrorEventHandler );
			
			if( __startIndex < 0 ) __startIndex = offset;
			
			var p:uint = __loadingQuee.length;
			
			if( __startIndex > 0 )
				p = __startIndex;
			
			for( var i:uint = offset; i < ( offset + maxSimLoading ) && i < __loadingQuee.length && i < p; i++ )
			{
				__resourceLoadManager.loadResource( __loadingQuee[ i ] );
			}
		}
		
		public function get queeLength():uint
		{
			return __loadingQuee.length;
		}
		
		public function get maxSimLoading():uint
		{
			return __max_sim_loading;
		}
		
		public function set maxSimLoading( max:uint ):void
		{
			__max_sim_loading = max;
		}
		
		public function set reloadOnError( value:Boolean ):void
		{
			__reloadOnError = true;
		}
		
		public function get reloadOnError():Boolean
		{
			return __reloadOnError;			
		}
		
		protected function _resourceLoadedEventHandler( event:ResourceEvent ):void
		{
			if(  __loadingQuee.indexOf( event.resourceInfo )  == -1 ) return; // this resource does not belong to our quee
				
			__loadedResources++;
			
			event.queePercentLoaded = __queeLoadProgress; 
			dispatchEvent( event.clone() );
			
			if( __loadedResources == __loadingQuee.length )
			{
				var e:ResourceEvent = new ResourceEvent( ResourceEvent.QUEE_COMPLETED );
					e.queePercentLoaded = 100; 
					
				dispatchEvent( e);
				
				__resourceLoadManager.removeEventListener( ResourceEvent.RESOURCE_LOADED, _resourceLoadedEventHandler );
				__resourceLoadManager.removeEventListener( ResourceEvent.RESOURCE_LOADING, _resourceLoadingEventHandler );
				__resourceLoadManager.removeEventListener( ResourceEvent.RESOURCE_LOADING_ERROR, _resourceLoadingErrorEventHandler );
				
				return;
			}
			else if(  __loadedResources % maxSimLoading == 0 )
			{
				if( __startIndex == 0 )
				{
					load( __loadedResources );
				}
				else
				{
					load( 0 );
				}
			}
		}
		
		protected function _resourceLoadingEventHandler( event:ResourceEvent ):void
		{
			if(  __loadingQuee.indexOf( event.resourceInfo )  == -1 ) return; // this resource does not belong to our quee
			
			var p:Number = 0;
			
			for each( var i:LoadResourceRequestVo in __loadingQuee )
			{
				if( i.status )
				{
					p += i.status.percentLoaded;
				}
			}
			
			p = p /  __loadingQuee.length;
			
			__queeLoadProgress = p;
			
			var e:ResourceEvent = event.clone() as ResourceEvent;
				e.queePercentLoaded = p;
					
			dispatchEvent( e ); 
		}
		
		protected function _resourceLoadingErrorEventHandler( event:ResourceEvent ):void
		{
			if(  __loadingQuee.indexOf( event.resourceInfo )  == -1 ) return; // this resource does not belong to our quee
			
			trace( "Loading error at QueeLoader::_resourceLoadingrErrorEventHandler()" );
			
			if( __reloadOnError )
			{
				__resourceLoadManager.loadResource( event.resourceInfo );
			}
		}
		
		public function unload():void
		{
			__loadingQuee = null;
			__resourceLoadManager.removeEventListener( ResourceEvent.RESOURCE_LOADED, _resourceLoadedEventHandler );
			__resourceLoadManager.removeEventListener( ResourceEvent.RESOURCE_LOADING, _resourceLoadingEventHandler );
			__resourceLoadManager.removeEventListener( ResourceEvent.RESOURCE_LOADING_ERROR, _resourceLoadingErrorEventHandler );
			
		}
	}
}
