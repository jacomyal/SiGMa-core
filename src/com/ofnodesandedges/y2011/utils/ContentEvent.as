package com.ofnodesandedges.y2011.utils{
	
	import flash.events.Event;
	
	public class ContentEvent extends Event{
		
		private var _content:Object;
		
		public function ContentEvent(type:String,content:Object,bubbles:Boolean = false,cancelable:Boolean = false){
			super(type,bubbles,cancelable);
			_content = content;
		}

		public function get content():Object{
			return _content;
		}

	}
}