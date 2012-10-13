package com.desktop.system.core
{
	import com.desktop.system.events.ModelDataChangeEvent;
	import com.desktop.system.events.ModuleEvent;
	import com.desktop.system.events.NotificationResponseEvent;
	import com.desktop.system.interfaces.IConfig;
	import com.desktop.system.interfaces.IModuleBase;
	import com.desktop.system.interfaces.INotification;
	import com.desktop.system.interfaces.INotifier;
	import com.desktop.system.interfaces.IResourceHolder;
	import com.desktop.system.interfaces.IServiceReqester;
	import com.desktop.system.utility.CommonErrorType;
	import com.desktop.system.utility.CrudOperations;
	import com.desktop.system.vos.ModelOperationResponseVo;
	import com.desktop.system.vos.NotificationVo;
	import com.desktop.ui.Components.Button.DesktopControllButton;
	import com.desktop.ui.Components.Group.LoadingContainer;
	import com.desktop.ui.Components.Group.ModuleNotification;
	import com.desktop.ui.vos.ResourceHolderVo;
	
	import components.Paging;
	import components.app.SaveData;
	
	import factories.ModelFactory;
	
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	import models.SystemModel;
	
	import mx.collections.ArrayList;
	import mx.collections.IList;
	import mx.collections.XMLListCollection;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.core.EventPriority;
	import mx.events.FlexEvent;
	
	import spark.components.ComboBox;
	import spark.components.DataGrid;
	import spark.components.gridClasses.GridColumn;
	import spark.components.supportClasses.ListBase;
	import spark.components.supportClasses.SkinnableComponent;
	import spark.modules.Module;
	
	import vos.DataHolderColumnVo;
	
	[Style(name="fontSize", inherit="yes", type="String")]
	
	public class SystemModuleBase extends Module implements IModuleBase, INotifier, IServiceReqester
	{
		private var __resourceHolder:IResourceHolder;
		private var __config:IConfig;
		private var __mode:uint;
		private var __created:Boolean = false;
		private var __rhc:ResourceHolderVo;
		private var __data:Object;
		private var __currentReadData:ModelOperationResponseVo;
		
		protected var _configResourceHolder:IResourceHolder;
		
		[SkinPart(required="false")]
		public var saveDataCmp:SaveData;
		
		[SkinPart(required="false")]
		public var notifier:ModuleNotification;
		
		[SkinPart(required="false")]
		public var loadingContainer:LoadingContainer;
		
		[SkinPart(required="false")]
		public var configButton:DesktopControllButton;
		
		private var __systemModel:SystemModel;
		
		public function SystemModuleBase()
		{
			super();
			__systemModel = ModelFactory.systemModel();
			addEventListener( FlexEvent.CREATION_COMPLETE, _creationComplete, false, 0, true );
		}
	
		public function init():void
		{
			top = 0;
			left = 0;
			right = 0;
			bottom = 0;	 
		}
		
		public function get systemModel():SystemModel
		{
			return __systemModel;
		}
		
		public function get currentReadData():ModelOperationResponseVo
		{
			return __currentReadData;
		}
		
		public function get created():Boolean
		{
			return __created;
		}
		
		public function set mode( m:uint ):void
		{
			__mode = m;
		}
		
		public function get mode():uint
		{
			return __mode;
		}
		
		public function set data( d:Object ):void
		{
			__data = d;	
		}
		
		public function get data():Object
		{
			return __data;
		}
		
		public function get session():SystemSession
		{
			return  SystemSession.instance;
		}
		
		public function get allowMultipleInstances():Boolean
		{
			return false;
		}
		
		public function set acl(value:Array):void
		{
		}
		
		public function get acl():Array
		{
			return null;
		}
		
		public function get resourceHolderConfig():ResourceHolderVo
		{
			return __rhc;
		}
		
		public function set resourceHolderConfig( rhc:ResourceHolderVo ):void
		{
			__rhc = rhc;
		}
		
		public function set resourceHolder(rh:IResourceHolder):void
		{
			if( __resourceHolder != rh )
			{
				__resourceHolder = rh;
				if( resourceHolder ) resourceHolder.beforeCloseFunction = this._beforeClose;
				
				dispatchEvent( new ModuleEvent( ModuleEvent.RESOURCE_HOLDER_CHANGE ) ); 
			}
		}
		
		public function get resourceHolder():IResourceHolder
		{
			return __resourceHolder;
		}
		
		public function notify( nvo:NotificationVo ):INotification
		{
			if( notifier )
			{
				notifier.data = nvo;
				notifier.show();
				return notifier;
			}
			else
			{
				return null;
			}
		}
		
		public function modelLoadingData( event:ModelDataChangeEvent ):void
		{
			if( loadingContainer )
				loadingContainer.loading = true;
		}
		
		public function modelLoadingDataComplete( event:ModelDataChangeEvent ):void
		{
			if( loadingContainer )
				loadingContainer.loading = false;
		}
		
		public function modelLoadingDataError( event:ModelDataChangeEvent ):void
		{
			if( loadingContainer )
				loadingContainer.loading = false;
			
			notifyCommonError( CommonErrorType.SERVER, event.operationName );
		}
		
		public function addRowToDataProvider( cmp:Object, data:Object ):void
		{
			if( ! cmp ) return;
			
			var dp:IList = cmp.dataProvider;
			
			if( ! dp )
			{
				dp = new ArrayList();
				cmp.dataProvider = dp;
			}
			
			dp.addItem( data );
		}
		
		public function setLoadingComboBox( cb:ComboBox ):void
		{
			if( ! cb ) return;
			
			cb.textInput.text = resourceManager.getString( this.session.config.LOCALE_CONFIG.dictonaryResourceName, "loading" ) + "...";
		}
		
		public function unload():void
		{
			resourceHolder = null;
			
			dispatchEvent( new ModuleEvent( ModuleEvent.MODULE_UNLOAD ) );
		}
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded( partName, instance );
			
			if( instance == notifier )
			{
				notifier.addEventListener( NotificationResponseEvent.NOTIFICATION_RESPONSE_EVENT, _notificationResponseEvent, false, EventPriority.DEFAULT );
			}
			else if( instance == configButton )
			{
				configButton.addEventListener( MouseEvent.CLICK, _configButtonClickEventHandler );
			}
		}
		
		protected function _configButtonClickEventHandler( event:MouseEvent ):void
		{
			if( ! _configResourceHolder )
			{
				var rhc:ResourceHolderVo = BaseModel.createConfigResourceHolderVo( resourceManager.getString( this.session.config.LOCALE_CONFIG.dictonaryResourceName, "customers" ) );
					rhc.parent = resourceHolder;
				
					_configResourceHolder = resourceHolder.desktop.addResourceHolder( rhc );
			}
		}
		
		protected function _notificationResponseEvent( event:NotificationResponseEvent ):void
		{
			
		}
		
		protected function _updateReadData( readData:ModelOperationResponseVo, dataHolder:Object, paging:Paging = null, sdc:SaveData = null ):void
		{				
			__currentReadData = readData;
			
			if( readData.status == BaseModel.STATUS_OK )
			{
				dataHolder.dataProvider = null;
				dataHolder.dataProvider = readData.result;
				
				if( dataHolder is ComboBox )
					( dataHolder as ComboBox ).textInput.text = "";
				
				if( paging )
				{
					paging.TOTAL_PAGE_COUNT = Math.ceil( readData.totalRows / paging.rowsPerPage );
					if( paging.TOTAL_PAGE_COUNT == 0 && readData.totalRows > 0 ) paging.TOTAL_PAGE_COUNT = 1;	
				}
				
				if( sdc ) 
				{
					sdc.previewDataIndex = 0;
					sdc.previewDataLength = readData.numRows;
				}
			}
		}
		
		protected function _setupOrder( dataHolder:SkinnableComponent, paging:Paging ):void
		{
			if( dataHolder && paging )
			{
				var c:IList = ( dataHolder as DataGrid ).columns;	
				
				if( ! c ) return;
				
				var odp:ArrayList = new ArrayList();
				var oc:Object;
				var gc:GridColumn;
				
				for ( var i:int = 0; i < c.length; i++ )
				{
					gc = c.getItemAt( i ) as GridColumn;
					
					oc = new Object();
					oc.label = gc.headerText;
					oc.value = gc.dataField;
					
					odp.addItem( oc );
				}
				
				paging.orderColumnsList.dataProvider = odp;
				paging.orderColumnsList.selectedIndex = 0;
				paging.sortColumnDirection = BaseModel.SORT_DIRECTION_DESCENDING;
			}
		}
		
		
		protected function _creationComplete( event:FlexEvent ):void
		{
			__created = true;
			event.target.removeEventListener( FlexEvent.CREATION_COMPLETE, _creationComplete );
			
			if( saveDataCmp )
			{
				if( mode == CrudOperations.CREATE )
				{
					saveDataCmp.contentGroup.removeElement( saveDataCmp.leftButton );
					saveDataCmp.contentGroup.removeElement( saveDataCmp.rightButton );
				}
				else if( mode == CrudOperations.UPDATE )
				{
					saveDataCmp.contentGroup.removeElement( saveDataCmp.resetButton );
				}
			}
		}
		
		public function notifyCommonError( type:uint, operationName:String ):void
		{
			var nvo:NotificationVo = new NotificationVo();
				nvo.icon = resourceManager.getClass( this.session.config.LOCALE_CONFIG.systemIconsResourceName, 'deleteErrorIcon', session.skinsLocaleName );
				nvo.title = resourceManager.getString( this.session.config.LOCALE_CONFIG.dictonaryResourceName, "error" );
				nvo.okButton = true;
				nvo.id = operationName;
				
				switch( type )
				{
					case CommonErrorType.SERVER:	
						nvo.text = resourceManager.getString( this.session.config.LOCALE_CONFIG.messagesResourceName, "serverError" );
					break;
					
					case CommonErrorType.PROGRAM:	
						nvo.text = resourceManager.getString( this.session.config.LOCALE_CONFIG.messagesResourceName, "programError" );
					break;
					
					case CommonErrorType.FORM_NOT_VALID:	
						nvo.text = resourceManager.getString( this.session.config.LOCALE_CONFIG.messagesResourceName, "invalidForm" );
					break;
					
					
				}
			
			notify( nvo );
		}
		
		public function setupDataGridColumns( defaultColumns:IList, customColumns:IList ):IList
		{
			if( defaultColumns && customColumns )
			{
				var newCols:ArrayList = new ArrayList();
				var oldCols:Dictionary = new Dictionary( true );
				var i:int;
				var col:DataHolderColumnVo;
				var oldCol:DataHolderColumnVo;
				
				for( i = 0; i < defaultColumns.length; i++ )
				{
					col = defaultColumns.getItemAt( i ) as DataHolderColumnVo;
					oldCols[ col.data_holder_column_data_field ] = col;
				}
			
				var customCol:DataHolderColumnVo;
				var translated:String;
				
				for( i = 0; i < customColumns.length; i++ )
				{
					customCol = customColumns.getItemAt( i ) as DataHolderColumnVo;
					translated = resourceManager.getString( this.session.config.LOCALE_CONFIG.dictonaryResourceName, customCol.data_holder_column_header_text );
					
					customCol.data_holder_header_text_translated = translated; 
						
					oldCol = oldCols[ customCol.data_holder_column_data_field ] as DataHolderColumnVo;
					
					oldCol.grid_column_object.visible = customCol.data_holder_column_visible == SystemModel.DATA_HOLDER_ITEM_VISIBLE_TRUE;
					oldCol.grid_column_object.headerText = customCol.data_holder_column_custom_header == SystemModel.DATA_HOLDER_CUSTOM_HEADER_TEXT_TRUE ?
										customCol.data_holder_column_custom_header_text : translated; 
					
					newCols.addItem( oldCol.grid_column_object );	
				}
				
				return newCols;
			}
			
			return null;
		}
		
		protected function _beforeClose():Boolean
		{
			return true;
		}
		
		protected function _createColumnVos( columns:IList ):ArrayList
		{
			if( ! columns || columns.length < 1 )
				return null;
			
			var cols:ArrayList = new ArrayList();
			
			var cvo:DataHolderColumnVo;
			var c:GridColumn;		
				
			for( var i:int = 0; i < columns.length; i++ )
			{
				c = columns.getItemAt( i ) as GridColumn;
				
				if( ! c ) continue;
				
				cvo = new DataHolderColumnVo();
				
				cvo.data_holder_column_data_field = c.dataField;
				cvo.data_holder_column_header_text = c.headerText;
				cvo.data_holder_column_position_index = i;
				cvo.data_holder_column_visible = c.visible == true ? 1 : 0;
				
				c.headerText = resourceManager.getString( this.session.config.LOCALE_CONFIG.dictonaryResourceName, c.headerText );
				
				cvo.data_holder_header_text_translated = c.headerText;
				
				cvo.grid_column_object = c;
				
				cols.addItem( cvo );
				
			}
			
			return cols;
		}
		
		
	}
}