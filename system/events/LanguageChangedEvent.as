package com.desktop.system.events
{
	import flash.events.Event;

	public class LanguageChangedEvent extends Event
	{
		private var _language:String;
		
		public static const LANGUAGE_CHANGED:String = "languageChanged";
		
		public function set language(language:String):void
		{
			this._language = language;
		}
		
		public function get language():String
		{
			return this._language;
		}
		
		public function LanguageChangedEvent(type:String, language:String)
		{
			super(type);
			this._language = language;
		}
		
	}
}