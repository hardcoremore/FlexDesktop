package com.desktop.system.core
{
	import com.desktop.system.interfaces.IConfig;
	import com.desktop.system.interfaces.IController;
	import com.desktop.system.interfaces.IModuleBase;
	
	import mx.core.IVisualElement;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;

	public class BaseController extends SystemObject implements IController
	{
		protected var _config:IConfig;
		
		public function set config( c:IConfig ):void
		{
			_config = c;
		}
		
		public function get config():IConfig
		{
			return _config;	
		}
		
		public function get session():SystemSession
		{
			return SystemSession.instance;
		}
		
		/**
		 * 
		 *  Instance of IDesktopModule if controller is inside the module
		 * @protected
		 * 
		 **/
		 
		protected var _module:IModuleBase;
		
		public function set module(module:IModuleBase):void
		{
			_module = module;
		}
		
		
		public function BaseController()
		{
			
			config = this.session.config;
		}
		
		/*
		public function getView( id:String = null ):UIComponent
		{
			if( _views.length != 0 )
			{
				if( id != null )
				{
					for( var i:Object in _views )
					{
						if( _views[i].id == id )
						{
							return _views[i].view;
						}
					}
				}else{
					
					if( _views.length == 1 ) _views[0].view;
						
					for( var b:Object in _views )
					{
						if( _views[b].id == "default" )
						{
							return _views[b].view;
						}
					}
				}
			}
			return null;
		}
		
		public function setView( view:UIComponent, id:String = null  ):void
		{
			if( view != null )
			{
				if( id != null)
				{
					_views.push({ id:id, view:view});
				}else{
					_views.push({id:'default', view:view});
				}
				view.addEventListener(FlexEvent.CREATION_COMPLETE, viewCreationComplete);
			}
		}
		*/
		
		public function unload():void
		{
			_module = null;
			
		}
		
	}
}