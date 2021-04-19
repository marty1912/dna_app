package dnaobject.components;

import dnaEvent.DnaEventSubscriber;
import dnaobject.interfaces.ITextBox;
import dnaobject.objects.DnaButtonObject;
import flixel.FlxSprite;
import flixel.math.FlxPoint;

/**
 * this class can be used to transform a button into a invisible clickarea that can be attached to other objects.
 */
class DisplayTimeComponent implements DnaComponent extends DnaComponentBase implements DnaEventSubscriber
{
	/**
	 * ctor
	 */
	public function new()
	{
		super("DisplayTimeComponent");
	}

	/**
	 * we will catch the event that the update timer emits.
	 * this event will have an float array as a param
	 * @param event_name 
	 * @param params 
	 */
	public function getNotified(event_name:String, params:Any = null)
	{
		if (params == null)
		{
			return;
		}
		var time_elapsed = (params : Array<Float>)[0];
		var time_total = (params : Array<Float>)[1];
		var remaining = time_total - time_elapsed;
		var minutes = Math.floor(remaining / 60);
		var sec = Math.floor(remaining % 60);
		var string = "";

		if (minutes > 0)
		{
			string += minutes + "min ";
		}

		if (sec >= 0)
		{
			string += sec + "s ";
		}

		this.parent_textbox.setText(string, true);
	}

	public var timer_event_name:String = "";
	public var parent_textbox:ITextBox;

	/**
	 * in here we read our params from a file..
	 * @param jsonFile - the jsonFile object to read from. should be the output of jsonParse.
	 */
	override public function fromFile(jsonFile:Dynamic):Void
	{
		if (Reflect.hasField(jsonFile, "timer_event_name"))
		{
			timer_event_name = jsonFile.timer_event_name;
		}
	}

	public var first:Bool = true;

	public override function onHaveParent()
	{
		this.parent_textbox = cast(this.getParent(), ITextBox);
		this.getParent().getParent().eventManager.addSubscriberForEvent(this, this.timer_event_name);
	}

	/**
	 * in this function we will make the object Shrink..
	 * @param elapsed
	 */
	override public function update(elapsed:Float) {}
}
