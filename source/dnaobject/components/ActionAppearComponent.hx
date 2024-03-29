package dnaobject.components;

/**
 * this class will make an object appear based on an event.
 */
class ActionAppearComponent implements DnaComponent extends DnaActionBase
{
	/**
	 * ctor
	 */
	public function new()
	{
		super("ActionAppearComponent");
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
		if (Reflect.hasField(jsonFile, "invert"))
		{
			this.invert = jsonFile.invert;
		}

		super.fromFile(jsonFile);
	}

	override public function doActionPerTarget(target_name:String)
	{
		var target:DnaObject = getParent().getParent().getObjectByName(target_name);
		// trace("target:", target_name);
		for (child in target.getChildren())
		{
			// invert is default to false. so default behaviour is to make stuff appear.
			// if invert is true we hide instead of making things appear.
			child.visible = !this.invert;
			// trace("set child to visible", !this.invert);
		}
	}

	override public function onHaveParent()
	{
		doActionOnAllTargets();
		this.finishAction();
	}

	/**
	 * in this function we will make the object appear..
	 * @param elapsed
	 */
	override public function update(elapsed:Float)
	{
		// might look confusing at first.
		// with the first getParent we get the object. and with the 2nd the state.
		// doActionOnAllTargets();
		// this.finishAction();
	}
}
