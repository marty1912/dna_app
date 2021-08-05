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
import dnaobject.objects.CorsiMachineDome.CorsiDomeRotateLeft;
import dnaobject.objects.DnaButtonObject.ButtonStateHidden;
import dnaobject.objects.DnaButtonObject.ButtonStateInactive;
import dnaobject.objects.DnaButtonObject.ButtonStateNormal;
import dnaobject.objects.DnaButtonObject.ButtonStatePressed;
import dnaobject.objects.FlankerMachine.FlankerMachineFixation;
import dnaobject.objects.FlankerMachine.FlankerMachinePresent;
import dnaobject.objects.flanker_task_states.real_task.FlankerInactiveState;
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
class FlankerTutorial implements DnaObject implements DnaEventSubscriber extends DnaObjectBase
{
	/**
	 * overwritten ctor.
	 */
	public function new()
	{
		super("FlankerTutorial");
	}

	override public function onHaveParent() {}

	public function getNotified(event_name:String, ?params:Null<Any>) {}

	public function after_init()
	{
		trace("init done.");
		finger_obj.sprite.alpha = 1;
		finger_obj.removeChild(finger_obj.sprite);
		finger_obj.addChild(finger_obj.sprite);
		var timer_fix = new FlxTimer();
		timer_fix.start(0.5, function(timer:FlxTimer)
		{
			flanker_obj.flanker_obj.state_machine.setNextState(new FlankerMachineFixation());
		});
		action_fixation_obj.startQueue(present);

		// FlxTween.tween(finger_obj, {pos_x: to_x, pos_y: to_y}, 2, {onComplete: dragToSlot, ease: FlxEase.cubeInOut});
	}

	public function present()
	{
		flanker_obj.flanker_obj.state_machine.setNextState(new FlankerMachinePresent());
		action_present_obj.startQueue(moveToSide);
	}

	public function moveToSide()
	{
		// move to the left side
		var to_x = FlxG.stage.stageWidth / 4;
		var to_y = FlxG.stage.stageHeight / 2;

		FlxTween.tween(finger_obj, {pos_x: to_x, pos_y: to_y}, 2, {
			startDelay: 0,
			onComplete: function(tween:FlxTween)
			{
				pressSide();
			},
			ease: FlxEase.cubeInOut
		});
	}

	public function pressSide()
	{
		var click_scale = 0.95;
		var old_width = finger_obj.width;
		var old_height = finger_obj.height;

		finger_obj.width *= click_scale;
		finger_obj.height *= click_scale;
		var press_time = 0.5;

		var to_x = FlxG.stage.stageWidth * 2;
		var to_y = FlxG.stage.stageHeight * 2;
		var button = flanker_obj.btn_left_obj;

		button.setNextState(new ButtonStatePressed());

		flanker_obj.flanker_obj.dome_obj.state_machine.setNextState(new CorsiDomeRotateLeft());

		var timer_fix = new FlxTimer();
		timer_fix.start(press_time, function(timer:FlxTimer)
		{
			button.setNextState(new ButtonStateInactive());

			finger_obj.width = old_width;
			finger_obj.height = old_height;
		});

		FlxTween.tween(finger_obj, {pos_x: to_x, pos_y: to_y}, 2, {startDelay: press_time, onComplete: finishTutorial, ease: FlxEase.cubeInOut});
	}

	public function finishTutorial(tween:FlxTween)
	{
		action_fin_obj.startQueue();
	}

	override public function onReady()
	{
		super.onReady();
		action_init_obj = cast this.getParent().getObjectByName(getNestedObjectName(action_init));
		action_fin_obj = cast this.getParent().getObjectByName(getNestedObjectName(action_fin));
		action_fixation_obj = cast this.getParent().getObjectByName(getNestedObjectName(action_fixation));
		action_present_obj = cast this.getParent().getObjectByName(getNestedObjectName(action_present));

		flanker_obj = cast this.getParent().getObjectByName((flanker));

		finger_obj = cast this.getParent().getObjectByName(getNestedObjectName(finger));
		finger_obj.sprite.alpha = 0;
		flanker_obj.setParams({
			pattern: [
				"assets/images/flanker_machine/arrow_right.png",
				"assets/images/flanker_machine/arrow_right.png",
				"assets/images/flanker_machine/arrow_left.png",
				"assets/images/flanker_machine/arrow_right.png",
				"assets/images/flanker_machine/arrow_right.png",

			],
			solution: "LEFT"
		});

		flanker_obj.state_machine.setNextState(new FlankerInactiveState());

		action_init_obj.startQueue(after_init);
	}

	public var action_fin:String;
	public var action_init:String;

	public var action_fixation:String;
	public var action_present:String;

	public var flanker:String;
	public var finger:String;

	public var action_fin_obj:ActionHandlerObject;
	public var action_init_obj:ActionHandlerObject;

	public var action_fixation_obj:ActionHandlerObject;
	public var action_present_obj:ActionHandlerObject;
	public var flanker_obj:FlankerTaskObject;
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
		if (Reflect.hasField(jsonFile, "action_fixation"))
		{
			action_fixation = jsonFile.action_fixation;
		}
		if (Reflect.hasField(jsonFile, "action_present"))
		{
			action_present = jsonFile.action_present;
		}
		if (Reflect.hasField(jsonFile, "action_fin"))
		{
			action_fin = jsonFile.action_fin;
		}
		if (Reflect.hasField(jsonFile, "flanker"))
		{
			flanker = jsonFile.flanker;
		}
		if (Reflect.hasField(jsonFile, "finger"))
		{
			finger = jsonFile.finger;
		}
	}

	public override function update(elapsed:Float) {}
}
