package com.desktop.ui.Components
{
	import com.desktop.system.events.ModuleRequestEvent;
	import com.desktop.system.events.ResourceEvent;
	import com.desktop.system.events.SystemEvent;
	import com.desktop.system.interfaces.IConfig;
	import com.desktop.system.interfaces.ILoadResourceRequester;
	import com.desktop.system.interfaces.INotification;
	import com.desktop.system.interfaces.INotifier;
	import com.desktop.system.interfaces.IResourceHolder;
	import com.desktop.system.utility.ErrorCodes;
	import com.desktop.system.utility.ResourceTypes;
	import com.desktop.system.vos.LoadResourceRequestVo;
	import com.desktop.system.vos.NotificationVo;
	import com.desktop.ui.Components.Button.Icon;
	import com.desktop.ui.Components.Button.TaskBarButton;
	import com.desktop.ui.Components.NavBars.StartMenu;
	import com.desktop.ui.Components.NavBars.TaskBar;
	import com.desktop.ui.Components.Window.DesktopNotification;
	import com.desktop.ui.Components.Window.DesktopWindow;
	import com.desktop.ui.Controls.Events.DesktopWindowEvent;
	import com.desktop.ui.Controls.Events.NavBarItemClickEvent;
	import com.desktop.ui.Events.DesktopEvent;
	import com.desktop.ui.Interfaces.IDesktopComponent;
	import com.desktop.ui.Interfaces.IDesktopWindowManager;
	import com.desktop.ui.Managers.WindowManager;
	import com.desktop.ui.vos.ButtonVo;
	import com.desktop.ui.vos.ResourceHolderVo;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	
	import models.DesktopModel;
	
	import mx.controls.Label;
	import mx.core.IVisualElement;
	import mx.core.IVisualElementContainer;
	import mx.events.FlexEvent;
	import mx.events.ResizeEvent;
	import mx.graphics.SolidColor;
	import mx.resources.IResourceManager;
	
	import spark.components.Group;
	import spark.components.Image;
	import spark.components.ToggleButton;
	import spark.components.supportClasses.SkinnableComponent;
	import spark.primitives.Rect;
	
	/**
	 * Task bar position. Possible values are taskbar-top-position, taskbar-bottom-position, taskbar-right-position, taskbar-left-position
	 */
	[Style(name="taskBarPosition", inherit="yes", type="String", 
			enumeration="taskbar-top-position, taskbar-bottom-position, taskbar-right-position, taskbar-left-position")]
	
	/**
	 * Thickness of taskbar
	 */
	[Style(name="taskBarThickness", inherit="yes", type="Number" )]
	
	/**
	 * The type of the desktop background
	 */
	[Style(name="wallpaperType", inherit="yes", type="String", enumeration="color, image" )]
	
	
	/**
	 * Background image of the desktop
	 */
	[Style(name="wallpaperImageUrl", inherit="yes", type="String" )]
	
	
	/**
	 * Background color of the desktop
	 */
	[Style(name="wallpaperColor", inherit="yes", type="Number" )]
	
	
	
	public class DesktopComponent extends ComponentBase implements IDesktopComponent, INotifier, ILoadResourceRequester
	{
		
		[SkinPart(required='true')]
		public var desktopContentAll:Group;
		
		[SkinPart(required='true')]
		public var desktopBackground:Group;
		
		[SkinPart(required='true')]
		public var imageBackgroundWallpaper:Image;
		
		[SkinPart(required='true')]
		public var rectangleBackgroundWallpaper:Rect;
		
		[SkinPart(required='true')]
		public var solidColorBackgrondWallpaper:SolidColor;
		
		
		[SkinPart(required='true')]
		public var desktopItemsGroup:Group;
		
		[SkinPart(required='false')]
		public var notificationGroup:Group;
		
		[SkinPart(required='false')]
		public var taskBar:TaskBar;
		
		[SkinPart(required='false')]
		public var startMenu:StartMenu;
		
		public static const TASK_BAR_TOP_POSITION:String 	= "taskbar-top-position";
		public static const TASK_BAR_BOTTOM_POSITION:String = "taskbar-bottom-position";
		public static const TASK_BAR_RIGHT_POSITION:String 	= "taskbar-right-position";
		public static const TASK_BAR_LEFT_POSITION:String 	= "taskbar-left-position";
		
		public var startButtonIcon:Class;
		
		private var _desktopIcons:Vector.<Icon>;
		
		private var _iconsAdded:Boolean = false;
		
		private var _iconUrl:String;
		
		private var __initialized:Boolean;
		
		private var __iconIsDragging:Boolean = false;
		
		private var __draggingIcon:Icon;
		
		private var __config:IConfig;
			
		protected var _mainWindowManager:IDesktopWindowManager;
		
		protected var _notificationManager:IDesktopWindowManager;
		
/*****************************
 * 
 *  CONSTRUCTOR
 * 
 ****************************/
		
		public function DesktopComponent()
		{
			super();
		}
		
		
/*****************************
 * 
 *  Getters/Setters
 * 
 ****************************/
		
/*****************************
 * 
 *  Overriden Methods
 * 
 ****************************/
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			
			if( instance == desktopItemsGroup )
			{				
				desktopItemsGroup.addEventListener( MouseEvent.CLICK, desktopItemsGroupItemsClickHandler );
				desktopItemsGroup.addEventListener( Event.RESIZE, _desktopItemsGroupResizeHandler );
				
			}else if( instance == notificationGroup )
			{
				_notificationManager = new WindowManager();
			}
			else if( instance == taskBar )
			{
				taskBar.desktop = this;
				taskBar.addEventListener( NavBarItemClickEvent.ITEM_CLICK, onTaskBarItemClickHandler );
			}
			else if( instance == startMenu )
			{
				startMenu.addEventListener(NavBarItemClickEvent.ITEM_CLICK, onStartMenuItemClickHandler);
			}
			
		}
			
		override protected function partRemoved(partName:String, instance:Object):void
		{	
			if( instance == desktopItemsGroup )
			{
				desktopItemsGroup.removeEventListener( MouseEvent.CLICK, desktopItemsGroupItemsClickHandler);
				desktopItemsGroup.removeEventListener( Event.RESIZE, _desktopItemsGroupResizeHandler );
			}
			
			super.partRemoved(partName, instance);
		}
		
/****************************
 * 
 *  Public Methods
 * 
 ****************************/
		
		public function onMainResize(event:ResizeEvent):void
		{
			width = event.target.width;
			height = event.target.height;
		}
		
		override public function styleChanged(styleProp:String):void
		{
			super.styleChanged( styleProp );
			
			if( ! styleProp ) return;
		
			if( styleProp == "taskBarThickness" || styleProp == "taskBarPosition" )
			{
				if( styleProp == "taskBarPosition" )
				{
					var pos:String = getStyle( "taskBarPosition" );
					
					if( pos == DesktopComponent.TASK_BAR_LEFT_POSITION || pos == DesktopComponent.TASK_BAR_RIGHT_POSITION )
					{
						taskBar.setStyle( "orientation", TaskBar.VERTICAL_ORIENTATION );
					}
					else if( pos == DesktopComponent.TASK_BAR_BOTTOM_POSITION || pos == DesktopComponent.TASK_BAR_TOP_POSITION )
					{
						taskBar.setStyle( "orientation", TaskBar.HORIZONTAL_ORIENTATION );
					}
				}
			}
			else if( styleProp == "wallpaperType" || styleProp == "wallpaperImageUrl" || styleProp == "wallpaperColor" )
			{
				if( getStyle( "wallpaperType" ) == DesktopModel.DESKTOP_WALLPAPER_TYPE_COLOR )
				{
					rectangleBackgroundWallpaper.visible = true;
					imageBackgroundWallpaper.visible = false;
					
					solidColorBackgrondWallpaper.color = uint( getStyle( "wallpaperColor" ) );
				}
				else if( getStyle( "wallpaperType" ) == DesktopModel.DESKTOP_WALLPAPER_TYPE_IMAGE )
				{
					rectangleBackgroundWallpaper.visible = false;
					imageBackgroundWallpaper.visible = true;
					
					imageBackgroundWallpaper.source = getStyle( "wallpaperImageUrl" );
				}
			}
			
			skin.invalidateSize();
			skin.invalidateDisplayList();
		}
		
		public function addResourceHolder( wvo:ResourceHolderVo = null ):IResourceHolder
		{
			
//			@TODO use default wvo from config
			if( ! wvo ) return null;
			
			if( wvo.child && ! wvo.parent ) 
			{
				throw Error("Child window must have parent window at Desktop::addWindow()");
			}
			
			var w:DesktopWindow = new DesktopWindow( wvo.child );
				w.id = wvo.id;
				w.desktop = this;
					
				if( w.isChild && wvo.parent is DesktopWindow ) ( wvo.parent as DesktopWindow ).addChildWindow( w ); 
					
				
			_mainWindowManager.register( w );	
			
			w.x = wvo.x;
			w.y = wvo.x;
			
			if( wvo.width ) w.width = wvo.width; 
			if( wvo.height ) w.height = wvo.height;
			
			w.resizable = wvo.resizable;
			w.maximizable = wvo.maximizable;
			w.minimizable = wvo.minimizable;
			
			w.hideOnClose = wvo.hideOnClose;
			w.titleBarIcon = wvo.titleBarIcon;
			
			w.title = wvo.title;
			
			w.setStyle('skinClass', resourceManager.getClass( this.session.config.LOCALE_CONFIG.skinsResourceName, "desktopWindowComponent", this.session.skinsLocaleName ) );
			
			w.currentState = w.normalState.name;
			w.active = true;
			
			if( ! wvo.child && ! wvo.cObject )
			{				
				wvo.cObject = taskBar.createButtonBarButton( createButtonVoFromWindow( w ) ) ;
				taskBar.addButtonBarButton( w.controllComponent as TaskBarButton );
				
			}else if( wvo.cObject )
			{
				if( wvo.cObject is TaskBarButton )
				{
					( wvo.cObject as TaskBarButton ).window = w;
					w.controllComponent = wvo.cObject;
					taskBar.addButtonBarButton( wvo.cObject as TaskBarButton );
				}
			}
			
			w.addEventListener( DesktopWindowEvent.CLOSE, onWindowCloseEvent, false, 0, true );
			w.addEventListener( DesktopWindowEvent.HIDE, onWindowHide, false, 0, true  );
			w.addEventListener( DesktopWindowEvent.MINIMIZE, onWindowMinimize, false, 0, true  );
			w.addEventListener( DesktopWindowEvent.RESTORE, onWindowRestore, false, 0, true  );
			w.addEventListener( DesktopWindowEvent.SHOW, onWindowShow, false, 0, true  );
			w.addEventListener( FlexEvent.CREATION_COMPLETE, _windowCreationComplete, false, 0, true  );
			w.addEventListener( DesktopWindowEvent.TO_FRONT, onWindowToFront, false, 0, true  );
			
			desktopItemsGroup.addElement( w );
			
			if( wvo.maximizable && wvo.maximized ) 
			{
				w.maximize();
			}
			
			w.show();
			w.toFront();
				
			return w;
		}
		
		public function constrainResourceHolder( w:IResourceHolder ):void
		{
			if( ! w ) return;
			
			if( w.width > desktopItemsGroup.width )
			{
				w.width = desktopItemsGroup.width;
			}
			
			if( w.height > desktopItemsGroup.height )
			{
				w.height = desktopItemsGroup.height;
			}
			
		}
		
		public function centerResourceHolder( w:IResourceHolder ):void
		{
			if( ! w ) return;
			
			w.x = desktopItemsGroup.width /  2 - w.width / 2;
			w.y = desktopItemsGroup.height / 2 - w.height / 2;
			
		}
		
		public function initDesktop():void
		{
			if( __initialized == false )
			{
				_desktopIcons = new Vector.<Icon>();
				_mainWindowManager = new WindowManager();
				_notificationManager = new WindowManager();
				
				addEventListener( MouseEvent.MOUSE_UP, desktopMouseUp, false, 0, true );
				addEventListener( MouseEvent.ROLL_OUT, desktopRollOut, false, 0, true );
				addEventListener( MouseEvent.MOUSE_MOVE, desktopMouseMove, false, 0, true );
				
				addEventListener( FlexEvent.CREATION_COMPLETE, _creationCompleteEventHandler, false, 0, true );
				addEventListener( Event.ADDED_TO_STAGE, addedToStageHandler, false, 0, true );
				addEventListener( MouseEvent.CLICK, desktopMouseClick, false, 0, true );
				
				__initialized = true;
			}
		}
			
		public function addIcon( ivo:ButtonVo ):Icon
		{
			var i:Icon = new Icon();
				i.setStyle('skinClass', resourceManager.getClass( this.session.config.LOCALE_CONFIG.skinsResourceName, "desktopIcon", this.session.skinsLocaleName ) );
				i.setStyle( 'iconSize', getStyle( 'iconSize' ) );
				
				i.init( ivo );
				i.mouseEnabled = true;
				i.doubleClickEnabled = true;
				
				i.addEventListener( MouseEvent.DOUBLE_CLICK, iconDoubleClick, false, 0, true ); 
				i.addEventListener( MouseEvent.MOUSE_DOWN, iconMouseDown, false, 0, true );
				
			_desktopIcons.push( i );
			
			
			if( __initialized )
			{
				desktopItemsGroup.addElement( i );
			}
			
			return i;
		}
		
		public function notify( nvo:NotificationVo ):INotification
		{
			if( ! nvo ) return null;
			
			var n:DesktopNotification = _getNotificationFromId( nvo.id ); 
			
			if( ! n )
			{
				n = new DesktopNotification();
				_notificationManager.register( n );
				
				n.id = nvo.id;
				n.setStyle( "skinClass", resourceManager.getClass( this.session.config.LOCALE_CONFIG.skinsResourceName, "desktopNotification", this.session.skinsLocaleName ) );
				
				n.width = notificationGroup.width;
				n.currentState = 'normal';
				n.setStyle('borderThickness', 8 );
				n.setStyle('cornerRadius', 0)
				n.setStyle('borderAlpha', 1);
				notificationGroup.addElement( n );
			}
			
			if( nvo.autoCloseTime > 0 )
			{
				n.setAutoClose( nvo.autoCloseTime );
			}
			
			n.data = nvo;
			
			return n;
		}
		
		public function updateResourceLoadStatus( resource:LoadResourceRequestVo ):void
		{			
			
		}
		
		
		public function createButtonVoFromWindow( w:DesktopWindow ):ButtonVo
		{
			if( ! w ) return null;
			
			var bvo:ButtonVo = new ButtonVo(0, 0, w.title );
				bvo.icon = w.titleBarIcon;
				bvo.id = w.id;
				bvo.controllComponent = w;
				w.controllComponent = taskBar.createButtonBarButton( bvo );
			return bvo;
		}
		

/****************************
* 
*  PROTECTED METHODS
* 
**************************/

		protected function _getNotificationFromId( id:String ):DesktopNotification
		{
			if( ! id || id.length < 1 ) return null;
			
			for each( var n:DesktopWindow in _notificationManager.getWindows() )
			{
				if( n.id == id )
					return n as DesktopNotification;
			}
			
			return null;
		}
	
		
		protected function _getWindowFromResource( r:Object ):DesktopWindow
		{
			if( ! r ) return null;
			
			var e:*;
			
			for each( var n:DesktopWindow in _mainWindowManager.getWindows() )
			{
				e = n.getElementAt( 0 );
				
				if( e == r )
					return n;
			}
			
			return null;
		}
/*---------- END OF PROTECTED METHODS ----------------- */		
		
		
/**************************************
 *
 *  Desktop Events
 *
 **************************************/

		protected function _creationCompleteEventHandler( event:FlexEvent ):void
		{
			if( __initialized )
			{
				dispatchEvent( new DesktopEvent( DesktopEvent.DESKTOP_INITIALISED ) );
			}
		}
		
		protected function _desktopItemsGroupResizeHandler( event:Event ):void
		{
			
			if( _mainWindowManager )
			{
				for each( var w:DesktopWindow in _mainWindowManager.getWindows() )
				{
					if( w.currentState == w.maximizedState.name || ( w.currentState == w.minimizedState.name && w.previousState == w.maximizedState.name ) )
					{
						w.width = event.target.width;
						w.height = event.target.height;
						
					}
					else if( w.currentState == w.normalState.name && ! w.resizable )
					{
						if( w.width > event.target.width ) w.width = event.target.width;
						if( w.height > event.target.height ) w.height = event.target.height;
					}
					
					if( w.x > event.target.width )
						w.x = event.target.width - 150;
					
				}
			}
			
			for each( var i:Icon in _desktopIcons )
			{
				if( i.x + i.width > event.target.width )
				{
					i.x = event.target.width - i.measuredWidth;
				}
			}
			
		}
		
		private function desktopMouseClick(event:MouseEvent):void
		{	
			if( event.target != taskBar.startMenuButton )
			{
				startMenu.visible = false;
			}
		}
		
		private function desktopMouseUp(event:MouseEvent):void
		{
			if( __draggingIcon )
			{
				__iconIsDragging = false;
				__draggingIcon.stopDrag();
				__draggingIcon = null;
			}
		}
		
		private function desktopRollOut(event:MouseEvent):void
		{
			if( __draggingIcon )
			{
				__iconIsDragging = false;
				__draggingIcon.stopDrag();
				__draggingIcon = null;
			}
		}
		
		private function desktopItemsGroupItemsClickHandler(event:MouseEvent):void
		{
			
		}
		
		private function iconMouseDown(event:MouseEvent):void
		{
			__iconIsDragging = true;
			__draggingIcon = event.currentTarget as Icon;
			
			var icon:Icon;
			var index:uint;
			var dindex:uint = desktopItemsGroup.getElementIndex( __draggingIcon );
			
			for( var i:uint = 0; i < desktopItemsGroup.numElements; i++ )
			{	
				icon = desktopItemsGroup.getElementAt( i ) as Icon;
				
				if( icon )
				{
					index = desktopItemsGroup.getElementIndex( icon );
					
					if( dindex < index   )
					{
						dindex = index;
					}
				}
			}
			
			desktopItemsGroup.setElementIndex( __draggingIcon, dindex );
		
		}
		
		private function addedToStageHandler(event:Event):void
		{
			width = root.width;
			height = root.height;
		}
		
		private function desktopMouseMove(event:MouseEvent):void
		{
			if( __iconIsDragging && __draggingIcon )
			{
				if( __draggingIcon.y + __draggingIcon.height  > desktopItemsGroup.height )
				{
					__draggingIcon.stopDrag();
					__draggingIcon.y = desktopItemsGroup.height - __draggingIcon.height;
				}
				else if( __draggingIcon.x + __draggingIcon.width  > desktopItemsGroup.width )
				{
					__draggingIcon.stopDrag();
					__draggingIcon.x = desktopItemsGroup.width - __draggingIcon.width;
					
				}
				else if( __draggingIcon.y < 0 )
				{
					__draggingIcon.stopDrag();
					__draggingIcon.y = 0;
				}
				else if( __draggingIcon.x < 0 )
				{
					__draggingIcon.stopDrag();
					__draggingIcon.x = 0;
				}else{
					__draggingIcon.startDrag();
				}
			
			}
		}
											
		private function iconDoubleClick (event:MouseEvent):void
		{
			var i:Icon = event.currentTarget as Icon;
			
			if( i )
			{
				var exists:Boolean = false;
				
				if( i.resourceInfo.resource )
				{
					// check to see if there is window that holds same resource
					for each( var w:DesktopWindow in _mainWindowManager.getWindows() )
					{
						if( w.numElements > 0 )
						{
							if( w.getElementAt( 0 ) == i.resourceInfo.resource )
							{
								exists = true;
								w.toFront();
								break;
							}
						}
					}

				}	
				
				if( ! exists )
				{
					i.resourceInfo.requester = this;
					i.resourceInfo.notifier = this;
					i.resourceInfo.createResourceHolderAutomatically = true;
					
					var e:ResourceEvent = new ResourceEvent(ResourceEvent.RESOURCE_LOAD_REQUEST );
						e.resourceInfo = i.resourceInfo;
					dispatchEvent( e );
				}
					
			}
		}
				
		
/**************************************
 *
 *  NavBars Events
 *
 **************************************/
		
		private function onTaskBarItemClickHandler(event:NavBarItemClickEvent):void
		{
			
			switch( event.itemType )
			{
				case TaskBar.START_MENU_BUTTON:
				
					if( startMenu.visible )
					{
						startMenu.visible = false;
					}
					else
					{
						startMenu.visible = true;
						desktopItemsGroup.setElementIndex( startMenu, desktopItemsGroup.numElements - 1 );
					}
					
				break;
				case TaskBar.BUTTON_BAR_ITEM:
					
					var b:TaskBarButton = event.item as TaskBarButton;
					var w:DesktopWindow = b.window;
					
					if( w.currentState == w.normalState.name || w.currentState  == w.maximizedState.name )
					{
						if( taskBar.buttonBar.selectedItemButton == null )
						{
							w.minimize();
						}
						else
						{
							w.toFront();	
						}
					}
					else
					{
						w.toFront();
					}
					
				break;
				
				case TaskBar.MINIMIZE_ALL_WINDOWS_BUTTON:
					
					_mainWindowManager.minimizeAll();
					
				break;
			}
			
			
		}
		
		private function onStartMenuItemClickHandler(event:NavBarItemClickEvent):void
		{
			if( event.item == startMenu.configButton )
			{
				dispatchEvent( new SystemEvent( SystemEvent.SHOW_CONFIG ) );
			}
			else if( event.item == startMenu.fullScreenButton )
			{
				if( stage.allowsFullScreen )
				{
					if( stage.displayState == StageDisplayState.FULL_SCREEN_INTERACTIVE )
					{
						stage.displayState = StageDisplayState.NORMAL;
					}
					else
					{
						stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
					}
				}
			}
		}
		


/**************************************
*
*  Window Events
*
**************************************/
		
		private function onWindowCloseEvent( event:DesktopWindowEvent ):void
		{	
			event.desktopWindow.removeEventListener( DesktopWindowEvent.CLOSE, onWindowCloseEvent );
			event.desktopWindow.removeEventListener( DesktopWindowEvent.HIDE, onWindowHide );
			event.desktopWindow.removeEventListener( DesktopWindowEvent.MINIMIZE, onWindowMinimize );
			event.desktopWindow.removeEventListener( DesktopWindowEvent.RESTORE, onWindowRestore );
			event.desktopWindow.removeEventListener( DesktopWindowEvent.SHOW, onWindowShow );
			event.desktopWindow.removeEventListener( DesktopWindowEvent.TO_FRONT, onWindowToFront );
			
			if( event.desktopWindow.controllComponent )
			{
				taskBar.removeButtonBarButton(  event.desktopWindow.controllComponent as TaskBarButton );
			}
			
			_mainWindowManager.unregister( event.desktopWindow );
			desktopItemsGroup.removeElement( event.desktopWindow );
			
			var e:ResourceEvent = new ResourceEvent( ResourceEvent.RESOURCE_REQUEST_UNLOAD );
				e.resourceInfo = event.desktopWindow.resourceInfo;
				
				dispatchEvent( e );			
		}
		
		private function onWindowHide(event:DesktopWindowEvent):void
		{
			if( event.desktopWindow.controllComponent && event.desktopWindow.controllComponent is TaskBarButton )
			{
				taskBar.removeButtonBarButton( event.desktopWindow.controllComponent as TaskBarButton );
			}
		}
		
		private function onWindowMinimize(event:DesktopWindowEvent):void
		{
			taskBar.buttonBar.setInactiveButton( event.desktopWindow.controllComponent as TaskBarButton );
		}
		
		private function onWindowToFront(event:DesktopWindowEvent):void
		{
			taskBar.buttonBar.setActiveButton( event.desktopWindow.controllComponent as TaskBarButton );
		}
		
		private function onWindowRestore(event:DesktopWindowEvent):void
		{
		}
		
		private function onWindowShow(event:DesktopWindowEvent):void
		{
			
			if( event.desktopWindow.isChild )return;
			
			var tbb:TaskBarButton = taskBar.createButtonBarButton( createButtonVoFromWindow( event.desktopWindow ) );
			event.desktopWindow.controllComponent = tbb;
			tbb.window = event.desktopWindow;
			taskBar.addButtonBarButton( tbb );
		}

		protected function _windowCreationComplete( event:FlexEvent ):void
		{
			event.target.removeEventListener( FlexEvent.CREATION_COMPLETE, _windowCreationComplete );
			
			var w:DesktopWindow = event.target as DesktopWindow;
				
			constrainResourceHolder( w );
			
			if( w.currentState != w.maximizedState.name ) 
				centerResourceHolder( w );
		}
		
				
	}
}