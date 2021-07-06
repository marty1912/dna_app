package dnaobject.components;

import dnaEvent.DnaEventSubscriber;
import dnaobject.interfaces.ITextBox;
import dnaobject.objects.ActionHandlerObject;
import dnaobject.objects.DnaButtonObject;
import dnaobject.objects.PatternExtendObject;
import dnaobject.objects.PatternExtendRealTask;
import flixel.FlxSprite;
import flixel.math.FlxPoint;

/**
 * this class can be used to transform a button into a invisible clickarea that can be attached to other objects.
 */
class PatternExtendPracticeComponent implements DnaComponent extends DnaComponentBase
{
	/**
	 * ctor
	 */
	public function new()
	{
		super("PatternExtendPracticeComponent");
	}

	public var action_correct:String;
	public var action_incorrect:String;

	public var action_correct_obj:ActionHandlerObject;
	public var action_incorrect_obj:ActionHandlerObject;
	public var parent_patternctrl:PatternExtendRealTask;

	/**
	 * in here we read our params from a file..
	 * @param jsonFile - the jsonFile object to read from. should be the output of jsonParse.
	 */
	override public function fromFile(jsonFile:Dynamic):Void
	{
		if (Reflect.hasField(jsonFile, "action_correct"))
		{
			action_correct = jsonFile.action_correct;
		}
		if (Reflect.hasField(jsonFile, "action_incorrect"))
		{
			action_incorrect = jsonFile.action_incorrect;
		}
	}

	public var first:Bool = true;

	public override function onHaveParent() {}

	public function onCorrect()
	{
		action_correct_obj.startQueue(parent_patternctrl.loadTrial);
	}

	public function onIncorrect()
	{
		action_incorrect_obj.startQueue(parent_patternctrl.trial_handler_obj.loadNextTrial);
	}

	public override function onReady()
	{
		parent_patternctrl = cast getParent();
		action_correct_obj = cast getParent().getParent().getObjectByName(action_correct);
		action_incorrect_obj = cast getParent().getParent().getObjectByName(action_incorrect);
		parent_patternctrl.onCorrectCallback = onCorrect;
		parent_patternctrl.onIncorrectCallback = onIncorrect;
	}

	/**
	 * in this function we will make the object Shrink..
	 * @param elapsed
	 */
	override public function update(elapsed:Float) {}
}
