package com.desktop.system.Application.Library.ui
{

	import com.desktop.system.core.SystemSession;
	import com.desktop.system.interfaces.IConfig;
	import com.desktop.system.vos.LocaleConfigVo;
	
	import flash.filters.GlowFilter;
	
	import spark.components.supportClasses.Skin;

	
	public class SkinBase extends Skin
	{		
		public static const GRID_GLOW_FILTER:GlowFilter = new GlowFilter(0xCCCCCC, 1, 6, 6, 2, 2);
		
		public function SkinBase()
		{
			super();
			_init();
		}
		
		[Bindable("__NoChangeEvent__")]
		public function get session():SystemSession
		{
			return SystemSession.instance;
		}
		
		protected function _init():void
		{
			
		}
		
	}
}