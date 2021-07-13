package dnaobject.objects;

import constants.DnaConstants;
import dnaEvent.DnaEventManager;
import dnaEvent.DnaEventSubscriber;
import dnadata.DnaDataManager;
import dnadata.TaskTrials;
import dnadata.TrialBlock;
import dnaobject.components.ActionStateSwitchComponent;
import dnaobject.components.DragableComponent;
import dnaobject.components.SymbolSlotComponent;
import dnaobject.interfaces.ILevelPreview;
import dnaobject.interfaces.IUnlockableItem;
import dnaobject.interfaces.TaskObject;
import dnaobject.objects.DnaButtonObject.ButtonStateHidden;
import dnaobject.objects.DnaButtonObject.ButtonStateInactive;
import dnaobject.objects.DnaButtonObject.ButtonStateNormal;
import dnaobject.objects.DnaButtonObject.ButtonStatePressed;
import flixel.FlxG;
import flixel.addons.plugin.taskManager.FlxTask;
import flixel.math.FlxPoint;
import flixel.system.debug.Window;
import flixel.tweens.FlxEase.EaseFunction;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import haxe.Json;

/**
 * this is the class that handles giving our trial parameters to the correct objects.
 */
class PatternUnitOfRepeatTutorial implements DnaObject implements DnaEventSubscriber extends DnaObjectBase
{
	/**
	 * overwritten ctor.
	 */
	public function new()
	{
		super("PatternUnitOfRepeatTutorial");
	}

	override public function onHaveParent() {}

	public function getNotified(event_name:String, ?params:Null<Any>) {}

	public function after_init()
	{
		moveToAndPressButton();
	}

	public function moveToAndPressButton()
	{
		// index 0 will be our correct choice
		finger_obj.sprite.alpha = 1.0;
		finger_obj.removeChild(finger_obj.sprite);
		finger_obj.addChild(finger_obj.sprite);
		var button_obj:DnaButtonObject = pattern_disp_obj.choice_buttons_obj[0];

		var to_x = button_obj.button.getMidpoint().x;
		var to_y = button_obj.button.getMidpoint().y;

		FlxTween.tween(finger_obj, {pos_x: to_x, pos_y: to_y}, 2, {onComplete: pressButton, ease: FlxEase.cubeInOut});
	}

	public function pressButton(tween:FlxTween)
	{
		var click_scale = 0.95;
		var old_w = finger_obj.width;
		var old_h = finger_obj.height;
		finger_obj.width *= click_scale;
		finger_obj.height *= click_scale;

		var to_x = FlxG.stage.stageWidth * 2;
		var to_y = FlxG.stage.stageHeight * 2;

		var start_delay = 0;
		FlxTween.tween(finger_obj, {width: old_w, height: old_h}, 0.5, {startDelay: 0, ease: FlxEase.cubeInOut});
		FlxTween.tween(finger_obj, {pos_x: to_x, pos_y: to_y}, 2, {startDelay: 0.5, onComplete: finishTutorial, ease: FlxEase.cubeInOut});
	}

	public function finishTutorial(tween:FlxTween)
	{
		action_fin_obj.startQueue();
	}

	override public function onReady()
	{
		action_init_obj = cast this.getParent().getObjectByName(getNestedObjectName(action_init));
		action_fin_obj = cast this.getParent().getObjectByName(getNestedObjectName(action_fin));
		pattern_disp_obj = cast this.getParent().getObjectByName((pattern_disp));

		finger_obj = cast this.getParent().getObjectByName(getNestedObjectName(finger));
		finger_obj.sprite.alpha = 0;
		pattern_disp_obj.setParams({
			pattern: [
				"assets/images/pattern_symbols/square.PNG",
				"assets/images/pattern_symbols/circle.PNG",
				"assets/images/pattern_symbols/square.PNG",
				"assets/images/pattern_symbols/circle.PNG",
				"assets/images/pattern_symbols/square.PNG",
				"assets/images/pattern_symbols/circle.PNG"
			],
			choices: [
				[
					"assets/images/pattern_symbols/square.PNG",
					"assets/images/pattern_symbols/circle.PNG"
				],
				[
					"assets/images/pattern_symbols/square.PNG",
					"assets/images/pattern_symbols/circle.PNG",
					"assets/images/pattern_symbols/square.PNG",
				],
				["assets/images/pattern_symbols/circle.PNG"]
			],
			solution: [
				"assets/images/pattern_symbols/square.PNG",
				"assets/images/pattern_symbols/circle.PNG",
			]
		});

		super.onReady();
		pattern_disp_obj.disabled = true;
		// pattern_disp_obj.pattern_choices_obj[0]
		// after_init();
		action_init_obj.startQueue(after_init);
	}

	public var action_fin:String;
	public var action_init:String;
	public var pattern_disp:String;
	public var finger:String;

	public var action_fin_obj:ActionHandlerObject;
	public var action_init_obj:ActionHandlerObject;
	public var pattern_disp_obj:PatternUnitOfRepeatObject;
	public var finger_obj:SpriteObject;
	public var rightmost:SpriteObject;
	public var initial_dragable_pos:FlxPoint;

	/**
	 * override so we can have parameters like random order and stuff.
	 * @param jsonFile 
	 */
	override public function fromFile(jsonFile:Dynamic)
	{
		super.fromFile(jsonFile);

		if (Reflect.hasField(jsonFile, "action_init"))
		{
			action_init = jsonFile.action_init;
		}
		if (Reflect.hasField(jsonFile, "action_fin"))
		{
			action_fin = jsonFile.action_fin;
		}
		if (Reflect.hasField(jsonFile, "pattern_disp"))
		{
			pattern_disp = jsonFile.pattern_disp;
		}
		if (Reflect.hasField(jsonFile, "finger"))
		{
			finger = jsonFile.finger;
		}
	}

	public override function update(elapsed:Float) {}
}
