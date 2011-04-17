package com.ofnodesandedges.y2011.core.control{
	
	import com.ofnodesandedges.y2011.core.data.Graph;
	import com.ofnodesandedges.y2011.core.data.Node;
	import com.ofnodesandedges.y2011.core.drawing.GraphDrawer;
	import com.ofnodesandedges.y2011.core.interaction.InteractionControler;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class CoreControler{
		
		// Consts:
		private static const LAYOUT_HANDLER:String = "layout_handler";
		
		// Options:
		private static var _workingLayouts:Vector.<Function> = new Vector.<Function>();
		private static var _graphicEffects:Vector.<Function> = new Vector.<Function>();
		
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
		
		public static function init(container:DisplayObjectContainer,width:int,height:int):void{
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
		
		private static function onNewFrame(e:Event):void{
			var i:int, l:int;
			
			// Here is described the drawing process:
			//   - 0. Reset the stage:
			resetScene();
			
			//   - 1. Layout, if needed:
			l = _workingLayouts.length;
			for(i=0;i<l;i++){
				_workingLayouts[LAYOUT_HANDLER]();
			}
			
			//   - 2. Initialize the display coordinates:
			Graph.rescaleNodes(_width,_height);
			Graph.setDisplayCoordinates();
			
			//   - 3. Graphic effects:
			l = _graphicEffects.length;
			for(i=0;i<l;i++){
				_graphicEffects[LAYOUT_HANDLER]();
			}
			
			//   - 4. Draw the graph:
			GraphDrawer.drawGraph(_nodesShape.graphics,_edgesShape.graphics,_labelsSprite);
		}
		
		private static function resetScene():void{
			_nodesShape.graphics.clear();
			_edgesShape.graphics.clear();
			
			while(_labelsSprite.numChildren){
				_labelsSprite.removeChildAt(0);
			}
		}

		public static function get width():int{
			return _width;
		}

		public static function get height():int{
			return _height;
		}
	}
}