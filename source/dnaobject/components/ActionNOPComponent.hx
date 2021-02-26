package dnaobject.components;

/**
 * this Action is a NOP (NO operation) so it just calls the finishAction function
 	* it can be used as a placeholder.
 */
class ActionNOPComponent implements DnaComponent extends DnaActionBase
{
	/**
	 * ctor
	 */
	public function new()
	{
		super("ActionNOPComponent");
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
	 * in this function we will make the object NOP..
	 * @param elapsed
	 */
	override public function update(elapsed:Float)
	{
		this.finishAction();
	}
}
