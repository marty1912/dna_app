package osspec;

import flixel.math.FlxPoint;

/**
 *
 * interface OsSpecific
 * this interface is used to define all functions we need
 * that are specific per os. so that are different on different systems that we want to work with
 */
interface OsSpecific
{
	/**
	 * this returns the server URL. this will differ for example from web to others.
	 * @return String
	 */
	public function getServerUrl():String;

	/**
	 * public function toLandscapeMode()
	 * this function sets the screen orientation to landscape.
	 */
	public function toLandscapeMode():Void;

	/**
	 * public function getInputPosition() -
	 * this function returns the current mouse or touch position for the specific target.
	 * @return FlxPoint - the position of the mouse or the touch or whatever we have
	 */
	public function getInputPosition():FlxPoint;

	/**
	 * toFullScreen() - activates fullscreen mode.
	 */
	public function toFullscreen():Void;

	/**
	 * saveToStorage - this function saves data to storage.
	 * @param data - the data to store
	 * @param filename - the filename to use
	 */
	public function saveToStorage(data:Dynamic, filename:String):Void;

	/**
	 * read from Storage - this function reads data from storage.
	 * @param filename - the filename where your data is stored.
	 * @return Dynamic - returns the data stored at the specified location.
	 */
	public function readFromStorage(filename:String):Dynamic;
}
