package com.desktop.system.Application.Library.ui
{
	import mx.core.mx_internal;
	use namespace mx_internal;
	
	import mx.containers.VDividedBox;
	import mx.managers.CursorManager;
	import mx.managers.CursorManagerPriority;
	import mx.containers.dividedBoxClasses.BoxDivider;
	
	public class VerticalDivideBox extends VDividedBox
	{
		private var cursorID:int = CursorManager.NO_CURSOR;
		
		public function VerticalDivideBox()
		{
			super();
		}
		
		override mx_internal function changeCursor( divider:BoxDivider ):void
		{
			if ( cursorID == CursorManager.NO_CURSOR  )
			{
				// If a cursor skin has been set for the specified BoxDivider,
				// use it. Otherwise, use the cursor skin for the DividedBox.
				var cursorClass:Class = getStyle("verticalDividerCursor") as Class;
				
				cursorID = CursorManager.setCursor( cursorClass,CursorManagerPriority.HIGH, 0, -10 );
			}
		}
		
		/**
		 *  @private
		 */
		override mx_internal function restoreCursor():void
		{
			if ( cursorID != CursorManager.NO_CURSOR )
			{
				cursorManager.removeCursor(cursorID);
				cursorID = CursorManager.NO_CURSOR;
			}
		}
	}
}