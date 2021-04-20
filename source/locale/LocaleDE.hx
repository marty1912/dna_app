package locale;

import textparsemacro.ConfigFile;

/**
 * this is the interface that each locale must implement.
 */
class LocaleDE implements Locale
{
	public final ERROR_NOT_FOUND:String = "STRING NOT FOUND IN LOCALE!!";
	public final ERROR_INV_INPUT:String = "STRING KEY INVALID IN LOCALE!!";
	public final translation_map:Map<String, String> = [
"TaskDoneText_01" => ConfigFile.text("assets/text/de/TaskDoneText_01.json"),
"NumlineInstructions_02_PC" => ConfigFile.text("assets/text/de/NumlineInstructions_02_PC.json"),
"4" => ConfigFile.text("assets/text/de/4.txt"),
"SymbNumCompInstructions_03_PC" => ConfigFile.text("assets/text/de/SymbNumCompInstructions_03_PC.txt"),
"OrdInstructions_02_PC_left" => ConfigFile.text("assets/text/de/OrdInstructions_02_PC_left.json"),
"NumberlineState_HEAD" => ConfigFile.text("assets/text/de/NumberlineState_HEAD.txt"),
"NonSymbNumCompInstructions_02_TOUCH" => ConfigFile.text("assets/text/de/NonSymbNumCompInstructions_02_TOUCH.json"),
"NumberlineTutorial_01" => ConfigFile.text("assets/text/de/NumberlineTutorial_01.json"),
"NumberlineFeedbackTimeout" => ConfigFile.text("assets/text/de/NumberlineFeedbackTimeout.json"),
"FeedbackRatingEasy" => ConfigFile.text("assets/text/de/FeedbackRatingEasy.txt"),
"ProbCode_HEAD" => ConfigFile.text("assets/text/de/ProbCode_HEAD.txt"),
"UNLOCKSTATE_HEAD" => ConfigFile.text("assets/text/de/UNLOCKSTATE_HEAD.txt"),
"CreditsSound" => ConfigFile.text("assets/text/de/CreditsSound.txt"),
"SymbNumCompInstructions_02_TOUCH" => ConfigFile.text("assets/text/de/SymbNumCompInstructions_02_TOUCH.json"),
"NumberlineTutorial_02" => ConfigFile.text("assets/text/de/NumberlineTutorial_02.json"),
"ArithmeticState_HEAD" => ConfigFile.text("assets/text/de/ArithmeticState_HEAD.txt"),
"SymbNumCompInstructions_01" => ConfigFile.text("assets/text/de/SymbNumCompInstructions_01.json"),
"AdditionTutorial_01" => ConfigFile.text("assets/text/de/AdditionTutorial_01.json"),
"SpeedInstructions_02_PC" => ConfigFile.text("assets/text/de/SpeedInstructions_02_PC.json"),
"SymbolicNumberComparison_BODY" => ConfigFile.text("assets/text/de/SymbolicNumberComparison_BODY.txt"),
"SETTINGS_AUDIO_TEST" => ConfigFile.text("assets/text/de/SETTINGS_AUDIO_TEST.txt"),
"SettingsState_LANG" => ConfigFile.text("assets/text/de/SettingsState_LANG.txt"),
"NumberlineTutorial_04" => ConfigFile.text("assets/text/de/NumberlineTutorial_04.json"),
"NonSymbNumCompInstructions_02_PC" => ConfigFile.text("assets/text/de/NonSymbNumCompInstructions_02_PC.json"),
"ArithmeticInstructions_02_TOUCH" => ConfigFile.text("assets/text/de/ArithmeticInstructions_02_TOUCH.json"),
"NumberlineTaskDone" => ConfigFile.text("assets/text/de/NumberlineTaskDone.json"),
"IntroText_02" => ConfigFile.text("assets/text/de/IntroText_02.json"),
"NewUnlock" => ConfigFile.text("assets/text/de/NewUnlock.json"),
"MainMenuTutorial_end" => ConfigFile.text("assets/text/de/MainMenuTutorial_end.json"),
"LOCALE_NAME" => ConfigFile.text("assets/text/de/LOCALE_NAME.txt"),
"SymbNumCompInstructions_02_PC" => ConfigFile.text("assets/text/de/SymbNumCompInstructions_02_PC.json"),
"FeedbackQuestion_Difficulty" => ConfigFile.text("assets/text/de/FeedbackQuestion_Difficulty.txt"),
"MultiplicationTutorial_01" => ConfigFile.text("assets/text/de/MultiplicationTutorial_01.json"),
"SRTTEXTBOX_TEST" => ConfigFile.text("assets/text/de/SRTTEXTBOX_TEST.json"),
"SpeedInstructions_02_TOUCH" => ConfigFile.text("assets/text/de/SpeedInstructions_02_TOUCH.json"),
"NumberlineTutorial_03" => ConfigFile.text("assets/text/de/NumberlineTutorial_03.json"),
"0" => ConfigFile.text("assets/text/de/0.txt"),
"ALL_TASKS_DONE_HEAD" => ConfigFile.text("assets/text/de/ALL_TASKS_DONE_HEAD.txt"),
"ProbCodeInstructions_02_PC" => ConfigFile.text("assets/text/de/ProbCodeInstructions_02_PC.json"),
"ProbCodeText_02" => ConfigFile.text("assets/text/de/ProbCodeText_02.txt"),
"TaskInstructions_continue_PC_return" => ConfigFile.text("assets/text/de/TaskInstructions_continue_PC_return.txt"),
"NonSymbolicNumberComparison_HEAD" => ConfigFile.text("assets/text/de/NonSymbolicNumberComparison_HEAD.txt"),
"ArithmeticState_BODY" => ConfigFile.text("assets/text/de/ArithmeticState_BODY.txt"),
"SpeedInstructions_01" => ConfigFile.text("assets/text/de/SpeedInstructions_01.json"),
"NonSymbolicNumberComparison_BODY" => ConfigFile.text("assets/text/de/NonSymbolicNumberComparison_BODY.txt"),
"SettingsState_HEAD" => ConfigFile.text("assets/text/de/SettingsState_HEAD.txt"),
"TaskInstructions_continue_PC_left" => ConfigFile.text("assets/text/de/TaskInstructions_continue_PC_left.txt"),
"MainMenuTutorial_02" => ConfigFile.text("assets/text/de/MainMenuTutorial_02.json"),
"SETTINGS_AUDIO_VOLUME" => ConfigFile.text("assets/text/de/SETTINGS_AUDIO_VOLUME.txt"),
"TEXTBOX_TEST" => ConfigFile.text("assets/text/de/TEXTBOX_TEST.txt"),
"InfoState_HEAD" => ConfigFile.text("assets/text/de/InfoState_HEAD.txt"),
"3" => ConfigFile.text("assets/text/de/3.txt"),
"IntroText_03" => ConfigFile.text("assets/text/de/IntroText_03.txt"),
"MainMenuTutorial_06" => ConfigFile.text("assets/text/de/MainMenuTutorial_06.json"),
"MainMenuTutorial_03" => ConfigFile.text("assets/text/de/MainMenuTutorial_03.json"),
"NumlineInstructions_01" => ConfigFile.text("assets/text/de/NumlineInstructions_01.json"),
"ProbCode_BODY" => ConfigFile.text("assets/text/de/ProbCode_BODY.txt"),
"ProbCodeText_01" => ConfigFile.text("assets/text/de/ProbCodeText_01.txt"),
"SubtractionTutorial_01" => ConfigFile.text("assets/text/de/SubtractionTutorial_01.json"),
"ALL_TASKS_DONE_BODY" => ConfigFile.text("assets/text/de/ALL_TASKS_DONE_BODY.txt"),
"ProbCodeInstructions_02_TOUCH" => ConfigFile.text("assets/text/de/ProbCodeInstructions_02_TOUCH.json"),
"MonsterEditor_HEAD" => ConfigFile.text("assets/text/de/MonsterEditor_HEAD.txt"),
"SymbNumCompInstructions_PracticeDone_01" => ConfigFile.text("assets/text/de/SymbNumCompInstructions_PracticeDone_01.json"),
"MainMenuTutorial_05" => ConfigFile.text("assets/text/de/MainMenuTutorial_05.json"),
"6" => ConfigFile.text("assets/text/de/6.txt"),
"TaskInstructions_continue_PC_right" => ConfigFile.text("assets/text/de/TaskInstructions_continue_PC_right.txt"),
"NumberlineState_BODY" => ConfigFile.text("assets/text/de/NumberlineState_BODY.txt"),
"SymbNumCompInstructions_03_TOUCH" => ConfigFile.text("assets/text/de/SymbNumCompInstructions_03_TOUCH.txt"),
"SETTINGS_DELETE_DATA" => ConfigFile.text("assets/text/de/SETTINGS_DELETE_DATA.txt"),
"DemoExplanationText01" => ConfigFile.text("assets/text/de/DemoExplanationText01.json"),
"SpeedTest_BODY" => ConfigFile.text("assets/text/de/SpeedTest_BODY.txt"),
"OrdInstructions_02_PC_right" => ConfigFile.text("assets/text/de/OrdInstructions_02_PC_right.json"),
"CreditsArt" => ConfigFile.text("assets/text/de/CreditsArt.txt"),
"ArithmeticInstructions_02_PC" => ConfigFile.text("assets/text/de/ArithmeticInstructions_02_PC.json"),
"INFO_STATE_C_ART" => ConfigFile.text("assets/text/de/INFO_STATE_C_ART.txt"),
"INFO_STATE_C_SOUND" => ConfigFile.text("assets/text/de/INFO_STATE_C_SOUND.txt"),
"7" => ConfigFile.text("assets/text/de/7.txt"),
"FeedbackQuestion_Nervous" => ConfigFile.text("assets/text/de/FeedbackQuestion_Nervous.txt"),
"IntroText_01" => ConfigFile.text("assets/text/de/IntroText_01.json"),
"2" => ConfigFile.text("assets/text/de/2.txt"),
"SymbolicNumberComparison_HEAD" => ConfigFile.text("assets/text/de/SymbolicNumberComparison_HEAD.txt"),
"ProbCodeText_03" => ConfigFile.text("assets/text/de/ProbCodeText_03.txt"),
"8" => ConfigFile.text("assets/text/de/8.txt"),
"SpeedTest_HEAD" => ConfigFile.text("assets/text/de/SpeedTest_HEAD.txt"),
"NonSymbNumCompInstructions_01" => ConfigFile.text("assets/text/de/NonSymbNumCompInstructions_01.json"),
"1" => ConfigFile.text("assets/text/de/1.txt"),
"NumberlineFeedbackIncorrect" => ConfigFile.text("assets/text/de/NumberlineFeedbackIncorrect.json"),
"OrdInstructions_01" => ConfigFile.text("assets/text/de/OrdInstructions_01.json"),
"NumlineInstructions_02_TOUCH" => ConfigFile.text("assets/text/de/NumlineInstructions_02_TOUCH.json"),
"NumberlinePracticeDone" => ConfigFile.text("assets/text/de/NumberlinePracticeDone.json"),
"OrdTask_HEAD" => ConfigFile.text("assets/text/de/OrdTask_HEAD.txt"),
"5" => ConfigFile.text("assets/text/de/5.txt"),
"NumberlineFeedbackCorrect" => ConfigFile.text("assets/text/de/NumberlineFeedbackCorrect.json"),
"SETTINGS_MENUPOINT_DATA" => ConfigFile.text("assets/text/de/SETTINGS_MENUPOINT_DATA.txt"),
"SETTINGS_UPLOAD_DATA" => ConfigFile.text("assets/text/de/SETTINGS_UPLOAD_DATA.txt"),
"NumberlineFeedbackRealTask" => ConfigFile.text("assets/text/de/NumberlineFeedbackRealTask.json"),
"OrdInstructions_02_TOUCH" => ConfigFile.text("assets/text/de/OrdInstructions_02_TOUCH.json"),
"FeedbackQuestion_Motivation" => ConfigFile.text("assets/text/de/FeedbackQuestion_Motivation.txt"),
"MainMenuTutorial_04" => ConfigFile.text("assets/text/de/MainMenuTutorial_04.json"),
"ProbCodeInstructions_01" => ConfigFile.text("assets/text/de/ProbCodeInstructions_01.json"),
"INFO_STATE_ID" => ConfigFile.text("assets/text/de/INFO_STATE_ID.txt"),
"ArithmeticPracticeFinished_01" => ConfigFile.text("assets/text/de/ArithmeticPracticeFinished_01.json"),
"OrdTask_BODY" => ConfigFile.text("assets/text/de/OrdTask_BODY.txt"),
"ArithmeticInstructions_01" => ConfigFile.text("assets/text/de/ArithmeticInstructions_01.json"),
"SHORTTASKS_BODY" => ConfigFile.text("assets/text/de/SHORTTASKS_BODY.txt"),
"FeedbackRatingHard" => ConfigFile.text("assets/text/de/FeedbackRatingHard.txt"),
"MainMenuTutorial_01" => ConfigFile.text("assets/text/de/MainMenuTutorial_01.json"),
"SETTINGS_MENUPOINT_AUDIO" => ConfigFile.text("assets/text/de/SETTINGS_MENUPOINT_AUDIO.txt"),
"MainMenu_HEAD" => ConfigFile.text("assets/text/de/MainMenu_HEAD.txt"),
"TaskInstructions_continue_button" => ConfigFile.text("assets/text/de/TaskInstructions_continue_button.txt"),
"9" => ConfigFile.text("assets/text/de/9.txt")
];

