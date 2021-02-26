package osspec;

import Assertion.*;
import osspec.OsSpecific;

/**
 * class OsManager
 * this class is used to create a singleton of type OsSpecific.
 * which in turn is used to implement code that is specific to certain targets.
 * This is done to encapsulate os specific code and hide all of the uglyness away in this package.
 *
 * The seperation into two classes was done because there are no virtual functions in Haxe.
 * if you know any more elegant way of solving this problem let me know.
 *
 * an example call for some_os_specific_function() would be:
 * OsManager.get_instance().some_os_specific_function()
 *
 */
class OsManager
{
	/**
	 * the singleton instance object
	 */
	public static var __instance:OsSpecific = null;

	/**
	 * public static function get_instance()
	 * this function is used in order to get the singleton object that is responsible
	 * for handling os specific code.
	 *
	 * an example call for some_os_specific_function() would be:
	 * OsManager.get_instance().some_os_specific_function()
	 *
	 * @return OsSpecific - The singleton where all of our os specific code lives.
	 */
	public static function get_instance():OsSpecific
	{
		if (OsManager.__instance == null)
		{
			#if android
			OsManager.__instance = new AndroidSpecific();
			#end

			#if desktop
			OsManager.__instance = new DesktopSpecific();
			#end

			#if web
			OsManager.__instance = new WebSpecific();
			#end
		}

		if (OsManager.__instance == null)
		{
			// "ERROR: (OsManager) OS type is not supported!!"
			assert(false);
		}

		return OsManager.__instance;
	}

	/**
	 * we use a private ctor so nobody creates a new Instance of this class.
	 */
	private function new() {}
}
