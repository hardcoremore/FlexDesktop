package com.desktop.system.vos
{
	[Bindable("__NoChangeEvent__")]
	public class NotificationVo
	{
		public var title:String;
		public var text:String
		public var icon:Class;
		public var autoCloseTime:uint; // number in miliseconds
		public var id:String;
		
		public var yesNoButtons:Boolean;
		public var okCancelButtons:Boolean;
		
		public var okButton:Boolean;
		
		public var prompt:Boolean;
		public var promptAsPassword:Boolean;
		
		public function NotificationVo( title:String = null, text:String = null, icon:Class = null, autoCloseTime:uint = 0, id:String = null )
		{
			this.title = title;
			this.text = text;
			this.icon = icon;
			this.autoCloseTime = autoCloseTime;
			this.id = id;
		}
	}
}