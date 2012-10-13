package com.desktop.system.Application.Library.ui
{
	import com.desktop.system.events.NotificationResponseEvent;
	import com.desktop.system.interfaces.INotification;
	import com.desktop.system.vos.NotificationVo;
	import com.desktop.ui.Components.Window.DesktopAlert;
	import com.desktop.ui.Controls.Events.DesktopWindowEvent;
	
	import flash.events.Event;
	
	import mx.core.EventPriority;
	import mx.events.FlexEvent;
	
	import spark.components.Label;
	import spark.components.SkinnableContainer;
	import spark.primitives.BitmapImage;
	
	public class NotificationBase extends SkinnableContainer implements INotification
	{
		[SkinPart(required="true")]
		public var alertWindow:DesktopAlert;
	
		private var __data:NotificationVo;
		
		private var __shown:Boolean;
		
		public function NotificationBase()
		{
			super();
		}
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded( partName, instance );
			
			if( instance == alertWindow )
			{
				alertWindow.addEventListener( NotificationResponseEvent.NOTIFICATION_RESPONSE_EVENT, _alertNotificationResponseEvent );
				addEventListener( NotificationResponseEvent.NOTIFICATION_RESPONSE_EVENT, _notificationResponseEvent, false, EventPriority.DEFAULT_HANDLER );
				
				alertWindow.addEventListener( FlexEvent.CREATION_COMPLETE, _alertWindowCreationCompleteEventHandler, false, 0, true  );
				
			 	_fillNotification();
			}
		}
		
		public function get shown():Boolean
		{
			return __shown;
		}
		
		[Bindable("__NoChangeEvent__")]
		public function set data( d:NotificationVo ):void
		{
			__data = d;
			_fillNotification();
		}
		
		public function get data():NotificationVo
		{
			return __data;
		}
		
		public function show():Boolean
		{
			__shown = true;
			invalidateSkinState();
			
			return true;
		}
		
		public function close():Boolean
		{
			__shown = false;
			invalidateSkinState();
			data = null;
			
			return true;
		}
		
		protected function _alertNotificationResponseEvent( event:NotificationResponseEvent ):void
		{
			event.notificationVo = data;
			dispatchEvent( event );
		}
		
		protected function _notificationResponseEvent( event:NotificationResponseEvent ):void
		{
			if( event.isDefaultPrevented() == false )
			{
				close();
			}
			else
			{
				event.notificationVo = data;
			}
		}
		
		
		protected function _alertWindowCreationCompleteEventHandler( event:FlexEvent ):void
		{
			alertWindow.panelWindow.draggable = false;
		}
		
		protected function _fillNotification():void
		{
			if( alertWindow && data )
			{
				alertWindow.message = data.text;
				alertWindow.title = data.title;
				alertWindow.setStyle( "icon", data.icon );
				
				if( data.okButton )
				{
					alertWindow.buttonFlags = DesktopAlert.OK;
				}
				else if( data.yesNoButtons )
				{
					alertWindow.buttonFlags = DesktopAlert.YES | DesktopAlert.NO;
				}
				else if( data.okCancelButtons )
				{
					alertWindow.buttonFlags = DesktopAlert.OK | DesktopAlert.CANCEL;
				}
				
			}
		}
	}
}