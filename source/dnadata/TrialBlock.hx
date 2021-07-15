package dnadata;

import haxe.Json;
import openfl.Assets;
import textparsemacro.ConfigFile;

/**
 * this will be used to get a nice encapsulation of a trial block
 */
class TrialBlock
{
	public var trials:Array<Dynamic>;
	public var id:String;
	public var preview(default, null):String;
	public var desc_head(default, null):String;
	public var desc_body(default, null):String;
	public var done(get, never):Bool;
	public var locked(get, set):Bool;

	/**
	 * getter for locked property
	 * @return Bool
	 */
	public function get_locked():Bool
	{
		if (!Reflect.hasField(this.trials[0], "locked"))
		{
			this.trials[0].locked = false;
		}
		return this.trials[0].locked;
	}

	/**
	 * setter for locked property
	 * @param value 
	 * @return Bool
	 */
	public function set_locked(value:Bool):Bool
	{
		trials[0].locked = value;
		TaskTrials.instance.storeTrialBlocks();
		return value;
	}

	static function matchTrial(my_trial:Dynamic, stored_trial:Dynamic)
	{
		return (my_trial.type == stored_trial.type
			&& (stored_trial.trials == my_trial.trials
				|| (stored_trial.trials == null && my_trial.trials != null)
				|| stored_trial.trials.length == my_trial.trials.length)
			&& my_trial.name == stored_trial.name);
	}

	/**
	 * getter for done attribute. in here we check if the current trialblock is already done or not.
	 */
	public function get_done()
	{
		var all_trials = DnaDataManager.instance.getTrials();
		var all_done = true;
		for (my_trial in trials)
		{
			var trial_found = false;
			for (stored_trial in all_trials)
			{
				if (matchTrial(my_trial, stored_trial) && stored_trial.done)
				{
					trial_found = true;
					break;
				}
			}

			if (trial_found == false)
			{
				all_done = false;
				break;
			}
		}
		return all_done;
	}

	/**
	 * loads this Trialblock
	 */
	public function load()
	{
		DnaDataManager.instance.setTrials(this.trials);
	}

	public function new(trials:Array<Dynamic>, id:String)
	{
		this.trials = trials;
		preview = trials[0].preview;
		desc_body = trials[0].desc_body;
		desc_head = trials[0].desc_head;
	}
}
