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
package com.ofnodesandedges.y2011.core.layout.forceAtlas.forces{
	
	import com.ofnodesandedges.y2011.core.data.Node;
	import com.ofnodesandedges.y2011.core.layout.forceAtlas.Region;
	
	public class LinearRepulsion{
		
		public static function apply_node_to_node(n1:Node, n2:Node, coefficient:Number):void{
			// Get the distance
			var xDist:Number = n1.x-n2.x;
			var yDist:Number = n1.y-n2.y;
			var distance:Number = Math.sqrt(xDist * xDist + yDist * yDist);
			
			if (distance > 0) {
				// NB: factor = force / distance
				var factor:Number = coefficient * n1.mass * n2.mass / Math.pow(distance,2);
				
				n1.dx += xDist * factor;
				n1.dy += yDist * factor;
				
				n2.dx -= xDist * factor;
				n2.dy -= yDist * factor;
			}
		}
		
		public static function apply_node_to_region(n:Node, r:Region, coefficient:Number):void{
			// Get the distance
			var xDist:Number = n.x - r.massCenterX;
			var yDist:Number = n.y - r.massCenterY;
			var distance:Number = Math.sqrt(xDist * xDist + yDist * yDist);
			
			if (distance > 0) {
				// NB: factor = force / distance
				var factor:Number = coefficient * n.mass * r.mass / distance / distance;
				
				n.dx += xDist * factor;
				n.dy += yDist * factor;
			}
		}
		
		public static function apply_gravity(n:Node, g:Number, coefficient:Number):void{
			// Get the distance
			var distance:Number = Math.sqrt(n.x*n.x + n.y*n.y);
			
			if (distance > 0) {
				// NB: factor = force / distance
				var factor:Number = coefficient * n.mass * g / distance;
				
				n.dx -= n.x * factor;
				n.dy -= n.y * factor;
			}
		}
	}
}