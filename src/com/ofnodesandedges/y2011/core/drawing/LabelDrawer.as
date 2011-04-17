package com.ofnodesandedges.y2011.core.drawing{
	
	import com.ofnodesandedges.y2011.core.data.Node;
	import com.ofnodesandedges.y2011.utils.ColorUtils;
	
	import flash.display.DisplayObjectContainer;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	public class LabelDrawer{
		
		public static function drawLabel(node:Node,ratio:Number,container:DisplayObjectContainer):void{
			var label:TextField = new TextField();
			var newSize:Number = ratio*node.displaySize/10;
			var color:String = ColorUtils.brightenColor(node.color,25).toString(16);
			
			label.htmlText = '<font face="Lucida Console" size="'+newSize+'" color="#'+color+'">'+node.label+'</font>';
			label.selectable = false;
			label.autoSize = TextFieldAutoSize.LEFT;
			label.x = node.displayX+node.displaySize*1.5;
			label.y = node.displayY-label.height/2;
			
			container.addChild(label);
		}
	}
}