package dnaobject.components;

import dnaEvent.DnaEventManager;
import dnadata.DnaDataManager;
import haxe.Json;

/**
 * this class will make an object appear based on an event.
 */
class ActionUnlockComponent implements DnaComponent extends DnaActionBase
{
	/**
	 * ctor
	 */
	public function new()
	{
		super("ActionUnlockComponent");
	}

	/**
	 * this member specifies whether we invert our behaviour.
	 * (hide instead of appear)
	 */
	public var invert:Bool = false;

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
		var target:DnaObject = getParent().getParent().getObjectByName(m_target_name);
		// target.fromFile(componentJson);

		var unlock:Dynamic = DnaDataManager.instance.unlockNextMontyPart();
		if (unlock == null)
		{
			this.getParent().getParent().eventManager.broadcastEvent("NO_MORE_TO_UNLOCK");
			this.finishAction();
			return;
		}
		var comp:DnaComponent = DnaComponentFactory.create(unlock.type);
		comp.fromFile(unlock);
		target.addComponent(comp);

		this.finishAction();
	}
}
