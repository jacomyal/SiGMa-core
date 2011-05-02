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
	
	import com.ofnodesandedges.y2011.core.data.Node;
	import com.ofnodesandedges.y2011.utils.ColorUtils;
	
	import flash.display.DisplayObjectContainer;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	public class LabelDrawer{
		
		public static function drawLabel(node:Node,size:Number,color:String,font:String,container:DisplayObjectContainer):void{
			var label:TextField = new TextField();
			
			label.htmlText = '<font face="'+font+'" size="'+size+'" color="#'+color+'">'+node.label+'</font>';
			label.selectable = false;
			label.autoSize = TextFieldAutoSize.LEFT;
			label.x = node.displayX+node.displaySize*1.5;
			label.y = node.displayY-label.height/2;
			
			container.addChild(label);
		}
	}
}