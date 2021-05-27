package dnaobject;

import Assertion.assert;
import dnaobject.DnaObject;
import dnaobject.objects.*;
import haxe.Json;
import textparsemacro.ConfigFile;

/**
 * class DnaObjectFactory
 * this class implements the static factory pattern and allows us to create a object at runtime given a string with the type.
 */
class DnaObjectFactory
{
	/**
	 * private ctor so nobody can create another singleton
	 */
	private function new() {};

	/**
	 * create(type:DnaObjectType)
	 * this function selects the correct builder based on the type.
	 * we do this by getting the builder from our map.
	 * so any type we want to create with this function must be first registered by using the  registerBuilder function
	 * @param type
	 * @return DnaObject
	 */
	public static function create(type:String):DnaObject
	{
		var obj:DnaObject = null;
		var file:Dynamic = null;

		if (type == 'NumberlineObject')
		{
			obj = new NumberlineObject();
			file = Json.parse(ConfigFile.text("assets/data/DnaObjectArchetypes/NumberlineObject.json"));
		}
		else if (type == 'BackgroundObject')
		{
			obj = new BackgroundObject();
			file = Json.parse(ConfigFile.text("assets/data/DnaObjectArchetypes/BackgroundObject.json"));
		}
		else if (type == 'TaskBackgroundObject')
		{
			obj = new BackgroundObject();
			file = Json.parse(ConfigFile.text("assets/data/DnaObjectArchetypes/TaskBackgroundObject.json"));
		}
		else if (type == 'MonsterObject')
		{
			obj = new MonsterObject();
			file = Json.parse(ConfigFile.text("assets/data/DnaObjectArchetypes/MonsterObject.json"));
		}
		else if (type == 'MonsterEditorObject')
		{
			obj = new MonsterEditorObject();
			file = Json.parse(ConfigFile.text("assets/data/DnaObjectArchetypes/MonsterEditorObject.json"));
		}
		else if (type == 'DnaButtonObject')
		{
			obj = new DnaButtonObject();
			file = Json.parse(ConfigFile.text("assets/data/DnaObjectArchetypes/DnaButtonObject.json"));
		}
		else if (type == 'PlusButtonObject')
		{
			obj = new DnaButtonObject();
			file = Json.parse(ConfigFile.text("assets/data/DnaObjectArchetypes/PlusButtonObject.json"));
		}
		else if (type == 'MinusButtonObject')
		{
			obj = new DnaButtonObject();
			file = Json.parse(ConfigFile.text("assets/data/DnaObjectArchetypes/MinusButtonObject.json"));
		}
		else if (type == 'TrialHandlerObject')
		{
			obj = new TrialHandlerObject();
			// file = Json.parse(ConfigFile.text("assets/data/DnaObjectArchetypes/TrialHandlerObject.json"));
		}
		else if (type == 'MainMenuButtonObject')
		{
			obj = new DnaButtonObject();
			file = Json.parse(ConfigFile.text("assets/data/DnaObjectArchetypes/MainMenuButtonObject.json"));
		}
		else if (type == 'DeleteButtonObject')
		{
			obj = new DnaButtonObject();
			file = Json.parse(ConfigFile.text("assets/data/DnaObjectArchetypes/DeleteButtonObject.json"));
		}
		else if (type == 'DataButtonObject')
		{
			obj = new DnaButtonObject();
			file = Json.parse(ConfigFile.text("assets/data/DnaObjectArchetypes/DataButtonObject.json"));
		}
		else if (type == 'SpeakerButtonObject')
		{
			obj = new DnaButtonObject();
			file = Json.parse(ConfigFile.text("assets/data/DnaObjectArchetypes/SpeakerButtonObject.json"));
		}
		else if (type == 'UploadButtonObject')
		{
			obj = new DnaButtonObject();
			file = Json.parse(ConfigFile.text("assets/data/DnaObjectArchetypes/UploadButtonObject.json"));
		}
		else if (type == 'RightArrowButtonObject')
		{
			obj = new DnaButtonObject();
			file = Json.parse(ConfigFile.text("assets/data/DnaObjectArchetypes/RightArrowButtonObject.json"));
		}
		else if (type == 'LeftArrowButtonObject')
		{
			obj = new DnaButtonObject();
			file = Json.parse(ConfigFile.text("assets/data/DnaObjectArchetypes/LeftArrowButtonObject.json"));
		}
		else if (type == 'AcceptButtonObject')
		{
			obj = new DnaButtonObject();
			file = Json.parse(ConfigFile.text("assets/data/DnaObjectArchetypes/AcceptButtonObject.json"));
		}
		else if (type == 'PlayButtonObject')
		{
			obj = new DnaButtonObject();
			file = Json.parse(ConfigFile.text("assets/data/DnaObjectArchetypes/PlayButtonObject.json"));
		}
		else if (type == 'LeftButtonObject')
		{
			obj = new DnaButtonObject();
			file = Json.parse(ConfigFile.text("assets/data/DnaObjectArchetypes/LeftButtonObject.json"));
		}
		else if (type == 'RightButtonObject')
		{
			obj = new DnaButtonObject();
			file = Json.parse(ConfigFile.text("assets/data/DnaObjectArchetypes/RightButtonObject.json"));
		}
		else if (type == 'SettingsButtonObject')
		{
			obj = new DnaButtonObject();
			file = Json.parse(ConfigFile.text("assets/data/DnaObjectArchetypes/SettingsButtonObject.json"));
		}
		else if (type == 'TrophyButtonObject')
		{
			obj = new DnaButtonObject();
			file = Json.parse(ConfigFile.text("assets/data/DnaObjectArchetypes/TrophyButtonObject.json"));
		}
		else if (type == 'InfoButtonObject')
		{
			obj = new DnaButtonObject();
			file = Json.parse(ConfigFile.text("assets/data/DnaObjectArchetypes/InfoButtonObject.json"));
		}
		else if (type == 'HelpButtonObject')
		{
			obj = new DnaButtonObject();
			file = Json.parse(ConfigFile.text("assets/data/DnaObjectArchetypes/HelpButtonObject.json"));
		}
		else if (type == 'EmptySmallButtonObject')
		{
			obj = new DnaButtonObject();
			file = Json.parse(ConfigFile.text("assets/data/DnaObjectArchetypes/EmptySmallButtonObject.json"));
		}
		else if (type == 'EmptyButtonObject')
		{
			obj = new DnaButtonObject();
			file = Json.parse(ConfigFile.text("assets/data/DnaObjectArchetypes/EmptyButtonObject.json"));
		}
		else if (type == 'NodeObject')
		{
			obj = new NodeObject();
			file = Json.parse(ConfigFile.text("assets/data/DnaObjectArchetypes/NodeObject.json"));
		}
		else if (type == 'TextBoxObject')
		{
			obj = new TextBoxObject();
			file = Json.parse(ConfigFile.text("assets/data/DnaObjectArchetypes/TextBoxObject.json"));
		}
		else if (type == 'TextObject')
		{
			obj = new TextObject();
			file = Json.parse(ConfigFile.text("assets/data/DnaObjectArchetypes/TextObject.json"));
		}
		else if (type == 'SrtPlayerTextObject')
		{
			obj = new SrtPlayerTextObject();
			file = Json.parse(ConfigFile.text("assets/data/DnaObjectArchetypes/SrtPlayerTextObject.json"));
		}
		else if (type == 'ActionHandlerObject')
		{
			obj = new ActionHandlerObject();
			file = Json.parse(ConfigFile.text("assets/data/DnaObjectArchetypes/ActionHandlerObject.json"));
		}
		else if (type == 'NumberlineTutorialHandlerObject')
		{
			obj = new ActionHandlerObject();
			file = Json.parse(ConfigFile.text("assets/data/DnaObjectArchetypes/NumberlineTutorialHandlerObject.json"));
		}
		else if (type == 'TutorialFingerObject')
		{
			obj = new SpriteObject();
			file = Json.parse(ConfigFile.text("assets/data/DnaObjectArchetypes/TutorialFingerObject.json"));
		}

		// // AUTOMATICALLY GENERATED
		else if (type == 'SpriteObject')
		{
			obj = new SpriteObject();
			file = Json.parse(ConfigFile.text("assets/data/DnaObjectArchetypes/SpriteObject.json"));
		}

		// // AUTOMATICALLY GENERATED
		else if (type == 'StaticTextObject')
		{
			obj = new StaticTextObject();
			file = Json.parse(ConfigFile.text("assets/data/DnaObjectArchetypes/StaticTextObject.json"));
		}
		// // AUTOMATICALLY GENERATED
		else if (type == 'ArithmeticTaskHandlerObject')
		{
			obj = new ArithmeticTaskHandlerObject();
			file = Json.parse(ConfigFile.text("assets/data/DnaObjectArchetypes/ArithmeticTaskHandlerObject.json"));
		}
		// // AUTOMATICALLY GENERATED
		else if (type == 'TimerObject')
		{
			obj = new TimerObject();
			file = Json.parse(ConfigFile.text("assets/data/DnaObjectArchetypes/TimerObject.json"));
		}
		// // AUTOMATICALLY GENERATED
		else if (type == 'SymbolicNumberComparisonTaskHandlerObject')
		{
			obj = new SymbolicNumberComparisonTaskHandlerObject();
			file = Json.parse(ConfigFile.text("assets/data/DnaObjectArchetypes/SymbolicNumberComparisonTaskHandlerObject.json"));
		}
		// // AUTOMATICALLY GENERATED
		else if (type == 'SubStateObject')
		{
			obj = new SubStateObject();
			file = Json.parse(ConfigFile.text("assets/data/DnaObjectArchetypes/SubStateObject.json"));
		}
		// // AUTOMATICALLY GENERATED
		else if (type == 'TaskTimeoutTimerObject')
		{
			obj = new TaskTimeoutTimerObject();
			file = Json.parse(ConfigFile.text("assets/data/DnaObjectArchetypes/TaskTimeoutTimerObject.json"));
		}
		// // AUTOMATICALLY GENERATED
		else if (type == 'RoundedRectangleObject')
		{
			obj = new RoundedRectangleObject();
			file = Json.parse(ConfigFile.text("assets/data/DnaObjectArchetypes/RoundedRectangleObject.json"));
		}
		// // AUTOMATICALLY GENERATED
		else if (type == 'DependentGroupObject')
		{
			obj = new DependentGroupObject();
			file = Json.parse(ConfigFile.text("assets/data/DnaObjectArchetypes/DependentGroupObject.json"));
		}
		// // AUTOMATICALLY GENERATED
		else if (type == 'OrdinalTaskHandlerObject')
		{
			obj = new OrdinalTaskHandlerObject();
			file = Json.parse(ConfigFile.text("assets/data/DnaObjectArchetypes/OrdinalTaskHandlerObject.json"));
		}
		// // AUTOMATICALLY GENERATED
		else if (type == 'NonSymbolCompTaskHandlerObject')
		{
			obj = new NonSymbolCompTaskHandlerObject();
			file = Json.parse(ConfigFile.text("assets/data/DnaObjectArchetypes/NonSymbolCompTaskHandlerObject.json"));
		}
		// INSERT_HERE
		else
		{
			// trace(type);
			assert(false);
		}
		if (file != null)
		{
			obj.fromFile(file);
		}
		return obj;
	}
}























