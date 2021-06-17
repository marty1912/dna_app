package dnaobject.components;

import Assertion.assert;
import dnadata.DnaDataManager;
import dnadata.TaskTrials;
import dnadata.TrialBlock;
import dnaobject.interfaces.ILevelPreview;
import dnaobject.interfaces.IStateMachine;
import dnaobject.interfaces.IUnlockableItem;
import dnaobject.objects.DnaButtonObject;
import haxe.Json;
import textparsemacro.ConfigFile;

/**
 * this class will make an object appear based on an event.
 */
class ActionShowLevelPreview implements DnaComponent extends DnaActionBase
{
	public var state:String = "";

	/**
	 * ctor
	 */
	public function new()
	{
		super("ActionShowLevelPreview");
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
		var n_tasks = this.targets.length;
		var trials = TaskTrials.instance.getTrialBlocksTodo();

		trials = Random.shuffle(trials);

		if (trials.length == 0)
		{
			trace("no trials available. TODO:handle this.");
			assert(false);
		}
		while (n_tasks > trials.length)
		{
			trials.push(trials[0]);
		}

		for (i in 0...this.targets.length)
		{
			var target:ILevelPreview = cast getParent().getParent().getObjectByName(targets[i]);
			var block:TrialBlock = trials[i];

			target.setTrialBlock(block);
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
