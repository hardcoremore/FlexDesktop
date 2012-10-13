package com.desktop.ui.vos
{
	import com.desktop.system.interfaces.IResourceHolder;
	
	import mx.core.IVisualElement;
	import mx.core.UIComponent;

	public class ResourceHolderVo
	{
		public var id:String;
		public var x:Number;
		public var y:Number;
		
		public var width:Number;
		public var height:Number;
		
		public var maximizable:Boolean;
		public var minimizable:Boolean;
		public var resizable:Boolean;
		
		public var maximized:Boolean;
		
		public var child:Boolean;
		public var parent:IResourceHolder;
		
		public var titleBarIcon:Class;
		
		public var title:String;
		
		public var hideOnClose:Boolean;
		
		public var cObject:IVisualElement;
		
		public function ResourceHolderVo()
		{
		}
	}
}