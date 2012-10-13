package com.desktop.ui.Components.Group
{
	import spark.components.SkinnableContainer;
	
	/**
	 *  Normal State of the DesktopContainer
	 */
	[SkinState("normal")]
	
	/**
	 *  Disabled State of the DesktopContainer
	 */
	[SkinState("disabled")]
	
	/**
	 *  Maked State of the DesktopContainer. When DesktopContainer is in masked state loading 
	 * icon and label apear above all and mouse is disabled. 
	 */
	[SkinState("masked")]
	
	
	
	public class DesktopContainer extends SkinnableContainer
	{
		private var __maskedForLoading:Boolean;
		
		public function set maskedForLoading(value:Boolean):void
		{
			if( __maskedForLoading != value )
			{
				__maskedForLoading = value;
				
				if( value )
				{
					mouseEnabled = false;
				}
				else
				{
					mouseEnabled = true;
				}
				
				invalidateSkinState();
			}
		}
		
		public function get maskedForLoading():Boolean
		{
			return __maskedForLoading;
		}
		
		override protected function getCurrentSkinState():String
		{
			if( __maskedForLoading )
			{
				return "masked";
			}
			else
			{
				return "normal";
			}
		}
		
		public function DesktopContainer()
		{
			super();
		}
	}
}