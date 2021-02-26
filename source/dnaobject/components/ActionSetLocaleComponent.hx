package dnaobject.components;

import dnaEvent.DnaEventManager;
import dnaEvent.DnaEventSubscriber;
import locale.LocaleManager;

/**
 * this class will be used to set the slider position on slideable objects.
 */
class ActionSetLocaleComponent implements DnaComponent extends DnaActionBase
{
	public final LOCALE_INC:String = "INC";
	public final LOCALE_DEC:String = "DEC";

	/**
	 * ctor
	 */
	public function new()
	{
		super("ActionSetLocaleComponent");
	}

	public var locale:String = "";

	/**
	 * in here we read our params from a file..
	 * @param jsonFile - the jsonFile object to read from. should be the output of jsonParse.
	 */
	override public function fromFile(jsonFile:Dynamic):Void
	{
		if (Reflect.hasField(jsonFile, "locale"))
		{
			locale = jsonFile.locale;
		}
		super.fromFile(jsonFile);
	}

	/**
	 * in here we will set the slider position and make it visible (if not the case)
	 */
	override public function update(elapsed:Float)
	{
		if (locale == LOCALE_INC)
		{
			LocaleManager.setNextLocale();
		}
		else if (locale == LOCALE_DEC)
		{
			LocaleManager.setPreviousLocale();
		}
		else
		{
			LocaleManager.setLocale(locale);
		}
		this.finishAction();
	}
}
