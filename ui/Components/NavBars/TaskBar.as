package com.desktop.ui.Components.NavBars
{
	import com.desktop.ui.Components.Button.TaskBarButton;
	import com.desktop.ui.Components.ComponentBase;
	import com.desktop.ui.Components.DesktopComponent;
	import com.desktop.ui.Components.Window.DesktopWindow;
	import com.desktop.ui.Controls.Events.NavBarItemClickEvent;
	import com.desktop.ui.vos.ButtonVo;
	
	import flash.events.MouseEvent;
	import flash.utils.setTimeout;
	
	import mx.core.IVisualElement;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	import mx.events.ItemClickEvent;
	import mx.states.OverrideBase;
	
	import spark.components.Button;
	import spark.components.Group;
	import spark.components.Image;
	import spark.components.ToggleButton;
	import spark.components.supportClasses.SkinnableComponent;
	import spark.layouts.HorizontalLayout;
	import spark.layouts.VerticalLayout;
	import spark.layouts.supportClasses.LayoutBase;
	
	/**
	 *  Dispatched when the user clicks on any button on task bar.
	 */
	[Event(name="itemClick", type="mx.events.ItemClickEvent")]
	
	
	/**
	 * Orientation of task bar. Possible values are vertical or horizontal.
	 */
	[Style(name="orientation", inherit="yes", type="String", enumeration="vertical, horizontal")]
	
	/**
	 *  If label is visible on task bar buttons.
	 */
	[Style(name="labelVisible", inherit="yes", type="Boolean", enumeration="true, false")]
	
	
	/**
	 *  Taskbar thickness.
	 */
	[Style(name="thickness", inherit="yes", type="Number")]
	
	/**
	 *  Taskbar background color alpha.
	 */
	[Style(name="backgroundAlpha", inherit="no", type="Number")]
	
	/**
	 *  Takskbar background color.
	 */
	[Style(name="backgroundColor", inherit="no", type="Number")]
	
	public class TaskBar extends ComponentBase
	{
		[SkinPart(required='true')]
		public var buttonBar:DesktopButtonBar;
		
		[SkinPart(required='true')]
		public var startMenuButton:Button;
		
		[SkinPart(required='true')]
		public var minimizeAllWindowsButton:Button;
		
		[SkinPart(required='true')]
		public var trayButton:Button;
		
		[SkinPart(required='false')]
		public var clock:Button;
		
		private var __taskBarButtonLabelVisible:Boolean;
		
		private var __position:String;
		
		private var __desktop:DesktopComponent;
		
		public static const START_MENU_BUTTON:String = "startMenuButton";
		public static const BUTTON_BAR_ITEM:String = "buttonBarItem";
		public static const MINIMIZE_ALL_WINDOWS_BUTTON:String = "minimizeAllWindowsButton";
		
		public static const HORIZONTAL_ORIENTATION:String = "horizontal";
		public static const VERTICAL_ORIENTATION:String = "vertical";
		
/****************************
 * 
 *  CONSTRUCTOR
 * 
 ****************************/
		
		public function TaskBar()
		{
			super();
		}
		
/*------------				CONSTRUCTOR				---------------*/		
		
/*****************************
 * 
 * 	GETTERS/SETTERS
 * 
 *****************************/
		
		
		public function set desktop( d:DesktopComponent ):void
		{
		 	if( d != __desktop )
				__desktop = d;
		}
		
		public function get desktop():DesktopComponent
		{
			return __desktop;
		}
		
/*------------------			END OF GETTERS/SETTERS				--------------------*/
		
/**********************************
 * 
 *  PUBLIC METHODS
 * 
 **********************************/
		
		public function createButtonBarButton( buttonVo:ButtonVo ):TaskBarButton
		{
			var b:TaskBarButton = new TaskBarButton();
				b.label = buttonVo.label;
				b.window = buttonVo.controllComponent as DesktopWindow;
				b.setStyle( "icon", buttonVo.icon );
				b.setStyle( "skinClass", resourceManager.getClass( this.session.config.LOCALE_CONFIG.skinsResourceName,  "taskBarButtonSkin", this.session.skinsLocaleName ) );
				
			return b;
		}
		
		
		public function addButtonBarButton( button:TaskBarButton ):void
		{
			buttonBar.addButton( button );
		}
		
		
		public function addTrayBarButton( buttonVo:ButtonVo ):void
		{
			
		}
		
		public function removeButtonBarButton( button:TaskBarButton ):void
		{
			try
			{
				button.window = null;
				buttonBar.removeButton( button );	
			}catch( e:Error )
			{
				trace( "Could not remove button bar button at TaskBar::removeButtonBarButton(). Message:\n" + e.message ); 
			}
			
		}
		
		public function removeTrayBarButton( id:String ):void
		{
			
		}
		
		override public function styleChanged(styleProp:String):void
		{
			super.styleChanged(styleProp);
			
			if( styleProp == "thickness" || styleProp == "labelVisible" || styleProp == "orientation" )
			{
				skin.invalidateSize();
				skin.invalidateDisplayList();
			}
			 
		}
		
/*------------------			END OF PUBLIC METHODS			------------------*/
		
/**********************************
 * 
 *  OVERRIDEN METHODS
 * 
 **********************************/		
			
		override protected function partAdded(partName:String, instance:Object):void
		{
			if( instance == startMenuButton )
			{
				startMenuButton.addEventListener( MouseEvent.CLICK, onStartMenuClick );
			}
			else if( instance == buttonBar )
			{
				buttonBar.addEventListener( ItemClickEvent.ITEM_CLICK, onButtonBarItemClick );
			}
			else if( instance == minimizeAllWindowsButton )
			{
				minimizeAllWindowsButton.addEventListener( MouseEvent.CLICK, onMinimizeAllWindowsClick );
			}
			
		}
		
		override protected function partRemoved(partName:String, instance:Object):void
		{
			if( instance == startMenuButton )
			{
				startMenuButton.removeEventListener(MouseEvent.CLICK, onStartMenuClick);
			}
			else if( instance == buttonBar )
			{
				buttonBar.removeEventListener(ItemClickEvent.ITEM_CLICK, onButtonBarItemClick);
			}
			else if( instance == minimizeAllWindowsButton )
			{
				minimizeAllWindowsButton.removeEventListener(MouseEvent.CLICK, onMinimizeAllWindowsClick);
			}
		}
		
		
		
/*-----------------					END OF OVERRIDE METHODS					--------------------*/
		
/**********************************
 * 
 *   CLICK EVENTS
 * 
 * *********************************/
		
		private function onStartMenuClick(event:MouseEvent):void	
		{
			dispatchEvent( new NavBarItemClickEvent( NavBarItemClickEvent.ITEM_CLICK, START_MENU_BUTTON, startMenuButton ) );
		}
		
		private function onButtonBarItemClick(event:ItemClickEvent):void
		{
			dispatchEvent( new NavBarItemClickEvent( NavBarItemClickEvent.ITEM_CLICK, BUTTON_BAR_ITEM, event.item as UIComponent ) );
		}
		
		private function onMinimizeAllWindowsClick(event:MouseEvent):void
		{
			dispatchEvent( new NavBarItemClickEvent( NavBarItemClickEvent.ITEM_CLICK, MINIMIZE_ALL_WINDOWS_BUTTON, minimizeAllWindowsButton ) );
		}
	}
	
/*-----------------				END OF CLICK EVENTS				-------------------*/
	
	
}