package dnaobject.components;

import Assertion.assert;
import dnaEvent.DnaEventManager;
import dnadata.DnaDataManager;
import dnaobject.DnaComponent;
import dnaobject.DnaComponentBase;
import dnaobject.interfaces.Slideable;
import dnaobject.objects.NumberlineObject;
import flixel.FlxG;
import flixel.math.FlxMath;
import flixel.math.FlxRect;
import flixel.ui.FlxButton;
import flixel.util.FlxDestroyUtil;
import osspec.OsManager;

/**
 * class PositionComponent.
 * this component keeps its parent in the center of the screen.
 */
class ActionSetAudioVolumeComponent implements DnaComponent extends DnaActionBase
{
	/**
	 * ctor
	 */
	public function new()
	{
		super('ActionSetAudioVolumeComponent');
	}

	/**
	 * dtor.
	 */
	override public function destroy()
	{
		super.destroy();
	}

	public var audio_type:String = "audio_volume_master";

	public var value:Float = 0;

	/**
	 * fromFile function. reads from Dynamic field.
	 * @param jsonFile
	 */
	override public function fromFile(jsonFile:Dynamic)
	{
		if (Reflect.hasField(jsonFile, "audio_type"))
		{
			this.audio_type = jsonFile.audio_type;
		}
		if (Reflect.hasField(jsonFile, "value"))
		{
			this.value = jsonFile.value;
		}
		super.fromFile(jsonFile);
	}

	/**
	 * update. we just do our thing and finish..
	 * @param elapsed
	 */
	override public function update(elapsed:Float)
	{
		FlxG.sound.volume += value;
		trace("new volume:", FlxG.sound.volume);
		finishAction();
	}
}
