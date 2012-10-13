package com.desktop.system.events
{
	import com.desktop.system.Application.vos.UserVo;
	
	import flash.events.Event;
	
	public class UserEvent extends Event
	{
		public static const USER_LOADED:String = 'userLoaded';
		public static const USER_LOADING_FAILED:String = 'userLoadingFailed';
		
		
		private var __user:UserVo;
		
		public function get user():UserVo
		{
			return __user;
		}
		
		public function set user( user:UserVo ):void
		{
			__user = user;
		}
		
		public function UserEvent( type:String, user:UserVo = null, bubbles:Boolean=false, cancelable:Boolean=false )
		{
			super(type, bubbles, cancelable);
			
			__user = user;
		}
	}
}