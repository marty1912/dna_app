package dnaobject.components;

import dnaobject.objects.ActionHandlerObject;
import haxe.Json;

/**
 * this class will make an object appear based on an event.
 */
class ActionCancelActionComponent implements DnaComponent extends DnaActionBase
{
	/**
	 * ctor
	 */
	public function new()
	{
		super("ActionCancelActionComponent");
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
	 * in this function we will make the object appear..
	 * @param elapsed
	 */
	override public function update(elapsed:Float)
	{
		// we give the json to the state as a string because the from file things take strings..
		var target:ActionHandlerObject = cast getParent().getParent().getObjectByName(m_target_name);
		// target.fromFile(componentJson);
		// trace("canceling actions now.---------------------------------");
		target.abortRunningActions();

		this.finishAction();
	}
}
