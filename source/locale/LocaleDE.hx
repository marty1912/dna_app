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
"MASIC_Q11_orange_subs" => ConfigFile.text("assets/text/de/MASIC_Q11_orange_subs.json"),
"StudentIntro_confirm_PC" => ConfigFile.text("assets/text/de/StudentIntro_confirm_PC.txt"),
"MASIC_Q4_subs" => ConfigFile.text("assets/text/de/MASIC_Q4_subs.json"),
"MASIC_Q3_orange_subs" => ConfigFile.text("assets/text/de/MASIC_Q3_orange_subs.json"),
"4" => ConfigFile.text("assets/text/de/4.txt"),
"ArithmeticTutorial_04" => ConfigFile.text("assets/text/de/ArithmeticTutorial_04.json"),
"SymbNumCompInstructions_03_PC" => ConfigFile.text("assets/text/de/SymbNumCompInstructions_03_PC.txt"),
"OrdInstructions_02_PC_left" => ConfigFile.text("assets/text/de/OrdInstructions_02_PC_left.json"),
"NumberlineState_HEAD" => ConfigFile.text("assets/text/de/NumberlineState_HEAD.txt"),
"MASIC_Q6" => ConfigFile.text("assets/text/de/MASIC_Q6.txt"),
"NumlineInstructions_PracticeDone_01" => ConfigFile.text("assets/text/de/NumlineInstructions_PracticeDone_01.json"),
"MASIC_Q6_yellow_subs" => ConfigFile.text("assets/text/de/MASIC_Q6_yellow_subs.json"),
"mathanxiety_tutorial_02" => ConfigFile.text("assets/text/de/mathanxiety_tutorial_02.json"),
"MASIC_TUT_Q2_yellow_subs" => ConfigFile.text("assets/text/de/MASIC_TUT_Q2_yellow_subs.json"),
"MASIC_Q1_green_subs" => ConfigFile.text("assets/text/de/MASIC_Q1_green_subs.json"),
"NonSymbNumCompInstructions_02_TOUCH" => ConfigFile.text("assets/text/de/NonSymbNumCompInstructions_02_TOUCH.json"),
"MASIC_TUT_Q1_green_subs" => ConfigFile.text("assets/text/de/MASIC_TUT_Q1_green_subs.json"),
"MASIC_Q2_green_subs" => ConfigFile.text("assets/text/de/MASIC_Q2_green_subs.json"),
"PatternGeneralizeTut_01" => ConfigFile.text("assets/text/de/PatternGeneralizeTut_01.json"),
"MASIC_Q9_red_subs" => ConfigFile.text("assets/text/de/MASIC_Q9_red_subs.json"),
"NumberlineTutorial_01" => ConfigFile.text("assets/text/de/NumberlineTutorial_01.json"),
"MASIC_Q8_subs" => ConfigFile.text("assets/text/de/MASIC_Q8_subs.json"),
"PatternUnitOfRepeatTut_01" => ConfigFile.text("assets/text/de/PatternUnitOfRepeatTut_01.json"),
"MASIC_Q1_subs" => ConfigFile.text("assets/text/de/MASIC_Q1_subs.json"),
"MASIC_Q11_green_subs" => ConfigFile.text("assets/text/de/MASIC_Q11_green_subs.json"),
"mathanxiety_tutorial_04" => ConfigFile.text("assets/text/de/mathanxiety_tutorial_04.json"),
"StudentFin_01" => ConfigFile.text("assets/text/de/StudentFin_01.txt"),
"MASIC_Q5" => ConfigFile.text("assets/text/de/MASIC_Q5.txt"),
"LevelSelectHEAD" => ConfigFile.text("assets/text/de/LevelSelectHEAD.txt"),
"PatternNumbersTut_03" => ConfigFile.text("assets/text/de/PatternNumbersTut_03.json"),
"NumberlineFeedbackTimeout" => ConfigFile.text("assets/text/de/NumberlineFeedbackTimeout.json"),
"FeedbackRatingEasy" => ConfigFile.text("assets/text/de/FeedbackRatingEasy.txt"),
"MASIC_TUT_Q2_green_subs" => ConfigFile.text("assets/text/de/MASIC_TUT_Q2_green_subs.json"),
"MASIC_Q7_orange_subs" => ConfigFile.text("assets/text/de/MASIC_Q7_orange_subs.json"),
"NonSymbCompTut_02" => ConfigFile.text("assets/text/de/NonSymbCompTut_02.json"),
"ProbCode_HEAD" => ConfigFile.text("assets/text/de/ProbCode_HEAD.txt"),
"MASIC_Q13_subs" => ConfigFile.text("assets/text/de/MASIC_Q13_subs.json"),
"UNLOCKSTATE_HEAD" => ConfigFile.text("assets/text/de/UNLOCKSTATE_HEAD.txt"),
"mathanxiety_tutorial_03" => ConfigFile.text("assets/text/de/mathanxiety_tutorial_03.json"),
"MASIC_Q13_red_subs" => ConfigFile.text("assets/text/de/MASIC_Q13_red_subs.json"),
"CreditsSound" => ConfigFile.text("assets/text/de/CreditsSound.txt"),
"SymbNumCompInstructions_02_TOUCH" => ConfigFile.text("assets/text/de/SymbNumCompInstructions_02_TOUCH.json"),
"MASIC_Q6_red_subs" => ConfigFile.text("assets/text/de/MASIC_Q6_red_subs.json"),
"NumberlineTutorial_02" => ConfigFile.text("assets/text/de/NumberlineTutorial_02.json"),
"MASIC_Q8_green_subs" => ConfigFile.text("assets/text/de/MASIC_Q8_green_subs.json"),
"ArithmeticState_HEAD" => ConfigFile.text("assets/text/de/ArithmeticState_HEAD.txt"),
"SymbNumCompInstructions_01" => ConfigFile.text("assets/text/de/SymbNumCompInstructions_01.json"),
"buttons_explain_yellow" => ConfigFile.text("assets/text/de/buttons_explain_yellow.json"),
"AdditionTutorial_01" => ConfigFile.text("assets/text/de/AdditionTutorial_01.json"),
"MASIC_Q9_yellow_subs" => ConfigFile.text("assets/text/de/MASIC_Q9_yellow_subs.json"),
"MASIC_TUT_Q1" => ConfigFile.text("assets/text/de/MASIC_TUT_Q1.txt"),
"ShowProgressHEAD" => ConfigFile.text("assets/text/de/ShowProgressHEAD.txt"),
"MASIC_Q4_red_subs" => ConfigFile.text("assets/text/de/MASIC_Q4_red_subs.json"),
"NonSymbCompTut_03" => ConfigFile.text("assets/text/de/NonSymbCompTut_03.json"),
"mathanxiety_tutorial_05" => ConfigFile.text("assets/text/de/mathanxiety_tutorial_05.json"),
"SpeedInstructions_02_PC" => ConfigFile.text("assets/text/de/SpeedInstructions_02_PC.json"),
"test_srt_orange" => ConfigFile.text("assets/text/de/test_srt_orange.json"),
"SymbolicNumberComparison_BODY" => ConfigFile.text("assets/text/de/SymbolicNumberComparison_BODY.txt"),
"SETTINGS_AUDIO_TEST" => ConfigFile.text("assets/text/de/SETTINGS_AUDIO_TEST.txt"),
"MASIC_Q5_red_subs" => ConfigFile.text("assets/text/de/MASIC_Q5_red_subs.json"),
"NonSymbCompTut_05" => ConfigFile.text("assets/text/de/NonSymbCompTut_05.json"),
"MASIC_Q7" => ConfigFile.text("assets/text/de/MASIC_Q7.txt"),
"SettingsState_LANG" => ConfigFile.text("assets/text/de/SettingsState_LANG.txt"),
"MASIC_Q10_orange_subs" => ConfigFile.text("assets/text/de/MASIC_Q10_orange_subs.json"),
"NumberlineTutorial_04" => ConfigFile.text("assets/text/de/NumberlineTutorial_04.json"),
"MASIC_Q6_orange_subs" => ConfigFile.text("assets/text/de/MASIC_Q6_orange_subs.json"),
"NonSymbNumCompInstructions_02_PC" => ConfigFile.text("assets/text/de/NonSymbNumCompInstructions_02_PC.json"),
"mathanxiety_tutorial_q01" => ConfigFile.text("assets/text/de/mathanxiety_tutorial_q01.txt"),
"ArithmeticInstructions_02_TOUCH" => ConfigFile.text("assets/text/de/ArithmeticInstructions_02_TOUCH.json"),
"MASIC_TUT_Q2_red_subs" => ConfigFile.text("assets/text/de/MASIC_TUT_Q2_red_subs.json"),
"NumberlineTaskDone" => ConfigFile.text("assets/text/de/NumberlineTaskDone.json"),
"IntroText_02" => ConfigFile.text("assets/text/de/IntroText_02.json"),
"NewUnlock" => ConfigFile.text("assets/text/de/NewUnlock.json"),
"MainMenuTutorial_end" => ConfigFile.text("assets/text/de/MainMenuTutorial_end.json"),
"MASIC_Q5_green_subs" => ConfigFile.text("assets/text/de/MASIC_Q5_green_subs.json"),
"MASIC_Q1_yellow_subs" => ConfigFile.text("assets/text/de/MASIC_Q1_yellow_subs.json"),
"MASIC_Q2_red_subs" => ConfigFile.text("assets/text/de/MASIC_Q2_red_subs.json"),
"MASIC_Q13" => ConfigFile.text("assets/text/de/MASIC_Q13.txt"),
"MASIC_Q10_red_subs" => ConfigFile.text("assets/text/de/MASIC_Q10_red_subs.json"),
"test_srt_red" => ConfigFile.text("assets/text/de/test_srt_red.json"),
"LOCALE_NAME" => ConfigFile.text("assets/text/de/LOCALE_NAME.txt"),
"MASIC_TUT_Q2" => ConfigFile.text("assets/text/de/MASIC_TUT_Q2.txt"),
"MASIC_Q12_subs" => ConfigFile.text("assets/text/de/MASIC_Q12_subs.json"),
"MASIC_Q8_red_subs" => ConfigFile.text("assets/text/de/MASIC_Q8_red_subs.json"),
"MASIC_Q8" => ConfigFile.text("assets/text/de/MASIC_Q8.txt"),
"UnlockSelected" => ConfigFile.text("assets/text/de/UnlockSelected.json"),
"MASIC_Q9_subs" => ConfigFile.text("assets/text/de/MASIC_Q9_subs.json"),
"MASIC_TUT_Q1_yellow_subs" => ConfigFile.text("assets/text/de/MASIC_TUT_Q1_yellow_subs.json"),
"SymbNumCompInstructions_02_PC" => ConfigFile.text("assets/text/de/SymbNumCompInstructions_02_PC.json"),
"FeedbackQuestion_Difficulty" => ConfigFile.text("assets/text/de/FeedbackQuestion_Difficulty.txt"),
"MultiplicationTutorial_01" => ConfigFile.text("assets/text/de/MultiplicationTutorial_01.json"),
"ProbcodeDoneText" => ConfigFile.text("assets/text/de/ProbcodeDoneText.json"),
"SRTTEXTBOX_TEST" => ConfigFile.text("assets/text/de/SRTTEXTBOX_TEST.json"),
"MASIC_Q5_yellow_subs" => ConfigFile.text("assets/text/de/MASIC_Q5_yellow_subs.json"),
"SpeedInstructions_02_TOUCH" => ConfigFile.text("assets/text/de/SpeedInstructions_02_TOUCH.json"),
"MASIC_Q3" => ConfigFile.text("assets/text/de/MASIC_Q3.txt"),
"MASIC_Q5_orange_subs" => ConfigFile.text("assets/text/de/MASIC_Q5_orange_subs.json"),
"NumberlineTutorial_03" => ConfigFile.text("assets/text/de/NumberlineTutorial_03.json"),
"MASIC_Q7_green_subs" => ConfigFile.text("assets/text/de/MASIC_Q7_green_subs.json"),
"mathanxiety_tutorial_01" => ConfigFile.text("assets/text/de/mathanxiety_tutorial_01.json"),
"0" => ConfigFile.text("assets/text/de/0.txt"),
"PatternExtendTut_01" => ConfigFile.text("assets/text/de/PatternExtendTut_01.json"),
"MASIC_Q13_orange_subs" => ConfigFile.text("assets/text/de/MASIC_Q13_orange_subs.json"),
"ALL_TASKS_DONE_HEAD" => ConfigFile.text("assets/text/de/ALL_TASKS_DONE_HEAD.txt"),
"MASIC_Q4" => ConfigFile.text("assets/text/de/MASIC_Q4.txt"),
"ProbCodeInstructions_02_PC" => ConfigFile.text("assets/text/de/ProbCodeInstructions_02_PC.json"),
"ProbCodeText_02" => ConfigFile.text("assets/text/de/ProbCodeText_02.txt"),
"mathanxiety_tutorial_06" => ConfigFile.text("assets/text/de/mathanxiety_tutorial_06.json"),
"MASIC_Q8_orange_subs" => ConfigFile.text("assets/text/de/MASIC_Q8_orange_subs.json"),
"MASIC_Q4_yellow_subs" => ConfigFile.text("assets/text/de/MASIC_Q4_yellow_subs.json"),
"MASIC_Q11_red_subs" => ConfigFile.text("assets/text/de/MASIC_Q11_red_subs.json"),
"TaskInstructions_continue_PC_return" => ConfigFile.text("assets/text/de/TaskInstructions_continue_PC_return.txt"),
"NonSymbolicNumberComparison_HEAD" => ConfigFile.text("assets/text/de/NonSymbolicNumberComparison_HEAD.txt"),
"ArithmeticState_BODY" => ConfigFile.text("assets/text/de/ArithmeticState_BODY.txt"),
"StudentIntro_01" => ConfigFile.text("assets/text/de/StudentIntro_01.json"),
"SpeedInstructions_01" => ConfigFile.text("assets/text/de/SpeedInstructions_01.json"),
"PatternUnitOfRepeatTut_02" => ConfigFile.text("assets/text/de/PatternUnitOfRepeatTut_02.json"),
"NonSymbolicNumberComparison_BODY" => ConfigFile.text("assets/text/de/NonSymbolicNumberComparison_BODY.txt"),
"MASIC_TUT_Q2_subs" => ConfigFile.text("assets/text/de/MASIC_TUT_Q2_subs.json"),
"PatternUnitOfRepeatTut_03" => ConfigFile.text("assets/text/de/PatternUnitOfRepeatTut_03.json"),
"MASIC_Q4_green_subs" => ConfigFile.text("assets/text/de/MASIC_Q4_green_subs.json"),
"SettingsState_HEAD" => ConfigFile.text("assets/text/de/SettingsState_HEAD.txt"),
"PatternGeneralizeTut_03" => ConfigFile.text("assets/text/de/PatternGeneralizeTut_03.json"),
"TaskInstructions_continue_PC_left" => ConfigFile.text("assets/text/de/TaskInstructions_continue_PC_left.txt"),
"MASIC_Q2_subs" => ConfigFile.text("assets/text/de/MASIC_Q2_subs.json"),
"MainMenuTutorial_02" => ConfigFile.text("assets/text/de/MainMenuTutorial_02.json"),
"MASIC_Q4_orange_subs" => ConfigFile.text("assets/text/de/MASIC_Q4_orange_subs.json"),
"SETTINGS_AUDIO_VOLUME" => ConfigFile.text("assets/text/de/SETTINGS_AUDIO_VOLUME.txt"),
"buttons_explain_01" => ConfigFile.text("assets/text/de/buttons_explain_01.json"),
"MASIC_Q2_orange_subs" => ConfigFile.text("assets/text/de/MASIC_Q2_orange_subs.json"),
"TEXTBOX_TEST" => ConfigFile.text("assets/text/de/TEXTBOX_TEST.txt"),
"PatternNumbersTut_01" => ConfigFile.text("assets/text/de/PatternNumbersTut_01.json"),
"MASIC_TUT_Q1_orange_subs" => ConfigFile.text("assets/text/de/MASIC_TUT_Q1_orange_subs.json"),
"PatternExtendTut_02" => ConfigFile.text("assets/text/de/PatternExtendTut_02.json"),
"MASIC_Q10_subs" => ConfigFile.text("assets/text/de/MASIC_Q10_subs.json"),
"test_srt_green" => ConfigFile.text("assets/text/de/test_srt_green.json"),
"MASIC_TUT_Q1_red_subs" => ConfigFile.text("assets/text/de/MASIC_TUT_Q1_red_subs.json"),
"MASIC_Q6_subs" => ConfigFile.text("assets/text/de/MASIC_Q6_subs.json"),
"InfoState_HEAD" => ConfigFile.text("assets/text/de/InfoState_HEAD.txt"),
"3" => ConfigFile.text("assets/text/de/3.txt"),
"IntroText_03" => ConfigFile.text("assets/text/de/IntroText_03.txt"),
"mathanxiety_tutorial_q03" => ConfigFile.text("assets/text/de/mathanxiety_tutorial_q03.txt"),
"MASIC_Q7_subs" => ConfigFile.text("assets/text/de/MASIC_Q7_subs.json"),
"MASIC_Q11" => ConfigFile.text("assets/text/de/MASIC_Q11.txt"),
"MASIC_Q9_orange_subs" => ConfigFile.text("assets/text/de/MASIC_Q9_orange_subs.json"),
"MainMenuTutorial_06" => ConfigFile.text("assets/text/de/MainMenuTutorial_06.json"),
"MASIC_Q5_subs" => ConfigFile.text("assets/text/de/MASIC_Q5_subs.json"),
"MASIC_Q8_yellow_subs" => ConfigFile.text("assets/text/de/MASIC_Q8_yellow_subs.json"),
"MASIC_Q9" => ConfigFile.text("assets/text/de/MASIC_Q9.txt"),
"MASIC_Q12_orange_subs" => ConfigFile.text("assets/text/de/MASIC_Q12_orange_subs.json"),
"NonSymbCompTut_01" => ConfigFile.text("assets/text/de/NonSymbCompTut_01.json"),
"MainMenuTutorial_03" => ConfigFile.text("assets/text/de/MainMenuTutorial_03.json"),
"SymbolicNumCompTut_02" => ConfigFile.text("assets/text/de/SymbolicNumCompTut_02.json"),
"NumlineInstructions_01" => ConfigFile.text("assets/text/de/NumlineInstructions_01.json"),
"MASIC_Q13_yellow_subs" => ConfigFile.text("assets/text/de/MASIC_Q13_yellow_subs.json"),
"buttons_explain_green" => ConfigFile.text("assets/text/de/buttons_explain_green.json"),
"buttons_explain_orange" => ConfigFile.text("assets/text/de/buttons_explain_orange.json"),
"ProbCode_BODY" => ConfigFile.text("assets/text/de/ProbCode_BODY.txt"),
"MASIC_TUT_Q2_orange_subs" => ConfigFile.text("assets/text/de/MASIC_TUT_Q2_orange_subs.json"),
"MASIC_Q1_red_subs" => ConfigFile.text("assets/text/de/MASIC_Q1_red_subs.json"),
"MASIC_Q10" => ConfigFile.text("assets/text/de/MASIC_Q10.txt"),
"test_srt_yellow" => ConfigFile.text("assets/text/de/test_srt_yellow.json"),
"ProbCodeText_01" => ConfigFile.text("assets/text/de/ProbCodeText_01.txt"),
"MASIC_Q12" => ConfigFile.text("assets/text/de/MASIC_Q12.txt"),
"SubtractionTutorial_01" => ConfigFile.text("assets/text/de/SubtractionTutorial_01.json"),
"MASIC_Q3_green_subs" => ConfigFile.text("assets/text/de/MASIC_Q3_green_subs.json"),
"ALL_TASKS_DONE_BODY" => ConfigFile.text("assets/text/de/ALL_TASKS_DONE_BODY.txt"),
"ProbCodeInstructions_02_TOUCH" => ConfigFile.text("assets/text/de/ProbCodeInstructions_02_TOUCH.json"),
"MonsterEditor_HEAD" => ConfigFile.text("assets/text/de/MonsterEditor_HEAD.txt"),
"SymbNumCompInstructions_PracticeDone_01" => ConfigFile.text("assets/text/de/SymbNumCompInstructions_PracticeDone_01.json"),
"MainMenuTutorial_05" => ConfigFile.text("assets/text/de/MainMenuTutorial_05.json"),
"MASIC_Q12_green_subs" => ConfigFile.text("assets/text/de/MASIC_Q12_green_subs.json"),
"6" => ConfigFile.text("assets/text/de/6.txt"),
"TaskInstructions_continue_PC_right" => ConfigFile.text("assets/text/de/TaskInstructions_continue_PC_right.txt"),
"NumberlineState_BODY" => ConfigFile.text("assets/text/de/NumberlineState_BODY.txt"),
"SymbNumCompInstructions_03_TOUCH" => ConfigFile.text("assets/text/de/SymbNumCompInstructions_03_TOUCH.txt"),
"MASIC_Q6_green_subs" => ConfigFile.text("assets/text/de/MASIC_Q6_green_subs.json"),
"SETTINGS_DELETE_DATA" => ConfigFile.text("assets/text/de/SETTINGS_DELETE_DATA.txt"),
"MASIC_Q9_green_subs" => ConfigFile.text("assets/text/de/MASIC_Q9_green_subs.json"),
"SymbolicNumCompTut_03" => ConfigFile.text("assets/text/de/SymbolicNumCompTut_03.json"),
"SymbolicNumCompTut_01" => ConfigFile.text("assets/text/de/SymbolicNumCompTut_01.json"),
"MASIC_Q10_yellow_subs" => ConfigFile.text("assets/text/de/MASIC_Q10_yellow_subs.json"),
"DemoExplanationText01" => ConfigFile.text("assets/text/de/DemoExplanationText01.json"),
"SpeedTest_BODY" => ConfigFile.text("assets/text/de/SpeedTest_BODY.txt"),
"OrdInstructions_02_PC_right" => ConfigFile.text("assets/text/de/OrdInstructions_02_PC_right.json"),
"CreditsArt" => ConfigFile.text("assets/text/de/CreditsArt.txt"),
"ArithmeticInstructions_02_PC" => ConfigFile.text("assets/text/de/ArithmeticInstructions_02_PC.json"),
"INFO_STATE_C_ART" => ConfigFile.text("assets/text/de/INFO_STATE_C_ART.txt"),
"INFO_STATE_C_SOUND" => ConfigFile.text("assets/text/de/INFO_STATE_C_SOUND.txt"),
"7" => ConfigFile.text("assets/text/de/7.txt"),
"SymbolicNumCompTut_04" => ConfigFile.text("assets/text/de/SymbolicNumCompTut_04.json"),
"FeedbackQuestion_Nervous" => ConfigFile.text("assets/text/de/FeedbackQuestion_Nervous.txt"),
"IntroText_01" => ConfigFile.text("assets/text/de/IntroText_01.json"),
"2" => ConfigFile.text("assets/text/de/2.txt"),
"SymbolicNumberComparison_HEAD" => ConfigFile.text("assets/text/de/SymbolicNumberComparison_HEAD.txt"),
"ProbCodeText_03" => ConfigFile.text("assets/text/de/ProbCodeText_03.txt"),
"8" => ConfigFile.text("assets/text/de/8.txt"),
"MASIC_Q3_red_subs" => ConfigFile.text("assets/text/de/MASIC_Q3_red_subs.json"),
"SpeedTest_HEAD" => ConfigFile.text("assets/text/de/SpeedTest_HEAD.txt"),
"NonSymbNumCompInstructions_01" => ConfigFile.text("assets/text/de/NonSymbNumCompInstructions_01.json"),
"1" => ConfigFile.text("assets/text/de/1.txt"),
"NumberlineFeedbackIncorrect" => ConfigFile.text("assets/text/de/NumberlineFeedbackIncorrect.json"),
"OrdInstructions_01" => ConfigFile.text("assets/text/de/OrdInstructions_01.json"),
"MASIC_Q12_red_subs" => ConfigFile.text("assets/text/de/MASIC_Q12_red_subs.json"),
"mathanxiety_reminder_01" => ConfigFile.text("assets/text/de/mathanxiety_reminder_01.json"),
"NumlineInstructions_02_TOUCH" => ConfigFile.text("assets/text/de/NumlineInstructions_02_TOUCH.json"),
"NumberlinePracticeDone" => ConfigFile.text("assets/text/de/NumberlinePracticeDone.json"),
"OrdTask_HEAD" => ConfigFile.text("assets/text/de/OrdTask_HEAD.txt"),
"MASIC_Q1_orange_subs" => ConfigFile.text("assets/text/de/MASIC_Q1_orange_subs.json"),
"MASIC_Q1" => ConfigFile.text("assets/text/de/MASIC_Q1.txt"),
"NonSymbCompTut_04" => ConfigFile.text("assets/text/de/NonSymbCompTut_04.json"),
"PatternNumbersTut_02" => ConfigFile.text("assets/text/de/PatternNumbersTut_02.json"),
"5" => ConfigFile.text("assets/text/de/5.txt"),
"NumberlineFeedbackCorrect" => ConfigFile.text("assets/text/de/NumberlineFeedbackCorrect.json"),
"mathanxiety_tutorial_q04" => ConfigFile.text("assets/text/de/mathanxiety_tutorial_q04.txt"),
"SETTINGS_MENUPOINT_DATA" => ConfigFile.text("assets/text/de/SETTINGS_MENUPOINT_DATA.txt"),
"SETTINGS_UPLOAD_DATA" => ConfigFile.text("assets/text/de/SETTINGS_UPLOAD_DATA.txt"),
"MASIC_Q2" => ConfigFile.text("assets/text/de/MASIC_Q2.txt"),
"NumberlineFeedbackRealTask" => ConfigFile.text("assets/text/de/NumberlineFeedbackRealTask.json"),
"OrdInstructions_02_TOUCH" => ConfigFile.text("assets/text/de/OrdInstructions_02_TOUCH.json"),
"MASIC_Q2_yellow_subs" => ConfigFile.text("assets/text/de/MASIC_Q2_yellow_subs.json"),
"FeedbackQuestion_Motivation" => ConfigFile.text("assets/text/de/FeedbackQuestion_Motivation.txt"),
"PatternGeneralizeTut_02" => ConfigFile.text("assets/text/de/PatternGeneralizeTut_02.json"),
"MainMenuTutorial_04" => ConfigFile.text("assets/text/de/MainMenuTutorial_04.json"),
"ProbCodeInstructions_01" => ConfigFile.text("assets/text/de/ProbCodeInstructions_01.json"),
"test_pipe" => ConfigFile.text("assets/text/de/test_pipe.json"),
"INFO_STATE_ID" => ConfigFile.text("assets/text/de/INFO_STATE_ID.txt"),
"ArithmeticPracticeFinished_01" => ConfigFile.text("assets/text/de/ArithmeticPracticeFinished_01.json"),
"MASIC_Q11_subs" => ConfigFile.text("assets/text/de/MASIC_Q11_subs.json"),
"MASIC_Q3_subs" => ConfigFile.text("assets/text/de/MASIC_Q3_subs.json"),
"OrdTask_BODY" => ConfigFile.text("assets/text/de/OrdTask_BODY.txt"),
"MASIC_Q13_green_subs" => ConfigFile.text("assets/text/de/MASIC_Q13_green_subs.json"),
"StudentIntro_confirm_TOUCH" => ConfigFile.text("assets/text/de/StudentIntro_confirm_TOUCH.txt"),
"ArithmeticInstructions_01" => ConfigFile.text("assets/text/de/ArithmeticInstructions_01.json"),
"SHORTTASKS_BODY" => ConfigFile.text("assets/text/de/SHORTTASKS_BODY.txt"),
"MASIC_Q7_yellow_subs" => ConfigFile.text("assets/text/de/MASIC_Q7_yellow_subs.json"),
"FeedbackRatingHard" => ConfigFile.text("assets/text/de/FeedbackRatingHard.txt"),
"MainMenuTutorial_01" => ConfigFile.text("assets/text/de/MainMenuTutorial_01.json"),
"buttons_explain_red" => ConfigFile.text("assets/text/de/buttons_explain_red.json"),
"SETTINGS_MENUPOINT_AUDIO" => ConfigFile.text("assets/text/de/SETTINGS_MENUPOINT_AUDIO.txt"),
"MASIC_Q10_green_subs" => ConfigFile.text("assets/text/de/MASIC_Q10_green_subs.json"),
"FEEDBACK_MASIC_HEAD" => ConfigFile.text("assets/text/de/FEEDBACK_MASIC_HEAD.txt"),
"PatternExtendTut_03" => ConfigFile.text("assets/text/de/PatternExtendTut_03.json"),
"SymbolicNumCompTut_05" => ConfigFile.text("assets/text/de/SymbolicNumCompTut_05.json"),
"MainMenu_HEAD" => ConfigFile.text("assets/text/de/MainMenu_HEAD.txt"),
"TaskInstructions_continue_button" => ConfigFile.text("assets/text/de/TaskInstructions_continue_button.txt"),
"MASIC_TUT_Q1_subs" => ConfigFile.text("assets/text/de/MASIC_TUT_Q1_subs.json"),
"mathanxiety_tutorial_q02" => ConfigFile.text("assets/text/de/mathanxiety_tutorial_q02.txt"),
"MASIC_Q12_yellow_subs" => ConfigFile.text("assets/text/de/MASIC_Q12_yellow_subs.json"),
"MASIC_Q3_yellow_subs" => ConfigFile.text("assets/text/de/MASIC_Q3_yellow_subs.json"),
"MASIC_Q7_red_subs" => ConfigFile.text("assets/text/de/MASIC_Q7_red_subs.json"),
"MASIC_Q11_yellow_subs" => ConfigFile.text("assets/text/de/MASIC_Q11_yellow_subs.json"),
"9" => ConfigFile.text("assets/text/de/9.txt")
];

	public final audio_path_map:Map<String, String> = [
"NumberlineTutorial_02" => ("assets/sounds/de/NumberlineTutorial_02.ogg"),
"MainMenuTutorial_03" => ("assets/sounds/de/MainMenuTutorial_03.ogg"),
"NumberlinePracticeDone" => ("assets/sounds/de/NumberlinePracticeDone.ogg"),
"IntroText_01" => ("assets/sounds/de/IntroText_01.ogg"),
"click_002" => ("assets/sounds/de/click_002.ogg"),
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

