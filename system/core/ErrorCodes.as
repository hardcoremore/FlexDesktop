package com.desktop.system.core
{
	public class ErrorCodes
	{
		public static function SERVER_FAILED():int
		{
			return 1000;
		}
		
		public static function INVALID_INPUT():int
		{
			return 2000;
		}
		
		public static function USER_OR_PASS_WRONG():int
		{
			return 2500;
		}
		
		public static function ACCESS_DENIED():int
		{
			return 3000;
		} 
		
		public static function APP_ERROR():int
		{
			return 4000;
		}
		
		public static function DATABASE_ERROR():int
		{
			return 5000;
		}
	}
}