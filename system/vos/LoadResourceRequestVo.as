package com.desktop.system.vos
{
	import com.desktop.system.interfaces.ILoadResourceRequester;
	import com.desktop.system.interfaces.INotifier;
	import com.desktop.system.interfaces.IResourceHolder;
	import com.desktop.ui.vos.ResourceHolderVo;

	final public class LoadResourceRequestVo
	{
		public var resourceId:String;
		
		private var __resourceUrl:String;
		
		public function set resourceUrl( url:String ):void
		{
			if( ! __resourceUrl )
				__resourceUrl = url;
		}
		
		public function get resourceUrl():String
		{
			return __resourceUrl;	
		}
		
		private var __type:uint;
		public function set type( type:uint ):void
		{
			if( ! __type )
				__type = type;
		}
		
		public function get type():uint
		{
			return __type;	
		}
		
		
		
		public var iconUrl:String;
		public var icon:Class;
		public var name:String;
		public var requester:ILoadResourceRequester;
		public var notifier:INotifier;
		public var status:ResourceLoadStatusVo;
		public var resource:Object;
		public var resourceHolderConfig:ResourceHolderVo;
		public var getNew:Boolean;
		public var createResourceHolderAutomatically:Boolean;
		
		public var resourceModuleLocale:String;
		
		
		public var service:WebServiceRequestVo;
		
		private var __index:int = -1;
		
		public function get index():int
		{
			return __index;
		}
		
		public function set index( i:int ):void
		{
			if( i < 0 ) return;
			
			if( __index < 0 ) __index = i;
		}
		
		public function LoadResourceRequestVo( resourceId:String = null, resourceUrl:String = null, type:uint = 0, name:String = null,  icon:Class = null )
		{
			this.resourceId = resourceId;
			this.resourceUrl = resourceUrl;
			this.type = type;
			this.name = name;
			this.icon = icon;
		}
	}
}