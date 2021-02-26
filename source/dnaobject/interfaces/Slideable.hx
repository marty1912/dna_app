package dnaobject.interfaces;

import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;

/**
 * interface for slideable objects.
 * objects that use a slider
 */
interface Slideable
{
	/**
	 * the clickarea in which we want to register clicks.
	 */
	public var axis:FlxSprite;

	/**
	 * the sprite that we want to make appear at the location.
	 */
	public var slider:FlxSprite;

	/**
	 * this function returns the position for a given point on the numberline
	 * @param value - this is the value on the numberline. so it might for example be
	 *  that we want to know where the value of 1 is located on this numline..
	 * @return FlxPoint - the point in the middle of the axis and at the position of the value.
	 */
	public function getPosFromValue(value:Float):FlxPoint;

	public function getNumMax():Float;
	public function getNumZero():Float;
	public function getNumTarget():Float;
	public function getSliderNum():Float;
	public function setSliderNum(value:Float):Void;
}
