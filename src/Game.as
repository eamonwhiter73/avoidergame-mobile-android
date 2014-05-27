package
{

import flash.geom.Point;

import Classes.EmbeddedAssets;

import starling.display.Image;
import starling.display.Sprite;
import starling.events.EnterFrameEvent;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.textures.Texture;
import starling.utils.AssetManager;

	public class Game extends Sprite
	{	
		public var img:Image;
		public var img2:Image;
		private var paused2:Boolean = false;
		private var counter:int = 0;
		
		public function Game() 
		{	
			var assets:AssetManager = new AssetManager();
			assets.verbose = true;
			assets.enqueue(EmbeddedAssets);
			
			assets.loadQueue(function(ratio:Number):void
			{
				trace("Loading assets, progress:", ratio);
				
				if (ratio == 1.0) {
					var texture:Texture = assets.getTexture("Avatarpic");
					var texture2:Texture = assets.getTexture("Enemypic");
					
					img = new Image(texture);
					img.x = 200;
					img.y = 300;
					
					img2 = new Image(texture2);
					img2.x = 320;
					img2.y = 480;
					
					addChild(img);
					addChild(img2);
					
					img.addEventListener(TouchEvent.TOUCH, onTouch);
					addEventListener(EnterFrameEvent.ENTER_FRAME, doCounter);
				}
			});
		}
		
		private function doCounter():void {
			counter++;
		}
		
		private function onTouch(e:TouchEvent):void
		{						
			var touch:Touch = e.getTouch(this);
			
			if (touch.phase == TouchPhase.BEGAN) {
				trace("you touched it");
				/*stage.color = 0xff0000;
				paused2 = true;*/
				addEventListener(EnterFrameEvent.ENTER_FRAME, withImage);
			}
			if (touch.phase == TouchPhase.MOVED) {
				trace("moving");
				var p1:Point = new Point(img.x, img.y);
				var p2:Point = new Point(img2.x, img2.y);
				
				var distance:Number = Point.distance(p1, p2);
				var radius1:Number = img.width / 2;
				var radius2:Number = img2.width / 2;
				
				if (distance < radius1 + radius2) {
					trace("enemy has been touched");
					stage.color = 0xff0000;
					img.removeEventListener(TouchEvent.TOUCH, onTouch);
					removeEventListener(EnterFrameEvent.ENTER_FRAME, doCounter);
					paused2 = true;
				}
			}
			if (touch.phase == TouchPhase.ENDED) {
				removeEventListener(EnterFrameEvent.ENTER_FRAME, withImage);
			}
			/*if (touch3.phase == TouchPhase.ENDED && paused2) {
			removeEventListener(EnterFrameEvent.ENTER_FRAME, withImage);
			image2.removeEventListener(TouchEvent.TOUCH, onTouch);
			
			}*/
			
			function withImage():void {
				img.x = touch.globalX;
				img.y = touch.globalY;
			}
		}
		
		public function getIsOver():Boolean {
			return paused2;
		}
		
		public function getScore():int {
			return counter;
		}
	}
}