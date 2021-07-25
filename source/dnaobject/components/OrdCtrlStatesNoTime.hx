package dnaobject.components;

import constants.DnaConstants;
import dnaEvent.DnaEventSubscriber;
import dnaobject.interfaces.ITextBox;
import dnaobject.objects.ActionHandlerObject;
import dnaobject.objects.DnaButtonObject;
import dnaobject.objects.DotsCompCtrl;
import dnaobject.objects.OrdinalTaskCtrl;
import dnaobject.objects.ordinal_task_states.no_time.OrdinalTaskNoTimeFactory;
import flixel.FlxSprite;
import flixel.math.FlxPoint;

/**
 * this class can be used to transform a button into a invisible clickarea that can be attached to other objects.
 */
class OrdCtrlStatesNoTime implements DnaComponent extends DnaComponentBase
{
	/**
	 * ctor
	 */
	public function new()
	{
		super("OrdCtrlStatesNoTime");
	}

	/**
	 * in here we read our params from a file..
	 * @param jsonFile - the jsonFile object to read from. should be the output of jsonParse.
	 */
	override public function fromFile(jsonFile:Dynamic):Void {}

	public var ord_ctrl:OrdinalTaskCtrl;

	public override function onHaveParent() {}

	public override function onReady()
	{
		this.ord_ctrl = cast this.getParent();
		ord_ctrl.states_factory = new OrdinalTaskNoTimeFactory();
		trace("set factory to numStateFactory.");
	}

	/**
	 * in this function we will make the object Shrink..
	 * @param elapsed
	 */
	override public function update(elapsed:Float) {}
}
