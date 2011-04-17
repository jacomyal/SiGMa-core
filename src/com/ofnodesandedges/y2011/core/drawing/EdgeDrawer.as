package com.ofnodesandedges.y2011.core.drawing{
	
	import com.ofnodesandedges.y2011.core.data.Graph;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.Shape;
	
	public class EdgeDrawer{
		
		public static const NONE:int = 0;
		public static const LINE:int = 1;
		public static const CURVE:int = 2;
		public static const ARROW:int = 3;
		
		/**
		 * This method adds a <code>Shape</code> with the edge drawn on it.
		 *  
		 * @param x1		(int) The x position of the source.
		 * @param y1		(int) The y position of the source.
		 * @param y2		(int) The x position of the target.
		 * @param x2		(int) The y position of the target.
		 * @param container	(DisplayObjecContainer) The display object container of the new Shape.
		 * @param color		(uint) The color of the edge.
		 * @param style		(int, default-value = 1)
		 * 					The style of the edge:
		 * 					- 1: The edge is a simple line.
		 * 					- 2: The edge is a curve.
		 * 					- 3: The edge is a arrow (TODO).
		 * @param thickness (int, default-value = 1)
		 * 
		 */
		public static function addEdge(x1:int,y1:int,x2:int,y2:int,container:DisplayObjectContainer,color:uint,style:int = 1,thickness:int = 1):void{
			drawEdge(x1,y1,x2,y2,Shape(container.addChild(new Shape)).graphics,color,style,thickness);
		}
		
		/**
		 * This method draws an edge.
		 *  
		 * @param x1		(int) The x position of the source.
		 * @param y1		(int) The y position of the source.
		 * @param y2		(int) The x position of the target.
		 * @param x2		(int) The y position of the target.
		 * @param graphics	(Graphics) The graphics where the polygon has to be drawn.
		 * @param color		(uint) The color of the edge.
		 * @param style		(int, default-value = 1)
		 * 					The style of the edge:
		 * 					- 1: The edge is a simple line.
		 * 					- 2: The edge is a curve.
		 * 					- 3: The edge is a arrow (TODO).
		 * @param thickness (int, default-value = 1)
		 * 
		 */		
		public static function drawEdge(x1:int,y1:int,x2:int,y2:int,graphics:Graphics,color:uint,style:int = 1,thickness:int = 1):void{
			graphics.lineStyle(thickness,color);
			
			var s:int = style!=NONE ? style : Graph.defaultEdgeType;
			
			switch(s){
				case LINE:
					graphics.moveTo(x1,y1);
					graphics.lineTo(x2,y2);
					break;
				case CURVE:
					var x_controle:Number = (x1+x2)/2 + (y2-y1)/4;
					var y_controle:Number = (y1+y2)/2 + (x1-x2)/4;
					
					graphics.moveTo(x1,y1);
					graphics.curveTo(x_controle,y_controle,x2,y2);
					break;
				case ARROW:
					// TODO
				default:
					graphics.moveTo(x1,y1);
					graphics.lineTo(x2,y2);
					break;
			}
		}
	}
}