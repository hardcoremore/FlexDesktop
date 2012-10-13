package com.desktop.system.core.service.parsers
{
	import avmplus.getQualifiedClassName;
	
	import com.desktop.system.interfaces.IServiceReturnData;
	
	import flash.events.EventDispatcher;
	import flash.utils.getDefinitionByName;
	
	import mx.collections.ArrayList;
	import mx.collections.XMLListCollection;
	
	public class WebServiceXmlDataParser extends EventDispatcher implements IServiceReturnData
	{
		private var __metadata:Object;
		
		private var __data:Object;
		
		public function WebServiceXmlDataParser()
		{
			super();
			
			__metadata = new Object();
		}
		
		public function parseData( serviceData:Object, voClasses:Object = null ):Boolean
		{
			var d:XML;
			try{
				d = XML( serviceData );
			}
			catch( e:Error )
			{
				trace( "Parsing failed at WebServiceXmlDataParser::parseData(). \nData:\n " + serviceData );
				return false;
			}
			
			if( d )
			{
				var o:Object;
				
				if( d.hasOwnProperty( "metadata" ) )
				{
					__metadata = d.metadata;
				}
				
				if( d.hasOwnProperty( "data" ) )
				{ 
					
					var row_node:Object;
					var row_object:Object;
					var array_list:ArrayList;
					var data_object:Object;
					var vector:Vector.<Object>;
					
					
					
					var data_len:uint = d.data.children().length();
					
					
					if( data_len > 0 )
					{
						array_list = new ArrayList();
						data_object = new Object();
						
						
						
						for( var i:int = 0; i < data_len; i++ )
						{
							row_node = d.data.children()[ i ];
						
							if( row_node )
							{
								if( voClasses && voClasses.hasOwnProperty( row_node.name() ) )
								{
									row_object = createObjectVo( row_node, voClasses[ row_node.name() ] );
								}
								else
								{
									row_object = createObjectVo( row_node, 'Object' );
								}
								
								if( metadata.dataType == WebServiceParserDataType.ARRAY_LIST )
								{
									array_list.addItem( row_object );
								}
								else if( metadata.dataType == WebServiceParserDataType.CUSTOM_OBJECT )
								{
									if( data_len == 1 )
									{
										data_object = row_object;
									}
									else
									{
										data_object[ row_node.name() ] = row_object;
									}
								}
								
							}
						}// end of for loop

						
						if( metadata.dataType == WebServiceParserDataType.ARRAY_LIST )
						{
							
							__data = array_list;
						}
						
						if( metadata.dataType == WebServiceParserDataType.CUSTOM_OBJECT )
						{
							
							__data = data_object
						}
						
						
					}// end of if( data_len > 0 )
				}
				
				return true;
			}
			else
			{
				return false;
			}
		}
		
		public function createObjectVo( data:Object, classVo:String ):Object
		{
			var vo_instance:*;
			var vo_clazz:Class;
			
			if( classVo )
				vo_clazz = getDefinitionByName( classVo ) as Class;
			
			if( vo_clazz )
			{
				vo_instance = new vo_clazz();
			}
			else
			{
				vo_instance = new Object();
			}
			
			var row_object:Object;
			var oc_index:String;
			var row_node:Object;
			var data_len:uint = data.children().length();
			
			for( var i:int = 0; i < data_len; i++ )
			{
				row_node = data.children()[ i ];
				
				if( vo_instance.hasOwnProperty( row_node.name() ) )
				{
					vo_instance[ row_node.name() ] = row_node.text();
				}
				else
				{
					trace( "VO Instance \"" + getQualifiedClassName( vo_instance ) + "\" don't have property: " + row_node.name() + ". at WebServiceXmlDataParser::createObjectVo()" );
				}
			}
			
			return vo_instance;
		}
		
		public function get metadata():Object
		{
			return __metadata;
		}
		
		public function get data():Object
		{
			return __data;
		}
	}
}