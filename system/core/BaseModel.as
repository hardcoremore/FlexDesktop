package com.desktop.system.core
{
	import com.desktop.system.core.service.ServiceLoader;
	import com.desktop.system.core.service.events.ServiceEvent;
	import com.desktop.system.events.ModelDataChangeEvent;
	import com.desktop.system.interfaces.IServiceReqester;
	import com.desktop.system.interfaces.IServiceReturnData;
	import com.desktop.system.utility.ModelReadParameters;
	import com.desktop.system.utility.SystemUtility;
	import com.desktop.system.vos.ModelOperationResponseVo;
	import com.desktop.system.vos.ReadVo;
	import com.desktop.system.vos.ResourceConfigVo;
	import com.desktop.system.vos.WebServiceRequestVo;
	import com.desktop.ui.vos.ResourceHolderVo;
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.net.URLVariables;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	
	import mx.collections.ArrayList;
	import mx.collections.IList;
	import mx.collections.XMLListCollection;
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;
	
	import vos.DataHolderColumnVo;
	
	public class BaseModel extends EventDispatcher
	{
		private var __resourceConfig:ResourceConfigVo;
		private static var __resourceManager:IResourceManager;
		private static var __session:SystemSession;
		
		public static const CURRENCY_TYPE_RSD:uint = 1;  
		public static const CURRENCY_TYPE_DOLLAR:uint = 2;
		public static const CURRENCY_TYPE_EUR:uint = 3;  
		public static const CURRENCY_TYPE_KM:uint = 4;  
		
		public static const STATUS_OK:String 			= 'ok';
		public static const STATUS_WARNING:String 		= 'warning';
		public static const STATUS_ERROR:String 		= 'error';
		
		public static const SORT_DIRECTION_ASCENDING:String = "asc";
		public static const SORT_DIRECTION_DESCENDING:String = "desc";
		
		private static var __currencyDataProvider:ArrayList;
		private static var __monthsListDataProvider:ArrayList;
		private static var __yearsListDataProvider:ArrayList;
		private static var __weekDaysList:ArrayList;
		private static var __countryDataProvider:ArrayList;
		private static var __monthNames:Array;
		
		private var __queeLoaderId:uint;
		
		public function get resourceConfig():ResourceConfigVo
		{
			return __resourceConfig;
		}
		
		public function set queeLoaderId( id:uint ):void
		{
			__queeLoaderId = id;
		}
		
		public function get queeLoaderId():uint
		{
			return __queeLoaderId;
		}
		
		public function BaseModel( resourceConfigVo:ResourceConfigVo, target:IEventDispatcher=null )
		{
			super(target);
			
			__resourceConfig = resourceConfigVo;
			__resourceManager = ResourceManager.getInstance();
			__session = SystemSession.instance;
		}
		
		public static function createConfigResourceHolderVo( moduleName:String = '' ):ResourceHolderVo
		{
			var rh:ResourceHolderVo = new ResourceHolderVo();
				rh.title = moduleName + ' ' + resourceManager.getString( session.config.LOCALE_CONFIG.dictonaryResourceName, 'config');
				rh.titleBarIcon = resourceManager.getClass( session.config.LOCALE_CONFIG.systemIconsResourceName, 'settingsIcon', session.skinsLocaleName );
				rh.maximizable = true;
				rh.minimizable = false;
				rh.hideOnClose = true;
				rh.resizable = true;
				rh.child = true;
				
			return rh;
		}
			
		public static function getStringBoolean( value:String ):Boolean
		{
			switch( value )
			{
				case "true":
					return true;
					
				case "false":
					return false;
					
				case "1":
					return true;
				
				case "0":
					return false;
				
				case "yes":
					return true;
					
				case "no":
					return false;
					
				default:
				
					return value && value.length > 0;
			}
		}
			
		public static function formatDate( format:String, date:Date ):String
		{
			if( ! date || ! format ) return "";
			
			format = format.replace( "YYYY", date.fullYear.toString() ).replace( 'MM',  ( date.month + 1 ).toString() ).replace( "DD",  date.date.toString() );
			
			return format;
			
		}
		
		public static function get currencyDataProvider():ArrayList
		{
			if( ! __currencyDataProvider )
			{
				__currencyDataProvider = new ArrayList();
				__currencyDataProvider.addItem( { value: 1, label: 'RSD' } );
				__currencyDataProvider.addItem( { value: 2, label: 'US DOLLAR' } );
				__currencyDataProvider.addItem( { value: 3, label: 'EUR' } );
				__currencyDataProvider.addItem( { value: 4, label: 'KM' } );
			}
			
			return __currencyDataProvider;
		}
		
		public static function get weekDaysDataProvider():ArrayList
		{
			if( ! __weekDaysList )
			{
				__weekDaysList = new ArrayList();
				__weekDaysList.addItem( { value: 1, label: resourceManager.getString( session.config.LOCALE_CONFIG.dictonaryResourceName, 'monday') } );
				__weekDaysList.addItem( { value: 2, label: resourceManager.getString( session.config.LOCALE_CONFIG.dictonaryResourceName, 'tuesday') } );
				__weekDaysList.addItem( { value: 3, label: resourceManager.getString( session.config.LOCALE_CONFIG.dictonaryResourceName, 'wednesday') } );
				__weekDaysList.addItem( { value: 4, label: resourceManager.getString( session.config.LOCALE_CONFIG.dictonaryResourceName, 'thursday') } );
				__weekDaysList.addItem( { value: 5, label: resourceManager.getString( session.config.LOCALE_CONFIG.dictonaryResourceName, 'friday') } );
				__weekDaysList.addItem( { value: 6, label: resourceManager.getString( session.config.LOCALE_CONFIG.dictonaryResourceName, 'saturday') } );
				__weekDaysList.addItem( { value: 7, label: resourceManager.getString( session.config.LOCALE_CONFIG.dictonaryResourceName, 'sunday') } );
			}
				
			return __weekDaysList;
		}
		
		public static function get monthsDataProvider():ArrayList
		{
			if( ! __monthsListDataProvider )
			{
				__monthsListDataProvider = new ArrayList();
				
				var c:uint = 1;
				for each( var month:String in monthNames )
				{
					__monthsListDataProvider.addItem( { value:c, label:month } );
					c++;
				}
				
			}
			
			return __monthsListDataProvider;
		}
		
		public static function get yearsDataProvider():ArrayList
		{
			if( ! __yearsListDataProvider )
			{
				__yearsListDataProvider = new ArrayList();
				
				for( var c:uint = 2008; c < 2100; c++ )
				{
					__yearsListDataProvider.addItem( { value:c, label:c } );
				}
				
			}
			
			return __yearsListDataProvider;
		}
		
		public static function get countryDataProvider():ArrayList
		{
			if( ! __countryDataProvider )
			{
				__countryDataProvider = new ArrayList();
				__countryDataProvider.addItem( { value: 1, label: 'Srbija' } );
				__countryDataProvider.addItem( { value: 2, label: 'Crna Gora' } );
				__countryDataProvider.addItem( { value: 3, label: 'Bosna' } );
				__countryDataProvider.addItem( { value: 4, label: 'Makedonija' } );
				__countryDataProvider.addItem( { value: 5, label: 'Slovenija' } );
				__countryDataProvider.addItem( { value: 6, label: 'Bugarska' } );
				__countryDataProvider.addItem( { value: 7, label: 'Madjarska' } );
				__countryDataProvider.addItem( { value: 8, label: 'Italija' } );
				__countryDataProvider.addItem( { value: 9, label: 'Austrija' } );
				__countryDataProvider.addItem( { value: 10, label: 'Hrvatska' } );
				__countryDataProvider.addItem( { value: 11, label: 'Rumunija' } );
				__countryDataProvider.addItem( { value: 12, label: 'Grcka' } );
				__countryDataProvider.addItem( { value: 13, label: 'Nemacka' } );
				__countryDataProvider.addItem( { value: 14, label: 'Francuska' } );				
				__countryDataProvider.addItem( { value: 15, label: 'Australija' } );
				__countryDataProvider.addItem( { value: 16, label: 'Albanija' } );
				
			}
			
			return __countryDataProvider;
		}
		
		public static function getWeekDayLabelFromNumber( num:int ):String
		{
			var o:Object;
			for( var i:uint = 0; i < weekDaysDataProvider.length; i++ )
			{
				o = weekDaysDataProvider.getItemAt( i );
				if( o.value == num )
				{ 
					return o.label.toString();
				}
			}
			
			return "";
		}
		
		public static function get monthNames():Array
		{
				
			if( ! __monthNames )
			{
				__monthNames = new Array();
				
				__monthNames[0] = resourceManager.getString( session.config.LOCALE_CONFIG.dictonaryResourceName, 'january');
				__monthNames[1] = resourceManager.getString( session.config.LOCALE_CONFIG.dictonaryResourceName, 'february');
				__monthNames[2] = resourceManager.getString( session.config.LOCALE_CONFIG.dictonaryResourceName, 'march');
				__monthNames[3] = resourceManager.getString( session.config.LOCALE_CONFIG.dictonaryResourceName, 'april');
				__monthNames[4] = resourceManager.getString( session.config.LOCALE_CONFIG.dictonaryResourceName, 'may');
				__monthNames[5] = resourceManager.getString( session.config.LOCALE_CONFIG.dictonaryResourceName, 'june');
				__monthNames[6] = resourceManager.getString( session.config.LOCALE_CONFIG.dictonaryResourceName, 'july');
				__monthNames[7] = resourceManager.getString( session.config.LOCALE_CONFIG.dictonaryResourceName, 'august');
				__monthNames[8] = resourceManager.getString( session.config.LOCALE_CONFIG.dictonaryResourceName, 'september');
				__monthNames[9] = resourceManager.getString( session.config.LOCALE_CONFIG.dictonaryResourceName, 'october');
				__monthNames[10] = resourceManager.getString( session.config.LOCALE_CONFIG.dictonaryResourceName, 'november');
				__monthNames[11] = resourceManager.getString( session.config.LOCALE_CONFIG.dictonaryResourceName, 'december');
			
			}
			
			return __monthNames;
		}
			
		public static function get resourceManager():IResourceManager
		{
			return __resourceManager;
		}
		
		public static function get session():SystemSession
		{
			return __session;
		}
		
		
		
		public function buildUrlVarialbesFromAssociateArray( array:Array, prefix:String ):URLVariables
		{
			var urlv:URLVariables = new URLVariables();

			var o:Object;			
			var props:Array;
			var name:String;
			
			for( var i:int = 0; i < array.length; i++ )
			{
				o = array[i];
				props = SystemUtility.getObjectProperties( o );
			
				for each( var p:Object in props )
				{
					name = prefix;
					name += i.toString() + resourceConfig.postArrayDelimiter + p.name;
					urlv[ name ] = o[ p.name ];
				}	
			}
			
			return urlv;
		}
					
		protected function _startOperation( web:WebServiceRequestVo, service:ServiceLoader ):void
		{
			service.name = web.action;
			service.addEventListener( ServiceEvent.COMPLETE, _finishOperation );
			service.addEventListener( ServiceEvent.ERROR, _finishOperation );
			
			var e:ModelDataChangeEvent = new ModelDataChangeEvent( ModelDataChangeEvent.MODEL_LOADING_DATA );
			e.operationName = web.action;
			e.requester = service.requester;
			
			dispatchEvent( e );
			
			if( service.requester )
				service.requester.modelLoadingData( e );
			
			service.loadService( web, resourceConfig );
			
		}
		
		protected function _finishOperation( serviceEvent:ServiceEvent, dispatch:Boolean = true ):ModelOperationResponseVo
		{
			serviceEvent.target.removeEventListener( ServiceEvent.COMPLETE, _finishOperation );
			serviceEvent.target.removeEventListener( ServiceEvent.ERROR, _finishOperation );
			
			var response:ModelOperationResponseVo = _getOperationFromServiceResponse( serviceEvent.response, new ModelOperationResponseVo() );
			var type:String;
			var func:String;
			
			if( dispatch )
			{
				_dispatchOperationResponse( serviceEvent, response );
			}
			
			return response;
		}
		
		protected function _dispatchOperationResponse( serviceEvent:ServiceEvent, response:ModelOperationResponseVo ):void
		{
			var type:String;
			var func:String;
			
			var e:ModelDataChangeEvent;
			var service:ServiceLoader = serviceEvent.target as ServiceLoader;
			
			if( response.status == STATUS_OK && serviceEvent.type == ServiceEvent.COMPLETE )
			{
				type = ModelDataChangeEvent.MODEL_LOADING_DATA_COMPLETE;
				func = "modelLoadingDataComplete";
			}
			else if( serviceEvent.type == ServiceEvent.ERROR )
			{
				type = ModelDataChangeEvent.MODEL_LOADING_DATA_ERROR;
				func = "modelLoadingDataError";
			}
			else
			{
				type = ModelDataChangeEvent.MODEL_LOADING_DATA_ERROR;
				func = "modelLoadingDataError";
			}
			
			e = new ModelDataChangeEvent( type );
			e.operationName =  service.name;
			e.response = response;
			e.requester = service.requester;
			
			dispatchEvent( e );
			
			if( service.requester && func )
				service.requester[ func ].call( func, e );
		}
			
		protected function _getUrlVariablesFromVo( o:Object ):URLVariables
		{
			var urlv:URLVariables = new URLVariables();
			
			var k:*;
			
				if( o is ReadVo )
				{
					var r:ReadVo = o as ReadVo;
					
					urlv[ ModelReadParameters.PAGE_NUMBER ] = r.pageNum;
					urlv[ ModelReadParameters.ROWS_PER_PAGE ] = r.numRows;
					urlv[ ModelReadParameters.SORT_COLUMN_NAME ] = r.sortColumnName;
					urlv[ ModelReadParameters.SORT_DIRECTION ] = r.sortColumnDirection;
					urlv[ ModelReadParameters.DATA_TYPE ] = r.data_type;
					
					if( r.is_search )
					{
						urlv[ ModelReadParameters.SEARCH_IS_ON ] = true;
						var sp:Object  = buildUrlVarialbesFromAssociateArray( r.search_paramters, ModelReadParameters.SEARCH_PARAMETERS );
						
						for( k in sp )
						{
							urlv[ k ] = sp[ k ];
						}
					}
				}
				else
				{
					var props:Array = SystemUtility.getObjectProperties( o );
					
					for each( var p:Object in props )
					{
						urlv[ p.name ] = o[ p.name ];
					}
				}
			
			return urlv;
		}
		
		protected function _getOperationFromServiceResponse( response:IServiceReturnData, operation:ModelOperationResponseVo ):ModelOperationResponseVo
		{
			if( response && operation )
			{
				operation.status = response.metadata.status;
				operation.errorCode = response.metadata.errorCode;
				operation.message = response.metadata.message;
				operation.metadata = response.metadata;
				
				if( response.metadata.errorCode == 0 && response.metadata.status == STATUS_OK )
				{
					operation.result = response.data;
					
					if( response.metadata.hasOwnProperty( "totalRows" ) )
					{
						operation.totalRows = response.metadata.totalRows;
					}
					if( response.metadata.hasOwnProperty( "numRows" ) )
					{
						operation.numRows = response.metadata.numRows;
					}
				}
			}
			else
			{
				throw new Error( "Invalid response or operation at BaseModel::_getOperationFromServiceResponse()" );
			}
			
			return operation;
		}
		
	}
}