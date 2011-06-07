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
package com.ofnodesandedges.y2011.core.layout.forceAtlas{
	
	import com.ofnodesandedges.y2011.core.control.CoreControler;
	import com.ofnodesandedges.y2011.core.data.Edge;
	import com.ofnodesandedges.y2011.core.data.Graph;
	import com.ofnodesandedges.y2011.core.data.Node;
	import com.ofnodesandedges.y2011.core.layout.forceAtlas.forces.LinearAttraction;
	import com.ofnodesandedges.y2011.core.layout.forceAtlas.forces.LinearRepulsion;
	
	public class ForceAtlas{
		
		public static const NAN_VALUE:String = "A node's coordinate is not a number.";
		
		private static var _speed:Number;
		private static var _jitterTolerance:Number;
		private static var _edgeWeightInfluence:Number;
		
		private static var _theta:Number;
		private static var _gravity:Number;
		private static var _scalingRatio:Number;
		
		private static var _isBarnesHutOptimize:Boolean;
		
		public static function initAlgo():void{
			initParams();
			CoreControler.addLayoutFunction(computeOneStep);
		}
		
		public static function killAlgo():void{
			CoreControler.removeLayoutFunction(computeOneStep);
		}
		
		private static function initParams():void{
			_speed = 1;
			
			var nodes:Vector.<Node> = Graph.nodes;
			var nodesCount:int = 0;
			var node:Node;
			var i:int,l:int = nodes.length;
			
			// Initialise layout data
			for(i=0;i<l;i++){
				node = nodes[i];
				
				node.mass = 1 + node.degree;
				node.old_dx = 0;
				node.old_dy = 0;
				node.dx = 0;
				node.dy = 0;
				
				nodesCount++;
			}
			
			// Reset parameters:
			// Tuning
			if(nodesCount>=100){
				_scalingRatio = 2;
			}else{
				_scalingRatio = 10;
			}
			
			// Gravity
			_gravity = 1;
			
			// Behavior
			_edgeWeightInfluence = 1;
			
			// Performance
			if(nodesCount>=50000){
				_jitterTolerance = 10;
			}else if(nodesCount>=5000){
				_jitterTolerance = 1;
			}else{
				_jitterTolerance = 0.1;
			}
			
			if(nodesCount>=1000){
				_isBarnesHutOptimize = true;
			}else{
				_isBarnesHutOptimize = false;
			}
			
			_theta = 1.2;
		}
		
		public static function computeOneStep():void{
			var rootRegion:Region;
			
			// Initialize graph data
			var nodes:Vector.<Node> = Graph.nodes;
			var edges:Vector.<Edge> = Graph.edges;
			
			var nodesIndex:Object = Graph.nodesIndex;
			var edgesIndex:Object = Graph.edgesIndex;
			
			var node1:Node, node2:Node;
			var edge:Edge;
			
			var i:int, j:int, l1:int = nodes.length, l2:int = edges.length;
			
			if(!nodes.length){
				return;
			}
			
			// Initialise layout data
			for(i=0;i<l1;i++){
				node1 = nodes[i];
				
				node1.mass = 1 + node1.degree;
				node1.old_dx = node1.dx;
				node1.old_dy = node1.dy;
				node1.dx = 0;
				node1.dy = 0;
			}
			
			// If Barnes Hut active, initialize root region
			if(_isBarnesHutOptimize){
				rootRegion = new Region(nodes);
				rootRegion.buildSubRegions();
			}
			
			// Repulsion
			if(_isBarnesHutOptimize){
				for(i=0;i<l1;i++){
					node1 = nodes[i];
					
					rootRegion.applyForce(node1,_scalingRatio,_theta);
				}
			} else {
				var nodeToNodeRepulsion:Function = LinearRepulsion.apply_node_to_node;
				
				for(i=0;i<l1-1;i++){
					node1 = nodes[i];
					
					for(j=i+1;j<l1;j++){
						node2 = nodes[j];
						
						nodeToNodeRepulsion(node1,node2,_scalingRatio);
					}
				}
			}
			
			// Attraction
			var attraction:Function = LinearAttraction.apply;
			for(i=0;i<l2;i++){
				edge = edges[i];
				
				attraction(
					nodes[nodesIndex[edge.sourceID]],
					nodes[nodesIndex[edge.targetID]],
					Math.pow(edge.weight,_edgeWeightInfluence)
				);
			}
			
			// Gravity
			var gravity:Function = LinearRepulsion.apply_gravity;
			for each(node1 in nodes){
				gravity(
					node1,
					_gravity/_scalingRatio,
					1
				);
			}
			
			// Auto adjust speed
			var totalSwinging:Number = 0;  // How much irregular movement
			var totalEffectiveTraction:Number = 0;  // Hom much useful movement
			var swinging:Number;
			
			for(i=0;i<l1;i++){
				node1 = nodes[i];
				
				if (!node1.isFixed){
					swinging = Math.sqrt(Math.pow(node1.old_dx - node1.dx,2) + Math.pow(node1.old_dy - node1.dy,2));
					totalSwinging += node1.mass * swinging;   // If the node has a burst change of direction, then it's not converging.
					totalEffectiveTraction += node1.mass * 0.5 * Math.sqrt(Math.pow(node1.old_dx + node1.dx,2) + Math.pow(node1.old_dy + node1.dy,2));
				}
			}
			// We want that swingingMovement < tolerance * convergenceMovement
			var targetSpeed:Number = _jitterTolerance * _jitterTolerance * totalEffectiveTraction / totalSwinging;
			
			// But the speed shoudn't rise too much too quickly, since it would make the convergence drop dramatically.
			var maxRise:Number = 2;   // Max rise: 20%
			_speed = Math.min(targetSpeed, maxRise*_speed);
			// Peut être modifié
			
			// Apply forces
			for(i=0;i<l1;i++){
				node1 = nodes[i];
				
				// Adaptive auto-speed: the speed of each node is lowered
				// when the node swings.
				swinging = Math.sqrt(Math.pow(node1.old_dx - node1.dx,2) + Math.pow(node1.old_dy - node1.dy,2));
				//double factor = speed / (1f + Math.sqrt(speed * swinging));
				var factor:Number = _speed / (1 + _speed * Math.sqrt(swinging));
				
				node1.x += node1.dx*factor;
				node1.y += node1.dy*factor;
				
				if(isNaN(node1.x) || isNaN(node1.y)){
					throw(new Error(NAN_VALUE));
				}
			}
		}
	}
}