package com.desktop.system.Application.Library.ui
{
	import com.desktop.system.core.BaseModel;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.controls.DateField;
	import mx.events.ItemClickEvent;
	
	import spark.components.CheckBox;
	import spark.components.ComboBox;
	import spark.components.Form;
	import spark.components.FormItem;
	import spark.components.NumericStepper;
	import spark.components.RadioButton;
	import spark.components.TextArea;
	import spark.components.TextInput;
	import spark.components.supportClasses.SliderBase;
	import spark.events.IndexChangeEvent;
	
	public class FormHelper
	{
		public function FormHelper()
		{
		}
		
		public static function resetForm( form:Form, skip:Array = null ):void
		{
			var fi:FormItem;
			var ie:*;
			
			for( var i:uint = 0; i < form.numElements; i++ )
			{
				fi = form.getElementAt( i ) as FormItem;
				
				if( fi )
				{
					ie = fi.getElementAt( 0 );
					
					if( skip && skip.indexOf( ie ) != -1 )
						continue;
					
					if( ie is TextInput )
					{
						( ie as TextInput ).text = "";
					}
					else if( ie is TextArea )
					{
						( ie as TextArea ).text = "";
					}
					else if( ie is ComboBox )
					{
						( ie as ComboBox).selectedIndex = 0;
					}
					else if( ie is DateField )
					{
						( ie as DateField ).text = "";
					}
					else if( ie is CheckBox )
					{
						( ie as CheckBox ).selected = false;
					}
					else if( ie is RadioButton )
					{
						( ie as RadioButton ).selected = false;
					}
					else if( ie is SliderBase || ie is NumericStepper )
					{
						ie.value = 0;
					}
					
				}
			}
		}
		
		
		public static const ADD_FORM_ITEM_CHANGE:uint = 1;
		public static const REMOVE_FORM_ITEM_CHANGE:uint = 2;
		
		public static function setFormItemChange( form:Form, func:Function, flag:uint = 1, skip:Array = null  ):void
		{
			var fi:FormItem;
			var ie:*;
			var f:String = flag == ADD_FORM_ITEM_CHANGE ? "addEventListener" : "removeEventListener";
			var event_type:String;
			
			for( var i:uint = 0; i < form.numElements; i++ )
			{
				fi = form.getElementAt( i ) as FormItem;
				
				if( fi )
				{
					ie = fi.getElementAt( 0 );
					
					if( skip && skip.indexOf( ie ) != -1 )
						continue;
					
					if( ie )
					{
						if( ie is TextInput )
						{
							event_type = Event.CHANGE;
						}
						else if( ie is TextArea )
						{
							event_type = Event.CHANGE;
						}
						else if( ie is ComboBox )
						{
							event_type = IndexChangeEvent.CHANGE;
						}
						else if( ie is DateField )
						{
							event_type = Event.CHANGE;
						}
						else if( ie is CheckBox )
						{
							event_type = MouseEvent.CLICK;
						}
						else if( ie is RadioButton )
						{
							ie = ( ie as RadioButton ).group; 
							event_type = ItemClickEvent.ITEM_CLICK;
						}
						else if( ie is SliderBase || ie is NumericStepper )
						{
							event_type = Event.CHANGE;
						}
					
						ie[ f ].call( f, event_type, func );
					}	
				}
			}
		}
		
		public static function totalMinutesToHoursMinutesString( value:Number ):String
		{
			var hours:uint 	=  Math.floor( value / 60 );
			var minutes:Number = value % 60; 
			
			var hrs:String = hours.toString();
			var min:String = minutes.toString();
			
			
			if ( hrs.toString().length < 2 ) hrs = "0" + hrs;
			if ( min.toString().length < 2 )  min = "0" + min;
			
			return hrs + ":" + min;
		}
		
		public static function totalMinutesFromHoursMinutesString( value:String ):int
		{
			if( ! value ) 0;
			
			var tm:int = 0;
			var h:int = int( value.substr( 0, 2 ) );
			var m:int = int(  value.substr( 3, 2 ) );
			
			tm = h * 60;
			tm += m;
			
			return tm;
		}
		
		public static function setComboBoxSelectedValue( cb:ComboBox, dataFieldName:String, value:* ):void
		{
			if( ! cb.dataProvider )
				return;
			
			
			for( var i:int = 0; i < cb.dataProvider.length; i++ )
			{
				if( cb.dataProvider.getItemAt( i )[dataFieldName] == value )
				{
					cb.selectedIndex = i;
				}
			}
		}
		
		public static function disableLabelToItemFunction(value:String):Object
		{
			return null;
		}
		
		public static function numberLabelToItemFunction(value:String):Object
		{
			if( isNaN( Number( value ) ) )
			{
				return 1;
			}
			else 
			{
				return value;
			}
		}
	}
}