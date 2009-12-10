package
{
	import org.flixel.*;

	//This is a simple, auto-generated menu (See the flx.py Tutorial on the wiki for more info)
	public class MenuState extends FlxState
	{
		public function MenuState()
		{
			//A couple of simple text fields
			add(new FlxText(0,FlxG.height/2-10,FlxG.width,"FlxTeroids",0xffffffff,null,16,"center"));
			add(new FlxText(0,FlxG.height-20,FlxG.width," click to play",0xffffffff,null,8,"center"));
		}

		override public function update():void
		{
			//Switch to play state if the mouse is pressed
			if(FlxG.mouse.justPressed())
				FlxG.switchState(PlayState);
		}
	}
}
