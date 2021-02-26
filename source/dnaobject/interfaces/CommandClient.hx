package dnaobject.interfaces;

import flixel.ui.FlxButton;

/**
 * interface for DnaButtons - this is used for our command pattern logic.
 */
interface CommandClient
{
	/**
	 * this is the list of commands that we have to execute on a certain action.
	 * we dont know the actions specifically.
	 * each command will add itself to that list and remove itself when setting the parent.
	 */
	public var command_list:Array<Command>;
}
