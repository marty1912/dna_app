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
		super("TrialHandlerObject");
		DnaEventManager.instance.addSubscriberForEvent(this, LOAD_TRIAL);
		DnaEventManager.instance.addSubscriberForEvent(this, SAVE_TRIAL_DATA);
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
		this.trials = trials;
	}

	/**
	 * this function collects all the data from the objects and stores it in the trials list (in the correct place).
	 */
	public function collectData()
	{
		trace("collectData", this.trials);
		trace("collectData", this.trial_index);
		if (this.trials == null)
		{
			return;
		}
		if (this.trial_index > this.trials.length - 1)
		{
			trace(this.trials);
			DnaEventManager.instance.broadcastEvent(TRIALS_FIN);
			return;
		}
		var current_trial:Array<Dynamic> = this.trials[trial_index];
		for (params in current_trial)
		{
			var task_object:TaskObject = cast(getParent().getObjectByName(params.name));
			if (task_object == null)
			{
				trace("WARNING: task_object not found in state! ", params.name);
				continue;
			}
			params.data = task_object.getData();
		}
	}

	/**
	 * this function loads the next trial.
	 */
	public function loadNextTrial()
	{
		if (this.trials == null)
		{
			this.getTrialsFromManager();
		}
		if (this.trials == null)
		{
			DnaEventManager.instance.broadcastEvent(TRIALS_FIN);
		}
		var trials_len = this.trials.length;

		if (this.trial_index >= trials_len)
		{
			trace(this.trials);
			DnaEventManager.instance.broadcastEvent(TRIALS_FIN);
			return;
		}
		var current_trial:Array<Dynamic> = this.trials[trial_index];
		for (params in current_trial)
		{
			var task_object:TaskObject = cast(getParent().getObjectByName(params.name));
			if (task_object == null)
			{
				trace("object not found! name:", params.name);
				return;
			}
			task_object.setParams(params.params);
		}
		DnaEventManager.instance.broadcastEvent(LOAD_TRIAL_FIN);
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
			DnaEventManager.instance.broadcastEvent(SAVE_TRIAL_DATA_FIN);
		}
	}
}
