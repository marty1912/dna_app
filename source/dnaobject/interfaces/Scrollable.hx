package dnaobject.interfaces;

import flixel.addons.display.FlxBackdrop;

/**
 * interface Scrollable - this interface is used to define what we need to
 * be able to scroll stuff indefinetely.
 */
interface Scrollable
{
	/**
	 * this is the backdrop object we want to scroll infinitely
	 */
	public var backdrop:FlxBackdrop;
}
