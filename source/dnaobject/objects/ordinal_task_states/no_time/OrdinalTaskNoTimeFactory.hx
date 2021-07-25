package dnaobject.objects.ordinal_task_states.no_time;

import dnaobject.interfaces.IStateFactory;

class OrdinalTaskNoTimeFactory implements IStateFactory
{
	public function new() {}

	public function create()
	{
		trace("no time factory create.");
		return new OrdInitialStateNoTime();
	}
}
