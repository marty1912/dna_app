package dnaobject.components;

import Assertion.assert;
import dnaobject.DnaComponent;
import dnaobject.DnaComponentBase;
import dnaobject.interfaces.Command;
import dnaobject.interfaces.CommandClient;
import flixel.FlxG;

/**
 * class CmdStateSwitchcomponent.
 * this encapsulates a command that switches the state to a new one.
 * specified as string (which must be in the list of our DnaStatefactory of course).
 */
class CmdStateSwitchComponent implements DnaComponent implements Command extends DnaCommandBase
{
	public function new()
	{
		super('CmdStateSwitchComponent');
	}

	private var m_next_state:String;

	/**
	 * fromFile function. reads from Dynamic field.
	 * @param jsonFile
	 */
	override public function fromFile(jsonFile:Dynamic)
	{
		// assert(jsonFile.type == this.comp_type);
		if (Reflect.hasField(jsonFile, "next_state"))
		{
			m_next_state = jsonFile.next_state;
		}
	}

	/**
	 * this function is executed by the "clients". every command has it.
	 */
	public override function execute()
	{
		trace("now switching states to:", m_next_state);
		var action = DnaComponentFactory.create("ActionStateSwitchComponent");
		cast(action, ActionStateSwitchComponent).next_state = m_next_state;
		this.getParent().addComponent(action);
		// FlxG.switchState(DnaStateFactory.create(m_next_state));
	}
}
