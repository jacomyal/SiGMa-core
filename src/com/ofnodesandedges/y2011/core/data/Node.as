package com.ofnodesandedges.y2011.core.data{
	
	public class Node{
		
		public static const BORDER_THICKNESS:String = "node:border_thickness";
		public static const STOPPED:String = "node:stopped";
		
		private var _id:String;
		
		public var label:String;
		
		public var x:int;
		public var y:int;
		
		public var displayX:int;
		public var displayY:int;
		
		public var dx:int;
		public var dy:int;
		
		public var size:Number;
		public var displaySize:Number;
		
		public var color:uint;
		public var shape:int;
		
		public var attributes:Object;
		
		private var _degree:int;
		
		public function Node(id:String,label:String){
			_id = id;
			this.label = label;
			
			size = 1;
			color = 0x000000;
			shape = 0;
			
			x = 0;
			y = 0;
			
			displayX = x;
			displayY = y;
			displaySize = size;
			
			dx = 0;
			dy = 0;
			
			attributes = {};
			_degree = 0;
		}
		
		public function incrementDegree():void{
			_degree++;
		}
		
		public function decrementDegree():void{
			_degree--;
		}
		
		public function get degree():int{
			return _degree;
		}

		public function get id():String{
			return _id;
		}

	}
}