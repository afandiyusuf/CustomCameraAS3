package com.ya.object 
{
	import flash.automation.ActionGenerator;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.media.Camera;
	import flash.media.Video;
	/**
	 * ...
	 * @author Yusuf Afandi
	 */
	public class CustomCamera 
	{
		private var cam:Camera;
		private var vid:Video;
		private var container:MovieClip;
		
		private var thisHeight:int;
		private var thisWidth:int;
		
		public function CustomCamera(_container:MovieClip,_width:int,_height:int,_fps:int) 
		{
			
			cam = Camera.getCamera();
			
			vid = new Video(_width,_height);
			cam.setMode(_width, _height,_fps);
			
			thisWidth = _width;
			thisHeight = _height;
			
			vid.attachCamera(cam);
			container = _container;
			container.addChild(vid);
		}
		
		public function SetCameraMode(_width:int,_height:int,_fps:int):void
		{
			thisWidth = _width;
			thisHeight = _height;
			cam.setMode(_width, _height, _fps);
		}
		
		public function SwitchCamera():void
		{
			var camNames:String = cam.name;
			
			//check camera number
			if (Camera.names.length == 1)
			{
				trace("kamu hanya punya satu kamera");
				return;
			}
			
			for (var i:int = 0; i < Camera.names.length; i++)
			{
				if (Camera.names[i] == camNames)
				{
					//this is last camera, 
					// get first camera
					if (i == Camera.names.length -1)
					{
						cam = Camera.getCamera("1");
					}else {
						//get next camera
						cam = Camera.getCamera("" + (1 + i));
					}
				}
				
			}
			
			vid.attachCamera(null);
			vid.attachCamera(cam);
		}
		
		public function CloseCamera():void
		{
			vid.attachCamera(null);
			container.removeChild(vid);
			trace("hello");
		}
		
		public function PauseCamera():void
		{
			vid.attachCamera(null);
		}
		
		public function ResumeCamera():void
		{
			vid.attachCamera(cam);
		}
		
		public function RotateCamera():void
		{
			if (vid.rotation == 0)
			{
				vid.y = 0;
				vid.rotation = 90;
				vid.x = vid.width;
				
			}else if (vid.rotation == 90)
			{
				vid.rotation = 180;
				vid.y = vid.height;
				vid.x = vid.width;
			}else if (vid.rotation == 180)
			{
				vid.rotation = -90;
				vid.x = 0;
				vid.y = vid.height;
			}else if (vid.rotation == -90)
			{
				vid.rotation = 0;
				vid.x = 0;
				vid.y = 0;
			}
			
			trace(vid.rotation);
		}
		
		
		public function GetBitmapData():BitmapData
		{
			var bmd:BitmapData = new BitmapData(container.width, container.height, false);
			bmd.draw(container);
			return bmd;
		}
	}

}