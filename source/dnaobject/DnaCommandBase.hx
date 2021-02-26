package dnaobject;

import dnaobject.interfaces.Command;
import dnaobject.interfaces.CommandClient;

class DnaCommandBase extends DnaComponentBase implements Command
{
	/**
	 * setter for Parent object.
	 */
	public override function setParent(parent:DnaObject):Void
	{
		if (this.m_parent_obj == parent)
		{
			return;
		}
		if (this.m_parent_obj != null)
		{
			var parent_client:CommandClient = cast(m_parent_obj, CommandClient);
			parent_client.command_list.remove(this);
		}
		if (parent != null)
		{
			var parent_client:CommandClient = cast(parent, CommandClient);
			parent_client.command_list.push(this);
		}
		this.m_parent_obj = parent;
	}

	/**
	 * this is the execute function.
	 * @return throw "Override this function!"
	 */
	public function execute()
		throw "Override this function!";
}
