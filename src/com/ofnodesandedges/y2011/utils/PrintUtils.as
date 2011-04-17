package com.ofnodesandedges.y2011.utils{
	
	public class PrintUtils{
		
		/**
		 * This method returns a String describing the content of any variable, as it could be 
		 * written in ActionScript3.
		 * 
		 */		
		public static function print(value:*):String{
			var result:String;
			if(typeof value != "object"){
				result = '"'+String(value)+'"';
			}else if(value is Array){
				result = printArray(value);
			}else if(value is Object){
				result = printObject(value);
			}
			
			return result;
		}
		
		private static function printArray(a:Array):String{
			return "["+a.map(print).join(',')+"]";
		}
		
		private static function printObject(o:Object):String{
			var a:Array = [];
			
			for(var key:* in o){
				a.push(print(key)+": "+print(o[key]));
			}
			
			return "{"+a.join(",")+"}";
		}
	}
}