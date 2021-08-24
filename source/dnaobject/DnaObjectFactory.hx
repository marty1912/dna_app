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
		// // AUTOMATICALLY GENERATED
		else if (type == 'FeedbackTaskHandlerObject')
		{
			obj = new FeedbackTaskHandlerObject();
			file = Json.parse(ConfigFile.text("assets/data/DnaObjectArchetypes/FeedbackTaskHandlerObject.json"));
		}
		// // AUTOMATICALLY GENERATED
		else if (type == 'ResourceObject')
		{
			obj = new ResourceObject();
			file = Json.parse(ConfigFile.text("assets/data/DnaObjectArchetypes/ResourceObject.json"));
		}
		// // AUTOMATICALLY GENERATED
		else if (type == 'NineSliceSprite')
		{
			obj = new NineSliceSprite();
			file = Json.parse(ConfigFile.text("assets/data/DnaObjectArchetypes/NineSliceSprite.json"));
		}
		// // AUTOMATICALLY GENERATED
		else if (type == 'UnlockDisplayController')
		{
			obj = new UnlockDisplayController();
			file = Json.parse(ConfigFile.text("assets/data/DnaObjectArchetypes/UnlockDisplayController.json"));
		}
		// // AUTOMATICALLY GENERATED
		else if (type == 'LevelSelectPreview')
		{
			obj = new LevelSelectPreview();
			file = Json.parse(ConfigFile.text("assets/data/DnaObjectArchetypes/LevelSelectPreview.json"));
		}
		// // AUTOMATICALLY GENERATED
		else if (type == 'ProgressBar')
		{
			obj = new ProgressBar();
			file = Json.parse(ConfigFile.text("assets/data/DnaObjectArchetypes/ProgressBar.json"));
		}
		// // AUTOMATICALLY GENERATED
		else if (type == 'DnaHelixOrb')
		{
			obj = new DnaHelixOrb();
			file = Json.parse(ConfigFile.text("assets/data/DnaObjectArchetypes/DnaHelixOrb.json"));
		}
		// // AUTOMATICALLY GENERATED
		else if (type == 'PatternDisplay')
		{
			obj = new PatternDisplay();
			file = Json.parse(ConfigFile.text("assets/data/DnaObjectArchetypes/PatternDisplay.json"));
		}
		// // AUTOMATICALLY GENERATED
		else if (type == 'SymbolSlot')
		{
			obj = new SpriteObject();
			file = Json.parse(ConfigFile.text("assets/data/DnaObjectArchetypes/SymbolSlot.json"));
		}
		// // AUTOMATICALLY GENERATED
		else if (type == 'SymbolDragable')
		{
			obj = new SymbolDragable();
			file = Json.parse(ConfigFile.text("assets/data/DnaObjectArchetypes/SymbolDragable.json"));
		}
		// // AUTOMATICALLY GENERATED
		else if (type == 'PatternExtendObject')
		{
			obj = new PatternExtendObject();
			file = Json.parse(ConfigFile.text("assets/data/DnaObjectArchetypes/PatternExtendObject.json"));
		}
		else if (type == 'PatternNumbersObject')
		{
			obj = new PatternExtendObject();
			file = Json.parse(ConfigFile.text("assets/data/DnaObjectArchetypes/PatternNumbersObject.json"));
		}

		// // AUTOMATICALLY GENERATED
		else if (type == 'PatternExtendRealTask')
		{
			obj = new PatternExtendRealTask();
			file = Json.parse(ConfigFile.text("assets/data/DnaObjectArchetypes/PatternExtendRealTask.json"));
		}
		// // AUTOMATICALLY GENERATED
		else if (type == 'PatternExtendTutorial')
		{
			obj = new PatternExtendTutorial();
			file = Json.parse(ConfigFile.text("assets/data/DnaObjectArchetypes/PatternExtendTutorial.json"));
		}
		// // AUTOMATICALLY GENERATED
		else if (type == 'LevelSelectGrid')
		{
			obj = new LevelSelectGrid();
			file = Json.parse(ConfigFile.text("assets/data/DnaObjectArchetypes/LevelSelectGrid.json"));
		}
		// // AUTOMATICALLY GENERATED
		else if (type == 'UnlockDisplay')
		{
			obj = new UnlockDisplay();
			file = Json.parse(ConfigFile.text("assets/data/DnaObjectArchetypes/UnlockDisplay.json"));
		}
		// // AUTOMATICALLY GENERATED
		else if (type == 'KeyboardButton')
		{
			obj = new KeyboardButton();
			file = Json.parse(ConfigFile.text("assets/data/DnaObjectArchetypes/KeyboardButton.json"));
		}
		// // AUTOMATICALLY GENERATED
		else if (type == 'PatternUnitOfRepeatObject')
		{
			obj = new PatternUnitOfRepeatObject();
			file = Json.parse(ConfigFile.text("assets/data/DnaObjectArchetypes/PatternUnitOfRepeatObject.json"));
		}
		// // AUTOMATICALLY GENERATED
		else if (type == 'PatternGeneralizeObject')
		{
			obj = new PatternGeneralizeObject();
			file = Json.parse(ConfigFile.text("assets/data/DnaObjectArchetypes/PatternGeneralizeObject.json"));
		}
		// // AUTOMATICALLY GENERATED
		else if (type == 'PatternGeneralizeTutorial')
		{
			obj = new PatternGeneralizeTutorial();
			file = Json.parse(ConfigFile.text("assets/data/DnaObjectArchetypes/PatternGeneralizeTutorial.json"));
		}
		// // AUTOMATICALLY GENERATED
		else if (type == 'PatternUnitOfRepeatTutorial')
		{
			obj = new PatternUnitOfRepeatTutorial();
			file = Json.parse(ConfigFile.text("assets/data/DnaObjectArchetypes/PatternUnitOfRepeatTutorial.json"));
		}
		// // AUTOMATICALLY GENERATED
		else if (type == 'PatternNumbersTutorial')
		{
			obj = new PatternNumbersTutorial();
			file = Json.parse(ConfigFile.text("assets/data/DnaObjectArchetypes/PatternNumbersTutorial.json"));
		}
		else if (type == 'PatternDisplayCupboard')
		{
			obj = new PatternDisplay();
			file = Json.parse(ConfigFile.text("assets/data/DnaObjectArchetypes/PatternDisplayCupboard.json"));
		}
		// // AUTOMATICALLY GENERATED
		else if (type == 'DotsDisplay')
		{
			obj = new DotsDisplay();
			file = Json.parse(ConfigFile.text("assets/data/DnaObjectArchetypes/DotsDisplay.json"));
		}
		else if (type == 'NumberDisplay')
		{
			obj = new DotsDisplay();
			file = Json.parse(ConfigFile.text("assets/data/DnaObjectArchetypes/NumberDisplay.json"));
		}
		// // AUTOMATICALLY GENERATED
		else if (type == 'DotsTaskObject')
		{
			obj = new DotsTaskObject();
			file = Json.parse(ConfigFile.text("assets/data/DnaObjectArchetypes/DotsTaskObject.json"));
		}
		else if (type == 'NumCompTaskObject')
		{
			obj = new DotsTaskObject();
			file = Json.parse(ConfigFile.text("assets/data/DnaObjectArchetypes/NumCompTaskObject.json"));
		}
		// // AUTOMATICALLY GENERATED
		else if (type == 'DotsCompCtrl')
		{
			obj = new DotsCompCtrl();
			file = Json.parse(ConfigFile.text("assets/data/DnaObjectArchetypes/DotsCompCtrl.json"));
		}
		// // AUTOMATICALLY GENERATED
		else if (type == 'DotsCompTutorial')
		{
			obj = new DotsCompTutorial();
			file = Json.parse(ConfigFile.text("assets/data/DnaObjectArchetypes/DotsCompTutorial.json"));
		}
		// // AUTOMATICALLY GENERATED
		else if (type == 'DotsCompTutorial_02')
		{
			obj = new DotsCompTutorial_02();
			file = Json.parse(ConfigFile.text("assets/data/DnaObjectArchetypes/DotsCompTutorial_02.json"));
		}
		// // AUTOMATICALLY GENERATED
		else if (type == 'SymbolicCompTutorial_02')
		{
			obj = new SymbolicCompTutorial_02();
			file = Json.parse(ConfigFile.text("assets/data/DnaObjectArchetypes/SymbolicCompTutorial_02.json"));
		}
		// // AUTOMATICALLY GENERATED
		else if (type == 'SymbolicCompTutorial')
		{
			obj = new SymbolicCompTutorial();
			file = Json.parse(ConfigFile.text("assets/data/DnaObjectArchetypes/SymbolicCompTutorial.json"));
		}
		// // AUTOMATICALLY GENERATED
		else if (type == 'OrdinalTaskObject')
		{
			obj = new OrdinalTaskObject();
			file = Json.parse(ConfigFile.text("assets/data/DnaObjectArchetypes/OrdinalTaskObject.json"));
		}
		// // AUTOMATICALLY GENERATED
		else if (type == 'OrdinalTaskCtrl')
		{
			obj = new OrdinalTaskCtrl();
			file = Json.parse(ConfigFile.text("assets/data/DnaObjectArchetypes/OrdinalTaskCtrl.json"));
		}
		// // AUTOMATICALLY GENERATED
		else if (type == 'OrdTaskTutorial_02')
		{
			obj = new OrdTaskTutorial_02();
			file = Json.parse(ConfigFile.text("assets/data/DnaObjectArchetypes/OrdTaskTutorial_02.json"));
		}
		// // AUTOMATICALLY GENERATED
