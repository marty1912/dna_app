package dnaobject.interfaces;

enum StateEnum
{
	NORMAL;
	HIGHLIGHT;
	PRESSED;
}

interface IStateMachine
{
	public function update(elapsed:Float):Void;
	public function setNextState(next_state:IState):Void;
	private var m_current_state:IState;
	public function setState(state:StateEnum):Void;
}
