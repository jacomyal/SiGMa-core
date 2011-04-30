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
				
				dispatchEvent(new Event(NODE_REMOVED));
			}
		}
		
		public static function removeEdge(edgeID:String):void{
			if(_edgesIndex[edgeID]){
				var edge:Edge = _edges[_edgesIndex[edgeID]];
				
				delete _nodes[_nodesIndex[edge.sourceID]];
				delete _nodes[_nodesIndex[edge.targetID]];
				
				delete _edges[_edgesIndex[edgeID]];
				delete _edgesIndex[edgeID];
				
				dispatchEvent(new Event(EDGE_REMOVED));
			}
		}
		
		public static function addMetaData(key:String,value:String):void{
			_metaData[key] = value;
		}
		
		public static function addNodeAttribute(id:String,title:String,type:String,defaultValue:*=null):void{
			_nodeAttributes[id] = new Object();
			_nodeAttributes[id]["title"] = title;
			_nodeAttributes[id]["type"] = type;
			
			if(defaultValue!=null){
				_nodeAttributes[id]["defaultValue"] = defaultValue;
			}
		}
		
		public static function addEdgeAttribute(id:String,title:String,type:String,defaultValue:*=null):void{
			_edgeAttributes[id] = new Object();
			_edgeAttributes[id]["title"] = title;
			_edgeAttributes[id]["type"] = type;
			
			if(defaultValue!=null){
				_edgeAttributes[id]["defaultValue"] = defaultValue;
			}
		}
		
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
		
		public static function rescaleNodes(areaWidth:Number,areaHeight:Number,displaySizeMin:Number = 0,displaySizeMax:Number = 15):void{
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
			
			// Rescale the nodes:
			for(i=0;i<l;i++){
				node = _nodes[i];
				
				node.displayX = (node.x-(xMax+xMin)/2)*scale + areaWidth/2;
				node.displayY = (node.y-(yMax+yMin)/2)*scale + areaHeight/2;
				node.displaySize = (node.size*(displaySizeMax-displaySizeMin)/sizeMax + displaySizeMin);
			}
		}
		
		public static function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void{
			_eventDispatcher.addEventListener(type,listener,useCapture,priority,useWeakReference);
		}
		
		public static function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void{
			_eventDispatcher.removeEventListener(type,listener,useCapture);
		}
		
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