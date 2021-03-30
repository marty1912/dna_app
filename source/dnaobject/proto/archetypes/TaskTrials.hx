package dnaobject.proto.archetypes;

import textparsemacro.ConfigFile;

/**
 * this class is used to store all of our Trials.
 * so each trial we have for any task is stored in here.
 * this is done so we can later collect them from the server.
 */
class TaskTrials
{
	public static final ALL_TASKS_DONE:String = '
	{	"type":"LevelSelectState",
		"desc_head":"ALL_TASKS_DONE_HEAD",
		"desc_body":"ALL_TASKS_DONE_BODY"
	}';

	/**
	 * this function returns all the trials in random order as a Dynamic .
	 */
	public static function getAllTrialsInRandomOrder():Dynamic
	{
		return {"todo": "get all tasks here"};
	}

	public static final Trials:String = ConfigFile.text("source/dnaobject/proto/archetypes/Trials.json");
}
