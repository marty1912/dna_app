package dnaobject.components;

import Assertion.assert;
import dnadata.DnaDataManager;
import dnaobject.interfaces.IStateMachine;
import dnaobject.interfaces.IUnlockableItem;
import dnaobject.objects.DnaButtonObject;
import haxe.Json;
import textparsemacro.ConfigFile;

/**
 * this class will make an object appear based on an event.
 */
class ActionShowUnlockables implements DnaComponent extends DnaActionBase
{
	public var state:String = "";

	/**
	 * ctor
	 */
	public function new()
	{
		super("ActionShowUnlockables");
	}

	/**
	 * in here we read our params from a file..
	 * @param jsonFile - the jsonFile object to read from. should be the output of jsonParse.
	 */
	override public function fromFile(jsonFile:Dynamic):Void
	{
		super.fromFile(jsonFile);
	}

	/**
	 * we use this function so everything happens immediately and without delay like in the update loop.
	 */
	override public function onHaveParent()
	{
		var n_unlocks = this.targets.length;
		var locked_parts = DnaDataManager.instance.getLockedMontiParts();

		locked_parts = Random.shuffle(locked_parts);

		if (locked_parts.length == 0)
		{
			var lock_part:Dynamic = Json.parse(ConfigFile.text("assets/text/MontiAllUnlockedPart.json"));
			locked_parts.push(lock_part);
		}
		while (n_unlocks > locked_parts.length)
		{
			locked_parts.push(locked_parts[0]);
		}

		for (i in 0...this.targets.length)
		{
			var target:IUnlockableItem = cast getParent().getParent().getObjectByName(targets[i]);
			var unlock:Dynamic = locked_parts[i];

			target.setUnlockable(unlock);
		}
		this.finishAction();
	}

	/**
	 * in this function we will make the object appear..
	 * @param elapsed
	 */
	override public function update(elapsed:Float)
	{
		// doActionOnAllTargets();
		// this.finishAction();
	}

	/**
	 * in here we will remove stuff..
	 * @param target_name 
	 */
	override public function doActionPerTarget(target_name:String) {}
}
