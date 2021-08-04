package dnaobject.objects.flanker_task_states.real_task;

import dnaobject.interfaces.IStateFactory;

class FlankerDefaultFactory implements IStateFactory
{
	public function new() {}

	public function create()
	{
		trace("default factory create.");
		return new FlankerInitialState();
	}
}
