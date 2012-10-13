package com.desktop.system.events
{
	import com.desktop.system.vos.LoadResourceRequestVo;
	
	import flash.events.Event;
	
	public class ResourceEvent extends Event
	{
		public static const RESOURCE_LOAD_REQUEST:String 		= "ResourceRequestLoad";
		public static const RESOURCE_LOADING:String 			= "ResourceLoading";
		public static const RESOURCE_LOADED:String 				= "ResourceLoaded";
		public static const RESOURCE_LOADING_ERROR:String 		= "ResourceLoadingError";
		
		public static const RESOURCE_REQUEST_UNLOAD:String 		= "ResourceRequestUnload";
		public static const RESOURCE_UNLOADED:String 			= "ResourceUnloaded";
		
		public static const QUEE_COMPLETED:String 				= "QueeCompleted";
		
		
		
		protected var _resourceInfo:LoadResourceRequestVo;
		public function set resourceInfo( r:LoadResourceRequestVo):void
		{
			_resourceInfo = r;
		}
		
		public function get resourceInfo():LoadResourceRequestVo
		{
			return _resourceInfo;
		}
		
		public function ResourceEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		protected var _queePercentLoaded:Number;
		public function get queePercentLoaded():Number
		{
			return _queePercentLoaded;
		}
		
		public function set queePercentLoaded( value:Number ):void
		{
			_queePercentLoaded = value;
		}
		
		protected var _bytesLoaded:Number;
		public function get bytesLoaded():Number
		{
			return _bytesLoaded;
		}
		
		public function set bytesLoaded( value:Number ):void
		{
			_bytesLoaded = value;
		}
		
		// resource to unload
		protected var _resource:Object;
		public function get resource():Object
		{
			return _resource;
		}
		
		public function set resource( r:Object ):void
		{
			_resource = r;
		}
	
		override public function clone():Event
		{
			var e:ResourceEvent = new ResourceEvent(type, bubbles, cancelable);
				e.resourceInfo = resourceInfo;
				e.queePercentLoaded = queePercentLoaded;
				e.bytesLoaded = bytesLoaded;
				e.resource = resource;
			return e;
		}
	}
}