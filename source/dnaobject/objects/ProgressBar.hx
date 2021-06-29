package dnaobject.objects;

import dnaEvent.DnaEventManager;
import dnaEvent.DnaEventSubscriber;
import dnadata.DnaDataManager;
import dnadata.TaskTrials;
import dnadata.TrialBlock;
import dnaobject.components.ActionStateSwitchComponent;
import dnaobject.interfaces.ILevelPreview;
import dnaobject.interfaces.IUnlockableItem;
import dnaobject.interfaces.TaskObject;
import flixel.addons.plugin.taskManager.FlxTask;
import flixel.tweens.FlxTween;
import haxe.Json;

/**
 * this is the class that handles giving our trial parameters to the correct objects.
 */
class ProgressBar implements DnaObject implements DnaEventSubscriber extends DnaObjectBase
{
	/**
	 * overwritten ctor.
	 */
	public function new()
	{
		super("ProgressBar");
	}

	/**
	 * this is the function that gets called everytime an event we subscribed for is fired
	 * @param event_name
	 */
	public function getNotified(event_name:String, params:Any = null) {}

	override public function onHaveParent() {}

	override public function onReady()
	{
		// setup our button
		this.filled_bar_obj = cast this.getParent().getObjectByName(getNestedObjectName(filled_bar));
		this.filled_bar_obj.width = 0;
		this.background_bar_obj = cast this.getParent().getObjectByName(getNestedObjectName(background_bar));

		this.set_progress(TaskTrials.instance.getProgress());
		updateProgressBar(false);
	}

	public var filled_bar:String;
	public var background_bar:String;

	public var filled_bar_obj:SpriteObject;
	public var background_bar_obj:NineSliceSprite;
	public var tween:FlxTween;

	public var progress(default, set):Float = 0.0;

	/**
	 * setter for progress property
	 * @param value 
	 * @return Float
	 */
	public function set_progress(value:Float):Float
	{
		this.progress = value;
		// TODO: use a FlxTween for cool effects.
		return this.progress;
	}

	/**
	 * Updates the visual representation of the progress. either with an animation or imediately
	 * @param animated 
	 */
	public function updateProgressBar(animated:Bool = true)
	{
		var new_width = Std.int((this.background_bar_obj.width) * progress);
		if (!animated)
		{
			filled_bar_obj.width = new_width;
			return;
		}
		tween = FlxTween.tween(filled_bar_obj, {width: new_width}, 3);
	}

	/**
	 * override so we can have parameters like random order and stuff.
	 * @param jsonFile 
	 */
	override public function fromFile(jsonFile:Dynamic)
	{
		super.fromFile(jsonFile);

		if (Reflect.hasField(jsonFile, "background_bar"))
		{
			this.background_bar = cast jsonFile.background_bar;
		}
		if (Reflect.hasField(jsonFile, "filled_bar"))
		{
			this.filled_bar = jsonFile.filled_bar;
		}
	}

	var total_time:Float = 0;

	public override function update(elapsed:Float) {}
}
