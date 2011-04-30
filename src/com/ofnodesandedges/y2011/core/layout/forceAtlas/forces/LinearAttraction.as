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