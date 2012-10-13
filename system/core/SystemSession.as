package com.desktop.system.core
{
	import com.desktop.system.interfaces.IConfig;
	
	import flash.events.EventDispatcher;
	
	import vos.UserVo;

	public class SystemSession extends EventDispatcher
	{
		public static var sessionIdName:String = 'sess_id';
		
		private static var __instance:SystemSession;
		
		private static var __session:Object;
		
		private var __user:UserVo;
		
		[Bindable]		
		public var skinsLocaleName:String = "Default_skinClasses";
		
		[Bindable]
		public  var languageLocaleName:String = "sr_RS";
		
		[Bindable]
		public var iconSize:Number = 1;
		
		[Bindable]
		public var fontSize:Number = 1;
		
		[Bindable]
		public var autoLockTime:uint = 15;
		
		private var __config:IConfig;
		public function get config():IConfig
		{
			 return __config;
		}
		
		[Bindable]
		public function set config( c:IConfig ):void
		{
			__config = c;
		}
		
		private var __sessionId:String;
		public function get id():String
		{
			return __sessionId;
		}
		
		[Bindable]
		public function set user( u:UserVo ):void
		{
			if( __user != u )
			{
				__user = u;
			}
		}
		
		public function get user():UserVo
		{
			return __user;
		}
		
		public function SystemSession( singleton:Singleton )
		{
			__session = new Object();
		}
		
		public static function get instance():SystemSession
		{ 
			if( !__instance )
				__instance = new SystemSession( new Singleton() );
			
			return __instance;
		}
		
		
		public function destroySession():void
		{
			__instance = null;
			__session = null;
		}
		
		public function set( name:String, val:Object ):void
		{
			__session[ name ] = val;
		}
		
		public function get( name:String ):Object
		{
			if( __session.hasOwnProperty( name ) )
			{
				return __session[ name ];
			}
			else
			{
				return null;
			}
		}
	}
}

class Singleton{}