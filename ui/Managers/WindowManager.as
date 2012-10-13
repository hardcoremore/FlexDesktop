package com.desktop.ui.Managers
{
	import com.desktop.ui.Components.Window.DesktopWindow;
	import com.desktop.ui.Controls.Events.DesktopWindowEvent;
	import com.desktop.ui.Interfaces.IDesktopWindowManager;
	
	import flash.events.MouseEvent;
	import flash.utils.getTimer;
	
	import mx.core.IVisualElement;
	import mx.core.IVisualElementContainer;
	
	import spark.components.Group;
	import spark.components.SkinnableContainer;
	
	public class WindowManager implements IDesktopWindowManager
	{
		protected var _windows:Vector.<DesktopWindow>;	
		
		protected var _front:DesktopWindow;
		
		protected var _all_minimized:Boolean = false;
		
		public function WindowManager()
		{
			_windows = new Vector.<DesktopWindow>();
		}
		
		public function register( window:DesktopWindow ):void
		{
			if(  ! isRegistered( window ) )
			{
				_windows.push( window );
				
				window.addEventListener( DesktopWindowEvent.RESTORE, 	_windowRestore );
				window.addEventListener( DesktopWindowEvent.MAXIMIZE, 	_windowMaximize );
				window.addEventListener( DesktopWindowEvent.SHOW, 		_windowShow );
				window.addEventListener( DesktopWindowEvent.CLOSE, 		_windowClose );
				window.addEventListener( DesktopWindowEvent.HIDE, 		_windowHide );
				window.addEventListener( DesktopWindowEvent.MINIMIZE, 	_windowMinimize );
				window.addEventListener( DesktopWindowEvent.TO_FRONT, 	_windowToFront );
				
			}
		}
		
		public function unregisterAll():void
		{
			for each( var w:DesktopWindow in _windows )
			{
				w.removeEventListener( DesktopWindowEvent.RESTORE, 		_windowRestore );
				w.removeEventListener( DesktopWindowEvent.MAXIMIZE, 	_windowMaximize );
				w.removeEventListener( DesktopWindowEvent.SHOW, 		_windowShow );
				w.removeEventListener( DesktopWindowEvent.CLOSE, 		_windowClose );
				w.removeEventListener( DesktopWindowEvent.HIDE, 		_windowHide );
				w.removeEventListener( DesktopWindowEvent.MINIMIZE, 	_windowMinimize );
				w.removeEventListener( DesktopWindowEvent.TO_FRONT, 	_windowToFront );
			}
			
			_windows = Vector.<DesktopWindow>();
			_front = null;
			_all_minimized = false;
		}
		
		public function unregister(window:DesktopWindow):void
		{
			var w:DesktopWindow;
			
			for( var i:uint = 0; i < _windows.length; i++ )
			{
				w = _windows[i];
				
				if( w == window )
				{
					_windows.splice(i, 1);
					
					w.removeEventListener( DesktopWindowEvent.RESTORE, 		_windowRestore );
					w.removeEventListener( DesktopWindowEvent.MAXIMIZE, 	_windowMaximize );
					w.removeEventListener( DesktopWindowEvent.SHOW, 		_windowShow );
					w.removeEventListener( DesktopWindowEvent.CLOSE, 		_windowClose );
					w.removeEventListener( DesktopWindowEvent.HIDE, 		_windowHide );
					w.removeEventListener( DesktopWindowEvent.MINIMIZE, 	_windowMinimize );
					w.removeEventListener( DesktopWindowEvent.TO_FRONT, 	_windowToFront );
					break;
				}
			}
		}
			
		public function isRegistered( window:DesktopWindow ):Boolean
		{
			if( ! _windows || _windows.length < 1 )
				return false;
			
			return _windows.indexOf( window ) != -1;
		}
		
		public function minimizeAll():void
		{
			if( _all_minimized ) return;
			
			for each( var w:DesktopWindow in _windows )
			{
				if( w.isChild )
				{
					w.hide();
				}
				else
				{
					w.minimize();
				}
				
			}
			
			_all_minimized = true;
			_front = null;
		}
		
		public function bringToFront( window:DesktopWindow ):void
		{	
			if( ! window ) return;
			
			var parent:IVisualElementContainer = window.parent as IVisualElementContainer; 
			
			if( _front != window && parent )
			{
				_all_minimized = false;
				
				window.visible = false;
				window.skin.visible = false;
				
				parent.setElementIndex( window, parent.numElements - 1 );
				
				window.visible = true;
				window.skin.visible = true;
				
				if( _front )
					_front.active = false;
				
				window.active = true;
				_front = window;
			}
			
			
			if( window.childWindows && parent )
			{
				var cw:DesktopWindow;
				for( var i:uint = 0; i < window.childWindows.length; i++ )
				{
					cw = window.childWindows[ i ];
					
					if( ! cw.userHidden )
					{
						cw.show();
						cw.active = false;
						parent.setElementIndex( cw, parent.numElements - 1 );
					}
				}
			}
			
		}
		
		public function sendToBack(window:DesktopWindow):void
		{
		}
		
		public function getActive():DesktopWindow
		{
			return _front;
		}
		
		public function getWindows():Vector.<DesktopWindow>
		{
			return _windows;
		}
		
		
		/*********************************
		 * 
		 *  WINDOW EVENTS
		 * 
		 *********************************/
		
		protected function _windowToFront( event:DesktopWindowEvent ):void
		{
			bringToFront( event.desktopWindow );
		}
		
		protected function _windowRestore( event:DesktopWindowEvent ):void
		{
			_all_minimized = false;
		}
		
		protected function _windowMaximize ( event:DesktopWindowEvent ):void
		{
		}
		
		protected function _windowShow ( event:DesktopWindowEvent ):void
		{
		}
		
		protected function _windowClose ( event:DesktopWindowEvent ):void
		{
		}
		
		protected function _windowHide ( event:DesktopWindowEvent ):void
		{
		}
		
		protected function _windowMinimize ( event:DesktopWindowEvent ):void
		{
			
			
			
		}
	}
}
