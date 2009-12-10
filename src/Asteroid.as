package
{
	import org.flixel.*;

	//This is the class used for all the different asteroid sizes
	public class Asteroid extends WrapSprite
	{
		private var asteroids:Array;
		
		[Embed(source="small.png")] private var ImgSmall:Class;
		[Embed(source="medium.png")] private var ImgMedium:Class;
		[Embed(source="large.png")] private var ImgLarge:Class;
		
		//This is where we create the actual asteroid
		public function Asteroid(Asteroids:Array,X:int=0,Y:int=0,VelocityX:Number=0,VelocityY:Number=0,Size:Class=null)
		{
			super((Size == null) ? ImgLarge : Size);	//If no graphic was provided, assume its the biggest one
			asteroids = Asteroids;						//Save off the asteroid list
			antialiasing = true;						//Smoother rotations
			
			//Set the asteroids a-rotatin' at a random speed (looks neat)
			angularVelocity = FlxG.random()*120 - 60;
			
			//Initialize a splinter of asteroid
			if((X != 0) || (Y != 0))
			{
				last.x = x = X;
				last.y = y = Y;
				velocity.x = VelocityX;
				velocity.y = VelocityY;
				return;	//Just return, the rest of the code here is for spawning a new large asteroid
			}
			
			//Let's spawn a giant asteroid!
			var initial_velocity:int = 20;
			//The basic idea here is we first try and figure out what side the asteroid
			// should come from, and then from there figure out how fast it should go,
			// and in what direction.  It looks kinda crazy but it's basically the same
			// block of code repeated twice, once for 'vertical' and once for 'horizontal'
			if(FlxG.random() < 0.5) 	//Appearing on the sides
			{
				if(FlxG.random() < 0.5)	//Appears on the left
				{
					last.x = x = -64 + offset.x;
					velocity.x = initial_velocity / 2 + FlxG.random() * initial_velocity;
				}
				else					//Appears on the right
				{
					last.x = x = FlxG.width + offset.x;
					velocity.x = -initial_velocity / 2 - FlxG.random() * initial_velocity;
				}
				last.y = y = FlxG.random()*(FlxG.height-height);
				velocity.y = FlxG.random() * initial_velocity * 2 - initial_velocity;
			}
			else						//Appearing on top or bottom
			{
				last.x = x = FlxG.random()*(FlxG.width-width);
				velocity.x = FlxG.random() * initial_velocity * 2 - initial_velocity;
				if(FlxG.random() < 0.5)	//Appears above
				{
					last.y = y = -64 + offset.y;
					velocity.y = initial_velocity / 2 + FlxG.random() * initial_velocity;
				}
				else					//Appears below
				{
					last.y = y = FlxG.height + offset.y;
					velocity.y = initial_velocity / 2 + FlxG.random() * initial_velocity;
				}
			}
		}
		
		//Asteroids are so simple that we don't even have to override their game loop.
		//BUT we do want to override their "kill" function.  FlxG.overlapArrays() will call
		// this whenever a bullet overlaps an asteroid.  We want to make sure it makes babies!
		override public function kill():void
		{
			//Default kill behavior - sets exists to false, and dead to true (useful for complex animations)
			super.kill();
			
			//Don't spawn chunks if this was the smallest asteroid bit
			if(_bw == 16)
				return;
			
			//Spawn new asteroid chunks
			var initial_velocity:int = 20;
			var slot:uint;
			var size:Class;
			//Need to figure out what size of chunk to show
			if(_bw == 64)	//_bw is a protected member that refers to the size of the graphic
			{
				size = ImgMedium;
				initial_velocity *= 2;
			}
			else
			{
				size = ImgSmall;
				initial_velocity *= 3;
			}
			//Figure out how many chunks to generate
			var numChunks:int = 2 + FlxG.random()*3;
			//For each chunk generate a new asteroid, filling in old slots in the list whenever possible.
			for(var i:uint = 0; i < numChunks; i++)
			{
				//So first we look for an old slot
				for(slot = 0; slot < asteroids.length; slot++)
				{
					if(!asteroids[slot].exists)
						break;
				}
				//Whether or not we found one, slot is set to the correct value now,
				// so we can create our new asteroid and add it to the state and the list.
				asteroids[slot] = new Asteroid(	asteroids, x + width / 2, y + height / 2, 
												FlxG.random() * initial_velocity * 2 - initial_velocity,
												FlxG.random() * initial_velocity * 2 - initial_velocity,
												size );
				FlxG.state.add(asteroids[slot]);
			}								
		}
		
		//These are basic collision handling routines that make the asteroids bounce off each other.
		//The default behavior is to simply stop.
		override public function hitFloor(Contact:FlxCore=null):Boolean
		{
			velocity.y = -velocity.y;
			angularVelocity = FlxG.random()*120 - 60;
			return true;
		}
		
		override public function hitCeiling(Contact:FlxCore=null):Boolean
		{
			velocity.y = -velocity.y;
			angularVelocity = FlxG.random()*120 - 60;
			return true;
		}
		
		override public function hitWall(Contact:FlxCore=null):Boolean
		{
			velocity.x = -velocity.x;
			angularVelocity = FlxG.random()*120 - 60;
			return true;
		}
	}
}