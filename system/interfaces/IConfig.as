package com.desktop.system.interfaces
{
	import com.desktop.ui.vos.DesktopConfigVo;
	import com.desktop.ui.vos.ResourceHolderVo;
	
	import com.desktop.system.vos.ApplicationConfigVo;
	import com.desktop.system.vos.LocaleConfigVo;
	import com.desktop.system.vos.ResourceConfigVo;

	public interface IConfig
	{
		 function get APPLICATION_CONFIG():ApplicationConfigVo;
		 function get DESKTOP_CONFIG():DesktopConfigVo;
		 function get RESOURCE_CONFIG():ResourceConfigVo;
		 function get LOCALE_CONFIG():LocaleConfigVo;
	}
}