package dnaobject.objects;

import Assertion.assert;
import dnaEvent.DnaEventManager;
import dnaEvent.DnaEventSubscriber;
import dnadata.DnaDataManager;
import dnaobject.interfaces.TaskObject;

/**
 * this is the class that handles giving our trial parameters to the correct objects.
 */
class TrialHandlerObject implements DnaObject implements DnaEventSubscriber extends DnaObjectBase
{
	public static final LOAD_TRIAL = "TrialHandler_load";
	public static final SAVE_TRIAL_DATA = "TrialHandler_save";
	public static final LOAD_TRIAL_FIN = "TrialHandler_load_fin";
	public static final SAVE_TRIAL_DATA_FIN = "TrialHandler_save_fin";
	public static final TRIALS_FIN = "TrialHandler_all_fin";

	public var base_trials:Array<Array<Dynamic>> = new Array<Array<Dynamic>>();

	/**
	 * overwritten ctor.
	 */
	public function new()
	{
		this.log_color = "0xFF0000";
		super("TrialHandlerObject");
	}

	override public function onHaveParent()
	{
		this.getParent().eventManager.addSubscriberForEvent(this, LOAD_TRIAL);
		this.getParent().eventManager.addSubscriberForEvent(this, SAVE_TRIAL_DATA);
	}

	/**
	 * this is where we store the trials we have to do in the current state.
	 *
	 */
	private var trials:Array<Dynamic>;

	/**
	 * the index for keeping track of on which trial we are currently at.
	 */
	private var trial_index:Int = 0;

	public function getTrialsFromManager()
	{
		// we need a copy of the base trials so we can append it in the resetTrials function
		// this is a pointer to the real trials in the manager.
		// everything we do with them will be done in the manager as well.
		var trials_in_manager:Array<Dynamic> = DnaDataManager.instance.getNextTrials().trials;

		this.base_trials = deepCopyTrials(cast trials_in_manager);

		this.setTrials(trials_in_manager);
	}

	/**
	 * setter for trials
	 * @param trials - the trials are expected to be in a format like so (list of lists):
	 * [[{name: yourobjectname1,params:{param_1:.... }},{name: yourobjectname2,params:{param_1:.... }},...],
	 * [{name: yourobjectname1,param_1:.... },{name: yourobjectname2,param_1:.... },...]]
	 */
	public function setTrials(trials:Array<Dynamic>)
	{
		// trace(trials);
		if (randomize)
		{
			trials = Random.shuffle(trials);
		}
		this.trials = trials;
	}

	/**
	 * this function collects all the data from the objects and stores it in the trials list (in the correct place).
	 */
	public function collectData()
	{
		if (this.trials == null)
		{
			return;
		}
		if (this.trial_index > this.trials.length - 1)
		{
			Assertion.assert(false);
			if (this.reload_on_fin)
			{
				reappendTrials();
				return collectData();
			}
			this.getParent().eventManager.broadcastEvent(TRIALS_FIN);
			return;
		}
		var current_trial:Array<Dynamic> = this.trials[trial_index];
		for (params in current_trial)
		{
			var task_object:TaskObject = cast(getParent().getObjectByName(params.name));
			try
			{
				params.data = task_object.getData();
			}
			catch (e)
			{
				trace("WARNING: failed to get Data for:", params.name);
				continue;
			}
		}
	}

	public var randomize:Bool = true;

	/**
	 * wheter or not to reload the trials when we finish.
	 * if this is set to true we will never have the all_fin event.
	 */
	public var reload_on_fin:Bool = false;

	/**
	 * override so we can have parameters like random order and stuff.
	 * @param jsonFile 
	 */
	override public function fromFile(jsonFile:Dynamic)
	{
		// //trace("trialhabdler from file:", jsonFile);
		if (Reflect.hasField(jsonFile, "randomize"))
		{
			randomize = jsonFile.randomize;
		}
		if (Reflect.hasField(jsonFile, "reload_on_fin"))
		{
			reload_on_fin = jsonFile.reload_on_fin;
		}

		super.fromFile(jsonFile);
	}

	static function deepCopyTrials(copy_me:Array<Array<Dynamic>>):Array<Array<Dynamic>>
	{
		var copied = new Array<Array<Dynamic>>();
		for (trial in copy_me)
		{
			var copy_trial = new Array<Dynamic>();
			for (param in trial)
			{
				var copy_param = Reflect.copy(param);
				copy_trial.push(copy_param);
			}
			copied.push(copy_trial);
		}
		return copied;
	}

	/**
	 * this function appends the base trials and keeps going (we do the same trials another time)
	 */
	public function reappendTrials()
	{
		var copy_base = deepCopyTrials(this.base_trials);
		// we want to edit trials inplace (because it is the pointer to the datamanager.)
		for (trial in copy_base)
		{
			this.trials.push(trial);
		}
		//
		// this.trials = this.trials.concat(copy_base);
		// this.trial_index = 0;
	}

	public var all_trials_done(get, null):Bool;

	public function get_all_trials_done():Bool
	{
		if (this.trials == null)
		{
			this.getTrialsFromManager();
		}
		if (this.trials == null)
		{
			return true;
		}

		if (this.trial_index >= this.trials.length)
		{
			return true;
		}
		return false;
	}

	public var done_trials(get, null):Int;

	/**
	 * getter for done_trials_property
	 * @return Int
	 */
	public function get_done_trials():Int
	{
		if (this.trials == null)
		{
			this.getTrialsFromManager();
		}
		if (this.trials == null)
		{
			return 0;
		}
		return this.trials.length - this.trial_index;
	}

	/**
	 * this function loads the next trial.
	 */
	public function loadNextTrial()
	{
		// //trace("load next trial", this.trials, "index", this.trial_index, "");
		if (this.trials == null)
		{
			this.getTrialsFromManager();
		}

		if (this.trials == null)
		{
			this.getParent().eventManager.broadcastEvent(TRIALS_FIN);
		}
		assert(this.trials != null);
		var trials_len = this.trials.length;

		if (this.trial_index >= trials_len)
		{
			// //trace(this.trials);
			if (this.reload_on_fin)
			{
				reappendTrials();
				return loadNextTrial();
			}
			this.getParent().eventManager.broadcastEvent(TRIALS_FIN);

			trace("WARNING: Trials end: ", trial_index);
			return;
		}
		var current_trial:Array<Dynamic> = this.trials[trial_index];
		for (params in current_trial)
		{
			var task_object:TaskObject = cast(getParent().getObjectByName(params.name));
			try
			{
				task_object.setParams(params.params);
			}
			catch (e)
			{
				trace("WARNING: Failed to set Params for: ", params.name, "params:", params);
				break;
				return;
			}
		}

		this.getParent().eventManager.broadcastEvent(LOAD_TRIAL_FIN);
	}

	public function saveCurrentTrial()
	{
		collectData();
		this.trial_index++;
		this.getParent().eventManager.broadcastEvent(SAVE_TRIAL_DATA_FIN);
	}

	/**
	 * this is the function that gets called everytime an event we subscribed for is fired
	 * @param event_name
	 */
	public function getNotified(event_name:String, params:Any = null)
	{
		if (this.trials == null)
		{
			getTrialsFromManager();
		}
		// trace("Trial Handler got notified:", event_name);
		if (event_name == LOAD_TRIAL)
		{
			loadNextTrial();
		}
		else if (event_name == SAVE_TRIAL_DATA)
		{
			saveCurrentTrial();
		}
	}
}
