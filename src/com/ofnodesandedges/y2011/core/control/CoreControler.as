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
package com.ofnodesandedges.y2011.core.control{
	
	import com.ofnodesandedges.y2011.core.data.Graph;
	import com.ofnodesandedges.y2011.core.data.Node;
	import com.ofnodesandedges.y2011.core.drawing.GraphDrawer;
	import com.ofnodesandedges.y2011.core.interaction.InteractionControler;
	import com.ofnodesandedges.y2011.core.layout.CircularLayout;
	import com.ofnodesandedges.y2011.core.layout.RotationLayout;
	import com.ofnodesandedges.y2011.core.layout.forceAtlas.ForceAtlas;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class CoreControler{
		
		// Consts:
		private static const LAYOUT_HANDLER:String = "layout_handler";
		
		// Options:
		private static var _preProcessHooks:Vector.<Function> = new Vector.<Function>();
		private static var _postProcessHooks:Vector.<Function> = new Vector.<Function>();
		
		public static var textSizeRatio:Number = 24;
		public static var textThreshold:Number = 18;
		
		// Coordinates:
		public static var x:int = 0;
		public static var y:int = 0;
		public static var ratio:Number = 1;
		
		// Containers and graphics:
		private static var _container:DisplayObjectContainer;
		
		private static var _edgesShape:Shape;
		private static var _nodesShape:Shape;
		
		private static var _labelsSprite:Sprite;
		private static var _miscSprite:Sprite;
		private static var _mouseSprite:Sprite;
		
		private static var _width:int = 0;
		private static var _height:int = 0;
		
		// Display parameters:
		private static var _isWorking:Boolean = false;
		
		public static var displayNodes:Boolean = true;
		public static var displayEdges:Boolean = true;
		public static var displayLabels:Boolean = true;
		
		public static var isDraggable:Boolean = true;
		public static var isZoomable:Boolean = true;
		
		public static var edgeSizes:Boolean = false;
		
		public static var minDisplaySize:Number = 0;
		public static var maxDisplaySize:Number = 0;
		
		public static var minDisplayThickness:Number = 0;
		public static var maxDisplayThickness:Number = 0;
		
		public static function init(container:DisplayObjectContainer,width:int,height:int):void{
			_isWorking = true;
			
			_container = container;
			_width = width;
			_height = height;
			
			_edgesShape = Shape(_container.addChild(new Shape()));
			_nodesShape = Shape(_container.addChild(new Shape()));
			_labelsSprite = Sprite(_container.addChild(new Sprite()));
			_miscSprite = Sprite(_container.addChild(new Sprite()));
			_mouseSprite = Sprite(_container.addChild(new Sprite()));
			
			_labelsSprite.mouseChildren = false;
			_miscSprite.mouseChildren = false;
			_mouseSprite.mouseChildren = false;
			
			// Initialize the interaction controller:
			InteractionControler.init(_mouseSprite);
			
			_container.addEventListener(Event.ENTER_FRAME,onNewFrame);
		}
		
		public static function kill(deleteGraph:Boolean):void{
			InteractionControler.disable();
			_container.removeEventListener(Event.ENTER_FRAME,onNewFrame);
			
			if(deleteGraph){
				Graph.deleteGraph();
			}
			
			resetScene();
			_isWorking = false;
		}
		
		private static function onNewFrame(e:Event):void{
			var i:int, l:int;
			
			// Here is described the drawing process:
			//   - 0. Reset the stage:
			resetScene();
			
			//   - 1. Pre-process hooks:
			l = _preProcessHooks.length;
			for(i=0;i<l;i++){
				_preProcessHooks[i]();
			}
			
			//   - 2. Initialize the display coordinates:
			if(edgeSizes && displayEdges){
				Graph.rescaleNodes(_width,_height,minDisplaySize,maxDisplaySize,edgeSizes,minDisplayThickness,maxDisplayThickness);
			}else{
				Graph.rescaleNodes(_width,_height,minDisplaySize,maxDisplaySize);
			}
			
			Graph.setDisplayCoordinates();
			
			//   - 3. Post-process hooks:
			l = _postProcessHooks.length;
			for(i=0;i<l;i++){
				_postProcessHooks[i]();
			}
			
			//   - 4. Check the InteractionControler:
			InteractionControler.mouseOverNode();
			
			//   - 5. Draw the graph:
			GraphDrawer.drawGraph(
				displayNodes ? _nodesShape.graphics : null,
				displayEdges ? _edgesShape.graphics : null,
				displayLabels ? _labelsSprite : null
			);
		}
		
		private static function resetScene():void{
			_nodesShape.graphics.clear();
			_edgesShape.graphics.clear();
			
			while(_labelsSprite.numChildren){
				_labelsSprite.removeChildAt(0);
			}
		}
		
		public static function addPreProcessHook(f:Function):void{
			_preProcessHooks.push(f);
		}
		
		public static function removePreProcessHook(f:Function):void{
			var i:int, l:int = _preProcessHooks.length;
			
			if(hasPreProcessHook(f)){
				for(i=l-1;i>=0;i--){
					if(_preProcessHooks[i] == f){
						_preProcessHooks.splice(i,1);
					}
				}
			}
		}
		
		public static function hasPreProcessHook(f:Function):Boolean{
			var result:Boolean = false;
			var i:int, l:int = _preProcessHooks.length;
			
			for(i=0;i<l;i++){
				if(_preProcessHooks[i] == f){
					result = true;
					break;
				}
			}
			
			return result;
		}
		
		public static function addPostProcessHook(f:Function,unique:Boolean = true):void{
			if(!unique || !hasPostProcessHook(f)){
				_postProcessHooks.push(f);
			}
		}
		
		public static function removePostProcessHook(f:Function):void{
			var i:int, l:int = _postProcessHooks.length;
			
			if(hasPostProcessHook(f)){
				for(i=l-1;i>=0;i--){
					if(_postProcessHooks[i] == f){
						_postProcessHooks.splice(i,1);
					}
				}
			}
		}
		
		public static function hasPostProcessHook(f:Function):Boolean{
			var result:Boolean = false;
			var i:int, l:int = _postProcessHooks.length;
			
			for(i=0;i<l;i++){
				if(_postProcessHooks[i] == f){
					result = true;
					break;
				}
			}
			
			return result;
		}
		
		public static function resize(w:int,h:int):void{
			_width = w;
			_height = h;
		}

		public static function get width():int{
			return _width;
		}

		public static function get height():int{
			return _height;
		}

		public static function get isWorking():Boolean{
			return _isWorking;
		}

	}
}