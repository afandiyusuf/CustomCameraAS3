package com.ya.object 
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	/**
	 * ...
	 * @author 
	 * 
	 */
	public class ImageLoader extends MovieClip
	{
		private var loader:Loader = new Loader();
		private var url:String = "";
		private var container:MovieClip;
		
		private var successFunction:Function;
		private var errorFunction:Function;
		private var bitmap:Bitmap;
		
		public function ImageLoader(_url:String) 
		{
			
			url = _url;
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, LoadComplete);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, LoadError);
			
		}
		
		public function addTo(container:MovieClip):void
		{
			this.container = container;
			loader.load(new URLRequest(url));
		}
		
		public function set successEvent(_successFunction:Function):void
		{
			
			successFunction = _successFunction;
		}
		
		public function set errorEvent(_errorFunction:Function):void
		{
			errorFunction = _errorFunction;
		}
		
		public function DestroyThis():void
		{
			try{
				container.removeChild(bitmap);
				bitmap = null;
				loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, LoadComplete);
				loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, LoadError);
			}catch (e:*) {
				
			}
		}
		
		private function LoadComplete(e:Event):void
		{
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, LoadComplete);
			loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, LoadError);
			
			bitmap = Bitmap(loader.content);
			container.addChild(bitmap);
			
			if (successFunction != null)
				successFunction();
		}
		
		private function LoadError(e:IOErrorEvent):void
		{
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, LoadComplete);
			loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, LoadError);
			
			if (errorFunction != null)
				errorFunction();
		}
		
		
		
	}

}