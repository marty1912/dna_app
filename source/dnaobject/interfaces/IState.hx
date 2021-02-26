package dnaobject.interfaces;

/**
 * this interface will be used to represent our states of our button.
 */
interface IState
{
	// I do not know why but this does not seem to work.. some weird haxe quirk??
	// public var parent:IStateMachine;
	public function setParent(parent:IStateMachine):Void;
	public function update(elapsed:Float):Void;

	public function enter():Void;

	public function exit():Void;
}
