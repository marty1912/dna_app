package dnaobject.objects;

import Assertion.assert;
import constants.DnaConstants;
import dnaEvent.DnaEventManager;
import dnaEvent.DnaEventSubscriber;
import dnadata.TaskTrials;
import dnaobject.DnaObject;
import dnaobject.interfaces.ITextBox;
import dnaobject.interfaces.Slideable;
import dnaobject.interfaces.TaskObject;
import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import haxe.DynamicAccess;
import haxe.Timer;

/**
 * class TimerObject
 * this class represents our ArithmeticTaskHandler.
 * it is used to set and get parameters of the objects used in the arithmetic task
 *
 */
class TimerObject implements DnaObject implements TaskObject extends DnaObjectBase
{
	public var time_update_loop:Float = 0;
	public var time_update_loop_stopped:Float = 0;
	public var timestamp_start:Float = 0;
	public var timestamp_end:Float = 0;

	@:isVar
	private var time_stopped(get, set):Bool = false;

	private function get_time_stopped():Bool
	{
		return time_stopped;
	}

	private function set_time_stopped(value:Bool):Bool
	{
		time_stopped = value;
		return value;
	}

	/**
		* isCorrect()
		* @return Bool
				throw "not implemented for timers"
	 */
	public function isCorrect():String
		throw "not implemented for timers";

	/**
	 * getData - this function collects the data we want to have from the ArithmeticTaskHandler object.
	 * @return Dynamic - the
	 */
	public function getData():Dynamic
	{
		var t_update_loop:Float;
		var t_timer:Float;
		if (time_stopped)
		{
			t_timer = timestamp_end - timestamp_start;
			t_update_loop = time_update_loop_stopped;
		}
		else
		{
			timestamp_end = Timer.stamp();

			t_timer = timestamp_end - timestamp_start;
			t_update_loop = time_update_loop;
		}
		var current_trial:Dynamic = {
			time_update_loop: t_update_loop,
			time_timer: t_timer
		};

		return current_trial;
	}

	public var solution:Float;

	/**
	 * setParams - this lets us set the parameters for the stimulus
	 * @param params - a dynamic object with fields: zero, ref, max and target
	 */
	public function setParams(params:Dynamic):Void
	{
		resetTime();
	}

	/**
	 * ctor - in here we set the members like our type, position etc.
	 */
	public function new()
	{
		super('TimerObject');
	}

	public function resetTime()
	{
		time_update_loop = 0;
		timestamp_start = Timer.stamp();
		time_stopped = false;
	}

	public function stopTime()
	{
		time_update_loop_stopped = time_update_loop;
		timestamp_end = Timer.stamp();
		time_stopped = true;
	}

	/**
		* fromFile()
		*
		* @param jsonFile - Dynamic Object with params.

		*
	 */
	override public function fromFile(jsonFile:Dynamic):Void
	{
		super.fromFile(jsonFile);
		return;
	}

	/**
	 * in here we measure the time for the update timer
	 * @param elapsed
	 */
	override public function update(elapsed):Void
	{
		super.update(elapsed);
		time_update_loop += elapsed;
	}
}
