package com.ofnodesandedges.y2011.core.data{
	
	import com.ofnodesandedges.y2011.core.control.CoreControler;
	import com.ofnodesandedges.y2011.core.interaction.InteractionControler;
	
	public class Graph{
		
		private static const NODE_ID_ALREADY_EXISTING:String = "Node ID already existing.";
		private static const EDGE_ID_ALREADY_EXISTING:String = "Edge ID already existing.";
		private static const MISSING_EDGE_EXTREMITY:String = "The target or the source of the edge is missing.";
		
		private static var _edges:Object = {};
		private static var _nodes:Object = {};
		
		private static var _nodesCount:int = 0;
		private static var _edgesCount:int = 0;
		
		private static var _metaData:Object = {};
		private static var _nodeAttributes:Object = {};
		private static var _edgeAttributes:Object = {};
		
		private static var _associations:Object = {};
		
		public static var defaultEdgeType:int = 1;
		public static var defaultNodeShape:int = 0;
		
		public static function addNode(node:Node):void{
			if(!_nodes[node.id]){
				_nodes[node.id] = node;
				_nodesCount ++;
			}else{
				throw new Error(NODE_ID_ALREADY_EXISTING);
			}
		}
		
		public static function addEdge(edge:Edge):void	{
			if(_edges[edge.id]){
				throw new Error(EDGE_ID_ALREADY_EXISTING);
			}else if(!_nodes[edge.targetID] || !_nodes[edge.sourceID]){
				throw new Error(MISSING_EDGE_EXTREMITY);
			}else{
				_edges[edge.id] = edge;
				_edgesCount ++;
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
			
			for each(node in _nodes){
				node.displayX = node.displayX*CoreControler.ratio + CoreControler.x;
				node.displayY = node.displayY*CoreControler.ratio + CoreControler.y;
				node.displaySize = node.displaySize*CoreControler.ratio;
			}
		}
		
		public static function rescaleNodes(areaWidth:Number,areaHeight:Number,displaySizeMin:Number = 0,displaySizeMax:Number = 15):void{
			var node:Node;
			
			// Find current maxima:
			var sizeMax:Number = 0;
			
			for each(node in _nodes){
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
			for each(node in _nodes){
				if(node.x>xMax) xMax = node.x;
				if(node.x<xMin) xMin = node.x;
				if(node.y>yMax) yMax = node.y;
				if(node.y<yMin) yMin = node.y; 
				if(node.size>sizeMax) sizeMax = node.size;
			}
			
			var scale:Number = Math.min(0.9*areaWidth/(xMax-xMin),0.9*areaHeight/(yMax-yMin));
			
			// Rescale the nodes:
			for each(node in _nodes){
				node.displayX = (node.x-(xMax+xMin)/2)*scale + areaWidth/2;
				node.displayY = (node.y-(yMax+yMin)/2)*scale + areaHeight/2;
				node.displaySize = (node.size*(displaySizeMax-displaySizeMin)/sizeMax + displaySizeMin);
			}
		}

		public static function get edges():Object{
			return _edges;
		}

		public static function get nodes():Object{
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


	}
}