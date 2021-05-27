package dnaobject.components;

import Assertion.assert;
import dnaEvent.DnaEventManager;
import dnaobject.DnaComponent;
import dnaobject.DnaComponentBase;
import dnaobject.interfaces.Command;
import dnaobject.interfaces.CommandClient;
import flixel.FlxG;

/**
 * class CmdEvtTrigcomponent.
 * this encapsulates a command that triggers specified events.
 */
class CmdEvtTrigComponent implements DnaComponent implements Command extends DnaCommandBase
{
	public function new()
	{
		super('CmdEvtTrigComponent');
	}

	private var m_event_to_trigger:String;

	public var params:Null<Any> = null;

	/**
	 * fromFile function. reads from Dynamic field.
	 * @param jsonFile
	 */
	override public function fromFile(jsonFile:Dynamic)
	{
		// assert(jsonFile.type == this.comp_type);
		if (Reflect.hasField(jsonFile, "event_name"))
		{
			m_event_to_trigger = jsonFile.event_name;
		}
		if (Reflect.hasField(jsonFile, "params"))
		{
			params = jsonFile.params;
		}
	}

	/**
	 * this function is executed by the "clients". every command has it.
	 */
	public override function execute()
	{
		this.getParent().getParent().eventManager.broadcastEvent(m_event_to_trigger, params);
	}
}
