##how to use
this is example how to use this class


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
    	
    	
    	public class Main extends Sprite 
    	{
    		private var customCamera:CustomCamera ;
    		private var b:Bitmap;
    		private var movieClipContainer:MovieClip = new MovieClip();
    		
    		
    		public function Main() 
    		{
    			
    			//how to use image loader
    			var urlImage:String = File.documentsDirectory.resolvePath("a.jpg").url;
    			
    			var imageLoader:ImageLoader;
    			imageLoader = new ImageLoader(urlImage);
    			imageLoader.successEvent = successLoad;
    			imageLoader.addTo(movieClipContainer);
    			addChild(movieClipContainer);
    			
    			
    			//how to add custom camera
    			var cameraContainer:MovieClip = new MovieClip();
    			customCamera= new CustomCamera(cameraContainer,100,80,60);
    			addChild(cameraContainer);
    			
    			
    			
    			stage.addEventListener(KeyboardEvent.KEY_DOWN, testKeyboard);
    			
    			
    		}
    		
    		private function successLoad():void
    		{
    			trace(movieClipContainer.width);
    		}
    		
    		private function testKeyboard(e:KeyboardEvent):void
    		{
    			if (e.charCode == Keyboard.ENTER)
    			{
    				customCamera.CloseCamera();
    				//trace("hei");
    			}else if (e.charCode == Keyboard.SPACE)
    			{
    				customCamera.PauseCamera();
    				//trace("hei");
    			}else if (e.keyCode == Keyboard.R)
    			{
    				customCamera.RotateCamera();
    			}else if (e.keyCode == Keyboard.S)
    			{
    				customCamera.SwitchCamera();
    			}else if (e.keyCode == Keyboard.P)
    			{
    				try{
    					removeChild(b)
    				}catch (e:*)
    				{
    					trace(e);
    				}
    				
    				b = new Bitmap(customCamera.GetBitmapData());
    				addChild(b);
    			}
    		}
    		
    
    		
    	}
    	}
	
