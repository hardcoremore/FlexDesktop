package com.desktop.ui.Components.Button
{
	import spark.components.Button;
	import spark.primitives.Rect;
	
	
	/**
	 *  If label is visible on task bar buttons.
	 */
	[Style(name="iconHeight", inherit="no", type="Number")]
	
	
	/**
	 *  If label is visible on task bar buttons.
	 */
	[Style(name="iconWidth", inherit="no", type="Number")]
	
	
	public class DesktopControllButton extends Button
	{
		[SkinPart(required='false')]
		public var fillPercent:Rect;
		
		private var __accessId:String;
		
		public function set accessId( val:String ):void
		{
			if( __accessId && __accessId.length > 0 )
				return;
			
			__accessId = val;
		}
		
		public function get accessId():String
		{
			return __accessId;
		}
		
		public function DesktopControllButton()
		{
			super();
		}
		
		public function set percent( value:Number ):void
		{
			if( fillPercent )
			{
				fillPercent.percentWidth = value;
			}
		}
	
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded( partName, instance );
			
			if( instance == iconDisplay )
			{
				iconDisplay.smooth = true;
				iconDisplay.smoothingQuality = "high";
			}
		}
		
		override public function styleChanged(styleProp:String):void
		{
			super.styleChanged( styleProp );
			
			if( styleProp == "iconWidth" || styleProp == "iconHeight" )
			{
				skin.invalidateSize();
				skin.invalidateDisplayList();
			}
		}
	}
}