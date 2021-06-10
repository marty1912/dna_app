package dnaobject.interfaces;

import flixel.math.FlxPoint;

/**
 * interface Scrollable - this interface is used to define what we need to
 * be able to scroll stuff indefinetely.
 */
interface Scrollable
{
	public function setPosition(value:FlxPoint):Void;
	public function getPosition():FlxPoint;
}
