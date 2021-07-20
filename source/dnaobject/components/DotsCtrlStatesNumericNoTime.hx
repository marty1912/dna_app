package dnaobject.components;

import constants.DnaConstants;
import dnaEvent.DnaEventSubscriber;
import dnaobject.interfaces.ITextBox;
import dnaobject.objects.ActionHandlerObject;
import dnaobject.objects.DnaButtonObject;
import dnaobject.objects.DotsCompCtrl;
import dnaobject.objects.dotcompstates.numerical_no_time.NumStateFactory;
import flixel.FlxSprite;
import flixel.math.FlxPoint;

/**
 * this class can be used to transform a button into a invisible clickarea that can be attached to other objects.
 */
class DotsCtrlStatesNumericNoTime implements DnaComponent extends DnaComponentBase
{
	/**
	 * ctor
	 */
	public function new()
	{
		super("DotsCtrlStatesNumericNoTime");
		trace("new DotsCtrlStatesNumericNoTime");
	}

	/**
	 * in here we read our params from a file..
	 * @param jsonFile - the jsonFile object to read from. should be the output of jsonParse.
	 */
	override public function fromFile(jsonFile:Dynamic):Void {}

	public var dots_ctrl:DotsCompCtrl;

	public override function onHaveParent() {}

	public override function onReady()
	{
		this.dots_ctrl = cast this.getParent();
		dots_ctrl.states_factory = new NumStateFactory();
		trace("set factory to numStateFactory no time.");
	}

	/**
	 * in this function we will make the object Shrink..
	 * @param elapsed
	 */
	override public function update(elapsed:Float) {}
}
