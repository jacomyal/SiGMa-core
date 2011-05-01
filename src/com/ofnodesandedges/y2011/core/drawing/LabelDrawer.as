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