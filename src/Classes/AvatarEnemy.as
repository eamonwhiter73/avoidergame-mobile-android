package Classes
{	
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	public class AvatarEnemy extends Sprite
	{
		
		//Make image
		[Embed(source='Enemypic.png')]
		private static var Enemypic:Class;
		
		private var texture:Texture = Texture.fromBitmap(new Enemypic());
		
		private var image:Image = new Image(texture);
		
		public function AvatarEnemy() 
		{				
			//image.addEventListener(TouchEvent.TOUCH, onTouch); //On touch of this image, do onTouch
			
			addChild(image);
		}
	}
}
