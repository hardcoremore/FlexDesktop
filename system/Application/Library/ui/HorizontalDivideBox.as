package com.desktop.system.Application.Library.ui
{
	import mx.core.mx_internal;
	use namespace mx_internal;
	
	import mx.containers.HDividedBox;
	import mx.managers.CursorManager;
	import mx.managers.CursorManagerPriority;
	import mx.containers.dividedBoxClasses.BoxDivider;
	
	public class HorizontalDivideBox extends HDividedBox
	{
		private var cursorID:int = CursorManager.NO_CURSOR;
		
		public function HorizontalDivideBox()
		{
			super();
		}
		
		override mx_internal function changeCursor( divider:BoxDivider ):void
		{
			if ( cursorID == CursorManager.NO_CURSOR )
			{
				// If a cursor skin has been set for the specified BoxDivider,
				// use it. Otherwise, use the cursor skin for the DividedBox.
				var cursorClass:Class = getStyle("horizontalDividerCursor") as Class;
				cursorID = cursorManager.setCursor( cursorClass, CursorManagerPriority.HIGH, -10, 0 );
			}
		}
		
		/**
		 *  @private
		 */
		override mx_internal function restoreCursor():void
		{
			if (cursorID != CursorManager.NO_CURSOR)
			{
				cursorManager.removeCursor(cursorID);
				cursorID = CursorManager.NO_CURSOR;
			}
		}
	}
}