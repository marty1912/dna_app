package dnadata;

import Assertion.assert;
import flixel.FlxG;
import flixel.util.FlxSave;
import haxe.DynamicAccess;
import haxe.Json;
import osspec.OsManager;
import osspec.OsSpecific;
import textparsemacro.ConfigFile;
import thx.csv.Csv;
import uuid.Uuid;

/**
 * class DnaDataManager. this class will be responsible for storing the data from the server and also for unlocks etc.
 */
class DnaDataManager
{
	public final PART_UUID:String = "participant_uuid";
	public final OS_DATA:String = "os_data";

	public static final ORD_TASK_COND:String = "ord_task_right_inorder";

	public static final TRIALS_KEY:String = "trials";
	public static final MONTI_KEY:String = "monti";
	public static final ALL_MONTI_PARTS_KEY:String = "all_monti_parts";
	public static final SAVE_ALL_BEFORE:String = "SAVE";
	public static final REDIRECT:String = "REDIRECT";

	public static final SCREEN_W:String = "screen_w";
	public static final SCREEN_H:String = "screen_h";

	public var persistent_storage:Dynamic;

	public static final save_slot_name:String = "save_slot.json";

	/**
	 * this is the only instance that will ever exist
	 */
	public static final instance:DnaDataManager = new DnaDataManager();

	/**
	 * private ctor so nobody can create another singleton
	 */
	private function new()
	{
		// persistent_storage = new FlxSave();
		// persistent_storage.bind(save_slot_name);
	};

	/**
	 * initStorage - initialize the permanent storage
	 */
	public function initStorage()
	{
		var stored_data:Dynamic = OsManager.get_instance().readFromStorage(save_slot_name);
		if (stored_data == null)
		{
			persistent_storage = {data: {}};
		}
		else
		{
			persistent_storage = {data: stored_data}
		}
	}

	/**
	 * initializes all the data from storage..
	 */
	public function init()
	{
		initStorage();
		var uuid:String = retrieveData(PART_UUID);
		// trace(uuid);
		if (uuid == null)
		{
			setupUUID();
			setupOsInfo();
			setupRandomConditions();
			setupTrials();
			setupMonti();
		}
		else
		{
			loadTrials();
		}
	}

	/**
	 * this function
	 */
	public function setupUUID()
	{
		storeData(PART_UUID, Uuid.v4());
	}

	/**
	 * this function
	 */
	public function setupOsInfo()
	{
		storeData(OS_DATA, OsManager.get_instance().getOsInfo());
		storeData(SCREEN_W, FlxG.stage.stageWidth);
		storeData(SCREEN_H, FlxG.stage.stageHeight);
	}

	public function setupRandomConditions()
	{
		var ord_task_right_inorder:Bool = Random.bool();
		storeData(ORD_TASK_COND, ord_task_right_inorder);
	}

	/**
	 * this function loads the trials from the storage to a member variable that is then used for many things.
	 * using this thing makes it easier.
	 */
	public function loadTrials():Void
	{
		m_trials = retrieveData(TRIALS_KEY);
	}

	/**
	 * storeData - this stores some data permanently.
	 * @param key
	 * @param value
	 */
	public function storeData(key:String, value:Dynamic)
	{
		// //trace("storeData:", key, value);
		Reflect.setProperty(persistent_storage.data, key, value);
		OsManager.get_instance().saveToStorage(getAllData(), save_slot_name);
		// persistent_storage.flush();
		// //trace(persistent_storage.data);
	}

	/** storeData - this stores some data permanently.
	 * @param key
	 * @param value
	 */
	public function retrieveData(key:String):Dynamic
	{
		return Reflect.getProperty(persistent_storage.data, key);
	}

	/**
	 * deleteAllData - Deletes all stored data.
	 */
	public function deleteAllData()
	{
		// persistent_storage.erase();
		OsManager.get_instance().saveToStorage({}, save_slot_name);
		// get default values loaded.
		init();
	}

	/**
	 * deleteAllData - returns all data we have
	 */
	public function getAllData():Dynamic
	{
		return persistent_storage.data;
	}

	/**
	 * this function is responsible for getting the trials we need.
	 * this will later involve saves and getting stuff from the server. but not yet.
	 */
	public function setupTrials()
	{
		setTrials(TaskTrials.instance.getAllTrials());
		// setTrials(Json.parse(TaskTrials.Trials));
	}

	/**
	 * setTrials sets the m_trials member to the value specified
	 */
	public function setTrials(value:Dynamic)
	{
		// trace("set trials:", value);
		m_trials = value;
		storeData(TRIALS_KEY, value);
	}

	/**
	 * setupMonti() - this function sets up the data for monti. for now it only reads from file but
	 * later it should also read from storage so we have persistency
	 */
	public function setupMonti()
	{
		var default_parts:Array<Dynamic> = Json.parse(ConfigFile.text("assets/text/MontiPartsDefault.json"));
		setMontiPartData(default_parts);
		var text:String = ConfigFile.text("assets/text/MontiParts.json");
		var parts:Array<Dynamic> = Json.parse(text);
		// we add both the default parts and the other parts.
		storeData(ALL_MONTI_PARTS_KEY, parts.concat(default_parts));
	}

	// this is the variable that stores our trials.
	private var m_trials:Array<Dynamic>;

