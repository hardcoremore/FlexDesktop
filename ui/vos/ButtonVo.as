package com.desktop.ui.vos
{
	import com.desktop.system.vos.LoadResourceRequestVo;
	
	import mx.core.IVisualElement;

	public class ButtonVo
	{
		private var __id:String;
		public function get id():String
		{
			return __id;
		}
		
		public function set id( bid:String ):void
		{
			if( ! __id )
				__id = bid;
		}
		
		
		public var x:Number;
		public var y:Number;
		public var label:String;
		public var icon:Class;
		public var iconUrl:String;
		public var labelVisible:Boolean;
		public var controllComponent:IVisualElement;
		public var resource:LoadResourceRequestVo;
		
		
		public function ButtonVo( x:Number = 0, y:Number = 0, label:String = null, resource:LoadResourceRequestVo = null)
		{
			this.x = x;
			this.y = y;
			this.label = label;
			
			this.resource = resource; 
		}
	}
}