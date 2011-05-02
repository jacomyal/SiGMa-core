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
package com.ofnodesandedges.y2011.core.drawing{
	
	import com.ofnodesandedges.y2011.core.control.CoreControler;
	import com.ofnodesandedges.y2011.core.data.Edge;
	import com.ofnodesandedges.y2011.core.data.Graph;
	import com.ofnodesandedges.y2011.core.data.Node;
	import com.ofnodesandedges.y2011.utils.ColorUtils;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	
	public class GraphDrawer{
		
		public static const NAN_VALUE:String = "A node's coordinate is not a number.";
		
		private static var _edgesColor:uint;
		private static var _hasEdgesColor:Boolean = false;
		
		private static var _nodesColor:uint;
		private static var _hasNodesColor:Boolean = false;
		
		private static var _labelsColor:uint;
		private static var _hasLabelsColor:Boolean = false;
		
		public static var fontName:String;
		
		public static function drawGraph(nodesGraphics:Graphics,edgesGraphics:Graphics,labelsContainer:DisplayObjectContainer):void{
			var node1:Node, node2:Node, edge:Edge;
			
			var nodes:Vector.<Node> = Graph.nodes;
			var edges:Vector.<Edge> = Graph.edges;
			
			var nodesIndex:Object = Graph.nodesIndex;
			var edgesIndex:Object = Graph.edgesIndex;
			
			var i:int, l1:int = nodes.length, l2:int = edges.length;
			
			var drawer:Function;
			
			// Nodes:
			if(nodesGraphics){
				drawer = NodeDrawer.drawNode;
				
				for(i=0;i<l1;i++){
					node1 = nodes[i];
					
					if(isOnScreen(node1)){
						drawer(
							node1.displaySize,
							node1.displayX,
							node1.displayY,
							_hasNodesColor ? _nodesColor : node1.color,
							nodesGraphics,
							node1.shape
						);
					}
				}
			}
			
			// Edges:
			if(edgesGraphics){
				drawer = EdgeDrawer.drawEdge;
				
				for(i=0;i<l2;i++){
					edge = edges[i];
					
					node1 = nodes[nodesIndex[edge.sourceID]];
					node2 = nodes[nodesIndex[edge.targetID]];
					
					if(isOnScreen(node1) || isOnScreen(node2)){
						drawer(
							node1.displayX,
							node1.displayY,
							node2.displayX,
							node2.displayY,
							edgesGraphics,
							_hasEdgesColor ? _edgesColor : node1.color,
							edge.type
						);
					}
				}
			}
			
			// Labels:
			if(labelsContainer){
				drawer = LabelDrawer.drawLabel;
				for(i=0;i<l1;i++){
					node1 = nodes[i];
					
					if(isOnScreen(node1) && node1.displaySize>CoreControler.textThreshold){
						drawer(
							node1,
							CoreControler.textSizeRatio*node1.displaySize/10,
							(_hasLabelsColor ? _labelsColor : ColorUtils.brightenColor(node1.color,25)).toString(16),
							fontName,
							labelsContainer
						);
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
		
		public static function setEdgesColor(value:* = null):void{
			if(value is uint && value!=null){
				_edgesColor = uint(value);
				_hasEdgesColor = true;
			}else{
				_hasEdgesColor = false;
			}
		}
		
		public static function setNodesColor(value:* = null):void{
			if(value is uint && value!=null){
				_nodesColor = uint(value);
				_hasNodesColor = true;
			}else{
				_hasNodesColor = false;
			}
		}
		
		public static function setLabelsColor(value:* = null):void{
			if(value is uint && value!=null){
				_labelsColor = uint(value);
				_hasLabelsColor = true;
			}else{
				_hasLabelsColor = false;
			}
		}
	}
}