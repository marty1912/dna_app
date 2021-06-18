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
	public var preview(default, null):String;
	public var desc_head(default, null):String;
	public var desc_body(default, null):String;
	public var done(get, never):Bool;

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
				if (my_trial.type == stored_trial.type
					&& stored_trial.done == true
					&& (stored_trial.trials == my_trial.trials
						|| (stored_trial.trials == null && my_trial.trials == null)
						|| stored_trial.trials.length == my_trial.trials.length))
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

	public function new(trials:Array<Dynamic>)
	{
		this.trials = trials;
		preview = trials[0].preview;
		desc_body = trials[0].desc_body;
		desc_head = trials[0].desc_head;
	}
}
