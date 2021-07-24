package dnaobject.objects.ordinal_task_states.real_task;

import dnaobject.interfaces.IStateFactory;

class OrdinalTaskDefaultFactory implements IStateFactory
{
	public function new() {}

	public function create()
	{
		trace("default factory create.");
		return new OrdInitialState();
	}
}
