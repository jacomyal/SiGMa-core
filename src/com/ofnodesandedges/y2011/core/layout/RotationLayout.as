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
package com.ofnodesandedges.y2011.core.layout{
	
	import com.ofnodesandedges.y2011.core.control.CoreControler;
	import com.ofnodesandedges.y2011.core.data.Graph;
	import com.ofnodesandedges.y2011.core.data.Node;
	
	public class RotationLayout{
		
		public static var x:Number = 0;
		public static var y:Number = 0;
		public static var angle:Number = 0;
		
		public static function initAlgo(new_angle:Number,new_x:Number = 0,new_y:Number = 0):void{
			angle = new_angle;
			x = new_x;
			y = new_y;
			CoreControler.addLayoutFunction(rotate);
		}
		
		public static function rotate():void{
			var nodes:Vector.<Node> = Graph.nodes;
			var node:Node;
			
			var newX:Number;
			var newY:Number;
			
			var i:int,l:int = nodes.length;
			
			for(i=0;i<l;i++){
				node = nodes[i];
				
				newX = (x+(node.x-x)*Math.cos(angle)) - (y+(node.y-y)*Math.sin(angle));
				newY = (x+(node.x-x)*Math.sin(angle)) + (y+(node.y-y)*Math.cos(angle));
				
				node.x = newX;
				node.y = newY;
				
				newX = node.dx*Math.cos(angle) - node.dy*Math.sin(angle);
				newY = node.dx*Math.sin(angle) + node.dy*Math.cos(angle);
				
				node.dx = newX;
				node.dy = newY;
				
				newX = node.old_dx*Math.cos(angle) - node.old_dy*Math.sin(angle);
				newY = node.old_dx*Math.sin(angle) + node.old_dy*Math.cos(angle);
				
				node.old_dx = newX;
				node.old_dy = newY;
			}
		}
	}
}