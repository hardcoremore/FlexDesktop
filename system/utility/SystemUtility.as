package com.desktop.system.utility
{
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import mx.collections.ArrayList;
	
	import vos.DataHolderColumnVo;
	
	public class SystemUtility
	{
		
		public static function getObjectProperties( obj:Object ):Array
		{
			var description:XML = describeType(obj);
			
			var props:Array = new Array();
			
			for each (var a:XML in description.variable ) props.push( { name:a.@name, type:a.@type } );
			
			return props;
		}
		
		public static function newSibling(sourceObj:Object):* 
		{
			if(sourceObj) {
				
				var objSibling:*;
				try {
					var classOfSourceObj:Class = getDefinitionByName(getQualifiedClassName(sourceObj)) as Class;
					objSibling = new classOfSourceObj();
				}
				
				catch(e:Object) {}
				
				return objSibling;
			}
			return null;
		}
		
		public static function clone(source:Object):Object 
		{
			
			var clone:Object;
			if(source) {
				
				clone = newSibling(source);
				
				if(clone) 
				{
					copyData(source, clone);
				}
			}
			
			return clone;
		}
		
		public static function copyData(source:Object, destination:Object ):void 
		{
			//copies data from commonly named properties and getter/setter pairs
			if( source && destination ) 
			{
				
				try 
				{
					var sourceInfo:XML = describeType(source);
					var prop:XML;
					
					for each( prop in sourceInfo.variable ) 
					{
						destination[ prop.@name ] = source[ prop.@name ];
					}
					
					for each( prop in sourceInfo.accessor ) 
					{
						if( prop.@access == "readwrite" ) 
						{
							destination[ prop.@name ] = source[prop.@name ];
						}
					}
				}
				catch ( error:Error ) 
				{
					trace( "ERROR WHILE COPYING OBJECT: " + error.message);
				}
			}
		}
		
		public static function cloneArrayList( arrayListSource:ArrayList ):ArrayList
		{
			var a:ArrayList = new ArrayList();
			
			for( var i:int = 0; i < arrayListSource.length; i ++ )
			{
				a.addItem( SystemUtility.clone( arrayListSource.getItemAt( i ) ) );
			}
			
			return a;
		}
		
		public static function cloneVector( v:Vector.<Object> ):Vector.<Object>
		{
			if( ! v ) return null;
			var c:Vector.<Object> = new Vector.<Object>( v.length, v.fixed );
			
			for( var i:int = 0; i < v.length; i++ )
			{
				c[ i ] = SystemUtility.clone( v[ i ] );
			}
			
			return c;
		}
		
		public static function getVoFromObject( className:String, object:Object ):*
		{
			var c:Class = getDefinitionByName( className ) as Class;
			var instance:Object;
			
			if( c )
			{
				instance = new c();
				
				var o:Object;
				
				if( object is XML )
				{
					var currentNode:XML;
					var name:QName;
					var locName:QName;
					
					for( var i:int = 0; i < object.children().length(); i++ )
					{
						currentNode = object.children()[ i ];
						// Notice the QName class?  It is used with XML.
						// It IS NOT a String, and if you forget to cast them, then
						// currentNode.localName() will NEVER be "city", even though it may
						// trace that way.
						name = currentNode.name(); // url.to.namespace::city
						instance[ name ] = currentNode.text();
					}
					
				}
				else
				{
					for( o in object )
					{
						instance[ o ] = object[ o ];
					}
				}
			}
			
			return instance;
		}
		
		public static function convertVectorToArray( v:Vector.<Object> ):Array
		{
			var a:Array = new Array();
			if( ! v ) return a;
			
			var l:int = v.length;
			
			for( var i:int = 0; i < l; i ++ )
			{
				a.push( v[ i ] );
			}
			
			return a;
		}
		
		public static function sortDataHolderColumnsFunction( a:DataHolderColumnVo, b:DataHolderColumnVo ):int
		{
			if( a.data_holder_column_position_index < b.data_holder_column_position_index ) 
			{ 
				return -1; 
			} 
			else if( a.data_holder_column_position_index > b.data_holder_column_position_index ) 
			{ 
				return 1; 
			} 
			else 
			{ 
				return 0; 
			}
		}
		
		// descending int
		public static function sortIntDescending( a:int, b:int ):int
		{
			if( a < b ) 
			{ 
				return 1; 
			} 
			else if( a > b ) 
			{ 
				return -1; 
			} 
			else 
			{ 
				return 0; 
			}
		}
		
		public static function sortIntAscending( a:int, b:int ):int
		{
			if( a < b ) 
			{ 
				return -1; 
			} 
			else if( a > b ) 
			{ 
				return 1; 
			} 
			else 
			{ 
				return 0; 
			}
		}
	}
}