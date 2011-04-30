package com.ofnodesandedges.y2011.core.layout{
	
	import com.ofnodesandedges.y2011.core.data.Graph;
	import com.ofnodesandedges.y2011.core.data.Node;
	
	public class RotationLayout{
		
		public static function rotate(angle:Number,x:Number = 0,y:Number = 0):void{
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