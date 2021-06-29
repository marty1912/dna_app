package dnadata;

import haxe.Json;
import openfl.Assets;
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
	 * this is the only instance that will ever exist
	 */
	public static final instance:TaskTrials = new TaskTrials();

	/**
	 * private ctor so nobody can create another singleton
	 */
	private function new() {};

	public final probCode:String = "assets/data/Trials/ProbCode.json";
	public final finalBlock:String = "assets/data/Trials/FinalStudentTrial.json";

	public final task_block_paths:Array<String> = [
		"assets/data/Trials/ArithmeticTrials.json",
		"assets/data/Trials/NonSymbolCompTrials.json",
		"assets/data/Trials/NumberlineTrials.json",
		"assets/data/Trials/MathAnxietyTrials.json",
		"assets/data/Trials/OrdTrials.json",
		"assets/data/Trials/SymbolicCompTrials.json",
		"assets/data/Trials/SpeedTrials.json",
		"assets/data/Trials/ProbCode.json"
	];

	/**
	 * this function returns all the trials in random order as a Dynamic .
	 */
	public function getAllTrials(randomize = true):Array<Dynamic>
	{
		var all_trial_paths = task_block_paths;
		if (randomize)
		{
			all_trial_paths = Random.shuffle(all_trial_paths);
		}

		//
		// all_trial_paths.insert(0, probCode);
		// all_trial_paths.push(finalBlock);

		var all_trials:Array<Dynamic> = new Array<Dynamic>();

		for (path in all_trial_paths)
		{
			all_trials = all_trials.concat(readTrialsFromFile(path));
		}

		return all_trials;
	}

	public var trial_path_index(default, set):Int = 0;

	public function set_trial_path_index(value:Int):Int
	{
		// trace("trial path index set to value:", value);
		trial_path_index = value % task_block_paths.length;
		return trial_path_index;
	}

	/**
	 * [Description]
	 */
	public function loadNextTrialBlock():Void
	{
		var trial_block = task_block_paths[trial_path_index];
		// trace("trialblock:", trial_block);
		trial_path_index++;
		DnaDataManager.instance.setTrials(readTrialsFromFile(trial_block));
	}

	/**
	 * [returns all the trialBlocks we have]
	 */
	public function getTrialBlocks():Array<TrialBlock>
	{
		var blocks:Array<TrialBlock> = new Array<TrialBlock>();
		for (path in task_block_paths)
		{
			var json = readTrialsFromFile(path);
			var trial_block = new TrialBlock(json);
			blocks.push(trial_block);
		}
		return blocks;
	}

	/**
	 * [returns all the trialBlocks we have]
	 */
	public function getTrialBlocksTodo():Array<TrialBlock>
	{
		var blocks:Array<TrialBlock> = new Array<TrialBlock>();
		for (path in task_block_paths)
		{
			var json = readTrialsFromFile(path);
			var trial_block = new TrialBlock(json);
			if (trial_block.done == false)
			{
				blocks.push(trial_block);
			}
		}
		return blocks;
	}

	/**
	 * returns ratio of done tasks. 
	 * @return Float value between 0 and 1
	 */
	public function getProgress():Float
	{
		return 1 - (getTrialBlocksTodo().length / getTrialBlocks().length);
	}

	/**
	 * [Description]
	 * @param path 
	 */
	public function readTrialsFromFile(path:String):Array<Dynamic>
	{
		var string = Assets.getText(path);
		var json = Json.parse(string);
		return json;
	}

	public static final Trials:String = ConfigFile.text("assets/data/Trials/Trials.json");
}
