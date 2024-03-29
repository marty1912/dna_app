package dnaobject.components;

/**
 * this class will make an object appear based on an event.
 */
class ActionRemoveObjectComponent implements DnaComponent extends DnaActionBase
{
	/**
	 * ctor
	 */
	public function new()
	{
		super("ActionRemoveObjectComponent");
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
		// might look confusing at first.
		// with the first getParent we get the object. and with the 2nd the state.
		var target:DnaObject = getParent().getParent().getObjectByName(m_target_name);

		if (target != null)
		{
			getParent().getParent().removeObject(target.id);
		}
		this.finishAction();
	}
}
