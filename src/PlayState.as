package
{
	import org.flixel.*;

	//This is our main game state, where we initialize all our game objects and do
	// things like check for game over, perform collisions, etc.
	public class PlayState extends FlxState
	{
		private var ship:Ship;			//Refers to the little player ship
		private var bullets:Array;	//A list of the bullets you shoot at the asteroids
		private var asteroids:Array;	//A list of all the asteroids 
		private var timer:Number;		//A timer to decide when to make a new asteroid
		
		public function PlayState()
		{
			var i:int;
			
			//Initialize the list of asteroids
			asteroids = new Array();
			addAsteroid();
			
			//Then instantiate the bullets you fire at your enemies.
			var s:FlxSprite;
			bullets = new Array();	//Initializing the array is very important and easy to forget!
			for(i = 0; i < 32; i++)		//Create 32 bullets for the player to recycle
			{
				//Instantiate a new 2x8 generic sprite offscreen
				s = new WrapSprite(-100, -100);
				s.createGraphic(8, 2);
				s.width = 10;		//We're going to exaggerate the bullet's bounding box a little
				s.height = 10;
				s.offset.x = -1;
				s.offset.y = -4;
				add(s);				//Add it to the state
				bullets.push(s);	//Add it to the array of player bullets
			}
			
			//Initialize the ship and add it to the layer
			ship = new Ship(bullets);
			add(ship);
		}
		
		//The main game loop function
		override public function update():void
		{
			//Count down the new asteroid timer
			timer -= FlxG.elapsed;
			if(timer <= 0)
				addAsteroid();
			
			//Perform collisions between the different objects.  Overlap will
			// check to see if any of those sprites touch, and if they do, it will
			// call kill() on both of them, which sets 'exists' to false, and 'dead' to true.
			//You can optionally pass it a callback function if you want more detailed reactions.
			FlxG.overlapArrays(bullets, asteroids);		//Check to see if any bullets overlap any asteroids
			FlxG.overlapArray(asteroids, ship);			//Check to see if any asteroids overlap the ship
			FlxG.collideArrays(asteroids, asteroids);	//Check for asteroid collisions
				
			//Pretty much always call the main game loop's parent update.
			//This goes and calls update on all the objects you added to this state
			super.update();
			
			//If the player died, reset the game
			if(!ship.exists)
				FlxG.switchState(PlayState);
		}
		
		//This function resets the timer and adds a new asteroid to the game
		private function addAsteroid():void
		{
			//First create a new asteroid
			var a:Asteroid = new Asteroid(asteroids);
			add(a);						//Add it to the state
			asteroids.push(a);			//Add it to the asteroids list
			timer = FlxG.random()*4;	//Reset the timer
		}
	}
}
