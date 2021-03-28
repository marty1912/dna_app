package python_templates;

import dnadata.DnaDataManager;
import dnaobject.DnaState;
import dnaobject.DnaStateFactory;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.system.FlxAssets;
import flixel.util.FlxSave;
import openfl.display.InteractiveObject;
import openfl.display.Sprite;
import osspec.OsManager;

class Main extends Sprite
{
	public function new()
	{
		trace("starting...");
		FlxAssets.FONT_DEFAULT = "assets/fonts/ttf-bitstream-vera-1.10/Vera.ttf";
		OsManager.get_instance().toLandscapeMode();
		DnaDataManager.instance.deleteAllData(); // debug
		DnaDataManager.instance.init();
		super();

		// addChild(new FlxGame(1280, 720, 1, 60, 60, true, false));
		// with 0,0 we get the game to fill the screen.
		// we want to force landscape mode. it does not really work as expected so here is our workaround:
		var width = FlxG.stage.stageWidth;
		var heigth = FlxG.stage.stageHeight;

		if (width <= heigth)
		{
			var tmp = heigth;
			heigth = width;
			width = tmp;
		}

		addChild(new FlxGame(width, heigth, 1, 60, 60, true, false));

		/*
		 * these settings are used so the update loops will get the 
		 * correct time that elapsed. therefore anabling everything to stay in
		 * sync even with sub-optimal framerate.
		 */
		FlxG.fixedTimestep = false;
		FlxG.maxElapsed = 0.3;

		trace("now creating initial state.");
		FlxG.switchState(DnaStateFactory.create("SubtractionTutorialState"));
	}
}