	/**
	 *  getDoneRatio - returns the % of total tasks done.
	 */
	public function getDoneRatio():Float
	{
		var index = 0;
		var done = 0;
		while (index < m_trials.length)
		{
			var cur_trial:Dynamic = m_trials[index];
			if (cur_trial.done == false)
			{
				done++;
			}
			index++;
		}

		if (index == 0)
		{
			return 0;
		}

		return done / index;
	}

	/**
	 * sets all trials that have come so far to finished = true
	 * TODO: permanently store this stuff!
	 * @param max_index - the index up to which we want to set finished
	 */
	public function saveAllBefore(max_index:Int):Void
	{
		trace("saving all before:", max_index);
		var index = 0;
		while (index < max_index)
		{
			trace("saving:", m_trials[index].type);
			m_trials[index].saved = true;
			index++;
		}
		this.storeData(TRIALS_KEY, m_trials);
		return;
	}

	/**
	 * resetUnsaved - this function resets all unsaved progress.
	 */
	public function resetUnsaved():Void
	{
		var index = 0;
		while (index < m_trials.length)
		{
			if (m_trials[index].saved == false)
			{
				m_trials[index].done = false;
			}
			index++;
		}
	}

	/**
	 *  getNextTrial() - returns the next trial that we have to do.
	 */
	public function getNextTrials():Dynamic
	{
		var index = 0;
		while (index < m_trials.length)
		{
			var cur_trial:Dynamic = m_trials[index];
			trace("current_trial:", cur_trial.type);
			if (cur_trial.done == false)
			{
				if (cur_trial.type == SAVE_ALL_BEFORE)
				{
					// trace("now saving progress..");
					saveAllBefore(index);
					cur_trial.done = true;
					return getNextTrials();
				}
				else if (cur_trial.type == REDIRECT)
				{
					// trace("now redirecting to:", cur_trial.to);
					cur_trial.done = true;
					saveAllBefore(index);
					return cur_trial.to;
				}
				return cur_trial;
			}
			index++;
		}
		return Json.parse(TaskTrials.ALL_TASKS_DONE);
		// return null;
	}

	/**
	 *  finishCurrentTask() - sets the current trial to done
	 */
	public function finishCurrentTask():Void
	{
		trace("finish current task..");
		var index = 0;
		while (index < m_trials.length)
		{
			var cur_trial:Dynamic = m_trials[index];
			if (cur_trial.done == false)
			{
				trace("finishing current task:", cur_trial.type);
				if (cur_trial.type == SAVE_ALL_BEFORE)
				{
					saveAllBefore(index);
				}
				cur_trial.done = true;
				break;
			}
			index++;
		}
	}

	public var monti_part_data:Array<Dynamic>;

	/**
	 * this stores the monti parts we selected (not yet) permanently
	 * @param data
	 */
	public function setMontiPartData(data:Array<Dynamic>):Void
	{
		monti_part_data = data;
		storeData(MONTI_KEY, monti_part_data);
	}

	/**
	 * this returns the monti parts that were previously stored.
	 * @param data
	 */
	public function getMontiPartData():Array<Dynamic>
	{
		monti_part_data = retrieveData(MONTI_KEY);

		return monti_part_data;
	}

	/**
	 * this function is used to get all the available (unlocked) monty parts and return them.
	 * @return Array<Dynamic>
	 */
	public function getAvailableMontyParts():Array<Dynamic>
	{
		var parts:Array<Dynamic> = retrieveData(ALL_MONTI_PARTS_KEY);
		var unlocked_parts:Array<Dynamic> = new Array<Dynamic>();
		for (part in parts)
		{
			if (part.unlocked)
			{
				unlocked_parts.push(part);
			}
		}
		return unlocked_parts;
	}

	/**
	 * this function is used to get all the available (unlocked) monty parts and return them.
	 * @return Array<Dynamic>
	 */
	public function getLockedMontiParts():Array<Dynamic>
	{
		var parts:Array<Dynamic> = retrieveData(ALL_MONTI_PARTS_KEY);
		var locked_parts:Array<Dynamic> = new Array<Dynamic>();
		for (part in parts)
		{
			if (part.unlocked == false)
			{
				locked_parts.push(part);
			}
		}
		return locked_parts;
	}

	/**
	 * this function unlocks the monti part given, stores the list of parts again and then
	 * returns the newly unlocked part.
	 * in case that all parts have been unlocked already it returns null
	 * @return Dynamic - the part that was unlocked.
	 */
	public function unlockMontyPart(value:Dynamic):Dynamic
	{
		var parts:Array<Dynamic> = retrieveData(ALL_MONTI_PARTS_KEY);
		var unlock:Dynamic = null;
		for (part in parts)
		{
			if (!part.unlocked && part == value)
			{
				part.unlocked = true;
				unlock = part;
				break;
			}
		}
		storeData(ALL_MONTI_PARTS_KEY, parts);
		return unlock;
	}

	/**
	 * this function unlocks the next available monti part, stores the list of parts again and then
	 * returns the newly unlocked part.
	 * in case that all parts have been unlocked already it returns null
	 * @return Dynamic - the part that was unlocked.
	 */
	public function unlockNextMontyPart():Dynamic
	{
		var parts:Array<Dynamic> = retrieveData(ALL_MONTI_PARTS_KEY);
		var unlock:Dynamic = null;
		for (part in parts)
		{
			if (!part.unlocked)
			{
				part.unlocked = true;
				unlock = part;
				break;
			}
		}
		storeData(ALL_MONTI_PARTS_KEY, parts);
		return unlock;
	}
}
