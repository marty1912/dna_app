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

	private var trial_blocks:Array<TrialBlock> = null;

	/**
	 * private ctor so nobody can create another singleton
	 */
	private function new() {};

	public function init()
	{
		retrieveTrialBlocks();
		storeTrialBlocks();
	}

	public final TRIALBLOCK_STORAGE_ID = "TRIALBLOCK_STORAGE_ID";

	/**
	 * stores the trialblocks in the Datamanager.
	 */
	public function storeTrialBlocks()
	{
		var blocks_storage = new Array<Dynamic>();
		for (block in trial_blocks)
		{
			blocks_storage.push(block.toStorageFormat());
		}
		DnaDataManager.instance.storeData(TRIALBLOCK_STORAGE_ID, {trial_blocks: this.trial_blocks});
	}

	/**
	 * gets the trial blocks from the manager.
	 */
	public function retrieveTrialBlocks()
	{
		var trials:Dynamic = DnaDataManager.instance.retrieveData(TRIALBLOCK_STORAGE_ID);

		if (trials == null)
		{
			trace("creating new trialBlocks");
			trial_blocks = new Array<TrialBlock>();
			for (path in task_block_paths)
			{
				var json = readTrialsFromFile(path);
				var trial_block = new TrialBlock(json, path);
				trial_blocks.push(trial_block);
			}
		}
		else
		{
			trace("using stored trialBlocks");
			this.trial_blocks = new Array<TrialBlock>();
			var stored_blocks:Array<Dynamic> = trials.trial_blocks;
			for (stored in stored_blocks)
			{
				var id = TrialBlock.idFromStorage(stored);
				var json = TrialBlock.trialsFromStorage(stored);
				var block = new TrialBlock(json, id);
				this.trial_blocks.push(block);
			}
		}
	}

	public final probCode:String = "assets/data/Trials/ProbCode.json";
	public final finalBlock:String = "assets/data/Trials/FinalStudentTrial.json";

	public final task_block_paths:Array<String> = [
		// "assets/data/Trials/ArithmeticTrials.json",
		"assets/data/Trials/ProbCode.json",
		"assets/data/Trials/Flanker.json",
		"assets/data/Trials/Corsi.json",
		"assets/data/Trials/AdditionTrials.json",
		"assets/data/Trials/SubtractionTrials.json",
		"assets/data/Trials/NonSymbolCompTrials.json",
		"assets/data/Trials/NumberlineTrials.json",
		"assets/data/Trials/MathAnxietyTrials.json",
		"assets/data/Trials/OrdTrials.json",
		"assets/data/Trials/SymbolicCompTrials.json",
		"assets/data/Trials/SpeedTrials.json",
		// "assets/data/Trials/ezFinishTask.json",
		"assets/data/Trials/PatternExtend.json",
		"assets/data/Trials/PatternGeneralize.json",
		"assets/data/Trials/PatternUnitOfRepeat.json",
		"assets/data/Trials/PatternNumbers.json",
		"assets/data/Trials/lockedTask.json", // "assets/data/Trials/doneTask.json"
		"assets/data/Trials/TEST_TASK.json" // "assets/data/Trials/doneTask.json"
	];

	/**
	 * unlocks the trial block. 
	 * @param id 
	 * @return Bool true if unlocked
	 * false if not found.
	 */
	public function unlockTrialBlock(id:String):Bool
	{
		for (block in this.trial_blocks)
		{
			if (block.id == id)
			{
				block.locked = false;
				return true;
			}
		}
		return false;
	}

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
		retrieveTrialBlocks();
		return trial_blocks.copy();
	}

	/**
	 * [returns all the trialBlocks we have]
	 */
	public function getTrialBlocksTodo():Array<TrialBlock>
	{
		retrieveTrialBlocks();
		var blocks = new Array<TrialBlock>();
		for (block in trial_blocks)
		{
			if (block.done == false)
			{
				blocks.push(block);
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
