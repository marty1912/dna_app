package dnaobject.components;

import dnaEvent.DnaEventManager;
import dnaEvent.DnaEventSubscriber;
import dnadata.DnaDataManager;
import dnaobject.interfaces.ITextBox;
import dnaobject.objects.TextObject;
import flixel.system.FlxAssets;
import flixel.util.FlxColor;
import textbox.Settings;
import textbox.Textbox.Status;

/**
 * this class will make an object appear based on an event.
 */
class ActionShowTextComponent implements DnaComponent implements DnaEventSubscriber extends DnaActionBase
{
	/**
	 * ctor
	 */
	public function new()
	{
		super("ActionShowTextComponent");
	}

	/**
	 * getNotified on the event for the finished text box
	 * @param event_name
	 */
	public function getNotified(event_name:String, params:Any = null)
	{
		this.first = true;
		this.finishAction();
	}

	/**
	 * in here we read our params from a file..
	 * @param jsonFile - the jsonFile object to read from. should be the output of jsonParse.
	 */
	override public function fromFile(jsonFile:Dynamic):Void
	{
		super.fromFile(jsonFile);
	}

	public var first:Bool = true;

	/**
	 * this starts our textbox.
	 */
	public function startTextBox()
	{
		// might look confusing at first.
		// with the first getParent we get the object. and with the 2nd the state.
		var target:ITextBox = cast(getParent().getParent().getObjectByName(m_target_name));
		// target.setText("ALL_TASKS_DONE_BODY");
		target.start();
		this.getParent().getParent().eventManager.addSubscriberForEvent(this, target.getEventFinName());
	}

	/**
	 * in this function we will make the object appear..
	 * @param elapsed
	 */
	override public function update(elapsed:Float)
	{
		if (first)
		{
			first = false;
			startTextBox();
		}
	}
}
