package dnaobject.components;

import dnaEvent.DnaEventManager;
import dnaEvent.DnaEventSubscriber;
import dnadata.DnaDataManager;
import dnaobject.interfaces.ITextBox;
import dnaobject.interfaces.TaskObject;
import dnaobject.objects.TextObject;
import flixel.system.FlxAssets;
import flixel.util.FlxColor;
import textbox.Settings;
import textbox.Textbox.Status;

/**
 * with this action we can set the parameters of the task objects in the state.
 */
class ActionSetTaskParamsComponent implements DnaComponent extends DnaActionBase
{
	/**
	 * ctor
	 */
	public function new()
	{
		super("ActionSetTaskParamsComponent");
	}

	public var m_params:Array<Dynamic>;

	/**
	 * in here we read our params from a file..
	 * @param jsonFile - the jsonFile object to read from. should be the output of jsonParse.
	 */
	override public function fromFile(jsonFile:Dynamic):Void
	{
		if (Reflect.hasField(jsonFile, "params"))
		{
			m_params = jsonFile.params;
		}
		super.fromFile(jsonFile);
	}

	public var first:Bool = true;

	/**
	 * this starts our textbox.
	 */
	public function setParams()
	{
		for (params in m_params)
		{
			var task_object:TaskObject = cast(getParent().getParent().getObjectByName(params.name));
			if (task_object == null)
			{
				trace("object not found! name:", params.name);
				return;
			}
			task_object.setParams(params.params);
		}
	}

	/**
	 * in this function we will make the object appear..
	 * @param elapsed
	 */
	override public function update(elapsed:Float)
	{
		setParams();
		finishAction();
	}
}
