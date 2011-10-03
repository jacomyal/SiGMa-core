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
	
	import com.ofnodesandedges.y2011.core.data.Graph;
	import com.ofnodesandedges.y2011.core.data.Node;
	
	public class CircularLayout{
		
		public static function apply(radius:Number = 100,x:Number = 0,y:Number = 0):void{
			var nodes:Vector.<Node> = Graph.nodes;
			var count:int = nodes.length;
			var node:Node;
			
			var i:int,l:int = nodes.length;
			
			for(i=0;i<l;i++){
				node = nodes[i];
				
				node.x = x + radius*Math.cos(Math.PI*2*i/count);
				node.y = y + radius*Math.sin(Math.PI*2*i/count);
				
				node.dx = 0;
				node.dy = 0;
				
				node.old_dx = 0;
				node.old_dy = 0;
			}
		}
	}
}