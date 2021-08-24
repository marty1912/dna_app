package dnadata;

import haxe.Json;
import openfl.Assets;
import textparsemacro.ConfigFile;
import thx.OrderedMap.StringOrderedMap;

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
		trace("set locked on id:", this.id, "to:", value);
		trials[0].locked = value;
		TaskTrials.instance.storeTrialBlocks();
		return value;
	}

	static function matchTrial(my_trial:Dynamic, stored_trial:Dynamic)
	{
		var trials_same = ((stored_trial.trials == my_trial.trials))
			|| ((my_trial.trials != null && stored_trial.trials != null) && (stored_trial.trials.length == my_trial.trials.length));

		return (my_trial.type == stored_trial.type && trials_same && my_trial.name == stored_trial.name);
	}

	/**
	 * getter for done attribute. in here we check if the current trialblock is already done or not.
	 */
	public function get_done()
	{
		var stored_trials = DnaDataManager.instance.getTrials();
		var my_trials = trials;
		// trace("get_done lengths:", my_trials.length, stored_trials.length);
		// if our trials are longer than all the trials they cannot be in there..
		if (my_trials.length > stored_trials.length)
		{
			return false;
		}

		/**
		 * we have the stored trials:
		 * | | | | | | | | | 
		 * and ours:
		 * | | | | 
		 * now we move our trials with the shift to the right and 
		 * check if the trials are in the stored ones
		 */

		for (shift in 0...(stored_trials.length - trials.length + 1))
		{
			// trace("get_done checking with shift:", shift);
			var all_done = true;
			for (trial_index in 0...my_trials.length)
			{
				var stored_trial = stored_trials[trial_index + shift];
				var my_trial = my_trials[trial_index];

				if (!(matchTrial(my_trial, stored_trial) && stored_trial.done))
				{
					all_done = false;
					break;
				}
			}

			if (all_done == true)
			{
				return true;
			}
		}
		return false;
	}

	public static function trialsFromStorage(stored:Dynamic):Array<Dynamic>
	{
		return stored.trials;
	}

	public static function idFromStorage(stored:Dynamic):String
	{
		return stored.id;
	}

	/**
	 * re
	 */
	public function toStorageFormat():Dynamic
	{
		return {id: this.id, trials: this.trials};
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
		this.id = id;
		preview = trials[0].preview;
		desc_body = trials[0].desc_body;
		desc_head = trials[0].desc_head;
	}
}
