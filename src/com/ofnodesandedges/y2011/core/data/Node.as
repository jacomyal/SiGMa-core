package com.ofnodesandedges.y2011.core.data{
	
	public class Node{
		
		public static const BORDER_THICKNESS:String = "node:border_thickness";
		public static const STOPPED:String = "node:stopped";
		
		private var _id:String;
		private var _degree:int;
		
		private var _edges:Object;
		
		public var label:String;
		
		public var x:Number;
		public var y:Number;
		
		public var displayX:Number;
		public var displayY:Number;
		
		public var dx:Number;
		public var dy:Number;
		
		public var old_dx:Number;
		public var old_dy:Number;
		
		public var mass:Number;
		public var size:Number;
		public var displaySize:Number;
		
		public var color:uint;
		public var shape:int;
		
		public var isFixed:Boolean;
		
		public var attributes:Object;
		
		public function Node(id:String,label:String){
			_id = id;
			this.label = label;
			
			size = 1;
			color = 0x808080;
			shape = 0;
			
			x = 0;
			y = 0;
			
			displayX = x;
			displayY = y;
			displaySize = size;
			
			mass = 1;
			isFixed = false;
			
			old_dx = 0;
			old_dy = 0;
			dx = 0;
			dy = 0;
			
			attributes = {};
			_degree = 0;
			
			_edges = new Object();
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

		public function get edges():Object{
			return _edges;
		}


	}
}