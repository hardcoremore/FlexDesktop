package com.desktop.system.interfaces
{
	import com.desktop.system.vos.LoadResourceRequestVo;

	public interface IResourceRequestHolder
	{
		function set resourceInfo( resourceRequest:LoadResourceRequestVo ):void;
		function get resourceInfo():LoadResourceRequestVo;
	}
}