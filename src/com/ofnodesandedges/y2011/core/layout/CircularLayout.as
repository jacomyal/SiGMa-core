package com.ofnodesandedges.y2011.core.layout{
	
	import com.ofnodesandedges.y2011.core.data.Graph;
	import com.ofnodesandedges.y2011.core.data.Node;
	
	public class CircularLayout{
		
		public static function apply(radius:Number,x:Number = 0,y:Number = 0):void{
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