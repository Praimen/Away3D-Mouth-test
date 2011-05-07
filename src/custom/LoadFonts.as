package custom
{
	import flash.net.*;
	import flash.text.*;
	import flash.events.*;
	
	import wumedia.vector.*;	
	
	public class LoadFonts
	{
		
		private var _loader:URLLoader;
		
		public function LoadFonts(loadURL:String){
			_loader = new URLLoader();
			_loader.dataFormat = URLLoaderDataFormat.BINARY;
			_loader.addEventListener(Event.COMPLETE, initFonts);
			_loader.load(new URLRequest(loadURL));
			
		}
		
		public function initFonts(event:Event):void{			
			VectorText.extractFont(_loader.data);			
			CustomDispatcher.GetInstance().dispatchEvent(new CustomEvent(CustomEvent.FONT_LOADED));
			trace("hello");
			
		}			
		
	}
}

