package
{
	import org.flixel.*;

	//This is the class declaration for the little player ship that you fly around in
	public class Ship extends WrapSprite
	{
		private var bullets:Array;		//Refers to the bullets you can shoot at enemies
		private var bulletIndex:int;		//Keeps track of where in the list of bullets we are
		
		[Embed(source="ship.png")] private var ImgShip:Class;	//Graphic of the player's ship
		
		//This function creates the ship, taking the list of bullets as a parameter
		public function Ship(Bullets:Array)
		{
			super(FlxG.width/2-8, FlxG.height/2-8, ImgShip);
			bullets = Bullets;	//Save a reference to the bullets array
			bulletIndex = 0;	//Initialize our list marker to the first entry
			
			angle = -90;		//Start the ship pointed upward
			maxThrust = 90;		//Cap the thrust at 90p/s2
			antialiasing = true;//Smoother rotations
		}
		
		//The main game loop function
		override public function update():void
		{
			//This is where we handle turning the ship left and right
			angularVelocity = 0;
			if(FlxG.keys.LEFT)
				angularVelocity -= 240;
			if(FlxG.keys.RIGHT)
				angularVelocity += 240;
			
			//This is where thrust is handled
			thrust = 0;
			if(FlxG.keys.UP)
				thrust -= maxThrust*3;
			
			//The all important parent game loop update - this calls WrapSprite.update()
			super.update();
			
			if(FlxG.keys.justPressed("SPACE"))
			{
				//Space bar was pressed!  FIRE A BULLET
				var b:FlxSprite = bullets[bulletIndex];	//Figure out which bullet to fire
				b.reset(x + (width - b.width) / 2, y + (height - b.height) / 2);
				b.angle = angle;
				b.velocity = FlxU.rotatePoint(150,0,0,0,b.angle);
				b.velocity.x += velocity.x;
				b.velocity.y += velocity.y;
				bulletIndex++;							//Increment our bullet list tracker
				if(bulletIndex >= bullets.length)		//And check to see if we went over
					bulletIndex = 0;					//If we did just reset.
			}
		}
	}
}