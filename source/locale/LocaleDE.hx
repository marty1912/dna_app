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
"4" => ConfigFile.text("assets/text/de/4.txt"),
"NumberlineState_HEAD" => ConfigFile.text("assets/text/de/NumberlineState_HEAD.txt"),
"NumberlineTutorial_01" => ConfigFile.text("assets/text/de/NumberlineTutorial_01.json"),
"NumberlineFeedbackTimeout" => ConfigFile.text("assets/text/de/NumberlineFeedbackTimeout.json"),
"FeedbackRatingEasy" => ConfigFile.text("assets/text/de/FeedbackRatingEasy.txt"),
"UNLOCKSTATE_HEAD" => ConfigFile.text("assets/text/de/UNLOCKSTATE_HEAD.txt"),
"CreditsSound" => ConfigFile.text("assets/text/de/CreditsSound.txt"),
"NumberlineTutorial_02" => ConfigFile.text("assets/text/de/NumberlineTutorial_02.json"),
"ArithmeticState_HEAD" => ConfigFile.text("assets/text/de/ArithmeticState_HEAD.txt"),
"AdditionTutorial_01" => ConfigFile.text("assets/text/de/AdditionTutorial_01.json"),
"SymbolicNumberComparison_BODY" => ConfigFile.text("assets/text/de/SymbolicNumberComparison_BODY.txt"),
"SETTINGS_AUDIO_TEST" => ConfigFile.text("assets/text/de/SETTINGS_AUDIO_TEST.txt"),
"SettingsState_LANG" => ConfigFile.text("assets/text/de/SettingsState_LANG.txt"),
"NumberlineTutorial_04" => ConfigFile.text("assets/text/de/NumberlineTutorial_04.json"),
"NumberlineTaskDone" => ConfigFile.text("assets/text/de/NumberlineTaskDone.json"),
"IntroText_02" => ConfigFile.text("assets/text/de/IntroText_02.json"),
"NewUnlock" => ConfigFile.text("assets/text/de/NewUnlock.json"),
"MainMenuTutorial_end" => ConfigFile.text("assets/text/de/MainMenuTutorial_end.json"),
"LOCALE_NAME" => ConfigFile.text("assets/text/de/LOCALE_NAME.txt"),
"FeedbackQuestion_Difficulty" => ConfigFile.text("assets/text/de/FeedbackQuestion_Difficulty.txt"),
"MultiplicationTutorial_01" => ConfigFile.text("assets/text/de/MultiplicationTutorial_01.json"),
"SRTTEXTBOX_TEST" => ConfigFile.text("assets/text/de/SRTTEXTBOX_TEST.json"),
"NumberlineTutorial_03" => ConfigFile.text("assets/text/de/NumberlineTutorial_03.json"),
"0" => ConfigFile.text("assets/text/de/0.txt"),
"ALL_TASKS_DONE_HEAD" => ConfigFile.text("assets/text/de/ALL_TASKS_DONE_HEAD.txt"),
"NonSymbolicNumberComparison_HEAD" => ConfigFile.text("assets/text/de/NonSymbolicNumberComparison_HEAD.txt"),
"ArithmeticState_BODY" => ConfigFile.text("assets/text/de/ArithmeticState_BODY.txt"),
"NonSymbolicNumberComparison_BODY" => ConfigFile.text("assets/text/de/NonSymbolicNumberComparison_BODY.txt"),
"SettingsState_HEAD" => ConfigFile.text("assets/text/de/SettingsState_HEAD.txt"),
"MainMenuTutorial_02" => ConfigFile.text("assets/text/de/MainMenuTutorial_02.json"),
"SETTINGS_AUDIO_VOLUME" => ConfigFile.text("assets/text/de/SETTINGS_AUDIO_VOLUME.txt"),
"TEXTBOX_TEST" => ConfigFile.text("assets/text/de/TEXTBOX_TEST.txt"),
"InfoState_HEAD" => ConfigFile.text("assets/text/de/InfoState_HEAD.txt"),
"3" => ConfigFile.text("assets/text/de/3.txt"),
"IntroText_03" => ConfigFile.text("assets/text/de/IntroText_03.txt"),
"MainMenuTutorial_06" => ConfigFile.text("assets/text/de/MainMenuTutorial_06.json"),
"MainMenuTutorial_03" => ConfigFile.text("assets/text/de/MainMenuTutorial_03.json"),
"SubtractionTutorial_01" => ConfigFile.text("assets/text/de/SubtractionTutorial_01.json"),
"ALL_TASKS_DONE_BODY" => ConfigFile.text("assets/text/de/ALL_TASKS_DONE_BODY.txt"),
"MonsterEditor_HEAD" => ConfigFile.text("assets/text/de/MonsterEditor_HEAD.txt"),
"MainMenuTutorial_05" => ConfigFile.text("assets/text/de/MainMenuTutorial_05.json"),
"6" => ConfigFile.text("assets/text/de/6.txt"),
"NumberlineState_BODY" => ConfigFile.text("assets/text/de/NumberlineState_BODY.txt"),
"SETTINGS_DELETE_DATA" => ConfigFile.text("assets/text/de/SETTINGS_DELETE_DATA.txt"),
"DemoExplanationText01" => ConfigFile.text("assets/text/de/DemoExplanationText01.json"),
"CreditsArt" => ConfigFile.text("assets/text/de/CreditsArt.txt"),
"INFO_STATE_C_ART" => ConfigFile.text("assets/text/de/INFO_STATE_C_ART.txt"),
"INFO_STATE_C_SOUND" => ConfigFile.text("assets/text/de/INFO_STATE_C_SOUND.txt"),
"7" => ConfigFile.text("assets/text/de/7.txt"),
"FeedbackQuestion_Nervous" => ConfigFile.text("assets/text/de/FeedbackQuestion_Nervous.txt"),
"IntroText_01" => ConfigFile.text("assets/text/de/IntroText_01.json"),
"2" => ConfigFile.text("assets/text/de/2.txt"),
"SymbolicNumberComparison_HEAD" => ConfigFile.text("assets/text/de/SymbolicNumberComparison_HEAD.txt"),
"8" => ConfigFile.text("assets/text/de/8.txt"),
"1" => ConfigFile.text("assets/text/de/1.txt"),
"NumberlineFeedbackIncorrect" => ConfigFile.text("assets/text/de/NumberlineFeedbackIncorrect.json"),
"NumberlinePracticeDone" => ConfigFile.text("assets/text/de/NumberlinePracticeDone.json"),
"OrdTask_HEAD" => ConfigFile.text("assets/text/de/OrdTask_HEAD.txt"),
"5" => ConfigFile.text("assets/text/de/5.txt"),
"NumberlineFeedbackCorrect" => ConfigFile.text("assets/text/de/NumberlineFeedbackCorrect.json"),
"SETTINGS_MENUPOINT_DATA" => ConfigFile.text("assets/text/de/SETTINGS_MENUPOINT_DATA.txt"),
"SETTINGS_UPLOAD_DATA" => ConfigFile.text("assets/text/de/SETTINGS_UPLOAD_DATA.txt"),
"NumberlineFeedbackRealTask" => ConfigFile.text("assets/text/de/NumberlineFeedbackRealTask.json"),
"FeedbackQuestion_Motivation" => ConfigFile.text("assets/text/de/FeedbackQuestion_Motivation.txt"),
"MainMenuTutorial_04" => ConfigFile.text("assets/text/de/MainMenuTutorial_04.json"),
"INFO_STATE_ID" => ConfigFile.text("assets/text/de/INFO_STATE_ID.txt"),
"OrdTask_BODY" => ConfigFile.text("assets/text/de/OrdTask_BODY.txt"),
"FeedbackRatingHard" => ConfigFile.text("assets/text/de/FeedbackRatingHard.txt"),
"MainMenuTutorial_01" => ConfigFile.text("assets/text/de/MainMenuTutorial_01.json"),
"SETTINGS_MENUPOINT_AUDIO" => ConfigFile.text("assets/text/de/SETTINGS_MENUPOINT_AUDIO.txt"),
"MainMenu_HEAD" => ConfigFile.text("assets/text/de/MainMenu_HEAD.txt"),
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

