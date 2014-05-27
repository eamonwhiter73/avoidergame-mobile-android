package Classes
{
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.utils.AssetManager;
	import Classes.EmbeddedAssets;

	public class Avatar extends Sprite
	{	
		
		/*private var myBitmap:Bitmap = new Avatarpic();
		private var hit_1:PixelHitArea = new PixelHitArea ( myBitmap, .5); // second arg is sampling for bitmapData
		private var img_1:PixelImageTouch = new PixelImageTouch ( Texture.fromBitmap (myBitmap), hit_1);*/
		
		public function Avatar()
		{
			var assets:AssetManager = new AssetManager();
			assets.verbose = true;
			assets.enqueue(EmbeddedAssets);
			
			var img:Image = new Image(assets.getTexture("Avatarpic"));
			//First we must create hitArea for a bitmapaData used in Image.
			addChild(img);
		}
	}
}