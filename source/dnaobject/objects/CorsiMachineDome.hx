package dnaobject.objects;

import dnaEvent.DnaEventManager;
import dnaEvent.DnaEventSubscriber;
import dnadata.DnaDataManager;
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
class CorsiMachineDome implements DnaObject implements DnaEventSubscriber extends DnaObjectBase
{
	/**
	 * overwritten ctor.
	 */
	public function new()
	{
		super("CorsiMachineDome");
	}

	/**
	 * this is the function that gets called everytime an event we subscribed for is fired
	 * @param event_name
	 */
	public function getNotified(event_name:String, params:Any = null) {}

	override public function onHaveParent() {}

	override public function onReady()
	{
		helix_obj = cast this.getParent().getObjectByName(getNestedObjectName(helix));
		back_obj = cast this.getParent().getObjectByName(getNestedObjectName(back));
		back_obj.sprite.animation.add("green", [0]);
		back_obj.sprite.animation.add("red", [1]);
		back_obj.sprite.animation.add("yellow", [2]);
		back_obj.sprite.animation.play("red");

		helix_obj.sprite.animation.add("rotate", [
			1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23
		], 25);
		helix_obj.sprite.animation.play("rotate");

		var tween = FlxTween.angle(helix_obj.sprite, 0, 360, 20, {type: LOOPING});
	}

	public var helix:String;
	public var base:String;
	public var front:String;
	public var back:String;

	public var helix_obj:SpriteObject;
	public var back_obj:SpriteObject;

	/**
	 * override so we can have parameters like random order and stuff.
	 * @param jsonFile 
	 */
	override public function fromFile(jsonFile:Dynamic)
	{
		super.fromFile(jsonFile);

		if (Reflect.hasField(jsonFile, "helix"))
		{
			this.helix = cast jsonFile.helix;
		}
		if (Reflect.hasField(jsonFile, "back"))
		{
			this.back = cast jsonFile.back;
		}

		if (Reflect.hasField(jsonFile, "base"))
		{
			this.base = cast jsonFile.base;
		}
		if (Reflect.hasField(jsonFile, "front"))
		{
			this.front = cast jsonFile.front;
		}
	}

	var total_time:Float = 0;
	var first = true;

	public override function update(elapsed:Float) {}
}
