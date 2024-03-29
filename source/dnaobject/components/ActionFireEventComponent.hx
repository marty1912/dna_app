package dnaobject.components;

import dnaEvent.DnaEventManager;
import dnaEvent.DnaEventSubscriber;

/**
 * this class will be used to set the slider position on slideable objects.
 */
class ActionFireEventComponent implements DnaComponent extends DnaActionBase
{
	/**
	 * ctor
	 */
	public function new()
	{
		super("ActionFireEventComponent");
	}

	public var event_name:String = "";
	public var params:Null<Any> = null;

	/**
	 * in here we read our params from a file..
	 * @param jsonFile - the jsonFile object to read from. should be the output of jsonParse.
	 */
	override public function fromFile(jsonFile:Dynamic):Void
	{
		if (Reflect.hasField(jsonFile, "event_name"))
		{
			event_name = jsonFile.event_name;
		}
		if (Reflect.hasField(jsonFile, "params"))
		{
			params = jsonFile.params;
		}
		super.fromFile(jsonFile);
		this.jsonFile = jsonFile;
	}

	public var jsonFile:Dynamic;

	/**
	 * we might do stuff here to speed everything up as we do not have to wait for the next update
	 */
	override public function onHaveParent()
	{
		this.getParent().getParent().eventManager.broadcastEvent(event_name, params);
		this.finishAction();
	}

	/**
	 * in here we will set the slider position and make it visible (if not the case)
	 */
	override public function update(elapsed:Float) {}
}
