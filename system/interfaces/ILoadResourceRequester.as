package com.desktop.system.interfaces
{
	import com.desktop.system.vos.LoadResourceRequestVo;
	import com.desktop.system.vos.ResourceLoadStatusVo;

	public interface ILoadResourceRequester
	{
		function updateResourceLoadStatus( resource:LoadResourceRequestVo ):void;
	}
}