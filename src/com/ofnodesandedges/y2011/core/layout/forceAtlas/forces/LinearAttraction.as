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
	
	public class LinearAttraction{
		
		public static function apply(n1:Node,n2:Node,e:Number):void{
			// Get the distance
			var xDist:Number = n1.x - n2.x;
			var yDist:Number = n1.y - n2.y;
			
			// NB: factor = force / distance
			var factor:Number = -e;
			
			n1.dx += xDist * factor;
			n1.dy += yDist * factor;
			
			n2.dx -= xDist * factor;
			n2.dy -= yDist * factor;
		}
	}
}