package dnaobject.objects;

import dnaEvent.DnaEventManager;
import dnaEvent.DnaEventSubscriber;
import dnadata.DnaDataManager;
import dnaobject.interfaces.TaskObject;
import haxe.DynamicAccess;

/**
 * this is the class that handles giving our trial parameters to the correct objects.
 */
class MonsterEditorObject implements DnaObject implements DnaEventSubscriber extends DnaObjectBase
{
	public static final SAVE_MONTI_DATA = "MonsterEditor_save";
	public static final SAVE_MONTI_DATA_FIN = "MonsterEditor_save_fin";
	public static final INC_INDEX_POSTFIX = "_INC";
	public static final DEC_INDEX_POSTFIX = "_DEC";

	// this is used to store our index
	public var unique_part_types:Map<String, Int>;

	/**
	 * overwritten ctor.
	 */
	public function new()
	{
		super("MonsterEditorObject");

		getPartListFromManager();
		registerListeners();
		this.getParent().eventManager.addSubscriberForEvent(this, SAVE_MONTI_DATA);
		getCurrentPartsFromManager();
	}

	/**
	 * this is where we store the parts we can choose from.
	 */
	private var available_parts:Array<Dynamic>;

	/**
	 * the index for keeping track of on which trial we are currently at.
	 */
	private var trial_index:Int = 0;

	public function getPartListFromManager()
	{
		this.available_parts = DnaDataManager.instance.getAvailableMontyParts();
	}

	/**
	 * getCurrentConfigFromManager
	 */
	public function getCurrentPartsFromManager()
	{
		var current_config = DnaDataManager.instance.getMontiPartData();
		for (monti_part in current_config)
		{
			var list_of_current_part:Array<Dynamic> = new Array<Dynamic>();
			for (element in available_parts)
			{
				if (element.part_type == monti_part.part_type)
				{
					list_of_current_part.push(element);
				}
			}

			var index = 0;
			for (element in list_of_current_part)
			{
				// this is kind of a hack but apparently you cannot compare dynamic in haxe
				// so we compare the first asset path.
				if (element.assets == null || monti_part.assets == null)
				{
					continue;
				}
				if (element.assets[0].path == monti_part.assets[0].path)
				{
					break;
				}
				index++;
			}

			index = index % list_of_current_part.length;
			if (index < 0)
			{
				index += list_of_current_part.length;
			}
			unique_part_types.set(monti_part.part_type, index);
			trace("part:", monti_part.part_type, "index:", index, "len of list:", list_of_current_part.length);
		}
	}

	public function registerListeners():Void
	{
		unique_part_types = new Map<String, Int>();
		for (part in available_parts)
		{
			if (!unique_part_types.exists(part.part_type))
			{
				unique_part_types.set(part.part_type, 0);
			}
		}
		for (typ => val in unique_part_types)
		{
			// listeners for incrementing and decrementing the index..

			this.getParent().eventManager.addSubscriberForEvent(this, typ + INC_INDEX_POSTFIX);
			this.getParent().eventManager.addSubscriberForEvent(this, typ + DEC_INDEX_POSTFIX);
		}
	}

	/**
	 * this function collects all the data from the objects and stores it in the trials list (in the correct place).
	 */
	public function collectData()
	{
		var list_to_store:Array<Dynamic> = new Array<Dynamic>();

		for (key => index in unique_part_types)
		{
			var list_of_current_part:Array<Dynamic> = new Array<Dynamic>();
			for (element in available_parts)
			{
				if (element.part_type == key)
				{
					list_of_current_part.push(element);
				}
			}
			index = index % list_of_current_part.length;
			if (index < 0)
			{
				index += list_of_current_part.length;
			}
			list_to_store.push(list_of_current_part[index]);
		}
		DnaDataManager.instance.setMontiPartData(list_to_store);
	}

	/**
	 * this updates the selected parts of the monster by using the map with the indices.
	 */
	private function updateMonsterPartSelection(key:String)
	{
		var monti:MonsterObject = cast(getParent().getObjectByName(target_name));

		var index:Int = unique_part_types.get(key);

		var list_of_current_part:Array<Dynamic> = new Array<Dynamic>();
		for (element in available_parts)
		{
			if (element.part_type == key)
			{
				list_of_current_part.push(element);
			}
		}

		index = index % list_of_current_part.length;
		if (index < 0)
		{
			index += list_of_current_part.length;
		}

		var comp:DnaComponent = DnaComponentFactory.create(list_of_current_part[index].type);
		comp.fromFile(list_of_current_part[index]);
		monti.addComponent(comp);

		// we can now remove the added component again because they only set stuff at the beginning.
		// this helps so we do not end up with 10000 components on monty in case someone spends hours in
		// the editor..
		monti.removeComponentByType(available_parts[0].type);
	}

	/**
	 * setIndexForKey - this function sets the index of the key in the unique list to the new index and then
	 * sets this newly selected Compoenent to the Monsterobject.
	 * @param key
	 * @param index
	 */
	private function getIndexForKey(key:String)
	{
		return this.unique_part_types.get(key);
	}

	/**
	 * setIndexForKey - this function sets the index of the key in the unique list to the new index and then
	 * sets this newly selected Compoenent to the Monsterobject.
	 * @param key
	 * @param index
	 */
	private function setIndexForKey(key:String, index:Int)
	{
		this.unique_part_types.set(key, index);
		updateMonsterPartSelection(key);
	}

	// target = monti object!
	public var target_name:String;

	/**
	 * in the fromFile function we simply read the asset path from the file.
	 *
	 * @param jsonFile
	 */
	override public function fromFile(jsonFile:Dynamic):Void
	{
		if (Reflect.hasField(jsonFile, "target"))
		{
			target_name = jsonFile.target;
		}
		super.fromFile(jsonFile);
	}

	/**
	 * this is the function that gets called everytime an event we subscribed for is fired
	 * @param event_name
	 */
	public function getNotified(event_name:String)
	{
		trace("MonsterEditor got notified:", event_name);

		if (event_name == SAVE_MONTI_DATA)
		{
			collectData();
		}
		else if (event_name.substr(event_name.length - INC_INDEX_POSTFIX.length) == INC_INDEX_POSTFIX)
		{
			var key = event_name.substr(0, event_name.length - INC_INDEX_POSTFIX.length);
			setIndexForKey(key, getIndexForKey(key) + 1);
		}
		else if (event_name.substr(event_name.length - DEC_INDEX_POSTFIX.length) == DEC_INDEX_POSTFIX)
		{
			var key = event_name.substr(0, event_name.length - DEC_INDEX_POSTFIX.length);
			setIndexForKey(key, getIndexForKey(key) - 1);
		}
	}
}
