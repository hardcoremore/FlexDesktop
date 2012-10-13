package com.desktop.system.managers
{
	import com.desktop.system.interfaces.IConfig;
	import com.desktop.system.interfaces.IConfigManager;
	
	public class ConfigManager implements IConfigManager
	{
		private static var __instance:ConfigManager;
		
		private var __configClass:IConfig;
		
		public function ConfigManager(singletonEnforcerer:SingletonEnforcerer)
		{
		}
		
		public function setConfigInstance( cClass:Object ):void
		{
			if( !__configClass )
			{
				__configClass = cClass.getInstance();
			}
			else
			{
				throw new Error("Config class is allready set. Currently this manager supports only one class at the time at ConfigManager()::setConfigInstance()" );
			}
		}
		
		public function getConfigInstance():IConfig
		{
			return __configClass as IConfig;
		}
		
		public static function getInstance():ConfigManager
		{
			if( __instance )
			{
				return __instance;
			}
			else
			{
				__instance = new ConfigManager(new SingletonEnforcerer());
				
				return __instance;
			}
		}
	}
}


class SingletonEnforcerer{}