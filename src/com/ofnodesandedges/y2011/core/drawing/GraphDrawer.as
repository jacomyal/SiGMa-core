package com.ofnodesandedges.y2011.core.drawing{
	
	import com.ofnodesandedges.y2011.core.control.CoreControler;
	import com.ofnodesandedges.y2011.core.data.Edge;
	import com.ofnodesandedges.y2011.core.data.Graph;
	import com.ofnodesandedges.y2011.core.data.Node;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	
	public class GraphDrawer{
		
		public static const NAN_VALUE:String = "A node's coordinate is not a number.";
		
		public static function drawGraph(nodesGraphics:Graphics,edgesGraphics:Graphics,labelsContainer:DisplayObjectContainer):void{
			var node1:Node, node2:Node, edge:Edge;
			
			var nodes:Vector.<Node> = Graph.nodes;
			var edges:Vector.<Edge> = Graph.edges;
			
			var nodesIndex:Object = Graph.nodesIndex;
			var edgesIndex:Object = Graph.edgesIndex;
			
			var i:int, l1:int = nodes.length, l2:int = edges.length;
			
			// Nodes:
			if(nodesGraphics){
				for(i=0;i<l1;i++){
					node1 = nodes[i];
					
					if(isOnScreen(node1)){
						NodeDrawer.drawNode(node1.displaySize,node1.displayX,node1.displayY,node1.color,nodesGraphics,node1.shape);
					}
				}
			}
			
			// Edges:
			if(edgesGraphics){
				for(i=0;i<l2;i++){
					edge = edges[i];
					
					node1 = nodes[nodesIndex[edge.sourceID]];
					node2 = nodes[nodesIndex[edge.targetID]];
					if(isOnScreen(node1) || isOnScreen(node2)){
						EdgeDrawer.drawEdge(node1.displayX,node1.displayY,node2.displayX,node2.displayY,edgesGraphics,node1.color,edge.type);
					}
				}
			}
			
			// Labels:
			if(labelsContainer){
				for(i=0;i<l1;i++){
					node1 = nodes[i];
					
					if(isOnScreen(node1) && node1.displaySize>CoreControler.textThreshold){
						LabelDrawer.drawLabel(node1,CoreControler.textSizeRatio,labelsContainer);
					}
				}
			}
		}
		
		private static function isOnScreen(node:Node):Boolean{
			if(isNaN(node.x) || isNaN(node.y)){
				throw(new Error(NAN_VALUE));
			}
			
			var res:Boolean = (node.displayX+node.displaySize>-CoreControler.width/3)
				&&(node.displayX-node.displaySize<CoreControler.width*4/3)
				&&(node.displayY+node.displaySize>-CoreControler.height/3)
				&&(node.displayY-node.displaySize<CoreControler.height*4/3);
			
			return res;
		}
	}
}