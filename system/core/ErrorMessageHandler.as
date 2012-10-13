package com.desktop.system.core
{
	public class ErrorMessageHandler
	{
		public function ErrorMessageHandler()
		{
		}
		
		public static function getMessageKeyString( code:int ):String
		{
			if( !code || code == 0 ) return null;
			
			
			var err:String;
			
			switch( code )
			{
				case ErrorCodes.SERVER_FAILED():
					
						err =  'serverError';
				break;
				
				case ErrorCodes.INVALID_INPUT():
						
						err =  'invalidInput';
				break;
				
				case ErrorCodes.USER_OR_PASS_WRONG():
					
						err = 'credErr';
				break;
				
				case ErrorCodes.ACCESS_DENIED():
						
						err = 'accessDenied';
				break;
				
				case ErrorCodes.APP_ERROR():
						
						err = 'programError';
				break;
				
				case ErrorCodes.DATABASE_ERROR():
						
						err =  'databaseError';
				break;
				
				default:
						err = 'myResources', 'programError';
				break;
				
			}
			
			return err;
		}
	}
}