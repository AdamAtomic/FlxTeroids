package
{
	import org.flixel.*;

	//In asteroids, everything wraps around from one side of the screen to the other.
	//To simulate this effect, I build a simple wrapper for FlxSprite that handles that behavior.
	public class WrapSprite extends FlxSprite
	{
		//This is the constructor - it is just like the FlxSprite constructor,
		// except we shrink the sprite's bounding box a little bit for more forgiving play.
		public function WrapSprite(X:int=0, Y:int=0, Graphic:Class=null)
		{
			super(X, Y, Graphic);
			alterBoundingBox();
		}
		
		//This function reduces the size of the bounding box
		public function alterBoundingBox():void
		{
			width = width*0.55;
			height = height*0.55;
			offset.x = (frameWidth - width) / 2;
			offset.y = (frameHeight - height) / 2;
		}
		
		//The game loop function
		override public function update():void
		{
			//Always call super.update() unless you really know what you're doing!!
			super.update();
			
			//This is the actual wrap effect code.  All this is doing is checking to see
			// if the object went off the screen.  If it did, it moves it to the other side.
			//It looks kind of crazy but that's because we done shrank up the bounding boxes,
			// which requires a little extra math to make sure the graphics don't disappear
			// or re-appear too early.
			if(x < -frameWidth + offset.x)
				x = FlxG.width + offset.x;
			else if(x > FlxG.width + offset.x)
				x = -frameWidth + offset.x;
			if(y < -frameHeight + offset.y)
				y = FlxG.height + offset.y;
			else if(y > FlxG.height + offset.y)
				y = -frameHeight + offset.y;
		}
	}
}