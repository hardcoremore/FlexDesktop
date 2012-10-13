package com.desktop.ui.Components
{
	import spark.components.ToggleButton;
	
	public class DesktopControllComponent extends ToggleButton
	{
		public function DesktopControllComponent()
		{
			super();
		}
	
		protected var _previouslySelected:Boolean = false;
		
		public function set previouslySelected( value:Boolean ):void
		{
			_previouslySelected = value;
		}
		
		public function get previouslySelected():Boolean
		{
			return _previouslySelected;
		}
		
		override public function set selected(value:Boolean):void
		{
			previouslySelected = ! value;
			super.selected = value;
		}
		
		/**
		 *  Description: Object that this button is controlling. 
		 * 
		 *  @private
		 */
		private var _controlledObject:Object;
		
		
		public function set controlledObject(cObject:Object):void
		{
			_controlledObject = cObject;
		}
		
		public function get controlledObject():Object
		{
			return _controlledObject;
		}
		
		protected var _labelVisible:Boolean;
		
		public function set labelVisible(value:Boolean):void
		{
			_labelVisible = value;
		}
		
		public function get labelVisible():Boolean
		{
			return _labelVisible;
		}
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName,instance);
			
			if( instance == labelDisplay )
			{
				if( labelVisible )
				{
					labelDisplay.text = label;
				}
				else
				{
					labelDisplay.text = "";
				}
			}
			
			if( instance == iconDisplay )
			{
				iconDisplay.smooth = true;
			}
					
		}
		
		
	}
}