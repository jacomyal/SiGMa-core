package com.ofnodesandedges.y2011.core.data{
	
	public class Edge{
		
		private var _id:String;
		private var _sourceID:String;
		private var _targetID:String;
		
		public var type:int;
		public var label:String;
		public var attributes:Object;
		
		public function Edge(id:String,sourceID:String,targetID:String,type:int = 0,label:String = ""){
			_id = id;
			
			_sourceID = sourceID;
			_targetID = targetID;
			type = type;
			
			attributes = {};
			
			this.label = label;
		}

		public function get targetID():String{
			return _targetID;
		}
		
		public function get sourceID():String{
			return _sourceID;
		}
		
		public function get id():String{
			return _id;
		}


	}
}