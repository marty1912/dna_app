package dnaobject.components;

import Assertion.assert;
import dnaobject.interfaces.IState;
import dnaobject.interfaces.IStateMachine;
import flixel.FlxSprite;
import flixel.ui.FlxButton;
import flixel.util.FlxDestroyUtil;
import openfl.display.Preloader.DefaultPreloader;

/**
 * this class is used to make our buttons interactice.
 */
class StateMachineComponent implements DnaComponent implements IStateMachine extends DnaComponentBase
{
	/**
	 * ctor
	 */
	public function new()
	{
		super('StateMachineComponent');
	}

	/**
	 * sets the next state
	 * @param next_state 
	 */
	public function setNextState(next_state:IState):Void
	{
		if (m_current_state != null)
		{
			m_current_state.exit();
			m_current_state = null;
		}
		m_current_state = next_state;
		m_current_state.setParent(this);
		m_current_state.enter();
	}

	// read from outside, write only from this class
	public var m_current_state(default, null):IState = null;

	public function setState(state:StateEnum):Void
		throw "not implemented! only here for legacy reasons!";

	override public function update(elapsed:Float)
	{
		this.m_current_state.update(elapsed);
	}

	/**
	 * fromFile function. reads from Dynamic field.
	 * @param jsonFile
	 */
	override public function fromFile(jsonFile:Dynamic) {}

	public var state_machine:IStateMachine = null;
}
