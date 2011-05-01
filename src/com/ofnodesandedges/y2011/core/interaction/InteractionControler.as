package com.ofnodesandedges.y2011.core.interaction{
	
	import com.ofnodesandedges.y2011.core.control.CoreControler;
	import com.ofnodesandedges.y2011.core.data.Graph;
	import com.ofnodesandedges.y2011.core.data.Node;
	import com.ofnodesandedges.y2011.utils.ContentEvent;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.utils.getTimer;
	
	public class InteractionControler{
		
		// Event dispatcher:
		private static var _eventDispatcher:EventDispatcher = new EventDispatcher();
		
		// Event types:
		public static const CLICK_NODES:String = "click nodes";
		public static const OVER_NODES:String = "over nodes";
		public static const CLICK_STAGE:String = "click stage";
		
		public static const ON_ZOOMING:String = "on zooming";
		public static const ON_GRAPH_MOVING:String = "on graph moving";
		
		// Error messages:
		private static const INVALID_DISPLAY_OBJECT:String = "The mouse display object is null.";
		private static const UNCONNECTED_DISPLAY_OBJECT:String = "The mouse display object is not added to the stage.";
		
		private static const MOVING_STEP:Number = 15;
		private static const ZOOMING_STEP:Number = 2;
		
		private static const ZOOM_RATIO:Number = 1.5;
		private static const ZOOM_SPEED:Number = 3/4;
		private static const CLICK_TIME:uint = 250;
		
		private static var _mouseSupport:DisplayObject;
		
		private static var _tempX:Number = 0;
		private static var _tempY:Number = 0;
		private static var _mouseX:Number = 0;
		private static var _mouseY:Number = 0;
		private static var _zoomRatio:Number = 1;
		
		private static var _clickTime:uint = 0;
		private static var _isMouseDown:Boolean = false;
		
		public static function init(mouseSupport:DisplayObject):void{
			_mouseSupport = mouseSupport;
			
			// Security:
			if(!_mouseSupport){
				throw new Error(INVALID_DISPLAY_OBJECT);
			}else if(!_mouseSupport.stage){
				throw new Error(UNCONNECTED_DISPLAY_OBJECT);
			}
			
			enable();
		}
		
		public static function mouseOverNode():void{
			var ids:Array = [];
			
			var nodes:Vector.<Node> = Graph.nodes, node:Node
			var i:int, l:int = nodes.length;
			
			for(i=0;i<l;i++){
				node = nodes[i];
				
				var dist:Number = Math.sqrt(Math.pow(_mouseX-node.displayX,2)+Math.pow(_mouseY-node.displayY,2));
				
				if(dist<node.displaySize){
					node.displaySize *= 1.2;
					node.attributes[Node.BORDER_THICKNESS] = node.displaySize/3;
					
					node.attributes[Node.STOPPED] = true;
					
					ids.push(node.id);
					
					dispatchEvent(new ContentEvent(OVER_NODES,ids));
				}else{
					node.attributes[Node.STOPPED] = false;
				}
			}
		}
		
		public static function enable():void{
			addEventListeners();
			
			_mouseSupport.addEventListener(Event.ADDED_TO_STAGE,addEventListeners);
			_mouseSupport.addEventListener(Event.REMOVED_FROM_STAGE,removeEventListeners);
		}
		
		public static function disable():void{
			removeEventListeners();
			
			_mouseSupport.removeEventListener(Event.ADDED_TO_STAGE,addEventListeners);
			_mouseSupport.removeEventListener(Event.REMOVED_FROM_STAGE,removeEventListeners);
		}
		
		public static function addEventListener(type:String,listener:Function,useCapture:Boolean = false,priority:int = 0,useWeakReference:Boolean = false):void{
			_eventDispatcher.addEventListener(type,listener,useCapture,priority,useWeakReference);
		}
		
		private static function addEventListeners(e:Event = null):void{
			_mouseSupport.stage.addEventListener(MouseEvent.MOUSE_DOWN,mouseDown);
			_mouseSupport.stage.addEventListener(MouseEvent.MOUSE_UP,mouseUp);
			_mouseSupport.stage.addEventListener(MouseEvent.MOUSE_WHEEL,mouseWheel);
			_mouseSupport.stage.addEventListener(MouseEvent.MOUSE_MOVE,mouseMove);
		}
		
		private static function removeEventListeners(e:Event = null):void{
			_mouseSupport.stage.removeEventListener(MouseEvent.MOUSE_DOWN,mouseDown);
			_mouseSupport.stage.removeEventListener(MouseEvent.MOUSE_UP,mouseUp);
			_mouseSupport.stage.removeEventListener(MouseEvent.MOUSE_WHEEL,mouseWheel);
			_mouseSupport.stage.removeEventListener(MouseEvent.MOUSE_MOVE,mouseMove);
		}
		
		private static function mouseDown(m:MouseEvent):void{
			_tempX = CoreControler.x;
			_tempY = CoreControler.y;
			_clickTime = getTimer();
			
			_isMouseDown = true;
		}
		
		private static function mouseUp(m:MouseEvent):void{
			_isMouseDown = false;
			
			if(getTimer() - _clickTime<CLICK_TIME){
				click();
			}
		}
		
		private static function mouseWheel(m:MouseEvent):void{
			_mouseX = m.stageX;
			_mouseY = m.stageY;
			
			if(m.delta>=0){
				startZoomIn();
			}else{
				startZoomOut();
			}
		}
		
		private static function mouseMove(m:MouseEvent):void{
			if(_isMouseDown){
				CoreControler.x = m.localX - _mouseX + _tempX;
				CoreControler.y = m.localY - _mouseY + _tempY;
				
				dispatchEvent(new ContentEvent(ON_GRAPH_MOVING,{"new_x":CoreControler.x,"new_y":CoreControler.y}));
			}else{
				_mouseX = m.localX;
				_mouseY = m.localY;
			}
		}
		
		private static function click():void{
			// Check if it clicks on a node:
			var ids:Array = [];
			
			var nodes:Vector.<Node> = Graph.nodes, node:Node;
			var i:int, l:int = nodes.length;
			
			for(i=0;i<l;i++){
				node = nodes[i];
				
				var dist:Number = Math.sqrt(Math.pow(_mouseX-node.displayX,2)+Math.pow(_mouseY-node.displayY,2));
				
				if(dist<node.displaySize){
					ids.push(node.id);
					break;
				}
			}
			
			if(ids.length){
				// If clicks a node:
				dispatchEvent(new ContentEvent(CLICK_NODES,ids));
			}else{
				// If clicks the stage:
				dispatchEvent(new ContentEvent(CLICK_STAGE,{"x":_mouseX,"y":_mouseY}));
			}
		}
		
		private static function startZoomIn():void{
			_zoomRatio = ZOOM_RATIO*CoreControler.ratio;
			_mouseSupport.stage.addEventListener(Event.ENTER_FRAME,zoomIn);
			_mouseSupport.stage.removeEventListener(Event.ENTER_FRAME,zoomOut);
			
			var new_x:int = _mouseX+(CoreControler.x-_mouseX)*_zoomRatio/CoreControler.ratio;
			var new_y:int = _mouseY+(CoreControler.y-_mouseY)*_zoomRatio/CoreControler.ratio;
			dispatchEvent(new ContentEvent(ON_ZOOMING,{"new_ratio":_zoomRatio,"new_x":new_x,"new_y":new_y}));
		}
		
		private static function startZoomOut():void{
			_zoomRatio = CoreControler.ratio/ZOOM_RATIO;
			_mouseSupport.stage.addEventListener(Event.ENTER_FRAME,zoomOut);
			_mouseSupport.stage.removeEventListener(Event.ENTER_FRAME,zoomIn);
			
			var new_x:int = _mouseX+(CoreControler.x-_mouseX)*_zoomRatio/CoreControler.ratio;
			var new_y:int = _mouseY+(CoreControler.y-_mouseY)*_zoomRatio/CoreControler.ratio;
			dispatchEvent(new ContentEvent(ON_ZOOMING,{"new_ratio":_zoomRatio,"new_x":new_x,"new_y":new_y}));
		}
		
		private static function zoomIn(e:Event):void{
			if(_zoomRatio/CoreControler.ratio>1.05){
				var new_ratio:Number = CoreControler.ratio*(1-ZOOM_SPEED) + _zoomRatio*ZOOM_SPEED;
				CoreControler.x = _mouseX+(CoreControler.x-_mouseX)*new_ratio/CoreControler.ratio;
				CoreControler.y = _mouseY+(CoreControler.y-_mouseY)*new_ratio/CoreControler.ratio;
				CoreControler.ratio = new_ratio;
			}else{
				_mouseSupport.stage.removeEventListener(Event.ENTER_FRAME,zoomIn);
			}
		}
		
		private static function zoomOut(e:Event):void{
			if(CoreControler.ratio/_zoomRatio>1.05){
				var new_ratio:Number = CoreControler.ratio*(1-ZOOM_SPEED) + _zoomRatio*ZOOM_SPEED;
				CoreControler.x = _mouseX+(CoreControler.x-_mouseX)*new_ratio/CoreControler.ratio;
				CoreControler.y = _mouseY+(CoreControler.y-_mouseY)*new_ratio/CoreControler.ratio;
				CoreControler.ratio = new_ratio;
			}else{
				_mouseSupport.stage.removeEventListener(Event.ENTER_FRAME,zoomOut);
			}
		}
		
		private static function dispatchEvent(event:Event):void{
			_eventDispatcher.dispatchEvent(event);
		}
		
	}
}