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
	public var m_current_state(default, null):IState;
	public function setState(state:StateEnum):Void;
}
