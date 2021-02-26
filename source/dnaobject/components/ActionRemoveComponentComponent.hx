package dnaobject.components;

/**
 * this class will make an object appear based on an event.
 */
class ActionRemoveComponentComponent implements DnaComponent extends DnaActionBase
{
	/**
	 * ctor
	 */
	public function new()
	{
		super("ActionRemoveComponentComponent");
	}

	public var target_comp:String;

	/**
	 * in here we read our params from a file..
	 * @param jsonFile - the jsonFile object to read from. should be the output of jsonParse.
	 */
	override public function fromFile(jsonFile:Dynamic):Void
	{
		if (Reflect.hasField(jsonFile, "target_comp"))
		{
			target_comp = jsonFile.target_comp;
		}
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
		target.removeComponentByType(target_comp);
		this.finishAction();
	}
}
