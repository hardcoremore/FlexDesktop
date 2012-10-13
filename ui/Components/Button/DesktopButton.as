package com.desktop.ui.Components.Button
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.core.UIComponent;
	import mx.states.State;
	
	import spark.components.Button;
	import spark.components.Label;
	
	
	public class DesktopButton extends Button
	{
		
		/**
		 *  @private
		 */
		private var _icon:Class;
		
		/**
		 *  @private
		 */
		private var _labelVisible:Boolean = true;
		
		
		/**
		 *  Description: Direction for the icon in the button. Posible values are left and right 
		 * 
		 *  @private
		 */
		private var _iconDirection:String = 'left';
		
		/**
		 *  Description: Object that this button is controlling. 
		 * 
		 *  @private
		 */
		private var _controlledObject:UIComponent;
	
		
		public function set controlledObject(cObject:UIComponent):void
		{
			this._controlledObject = cObject;
		}
		
		public function get controlledObject():UIComponent
		{
			return this._controlledObject;
		}
		
		public function set labelVisible(value:Boolean):void
		{
			
			_labelVisible = value;
			
			/*
			if( labelDisplay )
			{
				if( value )
				{
					labelDisplay. = 100;
				}
				else
				{
					labelDisplay.width = 0;
				}
				
				labelDisplay.invalidateSize();
				labelDisplay.invalidateDisplayList();
			}
			*/
		}
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			/*
			if( instance == labelDisplay )
			{
				_labelVisible ? labelDisplay.percentWidth = 100 : labelDisplay.width = 0;
			}
			
			super.partAdded(partName, instance);
			*/
		}
		
		
		public function get labelVisible():Boolean
		{
			return _labelVisible;
		}
		
		public function set iconDirection(value:String):void
		{
			if( _iconDirection != value )
			{
				_iconDirection = value;
			}
			
		}
		
		public function get iconDirection():String
		{
			return _iconDirection;
		}
		
		public function get icon():Class
		{
			return _icon;
		}
		
		
		public function set icon(icon:Class):void
		{
			_icon = icon;
		}
		
		public function DesktopButton()
		{
			super();
		}
	}
}