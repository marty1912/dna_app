package locale;

import Assertion.*;
import osspec.OsSpecific;

/**
 * class LocaleManager
 * this class is used to create a singleton of type OsSpecific.
 * which in turn is used to implement code that is specific to certain targets.
 * This is done to encapsulate os specific code and hide all of the uglyness away in this package.
 *
 * The seperation into two classes was done because there are no virtual functions in Haxe.
 * if you know any more elegant way of solving this problem let me know.
 *
 * an example call for some_os_specific_function() would be:
 * LocaleManager.get_instance().some_os_specific_function()
 *
 */
class LocaleManager
{
	/**
	 * the singleton instance object
	 */
	public static var __instance:Locale = null;

	private static var locale = "de";

	// TODO: use this!!
	private static var localeList:Map<String, Locale> = ["de" => new LocaleDE(), "en" => new LocaleEN()];

	/**
	 * public static function get_instance()
	 * this function is used in order to get the singleton object that is responsible
	 * for handling os specific code.
	 *
	 * an example call for some_os_specific_function() would be:
	 * LocaleManager.get_instance()
	 *
	 * @return OsSpecific - The singleton where all of our os specific code lives.
	 */
	public static function getInstance():Locale
	{
		if (LocaleManager.__instance == null)
		{
			LocaleManager.__instance = localeList.get(locale);
		}

		if (LocaleManager.__instance == null)
		{
			assert(false);
		}

		return LocaleManager.__instance;
	}

	/**
	 * sets the next available locale as locale.
	 */
	public static function setNextLocale()
	{
		var index:Int = 0;
		for (key => val in localeList)
		{
			if (key == locale)
			{
				break;
			}
			index++;
		}
		index = Std.int((index + 1) % Lambda.count(localeList));
		var index_search = 0;
		for (key => val in localeList)
		{
			if (index_search == index)
			{
				setLocale(key);
				return;
			}
			index_search++;
		}
	}

	/**
	 * sets the previous locale as the new one.
	 */
	public static function setPreviousLocale()
	{
		var index:Int = 0;
		for (key => val in localeList)
		{
			if (key == locale)
			{
				break;
			}
			index++;
		}
		index = Std.int((index - 1) % Lambda.count(localeList));
		if (index < 0)
		{
			index += Lambda.count(localeList);
		}
		var index_search = 0;
		for (key => val in localeList)
		{
			if (index_search == index)
			{
				setLocale(key);
				return;
			}
			index_search++;
		}
	}

	/**
	 * sets the locale to the specified value.
	 * @param value
	 */
	public static function setLocale(value:String)
	{
		locale = value;
		LocaleManager.__instance = localeList.get(locale);
	}

	/**
	 * we use a private ctor so nobody creates a new Instance of this class.
	 */
	private function new() {}
}
