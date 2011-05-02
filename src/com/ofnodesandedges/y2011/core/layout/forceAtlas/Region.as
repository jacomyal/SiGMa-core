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
	
	import com.ofnodesandedges.y2011.core.data.Node;
	import com.ofnodesandedges.y2011.core.layout.forceAtlas.forces.LinearRepulsion;
	
	public class Region{
		
		public static const UNVALID_PARAMETER:String = "Unvalid parameter";
		
		public var mass:Number;
		public var massCenterX:Number;
		public var massCenterY:Number;
		
		private var _size:Number;
		private var _nodes:Vector.<Node>;
		private var _subregions:Array;
		
		public function Region(nodes:Vector.<Node>){
			if(!nodes){
				throw(new Error(UNVALID_PARAMETER));
			}
		
			_nodes = nodes;
			
			_subregions = [];
			updateMassAndGeometry();
		}
		
		public function updateMassAndGeometry():void{
			if(_nodes.length>1){
				var n:Node;
				
				// Compute Mass
				mass = 0;
				var massSumX:Number = 0;
				var massSumY:Number = 0;
				
				for each(n in _nodes){
					mass += n.mass;
					massSumX += n.x * n.mass;
					massSumY += n.y * n.mass;
				}
				
				massCenterX = massSumX / mass;
				massCenterY = massSumY / mass;
				
				// Compute size
				_size = _nodes[0].mass;
				for each(n in _nodes){
					var distance:Number = Math.sqrt(Math.pow(n.x-massCenterX,2) + Math.pow(n.y-massCenterY,2));
					_size = (_size>distance) ? distance : _size;
				}
			}
		}
		
		public function buildSubRegions():void{
			if(_nodes.length>1){
				var n:Node;
				
				var leftNodes:Vector.<Node> = new Vector.<Node>();
				var rightNodes:Vector.<Node> = new Vector.<Node>();
				for each(n in _nodes){
					var nodesColumn:Vector.<Node> = (n.x<massCenterX) ? leftNodes : rightNodes;
					nodesColumn.push(n);
				}
				
				var nodesLine:Vector.<Node>;
				
				var topleftNodes:Vector.<Node> = new Vector.<Node>();
				var bottomleftNodes:Vector.<Node> = new Vector.<Node>();
				for each(n in leftNodes){
					nodesLine = (n.y<massCenterY) ? topleftNodes : bottomleftNodes;
					nodesLine.push(n);
				}
				
				var bottomrightNodes:Vector.<Node> = new Vector.<Node>();
				var toprightNodes:Vector.<Node> = new Vector.<Node>();
				for each(n in rightNodes){
					nodesLine = (n.y<massCenterY) ? toprightNodes : bottomrightNodes;
					nodesLine.push(n);
				}
				
				var subregion:Region;
				var oneNodeList:Vector.<Node>;
				
				if(topleftNodes.length>0){
					if(topleftNodes.length<_nodes.length){
						subregion = new Region(topleftNodes);
						_subregions.push(subregion);
					} else {
						for each(n in topleftNodes){
							oneNodeList = new Vector.<Node>();
							oneNodeList.push(n);
							subregion = new Region(oneNodeList);
							_subregions.push(subregion);
						}
					}
				}
				
				if(bottomleftNodes.length>0){
					if(bottomleftNodes.length<_nodes.length){
						subregion = new Region(bottomleftNodes);
						_subregions.push(subregion);
					} else {
						for each(n in bottomleftNodes){
							oneNodeList = new Vector.<Node>();
							oneNodeList.push(n);
							subregion = new Region(oneNodeList);
							_subregions.push(subregion);
						}
					}
				}
				
				if(bottomrightNodes.length>0){
					if(bottomrightNodes.length<_nodes.length){
						subregion = new Region(bottomrightNodes);
						_subregions.push(subregion);
					} else {
						for each(n in bottomrightNodes){
							oneNodeList = new Vector.<Node>();
							oneNodeList.push(n);
							subregion = new Region(oneNodeList);
							_subregions.push(subregion);
						}
					}
				}
				
				if(toprightNodes.length>0){
					if(toprightNodes.length<_nodes.length){
						subregion = new Region(toprightNodes);
						_subregions.push(subregion);
					} else {
						for each(n in toprightNodes){
							oneNodeList = new Vector.<Node>();
							oneNodeList.push(n);
							subregion = new Region(oneNodeList);
							_subregions.push(subregion);
						}
					}
				}
				
				for each(subregion in _subregions){
					subregion.buildSubRegions();
				}
			}
		}
		
		public function applyForce(n:Node,coeff:Number,theta:Number):void{
			if(_nodes.length < 2){
				var regionNode:Node = _nodes[0];
				LinearRepulsion.apply_node_to_node(n,regionNode,coeff);
			}else{
				var distance:Number = Math.sqrt(Math.pow(n.x-massCenterX,2) + Math.pow(n.y-massCenterY,2));
				
				if(distance * theta > _size){
					LinearRepulsion.apply_node_to_region(n,this,coeff);
				}else{
					for each(var subregion:Region in _subregions) {
						subregion.applyForce(n, coeff, theta);
					}
				}
			}
		}
	}
}