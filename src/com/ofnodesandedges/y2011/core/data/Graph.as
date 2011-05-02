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
package com.ofnodesandedges.y2011.core.data{
	
	import com.ofnodesandedges.y2011.core.control.CoreControler;
	import com.ofnodesandedges.y2011.core.interaction.InteractionControler;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	public class Graph{
		
		// Errors
		private static const NODE_ID_ALREADY_EXISTING:String = "Node ID already existing.";
		private static const EDGE_ID_ALREADY_EXISTING:String = "Edge ID already existing.";
		private static const SAME_EXTREMITIES:String = "The extremities of the edge are the same node.";
		private static const MISSING_EDGE_EXTREMITY:String = "The target or the source of the edge is missing.";
		
		// Events
		public static const NODE_ADDED:String = "node_added";
		public static const EDGE_ADDED:String = "edge_added";
		public static const NODE_REMOVED:String = "node_removed";
		public static const EDGE_REMOVED:String = "edge_removed";
		
		// Params
		private static var _edges:Vector.<Edge> = new Vector.<Edge>();
		private static var _nodes:Vector.<Node> = new Vector.<Node>();
		
		private static var _nodesIndex:Object = {};
		private static var _edgesIndex:Object = {};
		
		private static var _nodesCount:int = 0;
		private static var _edgesCount:int = 0;
		
		private static var _metaData:Object = {};
		private static var _nodeAttributes:Object = {};
		private static var _edgeAttributes:Object = {};
		
		private static var _associations:Object = {};
		
		private static var _eventDispatcher:EventDispatcher = new EventDispatcher();
		
		public static var defaultEdgeType:int = 1;
		public static var defaultNodeShape:int = 0;
		
		/**
		 * Adds a node into the base. If the node ID is already existing in the base,
		 * it returns an error <code>Graph.NODE_ID_ALREADY_EXISTING</code>.
		 *  
		 * @param node (Node) The node to push in the base.
		 * 
		 */		
		public static function addNode(node:Node):void{
			if(_nodesIndex[node.id]==undefined || _nodesIndex[node.id]==null){
				_nodes.push(node);
				_nodesIndex[node.id] = _nodesCount;
				
				_nodesCount ++;
				dispatchEvent(new Event(NODE_ADDED));
			}else{
				throw new Error(NODE_ID_ALREADY_EXISTING);
			}
		}
		
		/**
		 * Adds an edge into the base. If the edge ID is already existing in the base,
		 * it returns an error <code>Graph.EDGE_ID_ALREADY_EXISTING</code>. Also, if one 
		 * of the edge extremities is not existing into the base, it returns an error 
		 * <code>Graph.MISSING_EDGE_EXTREMITIES</code>, and if the extremities are the same,
		 * it returns an error <code>Graph.SAME_EXTREMITIES</code>.
		 * 
		 * @param edge (Edge) The edge to push in the base.
		 * 
		 */		
		public static function addEdge(edge:Edge):void	{
			if(_edgesIndex[edge.id]!=undefined && _edgesIndex[edge.id]!=null){
				throw new Error(EDGE_ID_ALREADY_EXISTING);
			}else if(_nodesIndex[edge.targetID]==undefined 
				|| _nodesIndex[edge.targetID]==null 
				|| _nodesIndex[edge.sourceID]==undefined 
				|| _nodesIndex[edge.sourceID]==null){
				throw new Error(MISSING_EDGE_EXTREMITY);
			}else if(edge.targetID == edge.sourceID){
				throw new Error(SAME_EXTREMITIES);
			}else{
				_edges.push(edge);
				_edgesIndex[edge.id] = _edgesCount;
				
				_nodes[_nodesIndex[edge.targetID]].edges[edge.id] = edge.sourceID;
				_nodes[_nodesIndex[edge.sourceID]].edges[edge.id] = edge.targetID;
				
				_edgesCount ++;
				dispatchEvent(new Event(EDGE_ADDED));
			}
		}
		
		/**
		 * Removes a node from the base, if it exists.
		 *  
		 * @param nodeID (String) The ID of the node to remove.
		 * 
		 */		
		public static function removeNode(nodeID:String):void{
			if(_nodesIndex[nodeID]!=undefined && _nodesIndex[nodeID]!=null){
				var index:int = _nodesIndex[nodeID];
				var node:Node = _nodes[index];
				
				var key:String;
				
				// Remove all connected edges:
				for(key in node.edges){
					removeEdge(key);
				}
				
				// Delete node:
				_nodes.splice(index,1);
				
				// Update nodes index:
				for(key in _nodesIndex){
					if(_nodesIndex[key]>index){
						_nodesIndex[key]--;
					}
				}
				
				delete _nodesIndex[nodeID];
				_nodesCount --;
				
				dispatchEvent(new Event(NODE_REMOVED));
			}
		}
		
		/**
		 * Removes an edge from the base, if it exists.
		 *  
		 * @param edgeID (String) The ID of the edge to remove.
		 * 
		 */		
		public static function removeEdge(edgeID:String):void{
			if(_edgesIndex[edgeID]!=undefined && _edgesIndex[edgeID]!=null){
				var index:int = _edgesIndex[edgeID];
				var edge:Edge = _edges[index];
				
				var key:String;
				
				_nodes[_nodesIndex[edge.sourceID]].decrementDegree();
				_nodes[_nodesIndex[edge.targetID]].decrementDegree();
				
				delete _nodes[_nodesIndex[edge.targetID]].edges[edge.id];
				delete _nodes[_nodesIndex[edge.sourceID]].edges[edge.id];
				
				// Delete edge:
				if(_edges.splice(index,1).length==0){
					trace("pouet");
				}
				
				// Update edges index:
				for(key in _edgesIndex){
					if(_edgesIndex[key]>index){
						_edgesIndex[key]--;
					}
				}
				
				delete _edgesIndex[edgeID];
				_edgesCount --;
				
				dispatchEvent(new Event(EDGE_REMOVED));
			}
		}
		
		/**
		 * Regenerate the graph from a new set of nodes and edges. It will delete all the 
		 * existing nodes and edges that are not part of the new sets, and add the missing
		 * ones. The main advantage is that the nodes that are already existing will be kept
		 * with the same coordinates.
		 *  
		 * @param newNodes	(Vector.<Node>) The new set of nodes.
		 * @param newEdges	(Vector.<Edge>) The new set of edges.
		 * 
		 */		
		public static function regenerate(newNodes:Vector.<Node>,newEdges:Vector.<Edge>):void{
			var newNodeIDs:Object = {};
			var newEdgeIDs:Object = {};
			var i:int, l:int;
			var key:String;
			
			// New nodes IDs extraction
			l = newNodes.length;
			for(i=0;i<l;i++){
				newNodeIDs[newNodes[i].id] = 1;
			}
			
			// New edges IDs extraction
			l = newEdges.length;
			for(i=0;i<l;i++){
				newEdgeIDs[newEdges[i].id] = 1;
			}
			
			// Remove no-more-existing nodes
			var nodesToRemove:Array = [];
			for(key in _nodesIndex){
				if(!newNodeIDs[key]){
					nodesToRemove.push(key);
				}
			}
			
			l = nodesToRemove.length;
			for(i=0;i<l;i++){
				removeNode(nodesToRemove[i]);
			}
			
			// Remove no-more-existing edges
			var edgesToRemove:Array = [];
			for(key in _edgesIndex){
				if(!newEdgeIDs[key]){
					edgesToRemove.push(key);
				}
			}
			
			l = edgesToRemove.length;
			for(i=0;i<l;i++){
				removeEdge(edgesToRemove[i]);
			}
			
			// Add new nodes
			l = newNodes.length;
			for(i=0;i<l;i++){
				if(!_nodesIndex[newNodes[i].id]){
					addNode(newNodes[i]);
				}
			}
			
			// Add new edges
			l = newEdges.length;
			for(i=0;i<l;i++){
				if(!_edgesIndex[newEdges[i].id]){
					addEdge(newEdges[i]);
				}
			}
		}
		
		
		public static function deleteGraph():void{
			var i:int, l:int = _nodes.length;
			for(i=l-1;i>=0;i--){
				removeNode(_nodes[i].id);
			}
			
			l = _edges.length;
			for(i=l-1;i>=0;i--){
				removeEdge(_edges[i].id);
			}
		}
		
		/**
		 * Adds a pair to the graph meta data hash.
		 *  
		 * @param key	(String) The key of the new value.
		 * @param value	(String) The new value.
		 * 
		 */		
		public static function addMetaData(key:String,value:String):void{
			_metaData[key] = value;
		}
		
		/**
		 * Adds a node attribute description to the graph.
		 *  
		 * @param id			(String) The attribute ID (caracterizes this attribute in each node).
		 * @param title			(String) The attribute label.
		 * @param type			(String) The attribute type.
		 * @param defaultValue	(*, default-value = null) The default value of the attribute.
		 * 
		 */		
		public static function addNodeAttribute(id:String,title:String,type:String,defaultValue:*=null):void{
			_nodeAttributes[id] = new Object();
			_nodeAttributes[id]["title"] = title;
			_nodeAttributes[id]["type"] = type;
			
			if(defaultValue!=null){
				_nodeAttributes[id]["defaultValue"] = defaultValue;
			}
		}
		
		/**
		 * Adds an edge attribute description to the graph.
		 *  
		 * @param id			(String) The attribute ID (caracterizes this attribute in each edge).
		 * @param title			(String) The attribute label.
		 * @param type			(String) The attribute type.
		 * @param defaultValue	(*, default-value = null) The default value of the attribute.
		 * 
		 */		
		public static function addEdgeAttribute(id:String,title:String,type:String,defaultValue:*=null):void{
			_edgeAttributes[id] = new Object();
			_edgeAttributes[id]["title"] = title;
			_edgeAttributes[id]["type"] = type;
			
			if(defaultValue!=null){
				_edgeAttributes[id]["defaultValue"] = defaultValue;
			}
		}
		
		/**
		 * This methods sets each node display coordinates, relatively to the position and scale ratio
		 * of the <code>InteractionControler</code> (zoom and drag'n'drop).
		 * 
		 * @see com.ofnodesandedges.y2011.core.interaction.InteractionControler 
		 * 
		 */		
		public static function setDisplayCoordinates():void{
			var node:Node;
			var i:int,l:int = _nodes.length;
			
			for(i=0;i<l;i++){
				node = _nodes[i];
				
				node.displayX = node.displayX*CoreControler.ratio + CoreControler.x;
				node.displayY = node.displayY*CoreControler.ratio + CoreControler.y;
				node.displaySize = node.displaySize*CoreControler.ratio;
			}
		}
		
		/**
		 * This method sets each node display coordinates, to make the whole graph
		 * fit in a specified rectangle (the <code>stage</code>, for example). It can also
		 * reset the size of each node in a specified range.
		 *  
		 * @param areaWidth			(Number) The rectangle width.
		 * @param areaHeight		(Number) The rectangle height.
		 * @param displaySizeMin	(Number, default-value = 0)
		 * 							The minimum size of the nodes. If <code>displayMinSize</code> 
		 * 							and <code>displayMaxSize</code> are both set to zero, then
		 * 							the nodes sizes will stay unchanged.
		 * @param displaySizeMax	(Number, default-value = 0)
		 * 							The maximum size of the nodes.	
		 * 
		 * @see com.ofnodesandedges.y2011.core.control.CoreControler
		 * 
		 */		
		public static function rescaleNodes(areaWidth:Number,areaHeight:Number,displaySizeMin:Number = 0,displaySizeMax:Number = 0):void{
			var node:Node;
			var i:int,l:int = _nodes.length;
			
			// Find current maxima:
			var sizeMax:Number = 0;
			
			for(i=0;i<l;i++){
				node = _nodes[i];
				if(node.size>sizeMax) sizeMax=node.size;
			}
			
			if(sizeMax==0){
				return;
			}
			
			var xMin:Number = node.x;
			var xMax:Number = node.x;
			var yMin:Number = node.y;
			var yMax:Number = node.y;
			
			// Recenter the nodes:
			for(i=0;i<l;i++){
				node = _nodes[i];
				
				if(node.x>xMax) xMax = node.x;
				if(node.x<xMin) xMin = node.x;
				if(node.y>yMax) yMax = node.y;
				if(node.y<yMin) yMin = node.y; 
				if(node.size>sizeMax) sizeMax = node.size;
			}
			
			var scale:Number = Math.min(0.9*areaWidth/(xMax-xMin),0.9*areaHeight/(yMax-yMin));
			
			// Size homothetic parameters:
			var a:Number;
			var b:Number;
			
			if(displaySizeMax == 0 && displaySizeMin == 0){
				a = 1;
				b = 0;
			}else if(displaySizeMax == displaySizeMin){
				a = 0;
				b = displaySizeMax;
			}else{
				a = (displaySizeMax-displaySizeMin)/sizeMax;
				b = displaySizeMin;
			}
			
			// Rescale the nodes:
			for(i=0;i<l;i++){
				node = _nodes[i];
				
				node.displayX = (node.x-(xMax+xMin)/2)*scale + areaWidth/2;
				node.displayY = (node.y-(yMax+yMin)/2)*scale + areaHeight/2;
				node.displaySize = node.size*a + b;
			}
		}
		
		/**
		 * @copy flash.events.EventDispatcher#addEventListener()
		 */		
		public static function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void{
			_eventDispatcher.addEventListener(type,listener,useCapture,priority,useWeakReference);
		}
		
		/**
		 * @copy flash.events.EventDispatcher#removeEventListener()
		 */		
		public static function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void{
			_eventDispatcher.removeEventListener(type,listener,useCapture);
		}
		
		/**
		 * @copy flash.events.EventDispatcher#dispatchEvent()
		 */		
		private static function dispatchEvent(event:Event):Boolean{
			return _eventDispatcher.dispatchEvent(event);
		}

		public static function get edges():Vector.<Edge>{
			return _edges;
		}

		public static function get nodes():Vector.<Node>{
			return _nodes;
		}
		
		public static function get metaData():Object{
			return _metaData;
		}
		
		public static function get nodeAttributes():Object{
			return _nodeAttributes;
		}
		
		public static function get edgeAttributes():Object{
			return _edgeAttributes;
		}

		public static function get nodesCount():int{
			return _nodesCount;
		}

		public static function get edgesCount():int{
			return _edgesCount;
		}

		public static function get nodesIndex():Object{
			return _nodesIndex;
		}

		public static function get edgesIndex():Object{
			return _edgesIndex;
		}


	}
}