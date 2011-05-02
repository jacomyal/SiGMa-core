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
	
	public class Edge{
		
		private var _id:String;
		private var _sourceID:String;
		private var _targetID:String;
		
		public var type:int;
		public var label:String;
		public var weight:Number;
		public var attributes:Object;
		
		public function Edge(id:String,sourceID:String,targetID:String,type:int = 0,label:String = ""){
			_id = id;
			
			_sourceID = sourceID;
			_targetID = targetID;
			type = type;
			weight = 1;
			
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