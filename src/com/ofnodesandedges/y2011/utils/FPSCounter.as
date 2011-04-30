package com.ofnodesandedges.y2011.utils{
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.getTimer;
	
	import flashx.textLayout.formats.TextAlign;
	
	public class FPSCounter extends Sprite{
		
		private const TIME_STEP:Number = 1000;
		
		public static const NAME:String = "FPSCounter";
		
		private const TEXT_HEIGHT:int = 12;
		private const BAR_WIDTH:int = 3;
		private const ELLIPSE:int = 3;
		private const MARGIN:int = 1;
		
		private var _field:TextField;
		
		private var _lastValues:Array;
		private var _lastMesure:uint;
		private var _ticks:uint;
		private var _count:int;
		
		private var _width:int;
		private var _height:int;
		
		private var _bgColor:uint;
		private var _barsColor:uint;
		
		public function FPSCounter(barsColor:uint = 0x4ca318,bgColor:uint = 0x000000,textColor:uint = 0xFFFFFF,count:int = 10){
			_lastValues = [];
			
			_count = count;
			_barsColor = barsColor;
			_bgColor = bgColor;
			
			_width = _count*BAR_WIDTH + (_count+1)*MARGIN;
			_height = _width+TEXT_HEIGHT;
			
			var format:TextFormat = new TextFormat("arial",10,textColor,null,null,null,null,null,TextAlign.CENTER);
			
			_field = TextField(addChild(new TextField()));
			_field.defaultTextFormat = format;
			_field.autoSize = TextFieldAutoSize.LEFT;
			_field.text = " - fps";
			_field.x = _width/2 -_field.width/2;
			_field.y = _width + TEXT_HEIGHT/2 - _field.height/2;
			
			_ticks = 0;
			_lastMesure = getTimer();
			
			this.addEventListener(Event.ADDED_TO_STAGE,addedToStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE,removedFromStage);
			
			
			draw();
		}
		
		private function tick(e:Event):void{
			_ticks++;
			
			var now:uint = getTimer();
			var delta:uint = now - _lastMesure;
			
			if (delta >= TIME_STEP) {
				var fps:Number = _ticks / delta * 1000;
				
				_lastValues.push(fps);
				if(_lastValues.length>_count){
					_lastValues.shift();
				}
				
				_ticks = 0;
				_lastMesure = now;
				draw();
			}
		}
		
		private function draw():void{
			var i:int, l:int = _lastValues.length;
			var maxValue:Number = 0;
			var height:int;
			
			for(i=0;i<l;i++){
				maxValue = Math.max(maxValue,_lastValues[i]);
			}
			
			graphics.clear();
			
			// Background:
			graphics.beginFill(_bgColor,1);
			graphics.drawRoundRect(0,0,_width,_height,ELLIPSE,ELLIPSE);
			graphics.drawRect(0,_width,_width,1);
			graphics.endFill();
			
			// Bars:
			graphics.beginFill(_barsColor,1);
			
			for(i=0;i<l;i++){
				height = (_width-2*MARGIN)*_lastValues[i]/maxValue;
				
				graphics.drawRect(
					MARGIN+i*(MARGIN+BAR_WIDTH),
					_width-MARGIN-height,
					BAR_WIDTH,
					height
				);
			}
			
			graphics.endFill();
			
			// Text:
			_field.text = (l ? _lastValues[l-1].toFixed(1) : " -") + " fps";
			_field.x = _width/2 -_field.width/2;
			_field.y = _width + TEXT_HEIGHT/2 - _field.height/2;
		}
		
		private function addedToStage(e:Event):void{
			stage.addEventListener(Event.ENTER_FRAME,tick);
		}
		
		private function removedFromStage(e:Event):void{
			stage.removeEventListener(Event.ENTER_FRAME,tick);
		}
	}
}