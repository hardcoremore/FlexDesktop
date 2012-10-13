package com.desktop.ui.Components.Group
{
	import flash.events.Event;
	import flash.geom.Matrix;
	
	import spark.components.Group;
	import spark.filters.GlowFilter;
	
	public class LoadingAnimation extends Group
	{
		
		public var colors:Array = [0x1EAAD2, 0x1EC2D2, 0x2fe0a4];
		public var alphas:Array = [1, 1, 1];
		public var ratios:Array = [0, 127, 255];
		public var matrix:Matrix = new Matrix();// {a:300, b:0, c:50, d:0, e:300, f:0, g:-3, h:3, i:1};
		public var _angle:uint = 0;
		
		public function LoadingAnimation()
		{
			super();
		}
		
		
		override public function set enabled(value:Boolean):void
		{
			super.enabled = value;
			
			if( enabled )
			{
				addEventListener( Event.ENTER_FRAME, onEnterFrameHandler, false, 0, true );
			}
			else
			{
				removeEventListener( Event.ENTER_FRAME, onEnterFrameHandler );
			}
		}
		
		public function dd( r1:Number, r2:Number, _x:Number, _y:Number ):void
		{
			
			var TO_RADIANS:Number = Math.PI / 180;
			this.graphics.moveTo(0, 0);
			this.graphics.lineTo(r1, 0);
			
			var endx:Number;
			var endy:Number;
			var ax:Number;
			var ay:Number;
			var i:uint=0;
			
			// draw the 30-degree segments
			var a:Number = 0.268;  // tan(15)
			for (i=0; i < 12; i++)
			{
				endx = r1 * Math.cos(( i+1) * 30 * TO_RADIANS);
				endy = r1 * Math.sin( (i+1) * 30 * TO_RADIANS);
				ax = endx + r1 * a * Math.cos( ((i+1) * 30 - 90 ) * TO_RADIANS );
				ay = endy + r1 * a * Math.sin( ((i+1)* 30 - 90 ) * TO_RADIANS );
				this.graphics.curveTo(ax, ay, endx, endy);   
			}
			
			// cut out middle (draw another circle before endFill applied)
			this.graphics.moveTo(0, 0);
			this.graphics.lineTo(r2, 0);
			
			for (i=0; i < 12; i++)
			{
				endx = r2 * Math.cos( (i+1) * 30 * TO_RADIANS);
				endy = r2 * Math.sin(( i+1) * 30 * TO_RADIANS);
				ax = endx + r2 * a * Math.cos( ((i+1) * 30 - 90 ) * TO_RADIANS );
				ay = endy + r2 * a * Math.sin( ((i+1) * 30 - 90 ) * TO_RADIANS);
				this.graphics.curveTo(ax, ay, endx, endy);   
			}
			
		}
		
		public function setMatrix(angle:uint):void
		{
			matrix.createGradientBox( 60, 60 );
			matrix.rotate( angle * Math.PI / 180 );
		}
		
		public function onEnterFrameHandler(event:Event):void
		{
			this.graphics.clear();
			
			setMatrix(_angle);
			
			this.graphics.beginGradientFill("linear", colors, alphas, ratios, matrix);
			dd(128, 80, 0, 0);
			
			this.graphics.endFill();
			
			_angle + 10 > 360 ? _angle = 0 : _angle += 10;
			
		}
		
	}
}