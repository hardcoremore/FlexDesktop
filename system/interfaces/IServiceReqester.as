package com.desktop.system.interfaces
{
	import com.desktop.system.events.ModelDataChangeEvent;

	public interface IServiceReqester
	{
		function modelLoadingData( event:ModelDataChangeEvent ):void;
		function modelLoadingDataComplete( event:ModelDataChangeEvent ):void;
		function modelLoadingDataError( event:ModelDataChangeEvent ):void;
	}
}