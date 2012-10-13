package com.desktop.ui.Components.NavBars
{	
	import com.desktop.ui.Components.Button.TaskBarButton;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.setTimeout;
	
	import mx.core.IVisualElement;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	import mx.events.ItemClickEvent;
	
	import spark.components.Button;
	import spark.components.ButtonBarButton;
	import spark.components.Group;
	import spark.components.NumericStepper;
	import spark.components.Scroller;
	import spark.components.ToggleButton;
	import spark.components.supportClasses.SkinnableComponent;
	import spark.layouts.HorizontalLayout;
	import spark.layouts.VerticalLayout;

	
	/**
	 * Orientation of buttons. Possible values are vertical or horizontal.
	 */
	[Style(name="orientation", inherit="yes", type="String")]
	
	/**
	 *  If label is visible on task bar buttons.
	 */
	[Style(name="labelVisible", inherit="yes", type="Boolean")]
	
	/**
	 *  If label is visible on task bar buttons.
	 */
	[Style(name="thickness", inherit="yes", type="Number")]
	
	public class DesktopButtonBar extends SkinnableComponent
	{
		
		public static const HORIZONTAL_ORIENTATION:String = "horizontal";
		public static const VERTICAL_ORIENTATION:String = "vertical";
		
		[SkinPart(reqired='true')]
		public var defaultGroup:Group;
			
		[SkinPart(reqired='true')]
		public var buttonBar:Group;
		
		[SkinPart(reqired='false')]
		public var buttonBarScrollStepper:NumericStepper;
		
		[SkinPart(reqired='false')]
		public var buttonBarHolder:Group;
		
		[SkinPart(reqired='false')]
		public var incrementalScrollButton:Button;
		
		
		
		[SkinPart(reqired='false')]
		public var decrementalScrollButton:Button;
		
		[SkinPart(reqired='false')]
		public var buttonBarScroller:Scroller
		
		private var _selectedItem:TaskBarButton;
		
		public function DesktopButtonBar()
		{
			super();
		}
		
		public function addButton( button:TaskBarButton ):void
		{			
			if( button )
			{
				button.addEventListener( MouseEvent.CLICK, onItemClick, false, 0, true  );
				button.addEventListener( FlexEvent.CREATION_COMPLETE, _buttonCreationComplete, false, 0, true );
				
				button.setStyle( "labelVisible", getStyle( 'labelVisible' ) );
				button.setStyle( "fontSize", getStyle( 'fontSize' ) );
				
				buttonBar.addElement( button );
			}
		}
		
		protected function _buttonCreationComplete( event:FlexEvent ):void
		{
			event.target.removeEventListener( FlexEvent.CREATION_COMPLETE, _buttonCreationComplete );
			invalidateSkinState();
			
			buttonBarScroller.ensureElementIsVisible( event.target as IVisualElement );
		}
		
		public function removeButton( button:TaskBarButton ):void
		{
			if( _selectedItem == button ) _selectedItem = null;
			
			button.removeEventListener(MouseEvent.CLICK, onItemClick);
			
			button.addEventListener( Event.REMOVED_FROM_STAGE, _buttonRemovedFromStage );
			buttonBar.removeElement( button );
		}
		
		
		protected function _buttonRemovedFromStage( event:Event ):void
		{
			event.target.removeEventListener( Event.REMOVED_FROM_STAGE, _buttonRemovedFromStage );
			invalidateSkinState();	
		}
		
		override public function styleChanged(styleProp:String):void
		{
			super.styleChanged( styleProp );
			
			if( styleProp == "labelVisible" || styleProp == "thickness" || styleProp == "orientation" )
			{
				var tbb:TaskBarButton;
				
				if( buttonBar )
				{
					for( var i:uint = 0; i < buttonBar.numElements; i++ )
					{ 
						tbb = buttonBar.getElementAt( i ) as TaskBarButton;
						
						if( tbb )
						{
							tbb.setStyle( styleProp, getStyle( styleProp ) );
							tbb.skin.invalidateSize();
							tbb.skin.invalidateDisplayList();
						}
					}
				}
				
				skin.invalidateSize();
				skin.invalidateDisplayList();
			}
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			switch( getStyle( "orientation" ) )
			{
				case HORIZONTAL_ORIENTATION:
					buttonBar.layout = new HorizontalLayout();
				break;
				
				case VERTICAL_ORIENTATION:
					
					buttonBar.layout = new VerticalLayout();
				break;
			}
			
			invalidateSkinState();
		}
		
			
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance );
			
			if( instance == buttonBarScrollStepper )
			{
				buttonBarScrollStepper.addEventListener( Event.CHANGE, _buttonBarScrollStepperChangeEventHandler );
			}
			else if( instance == incrementalScrollButton )
			{
				incrementalScrollButton.addEventListener( MouseEvent.CLICK, _incremnetalScrollButtonMouseClick );
			}
			else if ( instance ==  decrementalScrollButton )
			{
				decrementalScrollButton.addEventListener( MouseEvent.CLICK, _decrementalScrollButtonMouseClick );
			}
			
		}
		
		
		protected function _incremnetalScrollButtonMouseClick( event:MouseEvent ):void
		{
			buttonBarHolder[_scrollProp] += _scrollIncrement;
		}
		
		protected function _decrementalScrollButtonMouseClick( event:MouseEvent ):void
		{
			buttonBarHolder[_scrollProp] -= _scrollIncrement;	
		}
		
		protected function get _scrollIncrement():Number
		{
			if( defaultGroup.layout is VerticalLayout )
			{
				return ( buttonBar.getElementAt( 0 ) as UIComponent ).measuredHeight; 
			}
			else if ( defaultGroup.layout is HorizontalLayout )
			{
				return ( buttonBar.getElementAt( 0 ) as UIComponent ).measuredWidth;
			}
			
			return 30;
		}
		
		protected function get _scrollProp():String
		{
			if( defaultGroup.layout is VerticalLayout )
			{
				return "verticalScrollPosition"; 
			}
			else if ( defaultGroup.layout is HorizontalLayout )
			{
				return "horizontalScrollPosition";
			}
			
			return "x";
		}
		
		override protected function partRemoved(partName:String, instance:Object):void
		{
			super.partRemoved(partName, instance );
			
			if( instance == buttonBarScrollStepper )
			{
				buttonBarScrollStepper.removeEventListener( Event.CHANGE, _buttonBarScrollStepperChangeEventHandler );
			}
			else if( instance == incrementalScrollButton )
			{
				incrementalScrollButton.removeEventListener( MouseEvent.CLICK, _incremnetalScrollButtonMouseClick );
			}
			else if ( instance ==  decrementalScrollButton )
			{
				decrementalScrollButton.removeEventListener( MouseEvent.CLICK, _decrementalScrollButtonMouseClick );
			}
		}
		
		
		protected function _buttonBarScrollStepperChangeEventHandler( event:Event ):void
		{
			buttonBar.x = buttonBarScrollStepper.value;
		}
		
		
		public function setActiveButton( button:TaskBarButton ):void
		{
			if( button )
			{
				if( _selectedItem && _selectedItem.selected ) _selectedItem.selected = false;
				
				button.selected = true;
				_selectedItem = button;
			}
		}
		
		public function setInactiveButton( button:TaskBarButton ):void
		{
			if( button )
			{
				if( button == _selectedItem ) _selectedItem == null;
				
				button.selected = false;
			}		
		}
		
		protected function onItemClick( event:MouseEvent ):void
		{
			var clickedItem:IVisualElement = event.target as IVisualElement;
			
			buttonBarScroller.ensureElementIsVisible( clickedItem );
			
			if( _selectedItem == clickedItem )
			{
				_selectedItem = null;
			}
			else
			{		
				if( _selectedItem )
				{
					_selectedItem.selected = false;
				}
				
				_selectedItem = clickedItem as TaskBarButton;
			}
			
			var newEvent:ItemClickEvent = new ItemClickEvent(ItemClickEvent.ITEM_CLICK);
				newEvent.item = clickedItem;
				
			dispatchEvent(newEvent);
		}
		
		public function get selectedItemButton():TaskBarButton
		{
			return _selectedItem;
		}
		
		public function get isScrolling():Boolean
		{
			var v:Boolean;
			var t:Number = 0;
			var dprop:String;
			var mprop:String;
			
			if( buttonBar )
			{
				if( buttonBar.layout is VerticalLayout )
				{
					dprop = "measuredHeight";
					mprop = "maxHeight";
				}
				else if( buttonBar.layout is HorizontalLayout )
				{
					dprop = "measuredWidth";
					mprop = "maxWidth";
				}
				
				for( var i:uint = 0; i < buttonBar.numElements; i++ )
				{
					t += ( buttonBar.getElementAt( i ) as UIComponent )[dprop];
				}
			}
			
			if( buttonBarHolder )
				return t > buttonBarHolder[mprop];
			
			return false;
		}
		
		override protected function getCurrentSkinState():String
		{
			if( isScrolling )
			{
				return "scroll";
			}
			else
			{
				return "normal";
			}
		}
	}
}