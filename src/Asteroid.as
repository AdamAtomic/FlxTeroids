package
{
	import org.flixel.*;

	//This is the class used for all the different asteroid sizes
	public class Asteroid extends WrapSprite
	{
		static public var group:FlxGroup;
		
		[Embed(source="small.png")] private var ImgSmall:Class;
		[Embed(source="medium.png")] private var ImgMedium:Class;
		[Embed(source="large.png")] private var ImgLarge:Class;
		
		//Asteroid constructor - doesn't do much since
		// we want to be able to easily recycle asteroids later...
		public function Asteroid()
		{
			super();
			antialiasing = true; //Smooth rotations
		}
		
		//This function actually creates the asteroid
		public function create(X:int=0,Y:int=0,VelocityX:Number=0,VelocityY:Number=0,Size:Class=null):Asteroid
		{
			//This function can be used to reset or revive an asteroid too, so flip all these flags back on
			exists = true;
			visible = true;
			active = true;
			solid = true;
			loadRotatedGraphic((Size == null) ? ImgLarge : Size,100,-1,true,true);
			alterBoundingBox();
			
			//Set the asteroids a-rotatin' at a random speed (looks neat)
			angularVelocity = FlxU.random()*120 - 60;
			angle = FlxU.random()*360;
			
			//Initialize a splinter of asteroid if necessary
			if((X != 0) || (Y != 0))
			{
				x = X;
				y = Y;
				velocity.x = VelocityX;
				velocity.y = VelocityY;
				return this;	//Just return, the rest of the code here is for spawning a new large asteroid
			}
			
			//Let's spawn a giant asteroid!
			var initial_velocity:int = 20;
			//The basic idea here is we first try and figure out what side the asteroid
			// should come from, and then from there figure out how fast it should go,
			// and in what direction.  It looks kinda crazy but it's basically the same
			// block of code repeated twice, once for 'vertical' and once for 'horizontal'
			if(FlxU.random() < 0.5) 	//Appearing on the sides
			{
				if(FlxU.random() < 0.5)	//Appears on the left
				{
					x = -64 + offset.x;
					velocity.x = initial_velocity / 2 + FlxU.random() * initial_velocity;
				}
				else					//Appears on the right
				{
					x = FlxG.width + offset.x;
					velocity.x = -initial_velocity / 2 - FlxU.random() * initial_velocity;
				}
				y = FlxU.random()*(FlxG.height-height);
				velocity.y = FlxU.random() * initial_velocity * 2 - initial_velocity;
			}
			else						//Appearing on top or bottom
			{
				x = FlxU.random()*(FlxG.width-width);
				velocity.x = FlxU.random() * initial_velocity * 2 - initial_velocity;
				if(FlxU.random() < 0.5)	//Appears above
				{
					y = -64 + offset.y;
					velocity.y = initial_velocity / 2 + FlxU.random() * initial_velocity;
				}
				else					//Appears below
				{
					y = FlxG.height + offset.y;
					velocity.y = initial_velocity / 2 + FlxU.random() * initial_velocity;
				}
			}
			
			return this;
		}
		
		//Asteroids are so simple that we don't even have to override their game loop.
		//BUT we do want to override their "kill" function.  FlxG.overlapArrays() will call
		// this whenever a bullet overlaps an asteroid.  We want to make sure it makes babies!
		override public function kill():void
		{
			//Default kill behavior - sets exists to false, and dead to true (useful for complex animations)
			super.kill();
			
			//Don't spawn chunks if this was the smallest asteroid bit
			if(frameWidth <= 32)
				return;
			
			//Spawn new asteroid chunks
			var initial_velocity:int = 20;
			var slot:uint;
			var size:Class;
			//Need to figure out what size of chunk to show
			if(frameWidth >= 64)
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
			var numChunks:int = 2 + FlxU.random()*3;
			//For each chunk generate a new asteroid, filling in old slots in the list whenever possible.
			for(var i:uint = 0; i < numChunks; i++)
			{
				//Figure out the speed and position of the new asteroid chunk
				var ax:Number = x + width / 2;
				var ay:Number = y + height / 2;
				var avx:Number = FlxU.random() * initial_velocity * 2 - initial_velocity;
				var avy:Number = FlxU.random() * initial_velocity * 2 - initial_velocity;
				
				//Figure out if we need to add a new asteroid to the group, or edit an old dead one
				var a:Asteroid = group.getFirstAvail() as Asteroid;
				if(a == null)
					a = group.add(new Asteroid()) as Asteroid;
				//Generate the actual asteroid
				a.create(ax,ay,avx,avy,size);
			}								
		}
		
		//It looks cool if the asteroids change rotation speed when they bump into stuff
		override public function hitBottom(Contact:FlxObject,Velocity:Number):void
		{
			velocity.y = -velocity.y;
			angularVelocity = FlxU.random()*120 - 60;
		}
		
		override public function hitTop(Contact:FlxObject,Velocity:Number):void
		{
			velocity.y = -velocity.y;
			angularVelocity = FlxU.random()*120 - 60;
		}
		
		override public function hitLeft(Contact:FlxObject,Velocity:Number):void
		{
			velocity.x = -velocity.x;
			angularVelocity = FlxU.random()*120 - 60;
		}
	}
}