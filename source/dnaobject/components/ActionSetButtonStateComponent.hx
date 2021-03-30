package dnaobject.components;

import dnaobject.interfaces.IStateMachine;
import dnaobject.objects.DnaButtonObject;

/**
 * this class will make an object appear based on an event.
 */
class ActionSetButtonStateComponent implements DnaComponent extends DnaActionBase
{
	public var state:String = "";

	/**
	 * ctor
	 */
	public function new()
	{
		super("ActionSetButtonStateComponent");
	}

	/**
	 * this member specifies whether we invert our behaviour.
	 * (hide instead of appear)
	 */
	public var invert:Bool = false;

	/**
	 * in here we read our params from a file..
	 * @param jsonFile - the jsonFile object to read from. should be the output of jsonParse.
	 */
	override public function fromFile(jsonFile:Dynamic):Void
	{
		if (Reflect.hasField(jsonFile, "state"))
		{
			state = jsonFile.state;
		}
		super.fromFile(jsonFile);
	}

	/**
	 * setState() - sets the target button to a state selected by a string
	 * @param string - the status to set
	 * possible values:
	 * - NORMAL
	 * - HIGHLIGHT
	 * - PRESSED
	 * - INACTIVE
	 */
	public function setState(string:String, target_name:String)
	{
		// with the first getParent we get the object. and with the 2nd the state.
		var target:IStateMachine = cast(getParent().getParent().getObjectByName(target_name));
		if (string == "NORMAL")
		{
			target.setNextState(new ButtonStateNormal());
		}
		else if (string == "HIGHLIGHT")
		{
			target.setNextState(new ButtonStateHighlight());
		}
		else if (string == "PRESSED")
		{
			target.setNextState(new ButtonStatePressed());
		}
		else if (string == "INACTIVE")
		{
			target.setNextState(new ButtonStateInactive());
		}
		else
		{
			Assertion.assert(false);
		}
	}

	/**
	 * in this function we will make the object appear..
	 * @param elapsed
	 */
	override public function update(elapsed:Float)
	{
		doActionOnAllTargets();

		this.finishAction();
	}

	/**
	 * in here we will remove stuff..
	 * @param target_name 
	 */
	override public function doActionPerTarget(target_name:String)
	{
		setState(this.state, target_name);
	}
}
