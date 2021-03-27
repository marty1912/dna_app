package dnaobject.components;

import Assertion.assert;
import dnadata.DnaDataManager;
import dnaobject.objects.SubStateObject;
import flixel.FlxG;

/**
 * this class will be used to set the slider position on slideable objects.
 */
class ActionSwitchToSubStateComponent implements DnaComponent extends DnaActionBase
{
	/**
	 * ctor
	 */
	public function new()
	{
		super("ActionSwitchToSubstateComponent");
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
	 * in here we switch our state. and finish our action.
	 */
	private function switchstates()
	{
		trace("actionswitchto substate");
		var obj:SubStateObject = cast this.getParent().getParent().getObjectByName(this.m_target_name);
		var substate = obj.sub_state;
		trace("switching to substate now:", substate.state_type);
		this.getParent().getParent().openSubState(substate);
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
