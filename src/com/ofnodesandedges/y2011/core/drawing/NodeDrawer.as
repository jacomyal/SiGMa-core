package com.ofnodesandedges.y2011.core.drawing{
	
	import com.ofnodesandedges.y2011.core.data.Graph;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.Shape;
	
	public class NodeDrawer{
		
		public static const NONE:int = -1;
		
		private static const INVALID_SHAPE:String = "Invalid shape.";
		
		/**
		 * This method adds a <code>Shape</code> with the node drawn on it.
		 *  
		 * @param r					(Number) The size of the node.
		 * @param x					(int) The x position of the center of the node.
		 * @param y					(int) The y position of the center of the node.
		 * @param color				(uint) The color of the node.
		 * @param container			(DisplayObjecContainer) The display object container of the new Shape.
		 * @param shape				(int, default-value = 0) The shape of the node:
		 * 							- If 0, the node will be drawn as a disc.
		 * 							- If >0, the node will be drawn as a polygon with <code>shape</code> sides.
		 * @param outlineThickness	(int, default-value = 0) The outline thickness of the node.
		 * @param outlineColor		(uint, default-value = 0x000000) The outline color of the node.
		 * 
		 */		
		public static function addNode(r:Number,x:int,y:int,color:uint,container:DisplayObjectContainer,shape:int = 0,outlineThickness:int = 0,outlineColor:uint = 0x000000):void{
			drawNode(r,x,y,color,Shape(container.addChild(new Shape())).graphics,shape,outlineThickness,outlineColor);
		}
		
		/**
		 * This method draws a node.
		 *  
		 * @param r					(Number) The size of the node.
		 * @param x					(int) The x position of the center of the node.
		 * @param y					(int) The y position of the center of the node.
		 * @param color				(uint) The color of the node.
		 * @param graphics			(Graphics) The graphics where the polygon has to be drawn.
		 * @param shape				(int, default-value = 0) The shape of the node:
		 * 							- If 0, the node will be drawn as a disc.
		 * 							- If >0, the node will be drawn as a polygon with <code>shape</code> sides.
		 * @param outlineThickness	(int, default-value = 0) The outline thickness of the node.
		 * @param outlineColor		(uint, default-value = 0x000000) The outline color of the node.
		 * 
		 */		
		public static function drawNode(r:Number,x:int,y:int,color:uint,graphics:Graphics,shape:int = 0,outlineThickness:int = 0,outlineColor:uint = 0x000000):void{
			if(outlineThickness>0){
				graphics.lineStyle(outlineThickness,outlineColor);
			}
			
			graphics.beginFill(color);
			
			var s:int = shape==NONE ? Graph.defaultNodeShape : shape;
			
			if(s==0){
				// This will draw the node as a circle:
				graphics.drawCircle(x,y,r);
			}else if(s>0){
				drawPoly(r,s,x,y,graphics);
			}else{
				throw new Error(INVALID_SHAPE);
			}
			
			graphics.endFill();
		}
		
		/**
		 * This method draws a polygon.
		 *  
		 * @param r			(Number) The radius of the polygon.
		 * @param seg		(int) The count of sides.
		 * @param x			(int) The x position of the center of the polygon.
		 * @param y			(int) The y position of the center of the polygon.
		 * @param graphics	(Graphics) The graphics where the polygon has to be drawn.
		 * @param isFillSet	(Boolean, default-value = true) 
		 * 					Determines if the beginFill() method has to be called in the method or not. If
		 * 					it has to, it will plot it with no line-style, and in black.
		 * 
		 */		
		private static function drawPoly(r:Number,seg:int,x:Number,y:Number,graphics:Graphics,isFillSet:Boolean = true):void{
			var poly_id:int = 0;
			var coords:Array = new Array();
			var ratio:Number = 360/seg;
			
			if(!isFillSet){
				graphics.beginFill(0x000000,1);
			}
			
			for(var i:int=0;i<=360;i+=ratio){
				var px:Number=x+Math.sin(Math.PI/180*i)*r;
				var py:Number=y-Math.cos(Math.PI/180*i)*r;
				coords[poly_id]=new Array(px,py);
				
				if(poly_id>=1){
					graphics.lineTo(coords[poly_id][0],coords[poly_id][1]);
				}else{
					graphics.moveTo(coords[poly_id][0],coords[poly_id][1]);
				}
				
				poly_id++;
			}
			
			poly_id=0;
		}
	}
}