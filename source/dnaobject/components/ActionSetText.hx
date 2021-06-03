package dnaobject.components;

import dnaEvent.DnaEventManager;
import dnaEvent.DnaEventSubscriber;
import dnadata.DnaDataManager;
import dnaobject.interfaces.ITextBox;
import dnaobject.interfaces.TaskObject;
import dnaobject.objects.TextObject;
import flixel.system.FlxAssets;
import flixel.util.FlxColor;
import locale.LocaleManager;
import osspec.OsManager;
import textbox.Settings;
import textbox.Textbox.Status;

/**
 * with this action we can set the parameters of the task objects in the state.
 */
class ActionSetText implements DnaComponent extends DnaActionBase
{
	/**
	 * ctor
	 */
	public function new()
	{
		super("ActionSetText");
	}

	public var m_text:String;
	public var use_literal_text:Bool;

	/**
	 * in here we read our params from a file..
	 * @param jsonFile - the jsonFile object to read from. should be the output of jsonParse.
	 */
	override public function fromFile(jsonFile:Dynamic):Void
	{
		if (Reflect.hasField(jsonFile, "text"))
		{
			m_text = jsonFile.text;
		}
		if (Reflect.hasField(jsonFile, "use_literal_text"))
		{
			use_literal_text = jsonFile.use_literal_text;
		}
		super.fromFile(jsonFile);
	}

	/**
	 * here we set the text and then finish the action
	 */
	override public function onHaveParent()
	{
		var target_text:ITextBox = cast getParent().getParent().getObjectByName(this.m_target_name);
		target_text.setText(m_text, use_literal_text);
		this.finishAction();
	}

	/**
	 * in this function we will make the object appear..
	 * @param elapsed
	 */
	override public function update(elapsed:Float) {}
}