else if (type == 'OrdTaskTutorial_01')
{
	obj = new OrdTaskTutorial_01();
	file = Json.parse(ConfigFile.text("assets/data/DnaObjectArchetypes/OrdTaskTutorial_01.json"));
}
// // AUTOMATICALLY GENERATED
else if (type == 'CorsiMachineDome')
{
	obj = new CorsiMachineDome();
	file = Json.parse(ConfigFile.text("assets/data/DnaObjectArchetypes/CorsiMachineDome.json"));
}
// // AUTOMATICALLY GENERATED
else if (type == 'CorsiMachine')
{
	obj = new CorsiMachine();
	file = Json.parse(ConfigFile.text("assets/data/DnaObjectArchetypes/CorsiMachine.json"));
}
// // AUTOMATICALLY GENERATED
else if (type == 'CorsiTaskObject')
{
	obj = new CorsiTaskObject();
	file = Json.parse(ConfigFile.text("assets/data/DnaObjectArchetypes/CorsiTaskObject.json"));
}
// // AUTOMATICALLY GENERATED
else if (type == 'FlankerMachine')
{
	obj = new FlankerMachine();
	file = Json.parse(ConfigFile.text("assets/data/DnaObjectArchetypes/FlankerMachine.json"));
}
// // AUTOMATICALLY GENERATED
else if (type == 'FlankerTaskObject')
{
	obj = new FlankerTaskObject();
	file = Json.parse(ConfigFile.text("assets/data/DnaObjectArchetypes/FlankerTaskObject.json"));
}
// // AUTOMATICALLY GENERATED
else if (type == 'FlankerTutorial')
{
	obj = new FlankerTutorial();
	file = Json.parse(ConfigFile.text("assets/data/DnaObjectArchetypes/FlankerTutorial.json"));
}
// // AUTOMATICALLY GENERATED
else if (type == 'DnaProgressHelix')
{
	obj = new DnaProgressHelix();
	file = Json.parse(ConfigFile.text("assets/data/DnaObjectArchetypes/DnaProgressHelix.json"));
}
// // AUTOMATICALLY GENERATED
else if (type == 'ProbcodeHandlerObject')
{
	obj = new ProbcodeHandlerObject();
	file = Json.parse(ConfigFile.text("assets/data/DnaObjectArchetypes/ProbcodeHandlerObject.json"));
}
// INSERT_HERE
		else
		{
			trace("unknown object:", type);
			assert(false);
		}
		if (file != null)
		{
			obj.fromFile(file);
		}
		return obj;
	}
}

































































































