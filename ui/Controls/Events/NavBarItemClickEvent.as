package com.desktop.ui.Controls.Events
{
	import flash.events.Event;
	
	import mx.core.UIComponent;
	
	public class NavBarItemClickEvent extends Event
	{
		public static const ITEM_CLICK:String = "itemClick";
		
		private var _itemType:String;
		
		private var _item:UIComponent;
		
		public function get itemType():String
		{
			return this._itemType;
		}
		
		public function get item():UIComponent
		{
			return this._item;
		}
		
		public function NavBarItemClickEvent(type:String, itemType:String, item:UIComponent, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			
			this._itemType = itemType;
			this._item   = item;
		}
	}
}