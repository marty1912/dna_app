package constants;

import flixel.math.FlxPoint;

class DnaConstants
{
	public static final KEY_BACKSPACE = "BACKSPACE";
	public static final OBJECT_GROUP = "OBJECT_GROUP";
	public static final TASK_CORRECT = "TASK_CORRECT";
	public static final TASK_INCORRECT = "TASK_INCORRECT";
	// WARNING: this event is only used for the feedback. for making a task timeout use EVT_TASK_TIMEOUT
	public static final TASK_TIMED_OUT_FEEDBACK:String = "TASK_TIMED_OUT_FEEDBACK";
	public static final CODE_ID = "<ID>";

	public static final TASK_ANSWERED_EVENT:String = "EVT_TASK_ANSWERED";
	public static final EVT_TASK_TIMEOUT:String = "EVT_TASK_TIMEOUT";
	public static final EVT_START_TRIAL_TIME:String = "EVT_START_TRIAL_TIME";

	public static final DEFAULT_SCREEN_SIZE = FlxPoint.get(1280, 720);
}
