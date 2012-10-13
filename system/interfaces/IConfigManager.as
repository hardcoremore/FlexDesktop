package com.desktop.system.interfaces
{
	public interface IConfigManager
	{
		function setConfigInstance(cClass:Object):void;
		function getConfigInstance():IConfig;
	}
}