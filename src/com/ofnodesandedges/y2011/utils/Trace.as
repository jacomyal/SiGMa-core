package com.ofnodesandedges.y2011.utils{
	import flash.text.TextField;
	
	public class Trace{
		
		public static var output:TextField = null;
		
		public static function t(s:String):void{
			trace(s);
			
			if(output){
				output.text = s;
			}
		}
	}
}