package dnaobject.components;

import dnaEvent.DnaEvent;

/**
 * this class is used so we can read events from a file.
 */
class EventComponent implements DnaComponent extends DnaActionBase
{
	/**
	 * ctor
	 */
	public function new()
	{
		super("EventComponent");
	}

	private var event:DnaEvent;

	/**
	 * in here we read our params from a file..
	 * @param jsonFile - the jsonFile object to read from. should be the output of jsonParse.
	 */
	override public function fromFile(jsonFile:Dynamic):Void
	{
		if (Reflect.hasField(jsonFile, "event_name"))
		{
			this.event = new DnaEvent(jsonFile.event_name);
		}
		// assert(jsonFile.type == this.state_type);
		var pre:Array<Dynamic> = jsonFile.pre;
		for (p in pre)
		{
			this.event.addPrequisite(p);
		}

		super.fromFile(jsonFile);
	}

	/**
	 * @param elapsed
	 */
	override public function update(elapsed:Float) {}
}
