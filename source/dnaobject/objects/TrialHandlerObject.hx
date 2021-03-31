package dnaobject.objects;

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

	/**
	 * overwritten ctor.
	 */
	public function new()
	{
		this.log_color = "0xFF0000";
		super("TrialHandlerObject");
	}

	override public function registerEvents()
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
		this.setTrials(DnaDataManager.instance.getNextTrials().trials);
	}

	/**
	 * setter for trials
	 * @param trials - the trials are expected to be in a format like so (list of lists):
	 * [[{name: yourobjectname1,params:{param_1:.... }},{name: yourobjectname2,params:{param_1:.... }},...],
	 * [{name: yourobjectname1,param_1:.... },{name: yourobjectname2,param_1:.... },...]]
	 */
	public function setTrials(trials:Array<Dynamic>)
	{
		trace(trials);
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
		trace("\033[1;31m collectData", this.trials, "index", this.trial_index, "\033[0m");
		if (this.trials == null)
		{
			return;
		}
		if (this.trial_index > this.trials.length - 1)
		{
			trace(this.trials);
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
	 * override so we can have parameters like random order and stuff.
	 * @param jsonFile 
	 */
	override public function fromFile(jsonFile:Dynamic)
	{
		if (Reflect.hasField(jsonFile, "randomize"))
		{
			randomize = jsonFile.randomize;
		}
		super.fromFile(jsonFile);
	}

	/**
	 * this function loads the next trial.
	 */
	public function loadNextTrial()
	{
		trace("load next trial", this.trials, "index", this.trial_index, "");
		if (this.trials == null)
		{
			this.getTrialsFromManager();
		}
		if (this.trials == null)
		{
			this.getParent().eventManager.broadcastEvent(TRIALS_FIN);
		}
		var trials_len = this.trials.length;

		if (this.trial_index >= trials_len)
		{
			trace(this.trials);
			this.getParent().eventManager.broadcastEvent(TRIALS_FIN);
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
				trace("WARNING: Failed to set Params for: ", params.name);
				break;
				return;
			}
		}
		this.getParent().eventManager.broadcastEvent(LOAD_TRIAL_FIN);
	}

	/**
	 * this is the function that gets called everytime an event we subscribed for is fired
	 * @param event_name
	 */
	public function getNotified(event_name:String)
	{
		if (this.trials == null)
		{
			getTrialsFromManager();
		}
		trace("Trial Handler got notified:", event_name);
		if (event_name == LOAD_TRIAL)
		{
			loadNextTrial();
		}
		else if (event_name == SAVE_TRIAL_DATA)
		{
			collectData();
			this.trial_index++;
			this.getParent().eventManager.broadcastEvent(SAVE_TRIAL_DATA_FIN);
		}
	}
}
