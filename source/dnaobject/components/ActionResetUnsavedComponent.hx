package dnaobject.components;

import Assertion.assert;
import dnadata.DnaDataManager;
import flixel.FlxG;

/**
 * this class will be used to set the slider position on slideable objects.
 */
class ActionResetUnsavedComponent implements DnaComponent extends DnaActionBase
{
	/**
	 * ctor
	 */
	public function new()
	{
		super("ActionResetUnsavedComponent");
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
	 *  ResetUnsaved() in here we set the task as finished in the datamanager.
	 */
	private function resetUnsaved()
	{
		DnaDataManager.instance.resetUnsaved();
	}

	/**
	 * in here we will set the slider position and make it visible (if not the case)
	 */
	override public function update(elapsed:Float)
	{
		resetUnsaved();
		this.finishAction();
	}
}