	public final audio_path_map:Map<String, String> = [
"NumberlineTutorial_02" => ("assets/sounds/de/NumberlineTutorial_02.ogg"),
"MainMenuTutorial_03" => ("assets/sounds/de/MainMenuTutorial_03.ogg"),
"NumberlinePracticeDone" => ("assets/sounds/de/NumberlinePracticeDone.ogg"),
"IntroText_01" => ("assets/sounds/de/IntroText_01.ogg"),
"IntroText_02" => ("assets/sounds/de/IntroText_02.ogg"),
"MainMenuTutorial_04" => ("assets/sounds/de/MainMenuTutorial_04.ogg"),
"MainMenuTutorial_06" => ("assets/sounds/de/MainMenuTutorial_06.ogg"),
"NumberlineTutorial_01" => ("assets/sounds/de/NumberlineTutorial_01.ogg"),
"NumberlineTaskDone" => ("assets/sounds/de/NumberlineTaskDone.ogg"),
"NumberlineFeedbackIncorrect" => ("assets/sounds/de/NumberlineFeedbackIncorrect.ogg"),
"NumberlineFeedbackRealTask" => ("assets/sounds/de/NumberlineFeedbackRealTask.ogg"),
"MainMenuTutorial_02" => ("assets/sounds/de/MainMenuTutorial_02.ogg"),
"MainMenuTutorial_05" => ("assets/sounds/de/MainMenuTutorial_05.ogg"),
"MainMenuTutorial_end" => ("assets/sounds/de/MainMenuTutorial_end.ogg"),
"MainMenuTutorial_01" => ("assets/sounds/de/MainMenuTutorial_01.ogg"),
"NumberlineTutorial_04" => ("assets/sounds/de/NumberlineTutorial_04.ogg"),
"NumberlineFeedbackCorrect" => ("assets/sounds/de/NumberlineFeedbackCorrect.ogg"),
"NumberlineTutorial_03" => ("assets/sounds/de/NumberlineTutorial_03.ogg")
];


	/**
	 * empty ctor.
	 */
	public function new() {}

	/**
	 * this function is used to get an text string in our specific language.
	 * @param string_id  - the unique id of the string.
	 * @return String  - the string that we want to display in the game.
	 */
	public function getString(string_id:String):String
	{
		if (string_id == null)
		{
			return ERROR_NOT_FOUND + string_id;
		}
		var string = translation_map.get(string_id);

		if (string == null)
		{
			return ERROR_NOT_FOUND + string_id;
		}

		return string;
	}

	/**
	 * this function is used to get the asset path for the audiofiles for the respective language
	 * @param string_id  - the unique id of the audio asset.
	 * @return String  - the path of the asset for the current locale.
	 */
	public function getAudioPath(string_id:String):String
	{
		if (string_id == null)
		{
			return ERROR_NOT_FOUND + string_id;
		}
		var string = audio_path_map.get(string_id);

		if (string == null)
		{
			return ERROR_NOT_FOUND + string_id;
		}

		return string;
	}
}

