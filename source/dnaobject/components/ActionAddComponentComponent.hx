package dnaobject.components;

import haxe.Json;

/**
 * this class will make an object appear based on an event.
 */
class ActionAddComponentComponent implements DnaComponent extends DnaActionBase
{
	/**
	 * ctor
	 */
	public function new()
	{
		super("ActionAddComponentComponent");
	}

	/**
	 * this member specifies whether we invert our behaviour.
	 * (hide instead of appear)
	 */
	public var invert:Bool = false;

	public var componentJson:Array<Dynamic>;

	/**
	 * in here we read our params from a file..
	 * @param jsonFile - the jsonFile object to read from. should be the output of jsonParse.
	 */
	override public function fromFile(jsonFile:Dynamic):Void
	{
		if (Reflect.hasField(jsonFile, "components"))
		{
			componentJson = jsonFile.components;
		}
		// trace(jsonFile);
		super.fromFile(jsonFile);
	}

	override public function doActionPerTarget(target_name:String)
	{
		var target:DnaObject = getParent().getParent().getObjectByName(target_name);
		// trace("target name:", m_target_name);
		// target.fromFile(componentJson);
		for (comp_json in componentJson)
		{
			// trace(comp_json);
			var comp:DnaComponent = DnaComponentFactory.create(comp_json.type);
			comp.fromFile(comp_json);
			target.addComponent(comp);
		}
	}

	/**
	 * in this function we will make the object appear..
	 * @param elapsed
	 */
	override public function update(elapsed:Float)
	{
		// we give the json to the state as a string because the from file things take strings..
		doActionOnAllTargets();

		this.finishAction();
	}
}
