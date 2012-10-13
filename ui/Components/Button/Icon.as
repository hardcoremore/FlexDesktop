package com.desktop.ui.Components.Button
{
	import com.desktop.system.interfaces.IResourceRequestHolder;
	import com.desktop.system.vos.LoadResourceRequestVo;
	import com.desktop.ui.Components.ComponentBase;
	import com.desktop.ui.vos.ButtonVo;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	
	import spark.components.Image;
	import spark.components.Label;
	import spark.primitives.BitmapImage;
	
	/**
	 * Desktop Icon size
	 */
	[Style(name="iconHeight", inherit="no", type="Number")]
	
	[Style(name="iconWidth", inherit="no", type="Number")]
	
	public class Icon extends ComponentBase implements IResourceRequestHolder
	{
		[SkinPart(required='true')]
		public var icon:Image;
		
		[SkinPart(required='true')]
		public var labelDisplay:Label;
		
		private var __iconLoading:Boolean;
		
		private var __urlRequest:URLRequest;
		
		private var __loader:Loader;
		
		private var __iconUrl:String;
		
		private var __label:String;
		
		protected var _resourceInfo:LoadResourceRequestVo;
		
		public function Icon()
		{	
			super();
		}
		
		public function init( ivo:ButtonVo ):void
		{
			resourceInfo = ivo.resource;
			
			x = ivo.x;
			y = ivo.y;
			
			if( ivo.label )
			{
				label = ivo.label;
			}
			else
			{
				label = ivo.resource.name;
			}
		}
		
		public function set resourceInfo( resource:LoadResourceRequestVo ):void
		{
			if( resource.icon )
			{
				if( icon ) icon.source = resource.icon;	
			}
			else if( resource.iconUrl )
			{
				iconUrl = resource.iconUrl;
			}
			
			_resourceInfo = resource;
		}
		
		public function get resourceInfo():LoadResourceRequestVo
		{
			return _resourceInfo;
		}
		
		public function set iconUrl(value:String):void
		{
			if( value != __iconUrl )
			{
				__iconUrl = value;
				
				__urlRequest = new URLRequest();
				
				__loader = new Loader();
				__loader.contentLoaderInfo.addEventListener( Event.COMPLETE, _imageLoadingCompleteEventHandler );
				__loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, imageLoadingIOErrorEventHandler);
				
				__urlRequest.url = __iconUrl;
				__loader.load( __urlRequest );
				__iconLoading = true;
				
				if( icon )
				{
					icon.source = resourceManager.getClass( this.session.config.LOCALE_CONFIG.systemIconsResourceName, "loadingAnimation", this.session.skinsLocaleName );
				}
				
			}
		}
		
		public function get iconUrl():String
		{
			return __iconUrl;
		}
		
		public function set label( label:String ):void
		{
			__label = label;
			if( labelDisplay ) labelDisplay.text = __label;
		}
		
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			if( instance == labelDisplay )
			{
				labelDisplay.text = __label;
			}
			if( instance == icon )
			{
				if( __iconLoading )
				{
					icon.source = resourceManager.getClass( this.session.config.LOCALE_CONFIG.systemIconsResourceName, "loadingAnimation", this.session.skinsLocaleName );
				}
				else if( resourceInfo )
				{
					icon.source = resourceInfo.icon;
				}
			}
			
			super.partAdded(partName,instance);
				
		}
		
		protected function _imageLoadingCompleteEventHandler(event:Event):void
		{
			__iconLoading = false;		
			icon.source =  event.currentTarget.content;
		}
		
		private function imageLoadingIOErrorEventHandler(event:IOErrorEvent):void
		{
			__iconLoading = false;
			icon.source =  resourceManager.getClass( this.session.config.LOCALE_CONFIG.systemIconsResourceName, "moduleIcon", this.session.skinsLocaleName );
		}
		
		override public function unload():void
		{
			super.unload();
			
			__loader.contentLoaderInfo.removeEventListener( Event.COMPLETE, _imageLoadingCompleteEventHandler );
			__loader.removeEventListener(IOErrorEvent.IO_ERROR, imageLoadingIOErrorEventHandler);
			
			icon = null;
			labelDisplay = null;
			__iconUrl = null;
			__loader = null;
			__urlRequest = null;
			
			dispatchEvent( new Event( Event.UNLOAD ) );
		}
	}
}