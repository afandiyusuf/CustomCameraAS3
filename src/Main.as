package
{
	import com.ya.object.CustomCamera;
	import com.ya.object.ImageLoader;
	import flash.desktop.NativeApplication;
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.KeyboardEvent;
	import flash.filesystem.File;
	import flash.ui.Keyboard;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	
	/**
	 * ...
	 * @author Yusuf Afandi
	 */
	public class Main extends Sprite 
	{
		private var cc:CustomCamera ;
		private var b:Bitmap;
		private var l:ImageLoader;
		
		
		public function Main() 
		{
			
			//how to use image loader
			var urlImage:String = File.documentsDirectory.resolvePath("a.jpg").url;
			var movieClipContainer:MovieClip = new MovieClip();
			imageLoader = new ImageLoader(urlImage);
			imageLoader.addTo(movieClipContainer);
			addChild(movieClipContainer);
			
			
			//how to add custom camera
			var cameraContainer:MovieClip = new MovieClip();
			customCamera= new CustomCamera(cameraContainer,100,80,60);
			addChild(cameraContainer);
			
			
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, testKeyboard);
			
			
		}
		
		private function testKeyboard(e:KeyboardEvent):void
		{
			if (e.charCode == Keyboard.ENTER)
			{
				cc.CloseCamera();
				//trace("hei");
			}else if (e.charCode == Keyboard.SPACE)
			{
				cc.PauseCamera();
				//trace("hei");
			}else if (e.keyCode == Keyboard.R)
			{
				cc.RotateCamera();
			}else if (e.keyCode == Keyboard.S)
			{
				cc.SwitchCamera();
			}else if (e.keyCode == Keyboard.P)
			{
				try{
					removeChild(b)
				}catch (e:*)
				{
					trace(e);
				}
				
				b = new Bitmap(cc.GetBitmapData());
				addChild(b);
			}
		}
		

		
	}
	
}