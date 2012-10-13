package com.desktop.ui.vos
{
	import com.desktop.system.vos.LoadResourceRequestVo;

	public class IconVo
	{
		public var id:String;
		
		public var x:Number;
		public var y:Number;
		public var label:String;
		public var icon:Class;
		public var iconUrl:String;
		
		public var resource:LoadResourceRequestVo;
		
		public function IconVo( x:Number = 0, y:Number = 0, label:String = null, resource:LoadResourceRequestVo = null)
		{
			this.x = x;
			this.y = y;
			this.label = label;
			
			this.resource = resource; 
		}
	}
}