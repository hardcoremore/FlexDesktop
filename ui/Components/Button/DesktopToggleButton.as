package com.desktop.ui.Components.Button
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.states.State;
	

	[SkinState("active")]
	
	[SkinState("activeOver")]
	
	[SkinState("activeDown")]
	
	public class DesktopToggleButton extends DesktopButton
	{
		/**
		 *  @private
		 */
		
		private var _currentButtonSkinState:String;
		
		/**
		 *  @private
		 */
		private var _activeState:State;
		
		/**
		 *  @private
		 */
		private var _previousState:String;
		
		public function get previousState():String
		{
			return _previousState;
		}
		
		public function DesktopToggleButton()
		{
			super();
		}
		
		override protected function getCurrentSkinState():String
		{
			return _currentButtonSkinState;
		}
		
		override public function set currentState(value:String):void
		{
			setCurrentState(value);
			
			if( currentState == 'active' )
			{
				_currentButtonSkinState = 'active';
			}else if( currentState == 'inactive' )
			{
				_currentButtonSkinState = 'up';
			}
			
			invalidateSkinState();
			
		}
		
		override protected function mouseEventHandler(event:Event):void
		{
			var mouseEvent:MouseEvent = event as MouseEvent;
			
			switch( mouseEvent.type )
			{
				case MouseEvent.CLICK:
						
					if( currentState == 'active' )
					{
						_currentButtonSkinState = 'over';
						
						_previousState = currentState;
						currentState = 'inactive';
					}else{
						
						_previousState = currentState;
						currentState = 'active';
						_currentButtonSkinState = 'activeOver';
					}
				break;
				
				case MouseEvent.MOUSE_DOWN:
						currentState == 'active' ? _currentButtonSkinState = 'activeDown' : _currentButtonSkinState = 'down';
				break;
				
				case MouseEvent.MOUSE_OVER:
						currentState == 'active' ? _currentButtonSkinState = 'activeOver' : _currentButtonSkinState = 'over';
				break;
				
				case MouseEvent.ROLL_OVER:
						currentState == 'active' ? _currentButtonSkinState = 'activeOver' : _currentButtonSkinState = 'over';
				break;
				
				case MouseEvent.MOUSE_OUT:
						currentState == 'active' ? _currentButtonSkinState = 'active' : _currentButtonSkinState = 'up';
				break;
				
				case MouseEvent.ROLL_OUT:
						currentState == 'active' ? _currentButtonSkinState = 'active' : _currentButtonSkinState = 'up';
				break;
								
			}
			
			super.mouseEventHandler(event);
			
			invalidateSkinState();
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			_activeState = new State();
			_activeState.name = 'active';
			states.push( _activeState );
			
			_activeState = new State();
			_activeState.name = 'inactive';
			states.push( _activeState );
			
			
		}
		
	}
}