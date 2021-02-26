package dnaobject.interfaces;

/**
 * this interface will be used to implement the command Pattern for the UI.
 * this way we can hopefully reuse a lot of the code for the ui and only switch the commands.
 */
interface Command
{
	/**
	 * execute - this is the fundamental function for the command pattern
	 */
	public function execute():Void;
}
