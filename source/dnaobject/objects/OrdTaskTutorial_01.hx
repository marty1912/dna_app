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
import dnaobject.objects.DotsDisplay;
import dnaobject.objects.OrdinalTaskObject.OrdinalObjectStateFixation;
import dnaobject.objects.OrdinalTaskObject.OrdinalObjectStateHidden;
import dnaobject.objects.OrdinalTaskObject.OrdinalObjectStateInactive;
import dnaobject.objects.OrdinalTaskObject.OrdinalObjectStateVisible;
import flixel.FlxG;
import flixel.addons.plugin.taskManager.FlxTask;
import flixel.math.FlxPoint;
import flixel.system.debug.Window;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import haxe.Json;

/**
 * this is the class that handles giving our trial parameters to the correct objects.
 */
class OrdTaskTutorial_01 implements DnaObject implements DnaEventSubscriber extends DnaObjectBase
{
	/**
	 * overwritten ctor.
	 */
	public function new()
	{
		super("OrdTaskTutorial_01");
	}

	override public function onHaveParent() {}

	public function getNotified(event_name:String, ?params:Null<Any>) {}

	public function after_init()
	{
		trace("init done.");
		finger_obj.sprite.alpha = 1;
		finger_obj.removeChild(finger_obj.sprite);
		finger_obj.addChild(finger_obj.sprite);
		// ord_task_obj.state_machine.setNextState(new OrdinalObjectStateHidden());
		var timer_fix = new FlxTimer();
		/*
			timer_fix.start(1, function(timer:FlxTimer)
			{
				ord_task_obj.state_machine.setNextState(new OrdinalObjectStateFixation());
				var timer_show = new FlxTimer();
				timer_show.start(0.5, function(timer:FlxTimer)
				{
					ord_task_obj.state_machine.setNextState(new OrdinalObjectStateVisible());
				});
			});
		 */

		var to_x = my_button.button.getMidpoint().x;
		var to_y = my_button.button.getMidpoint().y;
		FlxTween.tween(finger_obj, {pos_x: to_x, pos_y: to_y}, 2, {startDelay: 2, onComplete: pressButton, ease: FlxEase.cubeInOut});
	}

	public function pressButton(tween:FlxTween)
	{
		var click_scale = 0.95;
		finger_obj.width *= click_scale;
		finger_obj.height *= click_scale;

		var to_x = FlxG.stage.stageWidth * 2;
		var to_y = FlxG.stage.stageHeight * 2;

		my_button.setNextState(new ButtonStatePressed());

		ord_task_obj.state_machine.setNextState(new OrdinalObjectStateInactive());

		var start_delay = 0;
		FlxTween.tween(finger_obj, {pos_x: to_x, pos_y: to_y}, 2, {startDelay: start_delay, onComplete: finishTutorial, ease: FlxEase.cubeInOut});
	}

	public function finishTutorial(tween:FlxTween)
	{
		action_fin_obj.startQueue();
	}

	public var my_button:DnaButtonObject;

	override public function onReady()
	{
		super.onReady();

		action_init_obj = cast this.getParent().getObjectByName(getNestedObjectName(action_init));
		action_fin_obj = cast this.getParent().getObjectByName(getNestedObjectName(action_fin));
		ord_task_obj = cast this.getParent().getObjectByName((ord_task));

		finger_obj = cast this.getParent().getObjectByName(getNestedObjectName(finger));
		finger_obj.sprite.alpha = 0;
		ord_task_obj.setParams({
			pattern: [
				"assets/images/pattern_numbers/1.PNG",
				"assets/images/pattern_numbers/3.PNG",
				"assets/images/pattern_numbers/5.PNG"
			],
			solution: "IN_ORDER",
		});

		ord_task_obj.button_left_obj.removeComponentByType("UserButtonComponent");
		ord_task_obj.button_right_obj.removeComponentByType("UserButtonComponent");
		ord_task_obj.state_machine.setNextState(new OrdinalObjectStateVisible());

		if (DnaDataManager.instance.retrieveData(DnaDataManager.ORD_TASK_COND))
		{
			my_button = ord_task_obj.button_right_obj;
		}
		else
		{
			my_button = ord_task_obj.button_left_obj;
		}

		// after_init();
		action_init_obj.startQueue(after_init);
	}

	public var action_fin:String;
	public var action_init:String;
	public var ord_task:String;
	public var finger:String;

	public var action_fin_obj:ActionHandlerObject;
	public var action_init_obj:ActionHandlerObject;
	public var ord_task_obj:OrdinalTaskObject;
	public var finger_obj:SpriteObject;
	public var symbol_to_drag:SpriteObject;
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
		if (Reflect.hasField(jsonFile, "ord_task"))
		{
			ord_task = jsonFile.ord_task;
		}
		if (Reflect.hasField(jsonFile, "finger"))
		{
			finger = jsonFile.finger;
		}
	}

	public override function update(elapsed:Float) {}
}
