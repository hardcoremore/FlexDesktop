package com.desktop.ui.Components.NavBars
{
	import com.desktop.ui.Controls.Events.NavBarItemClickEvent;
	import com.desktop.ui.vos.ButtonVo;
	
	import flash.events.MouseEvent;
	
	import mx.core.UIComponent;
	
	import spark.components.Button;
	import spark.components.Group;
	import spark.components.ToggleButton;
	import spark.components.supportClasses.SkinnableComponent;
	
	public class StartMenu extends SkinnableComponent
	{
		
		[SkinPart(required="true")]
		public var fullScreenButton:Button;
		
		[SkinPart(required="true")]
		public var configButton:Button;
		
		[SkinPart(required="true")]
		public var lockButton:Button;

		[SkinPart(required="true")]
		public var logOutButton:Button;
		
		[SkinPart(required="true")]
		public var startMenuButtons:Group;
		
		
		public function StartMenu()
		{
			super();
		}
		
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			if( instance == fullScreenButton )
			{
				fullScreenButton.addEventListener( MouseEvent.CLICK, _controllButtonsClickHandler );
			}
			if( instance == configButton )
			{
				configButton.addEventListener(MouseEvent.CLICK, _controllButtonsClickHandler );
			}
			else if( instance == lockButton )
			{
				lockButton.addEventListener(MouseEvent.CLICK, _controllButtonsClickHandler );
			}
			else if( instance == logOutButton )
			{
				logOutButton.addEventListener(MouseEvent.CLICK, _controllButtonsClickHandler );
			}
			
			super.partAdded(partName, instance);
		}
		
		override protected function partRemoved(partName:String, instance:Object):void
		{
			if( instance == configButton )
				configButton.removeEventListener(MouseEvent.CLICK, _controllButtonsClickHandler);
			
			if( instance == lockButton )
				lockButton.removeEventListener(MouseEvent.CLICK, _controllButtonsClickHandler);
			
			if( instance == logOutButton )
				logOutButton.removeEventListener(MouseEvent.CLICK, _controllButtonsClickHandler);
			
			super.partRemoved(partName, instance);
		}
		
		
		/*********************************
		 * 
		 *  Item Click Events
		 * 
		 * **********************************/
		
		protected function _controllButtonsClickHandler( event:MouseEvent ):void
		{
			dispatchEvent( new NavBarItemClickEvent(NavBarItemClickEvent.ITEM_CLICK, event.currentTarget.id, event.currentTarget as UIComponent ) );
		}
		
		public function addButton( buttonVo:ButtonVo ):ToggleButton
		{
			var b:ToggleButton = new ToggleButton();
				b.id = buttonVo.id;
				b.label = buttonVo.label;
				b.setStyle( "icon", buttonVo.icon );
				b.setStyle( "labelVisible", buttonVo.labelVisible );
				b.addEventListener(MouseEvent.CLICK, onStartMenuButtonClick);
				startMenuButtons.addElement( b );
				
			return b;
		}
		
		public function removeButton( button:ToggleButton ):void
		{
			startMenuButtons.removeElement( button );
		}
		
		private function onStartMenuButtonClick(event:MouseEvent):void
		{
			dispatchEvent( new NavBarItemClickEvent(NavBarItemClickEvent.ITEM_CLICK, "startMenuButton", event.target as  UIComponent) );
		}
		
		public function unload():void
		{
		}
	}
	
}