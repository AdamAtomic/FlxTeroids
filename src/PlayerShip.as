package
{
	import org.flixel.*;

	//This is the class declaration for the little player ship that you fly around in
	public class PlayerShip extends WrapSprite
	{
		[Embed(source="ship.png")] private var ImgShip:Class;	//Graphic of the player's ship
		
		//We use this number to figure out how fast the ship is flying
		protected var _thrust:Number;
		
		//This function creates the ship, taking the list of bullets as a parameter
		public function PlayerShip()
		{
			super(FlxG.width/2-8, FlxG.height/2-8);
			loadRotatedGraphic(ImgShip,32,-1,false,true);
			alterBoundingBox();
			_thrust = 0;
		}
		
		//The main game loop function
		override public function update():void
		{
			wrap();
			
			//This is where we handle turning the ship left and right
			angularVelocity = 0;
			if(FlxG.keys.LEFT)
				angularVelocity -= 240;
			if(FlxG.keys.RIGHT)
				angularVelocity += 240;
			
			//This is where thrust is handled
			acceleration.x = 0;
			acceleration.y = 0;
			if(FlxG.keys.UP)
				FlxU.rotatePoint(90,0,0,0,angle,acceleration);

			if(FlxG.keys.justPressed("SPACE"))
			{
				//Space bar was pressed!  FIRE A BULLET
				var bullet:FlxSprite = (FlxG.state as PlayState).bullets.recycle() as FlxSprite;
				bullet.reset(x + (width - bullet.width)/2, y + (height - bullet.height)/2);
				bullet.angle = angle;
				FlxU.rotatePoint(150,0,0,0,bullet.angle,bullet.velocity);
				bullet.velocity.x += velocity.x;
				bullet.velocity.y += velocity.y;
			}
		}
	}
}