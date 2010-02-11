package
{
	import org.flixel.*;

	//This is our main game state, where we initialize all our game objects and do
	// things like check for game over, perform collisions, etc.
	public class PlayState extends FlxState
	{
		protected var _ship:Ship;			//Refers to the little player ship
		protected var _bullets:FlxGroup;	//A list of the bullets you shoot at the asteroids
		protected var _asteroids:FlxGroup;	//A list of all the asteroids 
		protected var _timer:Number;		//A timer to decide when to make a new asteroid
		
		override public function create():void
		{
			FlxG.mouse.hide();
			var i:int;
			
			//Initialize the list of asteroids
			_asteroids = new FlxGroup();
			add(_asteroids);
			Asteroid.group = _asteroids;
			addAsteroid();
			
			//Then instantiate the bullets you fire at your enemies.
			var s:FlxSprite;
			_bullets = new FlxGroup();	//Initializing the array is very important and easy to forget!
			for(i = 0; i < 32; i++)		//Create 32 bullets for the player to recycle
			{
				//Instantiate a new 2x8 generic sprite offscreen
				s = new WrapSprite(-100, -100);
				s.createGraphic(8, 2);
				s.width = 10;		//We're going to exaggerate the bullet's bounding box a little
				s.height = 10;
				s.offset.x = -1;
				s.offset.y = -4;
				s.exists = false;
				_bullets.add(s);	//Add it to the array of player bullets
			}
			add(_bullets);
			
			//Initialize the ship and add it to the layer
			_ship = new Ship(_bullets.members);
			add(_ship);
		}
		
		//The main game loop function
		override public function update():void
		{
			//Count down the new asteroid timer
			_timer -= FlxG.elapsed;
			if(_timer <= 0)
				addAsteroid();
			
			//Perform collisions between the different objects.  Overlap will
			// check to see if any of those sprites touch, and if they do, it will
			// call kill() on both of them, which sets 'exists' to false, and 'dead' to true.
			//You can optionally pass it a callback function if you want more detailed reactions.
			FlxU.overlap(_bullets, _asteroids);		//Check to see if any bullets overlap any asteroids
			FlxU.overlap(_asteroids, _ship);			//Check to see if any asteroids overlap the ship
			FlxU.collide(_asteroids, _asteroids);	//Check for asteroid collisions
				
			//Pretty much always call the main game loop's parent update.
			//This goes and calls update on all the objects you added to this state
			super.update();
			
			//If the player died, reset the game
			if(!_ship.exists)
				FlxG.state = new PlayState();
		}
		
		//This function resets the timer and adds a new asteroid to the game
		private function addAsteroid():void
		{
			//Create a new asteroid and add it to the group
			_asteroids.add(new Asteroid().create());
			_timer = FlxU.random()*4;	//Reset the timer
		}
	}
}
