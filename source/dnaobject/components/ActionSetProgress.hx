package dnaobject.components;

import dnadata.TaskTrials;
import dnaobject.objects.ProgressBar;

/**
 * this class will make a Delay used mostly for sequential actions.
 */
class ActionSetProgress implements DnaComponent extends DnaActionBase
{
	/**
	 * ctor
	 */
	public function new()
	{
		super("ActionSetProgress");
	}

	public var update_event_name:String;

	/**
	 * in here we read our params from a file..
	 * @param jsonFile - the jsonFile object to read from. should be the output of jsonParse.
	 */
	override public function fromFile(jsonFile:Dynamic):Void
	{
		if (Reflect.hasField(jsonFile, "delay")) {}
		if (Reflect.hasField(jsonFile, "update_event_name")) {}

		super.fromFile(jsonFile);
	}

	override public function onHaveParent()
	{
		var progress_bar:ProgressBar = cast this.getParent().getParent().getObjectByName(this.m_target_name);
		var progress_plus_one = 1 - ((TaskTrials.instance.getTrialBlocksTodo().length - 1) / TaskTrials.instance.getTrialBlocks().length);
		if (progress_plus_one > 1)
		{
			progress_plus_one = 1;
		}
		progress_bar.progress = progress_plus_one;
		progress_bar.updateProgressBar(true);
		this.finishAction();
	}

	/**
	 * in this function we will make the object Delay..
	 * @param elapsed
	 */
	override public function update(elapsed:Float) {}
}
