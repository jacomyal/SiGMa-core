/**
 * SiGMa-core
 * Copyright (C) 2011, Alexis Jacomy
 * 
 * This file is part of the SiGMa-core AS3 project.
 * 
 * SiGMa-core is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * SiGMa-core is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with SiGMa-core.  If not, see <http://www.gnu.org/licenses/>.
 */
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
		
		public var old_x:Number;
		public var old_y:Number;
		
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
			shape = 0;
			
			x = 0;
			y = 0;
			old_x = 0;
			old_y = 0;
			
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