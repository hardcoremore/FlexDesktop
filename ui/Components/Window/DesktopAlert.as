package com.desktop.ui.Components.Window
{
	import com.desktop.system.core.SystemSession;
	import com.desktop.system.events.NotificationResponseEvent;
	import com.desktop.system.vos.NotificationResponseVo;
	import com.desktop.ui.Components.ComponentBase;
	import com.desktop.ui.Controls.Events.DesktopWindowEvent;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import mx.core.EventPriority;
	import mx.core.IFlexDisplayObject;
	import mx.managers.PopUpManager;
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;
	
	import skins.Default.components.Window.DesktopAlertSkin;
	
	import spark.components.Button;
	import spark.components.Group;
	import spark.components.Label;
	import spark.components.TextInput;

	[Style(name="iconSize", type="Number", inherit="no", theme="spark")]
	[Style(name="icon", type="Class", inherit="no", theme="spark")]
	
	public class DesktopAlert extends ComponentBase
	{	
		private static var _resourceManager:IResourceManager = ResourceManager.getInstance();
		
		[Bindable]
		public var title:String;
		
		[Bindable]
		public var message:String;
		
		[SkinPart(required="true")]
		public var panelWindow:DesktopWindow;
		
		[SkinPart(required="true")]
		public var messageLabel:Label;
				
		[SkinPart(required="false")]
		public var textInput:TextInput;
		
		[SkinPart(required="true")]
		public var buttonGroup:Group;
		
		public static const YES:uint = 0x0001;
		public static const NO:uint = 0x0002;
		public static const OK:uint = 0x0004;
		public static const CANCEL:uint= 0x0008;
	
		
		private var __buttonFlags:uint;
		
		public static const TYPE_WARNING:uint 				= 1;
		public static const TYPE_CRITICAL_WARNING:uint 		= 2;
		public static const TYPE_ERROR:uint 				= 3;
		public static const TYPE_SUCCESS:uint 				= 4;
		public static const TYPE_INFO:uint 					= 5;
		public static const TYPE_QUESTION:uint 				= 6;
		
		
		
		public function DesktopAlert()
		{
			super();
			
			//setStyle( "skinClass", resourceManager.getClass( this.session.config.LOCALE_CONFIG.skinsResourceName, 'desktopAlertComponent', this.session.skinsLocaleName ) );
			setStyle( "skinClass", DesktopAlertSkin );
			setStyle( "iconSize", 64 );
			
			addEventListener( NotificationResponseEvent.NOTIFICATION_RESPONSE_EVENT, _notificationResponseEvent, false, EventPriority.BINDING );
			
		}
		
		public function set buttonFlags( flags:uint ):void
		{
			__buttonFlags = flags;
			_createButtons();
		}
		
		public function get buttonFlags():uint
		{
			return __buttonFlags;
		}
		
		protected function _createButtons():void
		{
			var button:Button;
			if( buttonGroup )
			{
				for( var i:uint = 0; i < buttonGroup.numElements; i++ )
				{
					button = buttonGroup.getElementAt( i ) as Button;
					button.removeEventListener( MouseEvent.CLICK, _buttonMouseClickHandler );
				}
				
				buttonGroup.removeAllElements();
				 
				if( buttonFlags != 0 )
				{
					if( buttonFlags & DesktopAlert.OK )
					{
						button = new Button();
						button.name = DesktopAlert.OK.toString();
						button.label = _resourceManager.getString( this.session.config.LOCALE_CONFIG.dictonaryResourceName, 'ok' )
						button.addEventListener( MouseEvent.CLICK, _buttonMouseClickHandler );
						buttonGroup.addElement( button );
						
					}
					
					if( buttonFlags & DesktopAlert.CANCEL )
					{
						button = new Button();
						button.name = DesktopAlert.CANCEL.toString();
						button.label = _resourceManager.getString( this.session.config.LOCALE_CONFIG.dictonaryResourceName, 'cancel' )
						button.addEventListener( MouseEvent.CLICK, _buttonMouseClickHandler );
						buttonGroup.addElement( button );
					}
					
					if( buttonFlags & DesktopAlert.YES )
					{
						
						button = new Button();
						button.name = DesktopAlert.YES.toString();
						button.label = _resourceManager.getString( this.session.config.LOCALE_CONFIG.dictonaryResourceName, 'yes' )
						button.addEventListener( MouseEvent.CLICK, _buttonMouseClickHandler );
						buttonGroup.addElement( button );
					}
					
					if( buttonFlags & DesktopAlert.NO )
					{
						button = new Button();
						button.name = DesktopAlert.NO.toString();
						button.label = _resourceManager.getString( this.session.config.LOCALE_CONFIG.dictonaryResourceName, 'no' )
						button.addEventListener( MouseEvent.CLICK, _buttonMouseClickHandler );
						buttonGroup.addElement( button );
					}
				}
			}
		}
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			if( instance == panelWindow )
			{
				panelWindow.addEventListener( DesktopWindowEvent.CLOSE, _windowCloseEventHandler );
				panelWindow.title = title;
				panelWindow.titleBarIcon = getStyle( "icon" );
				panelWindow.closeButton.visible = false;
			}
			else if( instance == messageLabel )
			{
				messageLabel.text = message;
			}
			else if( instance == buttonGroup )
			{
				_createButtons();
			}
		}
		
	    public static function show( type:uint, parent:DisplayObject, modal:Boolean = false, message:String = "", title:String = ""  ):void
    	{
			var session:SystemSession = SystemSession.instance;
			
			var da:DesktopAlert = new DesktopAlert( );
				da.message = message;
		
			var auto_title:String;
			
            switch(type)
            {
            	case TYPE_WARNING:
					auto_title = _resourceManager.getString( session.config.LOCALE_CONFIG.dictonaryResourceName, 'warning' );
					 da.setStyle( "icon", _resourceManager.getClass( 'systemIconClasses', 'warningIcon', session.skinsLocaleName ) );
					 
            	break;
            	
            	case TYPE_CRITICAL_WARNING:
					auto_title = _resourceManager.getString( session.config.LOCALE_CONFIG.dictonaryResourceName, 'criticalWarning' );
					 da.setStyle( "icon", _resourceManager.getClass( 'systemIconClasses', 'criticalWarningIcon', session.skinsLocaleName ) );
            	break;
            	
            	case TYPE_ERROR:
					auto_title = _resourceManager.getString( session.config.LOCALE_CONFIG.dictonaryResourceName, 'errorOccurred' );
					  da.setStyle( "icon",_resourceManager.getClass( 'systemIconClasses', 'deleteErrorIcon', session.skinsLocaleName ) );
            	break;
            	
            	case TYPE_SUCCESS:
					auto_title = _resourceManager.getString( session.config.LOCALE_CONFIG.dictonaryResourceName, 'success' );
					  da.setStyle( "icon", _resourceManager.getClass( 'systemIconClasses', 'successIcon', session.skinsLocaleName ) );
            	break;
            	
            	case TYPE_INFO:
					auto_title =_resourceManager.getString( session.config.LOCALE_CONFIG.dictonaryResourceName, 'info' );
					  da.setStyle( "icon", _resourceManager.getClass( 'systemIconClasses', 'infoIcon', session.skinsLocaleName ) );
            	break;
            	case TYPE_QUESTION:
					auto_title = _resourceManager.getString( session.config.LOCALE_CONFIG.dictonaryResourceName, 'question' );
					da.setStyle( "icon", _resourceManager.getClass( 'systemIconClasses', 'questionMarkIcon', session.skinsLocaleName ) );
            	break;
            }   
			
			
			if( title == "" )
				da.title = auto_title;
			
			PopUpManager.addPopUp( da as IFlexDisplayObject, parent, modal );
			PopUpManager.centerPopUp( da as IFlexDisplayObject );

    	}	
		
		protected function _notificationResponseEvent( event:NotificationResponseEvent ):void
		{
			if( event.isDefaultPrevented() == false )
			{
				panelWindow.close();
			}
		}
		
		protected function _buttonMouseClickHandler( event:MouseEvent ):void
		{
			var evo:NotificationResponseVo = new NotificationResponseVo();
				evo.buttonPressed = event.currentTarget.name;
				
			if( textInput )
				evo.inputData = textInput.text;
			
			var e:NotificationResponseEvent = new NotificationResponseEvent( NotificationResponseEvent.NOTIFICATION_RESPONSE_EVENT, false, true );
				e.response = evo;
				
			dispatchEvent( e );
		} 
		
		protected function _windowCloseEventHandler( event:DesktopWindowEvent ):void
		{
			PopUpManager.removePopUp( this as IFlexDisplayObject );
		}
	}
}