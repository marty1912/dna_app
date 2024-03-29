package dnaobject;

import Assertion.assert;
import dnaobject.DnaState;
import haxe.Json;
import textparsemacro.ConfigFile;

/**
 * class DnaStateFactory
 * this class is our factory for states. it can create a factory when given a string with the name of the factory
 * this is also the only factory we have that implements a static factory. so also no instance is needet..
 * usage: DnaStateFactory.instance.dostuff()
 */
class DnaStateFactory
{
	/**
	 * private ctor so nobody can create another singleton
	 */
	private function new() {};

	/**
	 * create(type:DnaStateType)
	 * this function selects the correct builder based on the type.
	 * we do this by getting the builder from our map.
	 * so any type we want to create with this function must be first registered by using the  registerBuilder function
	 * @param type
	 * @return DnaState
	 */
	public static function create(type:String):DnaState
	{
		var state:DnaState = null;
		if (type == "NumberlineState")
		{
			state = new DnaState("NumberlineState");
			state.m_json_file = ConfigFile.text("assets/data/DnaStateArchetypes/Numberline/NumberlineState.json");
		}

		// // AUTOMATICALLY GENERATED
		else if (type == "UnlockState")
		{
			state = new DnaState("UnlockState");
			state.m_json_file = ConfigFile.text("assets/data/DnaStateArchetypes/UnlockState.json");
		}
		// // AUTOMATICALLY GENERATED
		else if (type == "IntroState")
		{
			state = new DnaState("IntroState");
			state.m_json_file = ConfigFile.text("assets/data/DnaStateArchetypes/IntroState.json");
		}
		// // AUTOMATICALLY GENERATED
		else if (type == "MainMenuTutorialState")
		{
			state = new DnaState("MainMenuTutorialState");
			state.m_json_file = ConfigFile.text("assets/data/DnaStateArchetypes/MainMenuTutorialState.json");
		}
		// // AUTOMATICALLY GENERATED
		else if (type == "SettingsDataState")
		{
			state = new DnaState("SettingsDataState");
			state.m_json_file = ConfigFile.text("assets/data/DnaStateArchetypes/SettingsDataState.json");
		}
		// // AUTOMATICALLY GENERATED
		else if (type == "SettingsState")
		{
			state = new DnaState("SettingsState");
			state.m_json_file = ConfigFile.text("assets/data/DnaStateArchetypes/SettingsState.json");
		}
		// // AUTOMATICALLY GENERATED
		else if (type == "SettingsAudioState")
		{
			state = new DnaState("SettingsAudioState");
			state.m_json_file = ConfigFile.text("assets/data/DnaStateArchetypes/SettingsAudioState.json");
		}
		// // AUTOMATICALLY GENERATED
		else if (type == "MonsterEditorState")
		{
			state = new DnaState("MonsterEditorState");
			state.m_json_file = ConfigFile.text("assets/data/DnaStateArchetypes/MonsterEditorState.json");
		}
		// // AUTOMATICALLY GENERATED
		else if (type == "LevelSelectState")
		{
			state = new DnaState("LevelSelectState");
			state.m_json_file = ConfigFile.text("assets/data/DnaStateArchetypes/LevelSelectState.json");
		}
		// // AUTOMATICALLY GENERATED
		else if (type == "InfoState")
		{
			state = new DnaState("InfoState");
			state.m_json_file = ConfigFile.text("assets/data/DnaStateArchetypes/InfoState.json");
		}
		// // AUTOMATICALLY GENERATED
		else if (type == "MainMenuState")
		{
			state = new DnaState("MainMenuState");
			state.m_json_file = ConfigFile.text("assets/data/DnaStateArchetypes/MainMenuState.json");
		}
		// // AUTOMATICALLY GENERATED
		else if (type == "NumberlinePracticeState_01")
		{
			state = new DnaState("NumberlinePracticeState_01");
			state.m_json_file = ConfigFile.text("assets/data/DnaStateArchetypes/Numberline/NumberlinePracticeState_01.json");
		}
		// // AUTOMATICALLY GENERATED
		else if (type == "NumberlineTutorialState")
		{
			state = new DnaState("NumberlineTutorialState");
			state.m_json_file = ConfigFile.text("assets/data/DnaStateArchetypes/Numberline/NumberlineTutorialState.json");
		}
		// // AUTOMATICALLY GENERATED
		else if (type == "NumberlineTutorialState_02")
		{
			state = new DnaState("NumberlineTutorialState_02");
			state.m_json_file = ConfigFile.text("assets/data/DnaStateArchetypes/Numberline/NumberlineTutorialState_02.json");
		}
		// // AUTOMATICALLY GENERATED
		else if (type == "NumberlinePracticeState_02")
		{
			state = new DnaState("NumberlinePracticeState_02");
			state.m_json_file = ConfigFile.text("assets/data/DnaStateArchetypes/Numberline/NumberlinePracticeState_02.json");
		}
		// // AUTOMATICALLY GENERATED
		else if (type == "ArithmeticState")
		{
			state = new DnaState("ArithmeticState");
			state.m_json_file = ConfigFile.text("assets/data/DnaStateArchetypes/Arithmetic/ArithmeticState.json");
		}
		// // AUTOMATICALLY GENERATED
		else if (type == "ArithmeticPracticeState")
		{
			state = new DnaState("ArithmeticPracticeState");
			state.m_json_file = ConfigFile.text("assets/data/DnaStateArchetypes/Arithmetic/ArithmeticPracticeState.json");
		}
		// // AUTOMATICALLY GENERATED
		else if (type == "AdditionTutorialState")
		{
			state = new DnaState("AdditionTutorialState");
			state.m_json_file = ConfigFile.text("assets/data/DnaStateArchetypes/Arithmetic/AdditionTutorialState.json");
		}
		// // AUTOMATICALLY GENERATED
		else if (type == "MultiplicationTutorialState")
		{
			state = new DnaState("MultiplicationTutorialState");
			state.m_json_file = ConfigFile.text("assets/data/DnaStateArchetypes/Arithmetic/MultiplicationTutorialState.json");
		}
		// // AUTOMATICALLY GENERATED
		else if (type == "SubtractionTutorialState")
		{
			state = new DnaState("SubtractionTutorialState");
			state.m_json_file = ConfigFile.text("assets/data/DnaStateArchetypes/Arithmetic/SubtractionTutorialState.json");
		}
		// // AUTOMATICALLY GENERATED
		else if (type == "SymbolicNumberComparisonState")
		{
			state = new DnaState("SymbolicNumberComparisonState");
			state.m_json_file = ConfigFile.text("assets/data/DnaStateArchetypes/SymbolicNumberComparison/SymbolicNumberComparisonState.json");
		}
		// // AUTOMATICALLY GENERATED
		else if (type == "DifficultyFeedbackState")
		{
			state = new DnaState("DifficultyFeedbackState");
			state.m_json_file = ConfigFile.text("assets/data/DnaStateArchetypes/Feedback/DifficultyFeedbackState.json");
		}
		// // AUTOMATICALLY GENERATED
		else if (type == "NervousFeedbackState")
		{
			state = new DnaState("NervousFeedbackState");
			state.m_json_file = ConfigFile.text("assets/data/DnaStateArchetypes/Feedback/NervousFeedbackState.json");
		}
		// // AUTOMATICALLY GENERATED
		else if (type == "MotivationFeedbackState")
		{
			state = new DnaState("MotivationFeedbackState");
			state.m_json_file = ConfigFile.text("assets/data/DnaStateArchetypes/Feedback/MotivationFeedbackState.json");
		}
		// // AUTOMATICALLY GENERATED
		else if (type == "DemoExplanationState")
		{
			state = new DnaState("DemoExplanationState");
			state.m_json_file = ConfigFile.text("assets/data/DnaStateArchetypes/DemoExplanationState.json");
		}
		// // AUTOMATICALLY GENERATED
		else if (type == "FixationState")
		{
			state = new DnaState("FixationState");
			state.m_json_file = ConfigFile.text("assets/data/DnaStateArchetypes/FixationState.json");
		}
		// // AUTOMATICALLY GENERATED
		else if (type == "BlankTaskState")
		{
			state = new DnaState("BlankTaskState");
			state.m_json_file = ConfigFile.text("assets/data/DnaStateArchetypes/BlankTaskState.json");
		}
		// // AUTOMATICALLY GENERATED
		else if (type == "OrdinalTaskState")
		{
			state = new DnaState("OrdinalTaskState");
			state.m_json_file = ConfigFile.text("assets/data/DnaStateArchetypes/Ordinal/OrdinalTaskState.json");
		}
		// // AUTOMATICALLY GENERATED
		else if (type == "NonSymbolCompState")
		{
			state = new DnaState("NonSymbolCompState");
			state.m_json_file = ConfigFile.text("assets/data/DnaStateArchetypes/NonSymbolComp/NonSymbolCompState.json");
		}
		// // AUTOMATICALLY GENERATED
		else if (type == "OrdinalTaskPracticeState")
		{
			state = new DnaState("OrdinalTaskPracticeState");
			state.m_json_file = ConfigFile.text("assets/data/DnaStateArchetypes/Ordinal/OrdinalTaskPracticeState.json");
		}
		// // AUTOMATICALLY GENERATED
		else if (type == "NonSymbolCompPracticeState")
		{
			state = new DnaState("NonSymbolCompPracticeState");
			state.m_json_file = ConfigFile.text("assets/data/DnaStateArchetypes/NonSymbolComp/NonSymbolCompPracticeState.json");
		}
		// // AUTOMATICALLY GENERATED
		else if (type == "SymbolicNumberComparisonPracticeState")
		{
			state = new DnaState("SymbolicNumberComparisonPracticeState");
			state.m_json_file = ConfigFile.text("assets/data/DnaStateArchetypes/SymbolicNumberComparison/SymbolicNumberComparisonPracticeState.json");
		}
		// // AUTOMATICALLY GENERATED
		else if (type == "NumberlinePracticeStateAdult")
		{
			state = new DnaState("NumberlinePracticeStateAdult");
			state.m_json_file = ConfigFile.text("assets/data/DnaStateArchetypes/Numberline/NumberlinePracticeStateAdult.json");
		}
		// // AUTOMATICALLY GENERATED
		else if (type == "SymbNumCompInstructionsState_01")
		{
			state = new DnaState("SymbNumCompInstructionsState_01");
			state.m_json_file = ConfigFile.text("assets/data/DnaStateArchetypes/SymbolicNumberComparison/SymbNumCompInstructionsState_01.json");
		}
		// // AUTOMATICALLY GENERATED
		else if (type == "SymbNumCompInstructionsState_02")
		{
			state = new DnaState("SymbNumCompInstructionsState_02");
			state.m_json_file = ConfigFile.text("assets/data/DnaStateArchetypes/SymbolicNumberComparison/SymbNumCompInstructionsState_02.json");
		}
			// // AUTOMATICALLY GENERATED

		// // AUTOMATICALLY GENERATED
		else if (type == "NonSymbNumCompInstructionsState_01")
		{
			state = new DnaState("NonSymbNumCompInstructionsState_01");
			state.m_json_file = ConfigFile.text("assets/data/DnaStateArchetypes/NonSymbolComp/NonSymbNumCompInstructionsState_01.json");
		}

		// // AUTOMATICALLY GENERATED
		else if (type == "OrdinalTaskInstructionsState_01")
		{
			state = new DnaState("OrdinalTaskInstructionsState_01");
			state.m_json_file = ConfigFile.text("assets/data/DnaStateArchetypes/Ordinal/OrdinalTaskInstructionsState_01.json");
		}
		// // AUTOMATICALLY GENERATED
		else if (type == "NumlineInstructionsState_01")
		{
			state = new DnaState("NumlineInstructionsState_01");
			state.m_json_file = ConfigFile.text("assets/data/DnaStateArchetypes/Numberline/NumlineInstructionsState_01.json");
		}
		// // AUTOMATICALLY GENERATED
		else if (type == "ArithmeticInstructionsState_01")
		{
			state = new DnaState("ArithmeticInstructionsState_01");
			state.m_json_file = ConfigFile.text("assets/data/DnaStateArchetypes/Arithmetic/ArithmeticInstructionsState_01.json");
		}
		// // AUTOMATICALLY GENERATED
		else if (type == "PracticeFinishedState_return")
		{
			state = new DnaState("PracticeFinishedState_return");
			state.m_json_file = ConfigFile.text("assets/data/DnaStateArchetypes/PracticeFinishedState_return.json");
		}
		// // AUTOMATICALLY GENERATED
		else if (type == "ArithmeticPracticeFinishedState_return")
		{
			state = new DnaState("ArithmeticPracticeFinishedState_return");
			state.m_json_file = ConfigFile.text("assets/data/DnaStateArchetypes/Arithmetic/ArithmeticPracticeFinishedState_return.json");
		}
		// // AUTOMATICALLY GENERATED
		else if (type == "ArithmeticTaskFinished")
		{
			state = new DnaState("ArithmeticTaskFinished");
			state.m_json_file = ConfigFile.text("assets/data/DnaStateArchetypes/Arithmetic/ArithmeticTaskFinished.json");
		}
		// // AUTOMATICALLY GENERATED
		else if (type == "TaskDoneState")
		{
			state = new DnaState("TaskDoneState");
			state.m_json_file = ConfigFile.text("assets/data/DnaStateArchetypes/TaskDoneState.json");
		}
		// // AUTOMATICALLY GENERATED
		else if (type == "SpeedInstructionsState_01")
		{
			state = new DnaState("SpeedInstructionsState_01");
			state.m_json_file = ConfigFile.text("assets/data/DnaStateArchetypes/Arithmetic/SpeedInstructionsState_01.json");
		}
		// // AUTOMATICALLY GENERATED
		else if (type == "ProbCodeState_01")
		{
			state = new DnaState("ProbCodeState_01");
			state.m_json_file = ConfigFile.text("assets/data/DnaStateArchetypes/ProbCode/ProbCodeState_01.json");
		}
		// // AUTOMATICALLY GENERATED
		else if (type == "ProbCodeStateDone")
		{
			state = new DnaState("ProbCodeStateDone");
			state.m_json_file = ConfigFile.text("assets/data/DnaStateArchetypes/ProbCode/ProbCodeStateDone.json");
		}
		// // AUTOMATICALLY GENERATED
		else if (type == "StudentIntro")
		{
			state = new DnaState("StudentIntro");
			state.m_json_file = ConfigFile.text("assets/data/DnaStateArchetypes/TestStudents/StudentIntro.json");
		}
		// // AUTOMATICALLY GENERATED
		else if (type == "StudentFin")
		{
			state = new DnaState("StudentFin");
			state.m_json_file = ConfigFile.text("assets/data/DnaStateArchetypes/TestStudents/StudentFin.json");
		}
		// // AUTOMATICALLY GENERATED
		else if (type == "GotoNextState")
		{
			state = new DnaState("GotoNextState");
			state.m_json_file = ConfigFile.text("assets/data/DnaStateArchetypes/GotoNextState.json");
		}
		// // AUTOMATICALLY GENERATED
		else if (type == "MathAnxietyState")
		{
			state = new DnaState("MathAnxietyState");
			state.m_json_file = ConfigFile.text("assets/data/DnaStateArchetypes/MathAnxiety/MathAnxietyState.json");
		}
		// // AUTOMATICALLY GENERATED
		else if (type == "MathAnxietyTutorial_02")
		{
			state = new DnaState("MathAnxietyTutorial_02");
			state.m_json_file = ConfigFile.text("assets/data/DnaStateArchetypes/MathAnxiety/MathAnxietyTutorial_02.json");
		}
		// // AUTOMATICALLY GENERATED
		else if (type == "MathAnxietyTutorial_01")
		{
			state = new DnaState("MathAnxietyTutorial_01");
			state.m_json_file = ConfigFile.text("assets/data/DnaStateArchetypes/MathAnxiety/MathAnxietyTutorial_01.json");
		}
		// // AUTOMATICALLY GENERATED
		else if (type == "NumberlinePracticeDoneState")
		{
			state = new DnaState("NumberlinePracticeDoneState");
			state.m_json_file = ConfigFile.text("assets/data/DnaStateArchetypes/Numberline/NumberlinePracticeDoneState.json");
		}
		// // AUTOMATICALLY GENERATED
		else if (type == "LevelSelectState_debug")
		{
			state = new DnaState("LevelSelectState_debug");
			state.m_json_file = ConfigFile.text("assets/data/DnaStateArchetypes/LevelSelectState_debug.json");
		}
		// // AUTOMATICALLY GENERATED
		else if (type == "ShowProgressState")
		{
			state = new DnaState("ShowProgressState");
			state.m_json_file = ConfigFile.text("assets/data/DnaStateArchetypes/ShowProgressState.json");
		}
		// // AUTOMATICALLY GENERATED
		else if (type == "PatternDisplayTest")
		{
			state = new DnaState("PatternDisplayTest");
			state.m_json_file = ConfigFile.text("assets/data/DnaStateArchetypes/Pattern/PatternDisplayTest.json");
		}
		// // AUTOMATICALLY GENERATED
		else if (type == "PatternExtend")
		{
			state = new DnaState("PatternExtend");
			state.m_json_file = ConfigFile.text("assets/data/DnaStateArchetypes/Pattern/PatternExtend.json");
		}
		// // AUTOMATICALLY GENERATED
		else if (type == "PatternExtendPractice")
		{
			state = new DnaState("PatternExtendPractice");
			state.m_json_file = ConfigFile.text("assets/data/DnaStateArchetypes/Pattern/PatternExtendPractice.json");
		}
		// // AUTOMATICALLY GENERATED
		else if (type == "PatternExtendTutorial_02")
		{
			state = new DnaState("PatternExtendTutorial_02");
			state.m_json_file = ConfigFile.text("assets/data/DnaStateArchetypes/Pattern/PatternExtendTutorial_02.json");
		}
		// // AUTOMATICALLY GENERATED
		else if (type == "PatternExtendTutorial_01")
		{
			state = new DnaState("PatternExtendTutorial_01");
			state.m_json_file = ConfigFile.text("assets/data/DnaStateArchetypes/Pattern/PatternExtendTutorial_01.json");
		}
		// // AUTOMATICALLY GENERATED
		else if (type == "PatternGeneralize")
		{
			state = new DnaState("PatternGeneralize");
			state.m_json_file = ConfigFile.text("assets/data/DnaStateArchetypes/Pattern/PatternGeneralize.json");
		}
		// // AUTOMATICALLY GENERATED
		else if (type == "PatternGeneralizePractice")
		{
			state = new DnaState("PatternGeneralizePractice");
			state.m_json_file = ConfigFile.text("assets/data/DnaStateArchetypes/Pattern/PatternGeneralizePractice.json");
		}
		// // AUTOMATICALLY GENERATED
		else if (type == "PatternGeneralizeTutorial_02")
		{
			state = new DnaState("PatternGeneralizeTutorial_02");
			state.m_json_file = ConfigFile.text("assets/data/DnaStateArchetypes/Pattern/PatternGeneralizeTutorial_02.json");
		}
		// // AUTOMATICALLY GENERATED
		else if (type == "PatternGeneralizeTutorial_01")
		{
			state = new DnaState("PatternGeneralizeTutorial_01");
			state.m_json_file = ConfigFile.text("assets/data/DnaStateArchetypes/Pattern/PatternGeneralizeTutorial_01.json");
		}
		// // AUTOMATICALLY GENERATED
		else if (type == "PatternUnitOfRepeat")
		{
			state = new DnaState("PatternUnitOfRepeat");
			state.m_json_file = ConfigFile.text("assets/data/DnaStateArchetypes/Pattern/PatternUnitOfRepeat.json");
		}
		// // AUTOMATICALLY GENERATED
		else if (type == "PatternUnitOfRepeatPractice")
		{
			state = new DnaState("PatternUnitOfRepeatPractice");
			state.m_json_file = ConfigFile.text("assets/data/DnaStateArchetypes/Pattern/PatternUnitOfRepeatPractice.json");
		}
		// // AUTOMATICALLY GENERATED

else if (type == "PatternUnitOfRepeatTutorial_02")
		{
			state = new DnaState("PatternUnitOfRepeatTutorial_02");
			state.m_json_file = ConfigFile.text("assets/data/DnaStateArchetypes/Pattern/PatternUnitOfRepeatTutorial_02.json");
		}
		// // AUTOMATICALLY GENERATED

else if (type == "PatternUnitOfRepeatTutorial_01")
		{
			state = new DnaState("PatternUnitOfRepeatTutorial_01");
			state.m_json_file = ConfigFile.text("assets/data/DnaStateArchetypes/Pattern/PatternUnitOfRepeatTutorial_01.json");
		}
		// // AUTOMATICALLY GENERATED

else if (type == "PatternNumbersTutorial_02")
		{
			state = new DnaState("PatternNumbersTutorial_02");
			state.m_json_file = ConfigFile.text("assets/data/DnaStateArchetypes/Pattern/PatternNumbersTutorial_02.json");
		}
		// // AUTOMATICALLY GENERATED

else if (type == "PatternNumbersTutorial_01")
		{
			state = new DnaState("PatternNumbersTutorial_01");
			state.m_json_file = ConfigFile.text("assets/data/DnaStateArchetypes/Pattern/PatternNumbersTutorial_01.json");
		}
		// // AUTOMATICALLY GENERATED

else if (type == "PatternNumbers")
		{
			state = new DnaState("PatternNumbers");
			state.m_json_file = ConfigFile.text("assets/data/DnaStateArchetypes/Pattern/PatternNumbers.json");
		}
		// // AUTOMATICALLY GENERATED

else if (type == "PatternNumbersPractice")
		{
			state = new DnaState("PatternNumbersPractice");
			state.m_json_file = ConfigFile.text("assets/data/DnaStateArchetypes/Pattern/PatternNumbersPractice.json");
		}
		// // AUTOMATICALLY GENERATED

else if (type == "TestState")
		{
			state = new DnaState("TestState");
			state.m_json_file = ConfigFile.text("assets/data/DnaStateArchetypes/TestState.json");
		}
		// // AUTOMATICALLY GENERATED

else if (type == "NonSymbolCompTutorial_02")
		{
			state = new DnaState("NonSymbolCompTutorial_02");
			state.m_json_file = ConfigFile.text("assets/data/DnaStateArchetypes/NonSymbolComp/NonSymbolCompTutorial_02.json");
		}
		// // AUTOMATICALLY GENERATED

else if (type == "NonSymbolCompTutorial_03")
		{
			state = new DnaState("NonSymbolCompTutorial_03");
			state.m_json_file = ConfigFile.text("assets/data/DnaStateArchetypes/NonSymbolComp/NonSymbolCompTutorial_03.json");
		}
		// // AUTOMATICALLY GENERATED

else if (type == "NonSymbolCompPracticeStateNoTime")
		{
			state = new DnaState("NonSymbolCompPracticeStateNoTime");
			state.m_json_file = ConfigFile.text("assets/data/DnaStateArchetypes/NonSymbolComp/NonSymbolCompPracticeStateNoTime.json");
		}
		// // AUTOMATICALLY GENERATED

else if (type == "NonSymbolCompTutorial_01")
		{
			state = new DnaState("NonSymbolCompTutorial_01");
			state.m_json_file = ConfigFile.text("assets/data/DnaStateArchetypes/NonSymbolComp/NonSymbolCompTutorial_01.json");
		}
		// // AUTOMATICALLY GENERATED

else if (type == "SymbolicNumberComparisonTutorial_01")
		{
			state = new DnaState("SymbolicNumberComparisonTutorial_01");
			state.m_json_file = ConfigFile.text("assets/data/DnaStateArchetypes/SymbolicNumberComparison/SymbolicNumberComparisonTutorial_01.json");
		}
		// // AUTOMATICALLY GENERATED

else if (type == "SymbolicNumberComparisonTutorial_03")
		{
			state = new DnaState("SymbolicNumberComparisonTutorial_03");
			state.m_json_file = ConfigFile.text("assets/data/DnaStateArchetypes/SymbolicNumberComparison/SymbolicNumberComparisonTutorial_03.json");
		}
		// // AUTOMATICALLY GENERATED

else if (type == "SymbolicNumberComparisonTutorial_02")
		{
			state = new DnaState("SymbolicNumberComparisonTutorial_02");
			state.m_json_file = ConfigFile.text("assets/data/DnaStateArchetypes/SymbolicNumberComparison/SymbolicNumberComparisonTutorial_02.json");
		}
		// // AUTOMATICALLY GENERATED

else if (type == "SymbolicNumberComparisonPracticeStateNoTime")
		{
			state = new DnaState("SymbolicNumberComparisonPracticeStateNoTime");
			state.m_json_file = ConfigFile.text("assets/data/DnaStateArchetypes/SymbolicNumberComparison/SymbolicNumberComparisonPracticeStateNoTime.json");
		}
		// INSERT_HERE
		else
		{
			trace("state type not found:", type);
			assert(false);
		}
		state.eventManager.clearEvents();
		state.fromFile(state.m_json_file);
		// state.eventManager.broadcastEvent("onCreate");
		return state;
	}
}























































