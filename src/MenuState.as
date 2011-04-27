package
{
	import org.flixel.*;

	//This is a simple, auto-generated menu (See the flx.py Tutorial on the wiki for more info)
	public class MenuState extends FlxState
	{
		override public function create():void
		{
			//A couple of simple text fields
			var t:FlxText;
			t = new FlxText(0,FlxG.height/2-20,FlxG.width,"FlxTeroids");
			t.size = 32;
			t.alignment = "center";
			add(t);
			t = new FlxText(0,FlxG.height-30,FlxG.width,"click to play");
			t.size = 16;
			t.alignment = "center";
			add(t);
			
			FlxG.mouse.show();
		}

		override public function update():void
		{
			//Switch to play state if the mouse is pressed
			if(FlxG.mouse.justPressed())
				FlxG.switchState(new PlayState());
		}
	}
}
