package com.ofnodesandedges.y2011.core.interaction{
	import com.ofnodesandedges.y2011.core.data.Graph;
	import com.ofnodesandedges.y2011.core.data.Node;
	
	public class Glasses{
		
		public static var fishEyePower:Number = 5;
		public static var fishEyeRadius:Number = 200;
		
		/**
		 * This method will apply a 'FishEye' effect on the graph, around the position of the
		 * mouse. The radius of this FishEye is <code>fishEyeRadius</code>, and its power 
		 * <code>fishEyePower</code>.
		 * <br />
		 * To activate it, just write:
		 * <code>CoreControler.addGraphicEffect(Glasses.fishEyeDisplay);</code>
		 * <br />
		 * To unactivate it, just write:
		 * <code>CoreControler.removeGraphicEffect(Glasses.fishEyeDisplay);</code>
		 * 
		 */		
		public static function fishEyeDisplay():void{
			var xDist:Number, yDist:Number, dist:Number, newDist:Number, newSize:Number;
			var mX:Number = InteractionControler.mouseX, mY:Number = InteractionControler.mouseY;
			
			var powerExp:Number = Math.exp(fishEyePower);
			
			for each(var node:Node in Graph.nodes){
				xDist = node.displayX - mX;
				yDist = node.displayY - mY;
				
				dist = Math.sqrt(xDist*xDist + yDist*yDist);
				
				if(dist<fishEyeRadius){
					newDist = powerExp/(powerExp-1)*fishEyeRadius*(1-Math.exp(-dist/fishEyeRadius*fishEyePower));
					newSize = powerExp/(powerExp-1)*fishEyeRadius*(1-Math.exp(-dist/fishEyeRadius*fishEyePower));
					
					if(!node.isFixed){
						node.displayX = mX + xDist*(newDist/dist*3/4 + 1/4);
						node.displayY = mY + yDist*(newDist/dist*3/4 + 1/4);
					}
					
					node.displaySize = Math.min(node.displaySize*newSize/dist,10*node.displaySize);
				}
			}
		}
	}
}