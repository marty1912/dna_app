package dnaobject.objects.dotcompstates.numerical_no_time;

import dnaobject.interfaces.IStateFactory;

class NumStateFactory implements IStateFactory
{
	public function new() {}

	public function create()
	{
		trace("numerical_no_time factory create");
		return new NumInitialState();
	}
}
