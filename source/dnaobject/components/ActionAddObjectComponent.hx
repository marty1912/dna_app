package dnaobject.components;

import haxe.Json;

/**
 * this class will make an object appear based on an event.
 */
class ActionAddObjectComponent implements DnaComponent extends DnaActionBase
{
	/**
	 * ctor
	 */
	public function new()
	{
		super("ActionAddObjectComponent");
	}

	/**
	 * this member specifies whether we invert our behaviour.
	 * (hide instead of appear)
	 */
	public var invert:Bool = false;

	public var objectJson:Dynamic;

	/**
	 * in here we read our params from a file..
	 * @param jsonFile - the jsonFile object to read from. should be the output of jsonParse.
	 */
	override public function fromFile(jsonFile:Dynamic):Void
	{
		if (Reflect.hasField(jsonFile, "objects"))
		{
			objectJson = {objects: jsonFile.objects};
		}
		super.fromFile(jsonFile);
	}

	/**
	 * in this function we will make the object appear..
	 * @param elapsed
	 */
	override public function update(elapsed:Float)
	{
		// we give the json to the state as a string because the from file things take strings..
		getParent().getParent().fromFile(Json.stringify(objectJson));
		this.finishAction();
	}
}
