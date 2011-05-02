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
package com.ofnodesandedges.y2011.utils{
	
	public class PrintUtils{
		
		/**
		 * This method returns a String describing the content of any variable, as it could be 
		 * written in ActionScript3.
		 * 
		 */		
		public static function print(value:*):String{
			var result:String;
			if(typeof value != "object"){
				result = '"'+String(value)+'"';
			}else if(value is Array){
				result = printArray(value);
			}else if(value is Object){
				result = printObject(value);
			}
			
			return result;
		}
		
		private static function printArray(a:Array):String{
			return "["+a.map(print).join(',')+"]";
		}
		
		private static function printObject(o:Object):String{
			var a:Array = [];
			
			for(var key:* in o){
				a.push(print(key)+": "+print(o[key]));
			}
			
			return "{"+a.join(",")+"}";
		}
	}
}