package com.desktop.system.core
{
	public class AdvancedArray extends Array
	{
		public function AdvancedArray(...parameters)
		{
			super(parameters);
		}
		
		public function existsFromTo( from:uint, to:uint ):Boolean
		{
			if( length - 1 < to ) return false;
			
			for( var i:uint = from; i < to; i++ )
			{
				if( this[ i ] == undefined || this[ i ] == null )
				{
					return false;
				}
			}
				
			return true;
		}
		
		public function getItemIndex(item:Object):int
		{
			for (var i:int = 0; i < length; i++)
			{
				if (this[i] === item)
					return i;
			}
			
			return -1;           
		}
	}
}