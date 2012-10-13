package com.desktop.ui.Components.Window
{
	import com.greensock.TweenLite;
	import com.desktop.system.interfaces.INotification;
	import com.desktop.system.interfaces.IResourceHolder;
	import com.desktop.system.vos.NotificationVo;
	import com.desktop.ui.Interfaces.IDesktopWindowManager;
	import com.desktop.ui.Managers.WindowManager;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import mx.core.IVisualElementContainer;
	
	import spark.components.Group;
	import spark.components.TextArea;

	public class DesktopNotification extends DesktopWindow implements INotification
	{
		private var __detail:Object;
		private var __icon:Class;
		private var __data:NotificationVo;
		
		[SkinPart(required="true")]
		public var bodyText:TextArea;
		
		public function set data( d:NotificationVo ):void
		{
			if( __data != d )
			{
				__data = d;
				
				if( bodyText ) bodyText.text = data.text;
				if( titleIcon ) titleIcon.source = data.icon;
				
				setAutoClose( autoCloseTime );
			}
		}
		
		public function get data():NotificationVo
		{
			return __data;
		}
		
		
		private  var _manager:IDesktopWindowManager;
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			
			if( instance == bodyText && data ) bodyText.text = data.text;
			if( instance == titleIcon && data ) titleIcon.source = data.icon;
			
			if( instance == minimizeButton )
				minimizeButton.removeEventListener(MouseEvent.CLICK, _minimizeButtonClickHandler );
			
			if( instance == maximizeRestoreButton )
				maximizeRestoreButton.removeEventListener(MouseEvent.CLICK, _maximizeRestoreButtonClickHandler );
			
			
			if( instance == moveArea )
			{
				moveArea.removeEventListener( MouseEvent.DOUBLE_CLICK, _moveAreaMouseDoubleClick );
				moveArea.doubleClickEnabled = false;
			}
		}
		
		public function set detail(detail:Object):void
		{
			__detail = detail;
		}
		
		public function get detail():Object
		{
			return __detail;
		}
		
		public function set icon( icon:Class ):void{}
		
		public function get icon():Class
		{
			return null;
		}
		
		public function DesktopNotification(isChild:Boolean=false)
		{
			super(isChild);
			
			maximizable = false;
			minimizable = false;
			resizable = false;
			active = true;
			draggable = false;
			
			init();
		}
		
		override public function close():Boolean
		{
			__detail = null;
			
			unload();
			
			if( parent )
				( parent as IVisualElementContainer ).removeElement( this );
			
			return true;
		}
		
		override public function set active(value:Boolean):void
		{
			
		}
		
		override public function get active():Boolean
		{
			return true;
		}
		
		override public function toFront():void
		{
			
		}
		
		override protected function _mouseDownEventHandler(event:MouseEvent):void
		{
			if( event.target == closeButton ) return;
			TweenLite.killTweensOf( this );
			this.alpha = 1;
			setAutoClose( autoCloseTime );
		}
		
	}
}