package dnaobject.components;

import Assertion.assert;
import dnadata.DnaDataManager;
import flixel.FlxG;

/**
 * this class will be used to set the slider position on slideable objects.
 */
class ActionStateSwitchComponent implements DnaComponent extends DnaActionBase
{
	public static final NEXT_TASK:String = "NEXT_TASK";

	/**
	 * ctor
	 */
	public function new()
	{
		super("ActionStateSwitchComponent");
	}

	public var next_state:String = "";

	/**
	 * in here we read our params from a file..
	 * @param jsonFile - the jsonFile object to read from. should be the output of jsonParse.
	 */
	override public function fromFile(jsonFile:Dynamic):Void
	{
		if (Reflect.hasField(jsonFile, "next_state"))
		{
			next_state = jsonFile.next_state;
		}
		super.fromFile(jsonFile);
	}

	/**
	 * in here we switch our state. and finish our action.
	 */
	private function switchstates()
	{
		if (next_state == NEXT_TASK)
		{
			var next_trial:Dynamic = DnaDataManager.instance.getNextTrials();
			if (next_trial == null)
			{
				assert(false);
				return;
			}
			next_state = next_trial.type;
		}
		// trace("switching states now to:", next_state);
		FlxG.switchState(DnaStateFactory.create(next_state));
	}

	/**
	 * in here we will set the slider position and make it visible (if not the case)
	 */
	override public function update(elapsed:Float)
	{
		switchstates();
		this.finishAction();
	}
}
