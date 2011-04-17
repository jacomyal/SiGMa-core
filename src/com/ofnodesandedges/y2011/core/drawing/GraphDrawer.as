package com.ofnodesandedges.y2011.core.drawing{
	
	import com.ofnodesandedges.y2011.core.control.CoreControler;
	import com.ofnodesandedges.y2011.core.data.Edge;
	import com.ofnodesandedges.y2011.core.data.Graph;
	import com.ofnodesandedges.y2011.core.data.Node;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	
	public class GraphDrawer{
		
		public static function drawGraph(nodesGraphics:Graphics,edgesGraphics:Graphics,labelsContainer:DisplayObjectContainer):void{
			var node1:Node, node2:Node, edge:Edge;
			
			// Nodes:
			if(nodesGraphics){
				for each(node1 in Graph.nodes){
					if(isOnScreen(node1)){
						NodeDrawer.drawNode(node1.displaySize,node1.displayX,node1.displayY,node1.color,nodesGraphics,node1.shape);
					}
				}
			}
			
			// Edges:
			if(edgesGraphics){
				for each(edge in Graph.edges){
					node1 = Graph.nodes[edge.sourceID];
					node2 = Graph.nodes[edge.targetID];
					if(isOnScreen(node1) || isOnScreen(node2)){
						EdgeDrawer.drawEdge(node1.displayX,node1.displayY,node2.displayX,node2.displayY,edgesGraphics,node1.color,edge.type);
					}
				}
			}
			
			// Labels:
			if(labelsContainer){
				for each(node1 in Graph.nodes){
					if(isOnScreen(node1) && node1.displaySize>CoreControler.textThreshold){
						LabelDrawer.drawLabel(node1,CoreControler.textSizeRatio,labelsContainer);
					}
				}
			}
		}
		
		private static function isOnScreen(node:Node):Boolean{
			var res:Boolean = (node.displayX+node.displaySize>-CoreControler.width/3)
				&&(node.displayX-node.displaySize<CoreControler.width*4/3)
				&&(node.displayY+node.displaySize>-CoreControler.height/3)
				&&(node.displayY-node.displaySize<CoreControler.height*4/3);
			
			return res;
		}
	}
}