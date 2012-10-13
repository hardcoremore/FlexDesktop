package com.desktop.system.core
{
	import com.desktop.system.events.LanguageChangedEvent;
	import com.desktop.system.events.ResourceEvent;
	import com.desktop.system.interfaces.IConfig;
	import com.desktop.system.interfaces.IModuleBase;
	import com.desktop.system.interfaces.IResourceLoader;
	import com.desktop.system.managers.ResourceLoadManager;
	import com.desktop.system.utility.ResourceTypes;
	import com.desktop.system.vos.LoadResourceRequestVo;
	
	import factories.ModelFactory;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.getQualifiedClassName;
	
	import interfaces.modules.IAuthenticationModule;
	
	import models.AuthenticationModel;
	
	import mx.collections.ArrayList;
	import mx.core.Container;
	import mx.core.IFlexDisplayObject;
	import mx.core.IVisualElement;
	import mx.core.IVisualElementContainer;
	import mx.core.UIComponent;
	import mx.managers.PopUpManager;
	import mx.resources.IResourceManager;
	
	import spark.components.SkinnableContainer;

	public class ApplicationBase extends SystemObject
	{	
		private var __config:IConfig;
		
		private var __acl:Array;
		
		private var __applicationHolder:IVisualElementContainer;
		
		private var __resourceLoadManager:IResourceLoader;
		
		private var __authLRR:LoadResourceRequestVo;
		
		private var __authModule:IAuthenticationModule;
		
		private var __authenticationModel:AuthenticationModel;
		
		public function ApplicationBase( config:IConfig, renderTo:IVisualElementContainer )
		{
			__authenticationModel = ModelFactory.authenticationModel();
			__config = config;
			session.config = __config;
			
			__applicationHolder = renderTo;
			
			__resourceLoadManager = ResourceLoadManager.instance;
			__resourceLoadManager.config = __config;
			
		}
		
/************************************
 * 
 * GETTERS / SETTERS
 * 
 ***********************************/		
		
		public function set displayContainer(dObject:IVisualElementContainer):void
		{
			__applicationHolder = dObject;
		}
		
		public function get displayContainer():IVisualElementContainer
		{
			return __applicationHolder;
		}
		
		public function get config():IConfig
		{
			return __config;
		}
		
		public function get isAuth():Boolean
		{
			return __config.APPLICATION_CONFIG.loginRequired;
		}
		
		public function get session():SystemSession
		{
			return SystemSession.instance;
		}
		
		public function get authenticationModel():AuthenticationModel
		{
			return __authenticationModel;
		}
		
		public function get authModule():IAuthenticationModule
		{
			return __authModule;
		}
		
/*-----------------				END OF GETTERS / SETTERS				-----------------*/
		
/************************************
 * 
 * PUBLIC METHODS
 * 
 ***********************************/
		
		public function initializeApplication():void
		{
			( displayContainer as EventDispatcher ).addEventListener( Event.RESIZE, _onMainResize );
			
			if( isAuth )
			{	
				
				__authLRR = new LoadResourceRequestVo( "authenticationModule", 
														this.session.config.RESOURCE_CONFIG.moduleBasePath + "AuthenticationModule.swf",
														ResourceTypes.MODULE,
														"Authentication Module"
														);
				
				__resourceLoadManager.addEventListener( ResourceEvent.RESOURCE_LOADED, _authenticationModuleLoaded );
				__resourceLoadManager.addEventListener( ResourceEvent.RESOURCE_LOADING_ERROR, _authenticationModuleLoadError );
					
				__resourceLoadManager.loadResource( __authLRR );
				
			}
		}
		
		private function getModuleAcl(name:String):Array
		{
			var a:Array = new Array();
			
			for( var i:uint = 0; i < __acl.length; i++ )
			{
				if( __acl[i].name == name )
				{
					
					var o:Object = __acl[i];
					
					for each( var aa:Object in o.allowedActions.row )
					{
						a.push(aa);
					}
					
					return a;
					break;
				}
				
			}	
			
			return null;
		}
		
/*-----------------				END OF PUBLIC METHODS				-----------------*/
		
/************************************
 * 
 * PROTECTED METHODS
 * 
 ***********************************/

		public function startApp():void
		{
			if( isAuth )
			{
				PopUpManager.removePopUp( IFlexDisplayObject( authModule ) );
			}
		}
		
/*----------------				END OF PROTECTED METHODS				--------------------*/
		
/************************************
 * 
 * EVENT HANDLERS
 * 
 ***********************************/		
		
		protected function _onMainResize( event:Event ):void
		{
			var fd:IFlexDisplayObject = IFlexDisplayObject( __authModule )
			
			if( fd )
				PopUpManager.centerPopUp(  fd );
		}
		
		protected function _authenticationModuleLoaded( event:ResourceEvent ):void
		{	
			__resourceLoadManager.removeEventListener( ResourceEvent.RESOURCE_LOADED, _authenticationModuleLoaded );
			
			__authModule = event.resourceInfo.resource as IAuthenticationModule;
			__authModule.application = this;
			
			( __authModule as IModuleBase ).init();
			
		
			PopUpManager.addPopUp( IFlexDisplayObject( __authModule ), DisplayObject( displayContainer ), true );
			PopUpManager.centerPopUp( IFlexDisplayObject( __authModule ) ); 
		}
		
		protected function _authenticationModuleLoadError( event:ResourceEvent ):void
		{
			trace( "AUTH MODULE LOAD ERROR. ERROR: " + event.resourceInfo.status.message );
		}
		
		/**
		protected function __authenticationResponseHandler( event:AuthenticationEvent ):void
		{
		}
		
		protected function __authenticationFailedHandler( event:AuthenticationEvent ):void
		{
		}
		
		protected function __userResponseHandler( event:AuthenticationEvent ):void
		{
		}
		
		protected function __userFailedHandler( event:AuthenticationEvent ):void
		{
		}
		
		protected function _authenticationResponseHandler(event:AuthenticationEvent):void
		{
			_startApp();
		}
	
		protected function _authenticationFailedHandler(event:AuthenticationEvent):void
		{
			//PopUpManager.centerPopUp( __authController.getView() );
		}
		 * ***/ 
		
/*----------------				END OF 	EVENT HANDLERS				--------------------*/		
		
		
		
	}
}