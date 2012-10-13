package com.desktop.ui.Components.Group
{
	import spark.components.Label;
	
	import spark.components.SkinnableContainer;
	
	public class LoadingContainer extends SkinnableContainer
	{
		private var __loading:Boolean;
		
		private var __loadingMessage:String;
		
		[SkinPart(required="false")]
		public var loadingMessageLabel:Label;
		
		public function LoadingContainer()
		{
			super();
		}
		
		public function get loading():Boolean
		{
			return __loading;
		}
		
		public function set loading( l:Boolean ):void
		{
			__loading = l;
			invalidateSkinState();
		}
		
		
		public function set loadingMessage( lm:String ):void
		{
			if( lm != __loadingMessage )
			{
				__loadingMessage = lm;
				if( loadingMessageLabel ) loadingMessageLabel.text = loadingMessage;
			}
		}
		
		public function get loadingMessage():String
		{
			return __loadingMessage;
		}
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded( partName, instance );
			
			if( instance == loadingMessageLabel ) loadingMessageLabel.text = loadingMessage;
		}
		
		override protected function getCurrentSkinState():String
		{
			if( loading )
			{
				return "loading";
			}
			else
			{
				return "normal";
			}
		}
	}
}