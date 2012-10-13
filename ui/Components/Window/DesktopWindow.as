package com.desktop.ui.Components.Window
{
	
	import com.desktop.system.core.SystemSession;
	import com.desktop.system.interfaces.IResourceHolder;
	import com.desktop.system.vos.LoadResourceRequestVo;
	import com.desktop.ui.Controls.Events.DesktopWindowEvent;
	import com.desktop.ui.Interfaces.IDesktopComponent;
	import com.greensock.TweenLite;
	import com.greensock.easing.Expo;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	import mx.controls.Image;
	import mx.core.IVisualElement;
	import mx.core.UIComponent;
	import mx.events.ResizeEvent;
	import mx.managers.CursorManagerPriority;
	import mx.managers.IFocusManagerComponent;
	import mx.states.State;
	
	import spark.components.Button;
	import spark.components.Group;
	import spark.components.Panel;
	import spark.components.supportClasses.SkinnableComponent;
	import spark.primitives.BitmapImage;
	import spark.primitives.Rect;
	
	/***********************
	 * 
	 * 		Styles
	 * 
	 * ********************/
	
	/**
	 *  The thickness of the title bar for this component.
	 *
	 *  @default 0.5
	 * 
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Flex 4
	 ***************************************/
	[Style(name="titleBarThickness", type="Number", inherit="no", theme="spark")]
	
	[Style(name="backgroundColor", type="Number", inherit="no", theme="spark")]
	
	[Style(name="backgroundAlpha", type="Number", inherit="no", theme="spark")]
	
	///////////// End of Styles ///////////////////////
	
	
	/***********************
	 * 
	 * 		Skin States
	 * 
	 * ********************/
	
	/**
	 *  Minimized State of the DesktopWindow
	 */
	[SkinState("minimized")]
	
	/**
	 *  Maximized State of the DesktopWindow
	 */
	[SkinState("maximized")]
	
	/**
	 *  MaximizedInactive State of the DesktopWindow
	 */
	[SkinState("maximizedInactive")]
	
	/**
	 *  Normal State of the DesktopWindow
	 */
	[SkinState("normal")]
	
	/**
	 *  NormalInactive State of the DesktopWindow
	 */
	[SkinState("normalInactive")]
	
	
	///////////// End of Skin States ////////////////
	
	
	/***********************
	 * 
	 * 		Events
	 * 
	 * ********************/
	
	/**
	 *  Dispatched when the user clicks the maximize button or maximize() method is called
	 */
	[Event(name="maximize", type="Desktop.Events.DesktopWindowEvent")]
	
	/**
	 *  Dispatched when the user clicks the minimize button or minimize() method is called.
	 */
	[Event(name="minimize", type="Desktop.Events.DesktopWindowEvent")]
	
	/**
	 *  Dispatched when the user restores the window
	 */
	[Event(name="restore", type="Desktop.Events.DesktopWindowEvent")]
	
	/**
	 *  Dispatched when the user click on the window or on the task bar button
	 */
	[Event(name="toFront", type="Desktop.Events.DesktopWindowEvent")]
	
	/**
	 *  Dispatched when the user shows the window
	 */
	[Event(name="show", type="Desktop.Events.DesktopWindowEvent")]
	
	/**
	 *  Dispatched when the user hides the window
	 */
	[Event(name="hide", type="Desktop.Events.DesktopWindowEvent")]
	
	/**
	 *  Dispatched when the user close the window
	 */
	[Event(name="close", type="Desktop.Events.DesktopWindowEvent")]
	
	///////////// End of Events ////////////////
	
	
	
	/////////////////////////////////////////////////
	//	
	//	
	// @ClassName: DesktopWindow
	//	
	// @Description: This class extends spark Panel 
	//				 and add functionality like 
	//				 maximize, minimize, close, resize, and dragging.
	// 
	//
	////////////////////////////////////////////////
	
	public class DesktopWindow extends Panel implements IResourceHolder
	{
		
		
/***************************
 * 
 * CONSTRUCTOR
 * 
 ***************************/

		public function DesktopWindow( isChild:Boolean = false )
		{
			super();
			_isChild = isChild;
			init();
			
			addEventListener( Event.ADDED_TO_STAGE, _addedToStage );
		}
		
/*----------------				END OF CONSTRUCTOR 					-------------------------*/
		
		
		private var session:SystemSession = SystemSession.instance;
		
/******************************
 * 
 * PROPERTIES
 * 
 *****************************/
		
		/*************** Skin Properties ********************/
		
		/**
		 *  @public
		 */
		[SkinPart(required="false")]
		public var minimizeButton:spark.components.Button;
		
		/**
		 *  @public
		 */
		[SkinPart(required="false")]
		public var maximizeRestoreButton:spark.components.Button;
		
		/**
		 *  @public
		 */
		[SkinPart(required="false")]
		public var closeButton:spark.components.Button;
		
		/**
		 *  @public
		 */
		[SkinPart(required="false")]
		public var minimizeChildWindowsButton:spark.components.Button;
		
		/**
		 *  @public
		 */
		[SkinPart(required="false")]
		public var moveArea:Group;
		
		/**
		 *  @public
		 */
		[SkinPart(required="true")]
		public var allContentGroup:Group;
		
		/**
		 *  @public
		 */
		[SkinPart(required="false")]
		public var titleIcon:BitmapImage;
		
		////////////// End of Skin Properties //////////////////
		
		private var __resourceInfo:LoadResourceRequestVo;
		
		
		
		/* ----------- Private Properties -----------*/
		/** 
		 *  @description: Image for vertical resize cursor.
		 *  
		 * 	@private
		 */
		
		public var __verticalResizeCursor:Class;
		
		/** 
		 *  @description: Image for horizontal resize cursor.
		 *  
		 * 	@private
		 */
		
		public var __horizontalResizeCursor:Class;
		
		/** 
		 *  @description: Image for left diagonal resize cursor.
		 *  
		 * 	@public
		 */
		
		public var __leftDiagonalCursor:Class;
		
		/** 
		 *  @description: Image for right diagonal resize cursor.
		 * 
		 *  @public
		 */
		
		private var __rightDiagonalCursor:Class;
		
		/**
		 * @description: Is this window child of another window
		 * 
		 *  @private
		 */
		private var __isChild:Boolean;
		
		/**
		 * @description: Is this window selected window
		 * 
		 *  @private
		 */
		private var __active:Boolean;
		
		/**
		 * 
		 * @description: Whether this window is minimizable
		 * 
		 * @private
		 */
		private var __minimizable:Boolean = false;
		
		/**
		 *  @description: Whether this window is maximizable
		 * 
		 *  @private
		 */
		private var __maximizable:Boolean = false;
		
		
		/**
		 *  @description: holds reference to which desktop it belongs
		 *  @private
		 */
		private var __desktopComponent:IDesktopComponent;
		
		/**
		 *  @description: This function is called before closing the window. 
		 *  If return type === true window is close otherwise closing is cancelled.
		 * 
		 *  @private
		 */
		private var __beforeCloseFunction:Function;
		
/**********************
 * 
 * STATE PROPERTIES
 * 
 *********************/
		
		/**
		 *  @private
		 */
		private var __normalState:State;
		
		/**
		 *  @private
		 */
		private var __minimizedState:State;
		
		/**
		 *  @private
		 */
		private var __maximizedState:State;
		
		/**
		 *  @private
		 */
		private var __hiddenState:State;
		
		/**
		 *  @private
		 */
		private var __previousState:String;
		
/*-------------        		END OF STATES 			--------------*/
		
		
		
		/**
		 *  @private
		 */
		
		private var __previousX:int;
		
		/**
		 *  @private
		 */

		private var __previousY:int;
		
		/**
		 *  @private
		 */
		
		private var __previousWidth:int;
		
		/**
		 *  @private
		 */
		
		private var __previousHeight:int;
		
		/**
		 *  @private
		 */
		
		private var __handleEdge:uint = 0;
		
		/**
		 *  @private
		 */
		
		private var __isDragging:Boolean = false;
		
		/**
		 *  @private
		 */
		
		private var __isHandleDragging:Boolean = false;
		
		/**
		 *  @private
		 */
		
		private var __resizeAffordance:uint;
		
		/**
		 *  @private
		 */
		
		private var __topResizeAffordance:uint = 3;
		
		/**
		 *  @private
		 */
		
		private var __resizable:Boolean = true;
		
		/**
		 *  @private
		 */
		
		private var __draggable:Boolean = true;
		
		/**
		 *  @private
		 */
		
		private var __cursorId:int = 0;
		
		/**
		 *  @private
		 */
		private var __lastEdge:int = 0;
		
		/**
		 *  @private
		 */
		private var __childWindows:Vector.<DesktopWindow>;
		
		/**
		 *  @private
		 */
		private var __:IVisualElement;
		
		/**
		 *  @private
		 */
		private var __titleIcon:Class; 
		
		/**
		 *  @private
		 */
		private var __downX:uint;
		
		/**
		 *  @private
		 */
		private var __downY:uint; 
		
		/**
		 *  @private
		 */
		private var __hideOnClose:Boolean
		
		/**
		 *  @private
		 */
		private var __userHidden:Boolean = false;
		
		/**
		 *  @private
		 */
		private var __controllComponent:IVisualElement;
		
		/**
		 *  @private
		 */
		private var __autoCloseTimer:Timer;
		
		/**
		 *  @private
		 */
		private var __autoCloseTime:Number;
		
		/* ============== End of  Private Properties ===============*/
		
		
		
		
/*-----------------				END OF Properties				--------------------*/ 	
		
/*****************************
 * 
 * CONSTANTS
 * 
 *****************************/
		
		// Constants for window edges                                                                                                                  
		static private var EDGE_NONE : Number = 0;
		
		static private var EDGE_BOTTOM : uint = 1;
		static private var EDGE_RIGHT : uint = 2;
		static private var EDGE_LEFT : uint = 3;
		static private var EDGE_TOP : uint = 4;
		
		static private var EDGE_RIGHT_BOTTOM : uint = 5;
		static private var EDGE_LEFT_BOTTOM : uint = 6;
		static private var EDGE_LEFT_TOP : uint = 7;
		static private var EDGE_RIGHT_TOP : uint = 8;
		
/*------------------				END OF CONSTANTS					-----------------*/
		
/************************************************************************************************************************************
 * 
 * 						GETTERS AND SETTERS
 * 
 ************************************************************************************************************************************/
		public function set desktop( desktop:IDesktopComponent ):void
		{
			__desktopComponent = desktop;
		}
		
		public function get desktop():IDesktopComponent
		{
			return __desktopComponent;
		}
		
		public function get childWindows():Vector.<DesktopWindow>
		{
			return __childWindows;
		}
		
		public function get resourceInfo():LoadResourceRequestVo
		{
			return __resourceInfo;
		}
		
		public function set resourceInfo( resource:LoadResourceRequestVo ):void
		{
			__resourceInfo = resource;	
		}
		
		public function get userHidden():Boolean
		{
			return __userHidden;
		}
		
		public function set userHidden( h:Boolean ):void
		{
			__userHidden = h;
		}
		
		public function set hideOnClose(value:Boolean):void
		{
			__hideOnClose = value;
		}
		
		public function get hideOnClose():Boolean
		{
			return __hideOnClose;
		}
		
		public function set minimizable(value:Boolean):void
		{
			__minimizable = value;
		}
		
		public function get minimizable():Boolean
		{
			return __minimizable;
		}
		
		public function set maximizable(value:Boolean):void
		{
			__maximizable = value;
		}
		
		public function get maximizable():Boolean
		{
			return __maximizable;
		}
		
		public function set titleBarIcon( ti:Class):void
		{
			__titleIcon = ti;
			if( titleIcon ) titleIcon.source = __titleIcon;
		}
		
		public function get titleBarIcon():Class
		{
			return __titleIcon;
		}
		
		public function set resizable(value:Boolean):void
		{
			__resizable = value;
		}
		
		public function get resizable():Boolean
		{
			return __resizable;
		}
		
		public function set draggable(value:Boolean):void
		{
			__draggable = value;
		}
		
		public function get draggable():Boolean
		{
			return __draggable;
		}
		
		public function set active(value:Boolean):void
		{
			if( value != __active )
			{
				__active = value;
				
				if( active )
				{
					if( stage )
						stage.focus = this;
				}
				
				invalidateSkinState();
			}
	
		}
	
		public function get active():Boolean
		{
			return __active;
		}
		
		public function get isChild():Boolean
		{
			return __isChild;
		}
		
		protected function set _isChild( c:Boolean ):void
		{
			__isChild = c;
		}
		
		public function get normalState():State
		{
			return __normalState;
		}
		
		public function get minimizedState():State
		{
			return __minimizedState;
		}
		
		public function get maximizedState():State
		{
			return __maximizedState;
		}
		
		public function get hiddenState():State
		{
			return __hiddenState;
		}
		
		public function get previousState():String
		{
			return __previousState;
		}
		
		protected function set _previousState( s:String ):void
		{
			__previousState = s;
		}
			
		public function set _previousX( X:Number ):void
		{
			__previousX = X;
		}
		
		public function get previousX():Number
		{
			return __previousX;
		}
			
		public function set _previousY( Y:Number ):void
		{
			__previousY = Y;
		}
		
		public function get previousY():Number
		{
			return __previousY;
		}
		
		protected function set _previousWidth( W:Number ):void
		{
			__previousWidth = W;
		}
		
		public function get previousWidth():Number
		{
			return __previousWidth;
		}
		
		protected function set _previousHeight( H:Number ):void
		{
			__previousHeight = H;
		}
		
		public function get previousHeight():Number
		{
			return __previousHeight;
		}
		
		public function get resizeAffordance():uint
		{
			return __resizeAffordance;
		}
		
		public function set resizeAffordance( a:uint ):void
		{
			__resizeAffordance = a;
		}
		
		public function get isHandleDragging():Boolean
		{
			return __isHandleDragging;
		}
		
		protected function set _isHandleDragging( i:Boolean ):void
		{
			__isHandleDragging = i;
		}
		
		public function get handleEdge():uint
		{
			return __handleEdge;
		}
		
		protected function set _handleEdge( h:uint ):void
		{
			__handleEdge = h;
		}
		
		public function get isDragging():Boolean
		{
			return __isDragging;
		}
		
		protected function set _isDragging( d:Boolean ):void
		{
			__isDragging = d;
		}
		
		public function get downX():uint
		{
			return __downX;
		}
		
		protected function set _downX( dx:uint ):void
		{
			__downX = dx;
		}
		
		public function get downY():uint
		{
			return __downY;
		}
		
		protected function set _downY( dy:uint ):void
		{
			__downY = dy;
		}
		
		public function get cursorId():int
		{
			return __cursorId;
		}
		
		protected function set _cursorId( c:int ):void
		{
			__cursorId = c;
		}
		
		public function get lastEdge():int
		{
			return __lastEdge;
		}
		
		protected function set _lastEdge( e:int ):void
		{
			__lastEdge = e;
		}
		
		public function get verticalResizeCursor():Class
		{
			return __verticalResizeCursor;
		}
		
		public function set verticalResizeCursor( vc:Class ):void
		{
			__verticalResizeCursor = vc;
		}
		
		public function get horizontalResizeCursor():Class
		{
			return __horizontalResizeCursor;
		}
		
		public function set horizontalResizeCursor( hc:Class ):void
		{
			__horizontalResizeCursor = hc;
		}
		
		public function get leftDiagonalCursor():Class
		{
			return __leftDiagonalCursor;
		}
		
		public function set leftDiagonalCursor( ldc:Class ):void
		{
			__leftDiagonalCursor = ldc;
		}
		
		public function get rightDiagonalCursor():Class
		{
			return __rightDiagonalCursor;
		}
		
		public function set rightDiagonalCursor( rdc:Class ):void
		{
			__rightDiagonalCursor = rdc;
		}
		
		public function set topResizeAffordance( tra:uint ):void
		{
			__topResizeAffordance = tra;			
		}
		
		public function get topResizeAffordance():uint
		{
			return __topResizeAffordance;
		}
		
		public function set beforeCloseFunction( fn:Function ):void
		{
			__beforeCloseFunction = fn;
		}
		
		public function set controllComponent( comp:IVisualElement ):void
		{
			if( comp != __controllComponent )
			{
				__controllComponent = comp;
				dispatchEvent( new DesktopWindowEvent( DesktopWindowEvent.CONTROLL_COMPONENT_CHANGED, this ) );
			}
		}
		
		public function get controllComponent():IVisualElement
		{
			return __controllComponent;
		}
		
		
		protected function get _autoCloseTimer():Timer
		{
			return __autoCloseTimer;
		}
		
		public function get autoCloseTime():Number
		{
			return __autoCloseTime;
		}
/*---------------					END OF GETTERS AND SETTERS    			----------------*/

/**************************************************************************************************************************
 * 
 * 							OVERRIDEN METHODS
 * 
 ***************************************************************************************************************************/

		override protected function getCurrentSkinState():String 
		{
			if( active ) 
			{
				return currentState;
			}
			else
			{
				if( ! currentState )
				{
					return 'normalInactive';
				}
				else
				{
					return currentState + 'Inactive';
				}
			}	 
		}

		override protected function partAdded(partName:String, instance:Object):void
		{
			if( instance == minimizeButton )
			{
				minimizeButton.addEventListener(MouseEvent.CLICK, _minimizeButtonClickHandler);
			}
			else if( instance == closeButton )
			{
				closeButton.addEventListener(MouseEvent.CLICK, _closeButtonClickHandler);				
			}
			else if( instance == maximizeRestoreButton )
			{
				maximizeRestoreButton.addEventListener(MouseEvent.CLICK, _maximizeRestoreButtonClickHandler);
			}
			else if( instance == minimizeChildWindowsButton )
			{
				minimizeChildWindowsButton.addEventListener( MouseEvent.CLICK, _minimizeChildWindows );
			}
			else if( instance == moveArea )
			{
				moveArea.addEventListener( MouseEvent.DOUBLE_CLICK, _moveAreaMouseDoubleClick );
				moveArea.doubleClickEnabled = true;
			}
			else if( instance == titleIcon )
			{
				titleIcon.source = titleBarIcon;
			}
			
			super.partAdded(partName, instance);
		}
		
		override protected function partRemoved(partName:String, instance:Object):void
		{
			if( instance == minimizeButton )
			{
				minimizeButton.removeEventListener(MouseEvent.CLICK, _minimizeButtonClickHandler);	
			}
			else if( instance == closeButton )
			{
				closeButton.removeEventListener(MouseEvent.CLICK, _closeButtonClickHandler);
			}
			if( instance == maximizeRestoreButton )
			{
				closeButton.removeEventListener(MouseEvent.CLICK, _maximizeRestoreButtonClickHandler);
			}
			else if( instance == minimizeChildWindowsButton )
			{
				minimizeChildWindowsButton.removeEventListener( MouseEvent.CLICK, _minimizeChildWindows );
			}
			else if( instance == moveArea )
			{
				moveArea.removeEventListener( MouseEvent.DOUBLE_CLICK, _moveAreaMouseDoubleClick );
			}
			
			super.partRemoved(partName, instance);
		}
	
		override public function setVisible(value:Boolean, noEvent:Boolean=false):void
		{
			super.setVisible(value, true);
		}
		
		
/*------------				END OF OVERRIDEN METHODS 			------------------*/
		
/****************************************************************************************************************************
 * 
 * 							PUBLIC METHODS
 * 
 *****************************************************************************************************************************/
	
		public function init():void
		{
			__normalState = new State();
			__normalState.name = 'normal';
			states.push( __normalState );
			
			__minimizedState = new State();
			__minimizedState.name = 'minimized';
			states.push( __minimizedState );
			
			__maximizedState = new State();
			__maximizedState.name = 'maximized';
			states.push( __maximizedState );
			
			__hiddenState = new State();
			__hiddenState.name = 'hidden';
			states.push( __hiddenState );
		
			verticalResizeCursor = resourceManager.getClass( this.session.config.LOCALE_CONFIG.systemIconsResourceName, "verticalResizeCursor", this.session.skinsLocaleName );
			horizontalResizeCursor = resourceManager.getClass( this.session.config.LOCALE_CONFIG.systemIconsResourceName, "horizontalResizeCursor", this.session.skinsLocaleName );
			rightDiagonalCursor = resourceManager.getClass( this.session.config.LOCALE_CONFIG.systemIconsResourceName, "rightDiagonalResizeCursor", this.session.skinsLocaleName );
			leftDiagonalCursor = resourceManager.getClass( this.session.config.LOCALE_CONFIG.systemIconsResourceName, "leftDiagonalResizeCursor", this.session.skinsLocaleName );
			
			currentState = normalState.name;
			active = true;
			
			resizable = false;
			minimizable = false;
			maximizable = false;
		}
		
		
		/**
		 * Function: setSize
		 * 
		 * Description: Convinient method for setting size of a window
		 *
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 10
		 *
		 * @public
		 * @return void
		 */
		public function setSize(X:Number, Y:Number, WIDTH:Number, HEIGHT:Number):void
		{
			if( WIDTH < 150 )
			{
				WIDTH = 150;
				X = x;
				Y = y;
			}
			
			if( HEIGHT < 150 ) 
			{
				HEIGHT = 150;
				X = x;
				Y = y;
			}
			
			_previousX = x;
			_previousY = y;
			_previousWidth = WIDTH;
			_previousHeight = HEIGHT;
			
			
			x = X;
			y = Y;
			width = WIDTH;
			height = HEIGHT;
		}
		
		/**
		 * Function: maximize
		 * 
		 * Description: Maximizes the window by setting width and height to windows parent 
		 * width and height, and x and y to 0.
		 *
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 10
		 *
		 * @public
		 * @return void
		 */

		public function maximize():void
		{
			if( ! maximizable ) return;
			
			if( currentState != maximizedState.name )
			{
				_saveDimensionsAndProperties();
				
				_previousState = currentState;
				setCurrentState( maximizedState.name );
				
				width = parent.width; 
				height = parent.height;
				x = 0;
				y = 0;
				
				invalidateSkinState();
				
				dispatchEvent( new DesktopWindowEvent( DesktopWindowEvent.MAXIMIZE, this ) );
			}
		}
		
		/**
		 * Function: minimize
		 * 
		 * Description: Minimizes the window to task bar
		 *
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 10
		 *
		 * @public
		 * @return void
		 */

		public function minimize():void
		{
			if( ! minimizable ) return;
			
			if( currentState != minimizedState.name )
			{	
				_previousState = currentState;
				currentState  = minimizedState.name;
				visible = false;
				
				if( childWindows && childWindows.length != 0 )
				{
					for( var i:uint = 0; i < childWindows.length; i++ )
					{
						childWindows[i].hide();
					}
				}
				
				dispatchEvent( new DesktopWindowEvent( DesktopWindowEvent.MINIMIZE, this ) );
			}
		}
		
		
		/**
		 * Function: restore
		 * 
		 * Description: Restores the window by setting windows dimensions to that before window 
		 * was maximized.
		 *
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 10
		 *
		 * @public
		 * @return void
		 */
		
		public function restore():void
		{
			var restored:Boolean = false;
			if( currentState == minimizedState.name )
			{
				
				visible = true;
				restored = true;
				
				previousState == normalState.name 
				 ?
				setCurrentState( normalState.name )
				:				
				setCurrentState( maximizedState.name );
				
				_previousState = minimizedState.name;
				
			}
			else if( currentState == maximizedState.name )
			{
				width = previousWidth; 
				height = previousHeight;
				x = previousX;
				y = previousY;
				
				_previousState = maximizedState.name;
				currentState = normalState.name;
				
				restored = true;
			}
			else if( currentState == hiddenState.name )
			{
				show();
				restored = true;
			}
			
			if( restored )
			{
				invalidateSkinState();
				dispatchEvent( new DesktopWindowEvent( DesktopWindowEvent.RESTORE, this) );
			}
		}
		
		/**
		 * Function: toFront
		 * 
		 * Description: Puts window in front of all windows in the 
		 * parent container by utilizing window manager class.
		 *
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 10
		 *
		 * @public
		 * @return void
		 */
		public function toFront():void
		{		
			if( currentState == minimizedState.name || currentState == hiddenState.name )
			{
				restore();
			}
			
			dispatchEvent( new DesktopWindowEvent( DesktopWindowEvent.TO_FRONT, this ) );
		}
		
		/**
		 * Function: show
		 * 
		 * Description: Displays window.
		 *
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 10
		 *
		 * @public
		 * @return void
		 */
		public function show():Boolean
		{
			if( currentState == hiddenState.name )
			{
	 			currentState = previousState;
				_previousState = hiddenState.name;
				
				userHidden = false;
				visible = true;
				dispatchEvent( new DesktopWindowEvent( DesktopWindowEvent.SHOW, this ) );
				return true;
			}
			
			return false;
		}
		
		/**
		 * Function: hide
		 * 
		 * Description: Hides the window.
		 *
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 10
		 *
		 * @public
		 * @return void
		 */
		public function hide():void
		{
			if( currentState != hiddenState.name  )
			{
				_previousState = currentState;
				currentState = hiddenState.name;
				
				visible = false;
				dispatchEvent( new DesktopWindowEvent( DesktopWindowEvent.HIDE, this ) );	
			}
		}
	
		/**
		 * Function: unload
		 * 
		 * Description: Delete all references so that window can be garbage collected.
		 *
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 10
		 *
		 * @public
		 * @return void
		 */
		public function unload():void
		{
			if( __autoCloseTimer )
			{
				__autoCloseTimer.stop();
				__autoCloseTimer.removeEventListener(TimerEvent.TIMER, _closeTimerEventHandler );
				__autoCloseTimer = null;
			}
			
			if( childWindows )
			{
				for( var i:uint = 0; i < childWindows.length; i++ )
				{ 					
					childWindows[i].unload();
				}
			}
			
			__beforeCloseFunction = null;
			
			if( parent )
			{
				parent.removeEventListener( MouseEvent.MOUSE_MOVE, _mouseMoveEventHandler );
				parent.removeEventListener( MouseEvent.ROLL_OUT, _parentMouseRollOutEventHandler );
				parent.removeEventListener( MouseEvent.MOUSE_UP, _parentMouseUpEventHandler );
				parent.removeEventListener( ResizeEvent.RESIZE, _parentResizeEventHandler );
			}
			
			removeEventListener( MouseEvent.ROLL_OUT, _mouseRollOutEventHandler );
			removeEventListener( MouseEvent.MOUSE_DOWN, _mouseDownEventHandler );
			removeEventListener( MouseEvent.MOUSE_UP, _mouseUpEventHandler );
			
			titleBarIcon = null;
			__childWindows = null;
			
			verticalResizeCursor = null;
			horizontalResizeCursor = null;
			leftDiagonalCursor = null;
			rightDiagonalCursor = null;
			resourceInfo = null;
			controllComponent = null;
			while( numElements )
				removeElementAt( 0 );
			
			dispatchEvent( new DesktopWindowEvent( DesktopWindowEvent.UNLOAD, this ) );
		}
		
		public function close():Boolean
		{
			if( childWindows )
			{
				for each( var w:DesktopWindow in childWindows )
				{
					if( w.close() !== true )
						return false;
				}
			}
			
			if( __beforeCloseFunction != null )
			{
				if( __beforeCloseFunction.call() !== false )
				{
					dispatchEvent( new DesktopWindowEvent( DesktopWindowEvent.CLOSE, this ) );
					unload();
					return true;
				}
				else
				{
					return false;
				}
			}
			else
			{
				dispatchEvent( new DesktopWindowEvent( DesktopWindowEvent.CLOSE, this ) );
				return true;
			}
		}
		
		/**
		 * Function: setAutoClose
		 * 
		 * Description: Set window auto close timer in milliseconds.
		 *
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 10
		 * 
		 * 
		 * @public
		 * @return void
		 */
		public function setAutoClose( timeBeforeCloseMs:Number ):void
		{
			if( ! __autoCloseTimer && timeBeforeCloseMs > 0 )
			{
				__autoCloseTimer = new Timer( timeBeforeCloseMs, 1 );
				__autoCloseTimer.addEventListener(TimerEvent.TIMER, _closeTimerEventHandler );
			}
			else if( __autoCloseTimer )
			{
				__autoCloseTimer.reset();
				__autoCloseTimer.delay = timeBeforeCloseMs;
				__autoCloseTimer.repeatCount = 1;
				__autoCloseTimer.start();
			}
				
			__autoCloseTime = timeBeforeCloseMs;
			
		}
		
		/**
		 * Function: addChildWindow
		 * 
		 * Description: Adds child windows to the _childWindowsArray. When parent window is minimized 
		 * or restored all his children are minimized or restored automatically depending on the
		 * previousState of the _childWindow.
		 *
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 10
		 * 
		 * 
		 * @public
		 * @return void
		 */
		
		public function addChildWindow(window:DesktopWindow):void
		{
			// if window is alrady child of another window
			// return void because window can only be chlid of
			// one window
			if( isChild ) return;
			
			if( ! childWindows ) __childWindows = new Vector.<DesktopWindow>();
			
			minimizeChildWindowsButton.visible = true;
			childWindows.push( window );
		}
		
/*------------------				END OF PUBLIC METHODS				----------------------*/
		
		
/****************************************************************************************************************************
 * 
 * 							PROTECTED METHODS
 * 
 *****************************************************************************************************************************/
		
		protected function _saveDimensionsAndProperties():void
		{
			_previousHeight = height;
			_previousWidth = width;
			
			_previousX = x;
			_previousY = y;
		}
		
/****************************
* 
*  EVENT HANDLERS	
* 
****************************/
		
		protected function _closeFadeOutComplete():void
		{
			if( hideOnClose )
			{
				hide();
			}
			else
			{
				close();
			}
		}
		
		protected function _closeTimerEventHandler(event:TimerEvent):void
		{
			__autoCloseTimer.removeEventListener( TimerEvent.TIMER, _closeTimerEventHandler );
			__autoCloseTimer = null;
			TweenLite.to( this, 3, {alpha:0, onComplete:_closeFadeOutComplete} );
		}
		
		protected function _moveAreaMouseDoubleClick(event:MouseEvent):void
		{
			if( event.type == MouseEvent.DOUBLE_CLICK )
			{
				if( currentState == normalState.name  && maximizable )
				{
					maximize();
					
				}else if( currentState == maximizedState.name )
				{
					restore();
				}
				
			}
		}
		
		protected function _maximizeRestoreButtonClickHandler(event:MouseEvent):void
		{
			if( currentState == normalState.name )
			{
				maximize();
				
			}else if( currentState == maximizedState.name || currentState == hiddenState.name || currentState == minimizedState.name )
			{
				restore();
			}
			
		}
					
		protected function _minimizeButtonClickHandler(event:MouseEvent):void
		{
			minimize();
		}
				
		protected function _minimizeChildWindows( event:MouseEvent ):void
		{
			if( childWindows )
			{
				for each (var cw:DesktopWindow in childWindows ) 
				{
					cw.hide();
					cw.userHidden = true;	
				}
			}
			
			toFront();
		}
		
		protected function _addedToStage(event:Event):void
		{
			
			removeEventListener(Event.ADDED_TO_STAGE, _addedToStage);
			
			if( active )
				stage.focus = this;
			
			parent.addEventListener( MouseEvent.MOUSE_MOVE, _mouseMoveEventHandler );
			parent.addEventListener( MouseEvent.ROLL_OUT, _parentMouseRollOutEventHandler );
			parent.addEventListener( MouseEvent.MOUSE_UP, _parentMouseUpEventHandler );
			parent.addEventListener( ResizeEvent.RESIZE, _parentResizeEventHandler );
			
			addEventListener( MouseEvent.MOUSE_DOWN, _mouseDownEventHandler );
			addEventListener( MouseEvent.MOUSE_UP, _mouseUpEventHandler );
			addEventListener( MouseEvent.ROLL_OUT, _mouseRollOutEventHandler );
			
			 ( getStyle('borderThickness') as uint != 0 ) ? resizeAffordance = getStyle('borderThickness') as uint : resizeAffordance = 6;

			 show();
		}
		
		protected function _closeButtonClickHandler(event:MouseEvent):void
		{
			if( hideOnClose )
			{
				userHidden = true;
				hide();
			}
			else
			{
				close();
			}
			
		}
		
		protected function _mouseRollOutEventHandler(event:MouseEvent):void
		{
			if( ! isHandleDragging )
			{
				cursorManager.removeAllCursors();
			}
		}
										
		protected function _mouseDownEventHandler(event:MouseEvent):void
		{
			if( event.target == minimizeButton || event.target == closeButton || event.target == minimizeChildWindowsButton ) return;
			
			toFront();
			
			if( event.target == moveArea && !__handleEdge )
			{
				_isDragging = true;
				_isHandleDragging = false;
				
				var p:Point = new Point( event.stageX, event.stageY );
				var thisLp:Point = this.globalToLocal( p );
				
				_downX = thisLp.x;
				_downY = thisLp.y;
				
			}
			else if( handleEdge )
			{
				_isHandleDragging = true;
				_isDragging = false;
			}
		}
		
		protected function _mouseMoveEventHandler(event:MouseEvent):void
		{
			if( resizable && currentState != maximizedState.name )
			{
				if( isHandleDragging )
				{
					_resize(event);
				}
				else
				{
					_setCursor(event);	
				}
			}
			
			if( draggable )
			{
				if( isDragging && currentState != maximizedState.name && ! isHandleDragging ) 
				{
					_moveWindow(event);
				}
			}
		}
			
		protected function _moveWindow(event:MouseEvent):void
		{			
			var gp:Point = new Point( event.stageX, event.stageY );
			
			var plp:Point = this.parent.globalToLocal( gp );
			var tlp:Point = this.globalToLocal( gp );
			
			var tmpX:Number = plp.x - downX;
			var tmpY:Number = plp.y - downY; 
			
			if( 
				tmpY  >= 0 && 
				tmpY <= parent.height - moveArea.height && 
				tmpX >= (width - 150) * -1  && 
				( tmpX + 150 ) <= parent.width
			)
			{	            
				x =  tmpX;
				y =  tmpY;
			}
			else
			{
				if( tmpY < 0 )
				{
					y = 0;
					
				}
				else if( tmpY >  parent.height - moveArea.height )
				{
					y =  parent.height - moveArea.height;
				}
				
				if( tmpX < ( width - 150 ) * -1 )
				{
					tmpX = ( width - 150 ) * -1;
					
				}
				else if( tmpX + 150 > parent.width )
				{
					x = parent.width - 150	
				}
				
			}	
		}
		
		protected function _parentMouseRollOutEventHandler(event:MouseEvent):void
		{
			if( y < 0 )
			{
				y = 0;
			}
			
			_isHandleDragging = false;
			_isDragging = false;
			stopDrag();

		}
		
		protected function _parentResizeEventHandler(event:ResizeEvent):void
		{
			if( previousHeight > event.target.height )  _previousHeight = event.target.height;
			if( previousWidth > event.target.width )  _previousWidth = event.target.width;
		}
		
		protected function _mouseUpEventHandler(event:MouseEvent):void
		{	
			_isHandleDragging = false;
			_isDragging = false;
			
			if( cursorId != 0 )
			{
				cursorManager.removeCursor( cursorId );
				_cursorId=0;
				
				__lastEdge = EDGE_NONE;
			}
			
			stopDrag();
		}
		
		protected function _parentMouseUpEventHandler(event:MouseEvent):void
		{
			if( cursorId != 0 )
			{
				cursorManager.removeCursor( cursorId );
				_cursorId = 0;
				_lastEdge = EDGE_NONE;
			}
			
			_isDragging = false;
			_isHandleDragging = false;
		}
		
		protected function _resize(event:MouseEvent):void
		{
			var p:Point = new Point( event.stageX, event.stageY );
			var lP:Point = this.parent.globalToLocal(p);
			
			switch( handleEdge )
			{
				case EDGE_BOTTOM:
					setSize( x, y, width,  lP.y - y  );
				break;
				
				case EDGE_LEFT:
					setSize( lP.x , y, x - lP.x + width, height  );
				break;
				
				case EDGE_LEFT_BOTTOM:
					setSize( lP.x, y, x - lP.x + width, lP.y - ( height + y ) + height  );
				break;
				
				case EDGE_LEFT_TOP:
					setSize( lP.x, lP.y, x - lP.x + width, y - lP.y + height);
				break;
				
				case EDGE_RIGHT:
					setSize(x, y, lP.x - ( width + x ) + width, height  );
				break;
				
				case EDGE_RIGHT_BOTTOM:
					setSize(x, y, lP.x - ( width + x ) + width, lP.y - ( height + y ) + height  );
					
				break;
				
				case EDGE_RIGHT_TOP:
					setSize(x, lP.y, lP.x - ( width + x ) + width, y - lP.y + height  );
				break;
				
				case EDGE_TOP:
					setSize(x, lP.y, width, y - lP.y + height  );
				break;
			}
		}
			
		protected function _setCursor(event:MouseEvent):void
		{
			if( event.type == MouseEvent.ROLL_OUT )
			{
				cursorManager.removeAllCursors();
				_handleEdge = EDGE_NONE;
				_cursorId = 0;
				return;
			}
			
			
			_isCursorOnEgde(event);
			
			if( handleEdge != EDGE_NONE )
			{
				
				if( cursorId == 0 || lastEdge != handleEdge )
				{
					if( lastEdge != handleEdge )
					{
						cursorManager.removeCursor( cursorId );
						_cursorId = 0;
					}
					
					if( handleEdge == EDGE_BOTTOM || handleEdge == EDGE_TOP )
					{
						_cursorId = cursorManager.setCursor( verticalResizeCursor, CursorManagerPriority.HIGH, -5, -10 );
					}
					else if( handleEdge == EDGE_LEFT || handleEdge == EDGE_RIGHT )
					{
						_cursorId = cursorManager.setCursor( horizontalResizeCursor, CursorManagerPriority.HIGH, -10 );
					}
					else if( handleEdge == EDGE_LEFT_BOTTOM || handleEdge == EDGE_RIGHT_TOP )
					{
						_cursorId = cursorManager.setCursor( leftDiagonalCursor, CursorManagerPriority.HIGH, -7, -5 );
					}
					else if( handleEdge == EDGE_LEFT_TOP || handleEdge == EDGE_RIGHT_BOTTOM )
					{
						_cursorId = cursorManager.setCursor( rightDiagonalCursor, CursorManagerPriority.HIGH, -7, -5 );
					}
					
					_lastEdge = handleEdge;
				}
			}
			else
			{
				if( cursorId != 0 )
				{
					cursorManager.removeCursor( cursorId );
					
					_cursorId = 0;
					_lastEdge = EDGE_NONE;
				}
			}
			
			
		}
		
		protected function _isCursorOnEgde(event:MouseEvent):void
		{
			if( 
				event.target == minimizeButton || 
				event.target == maximizeRestoreButton || 
				event.target == closeButton 
			  ) 
			{
				_handleEdge = EDGE_NONE;
				return;
			}
				
			if( event.target == allContentGroup || event.target == moveArea )
			{
				if( event.localX >= 0 && event.localX <= resizeAffordance && event.localY >= resizeAffordance * 2 && event.localY <= height - resizeAffordance * 2 )
				{
					_handleEdge = EDGE_LEFT;
				}
				else if(event.localX >= width - resizeAffordance && event.localX <= width && event.localY >= resizeAffordance && event.localY <= height - resizeAffordance * 2)
				{
					_handleEdge = EDGE_RIGHT;
				}
				else if( event.localX >= resizeAffordance * 2 && event.localX <= width - resizeAffordance * 2 && event.localY >= height - resizeAffordance && event.localY <= height )
				{
					_handleEdge = EDGE_BOTTOM;
				}
				else if( event.localX >= topResizeAffordance * 2 && event.localX <= width - topResizeAffordance * 2 && event.localY <=  topResizeAffordance && event.localY >= 0 )
				{
					_handleEdge = EDGE_TOP;
				}
				else if( event.localX >= 0 && event.localX <= resizeAffordance * 2 && event.localY >= 0 && event.localY <= resizeAffordance * 2 )
				{
					_handleEdge = EDGE_LEFT_TOP;
				}
				else if( event.localX >= width - resizeAffordance * 2 && event.localX <= width && event.localY >= 0 && event.localY <= resizeAffordance * 2 )
				{
					_handleEdge = EDGE_RIGHT_TOP;
				}
				else if( event.localX >= 0 && event.localX <= resizeAffordance * 2 && event.localY > height - resizeAffordance * 2 && event.localY <= height )
				{
					_handleEdge = EDGE_LEFT_BOTTOM;
				}
				else if( event.localX >= width - resizeAffordance * 2 && event.localX <= width && event.localY > height - resizeAffordance * 2 && event.localY <= height )
				{
					_handleEdge = EDGE_RIGHT_BOTTOM;	
				}
				else
				{
					_handleEdge = EDGE_NONE;
				}
				
				
			}else{
				_handleEdge = EDGE_NONE;
			}
		}
		
/*-------------------------  				END OF EVENTS 				-------------------------*/
		
/*******************************
 * 
 * PRIVATE METHODS
 * 
 ********************************/
		
/*-------------------------  				END OF PRIVATE METHODS 				-------------------------*/
		
		
		
	}
}