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
class PatternGeneralizeTutorial implements DnaObject implements DnaEventSubscriber extends DnaObjectBase
{
	/**
	 * overwritten ctor.
	 */
	public function new()
	{
		super("PatternGeneralizeTutorial");
	}

	override public function onHaveParent() {}

	public function getNotified(event_name:String, ?params:Null<Any>) {}

	public function after_init()
	{
		dragIntoSlot(1, 0, dragIntoSlot.bind(3, 1, dragIntoSlot.bind(1, 2, dragIntoSlot.bind(3, 3, dragIntoSlot.bind(1, 4, moveToAndPressButton)))));
	}

	public function moveToAndPressButton()
	{
		var button_obj:DnaButtonObject = pattern_disp_obj.button_obj;

		var to_x = button_obj.button.getMidpoint().x;
		var to_y = button_obj.button.getMidpoint().y;

		FlxTween.tween(finger_obj, {pos_x: to_x, pos_y: to_y}, 2, {onComplete: pressButton, ease: FlxEase.cubeInOut});
	}

	/**
	 * this is a function to drag an item to a slot.
	 * @param to_drag 
	 * @param drag_to 
	 */
	public function dragIntoSlot(to_drag:Int, drag_to:Int, onDoneCallback:Void->Void)
	{
		symbol_to_drag = pattern_disp_obj.dragables_obj[to_drag].symbol_obj;

		finger_obj.sprite.alpha = 1;
		finger_obj.removeChild(finger_obj.sprite);
		finger_obj.addChild(finger_obj.sprite);

		// obj 2 will be our circle that we need.
		var to_x = symbol_to_drag.sprite.getMidpoint().x;
		var to_y = symbol_to_drag.sprite.getMidpoint().y;
		FlxTween.tween(finger_obj, {pos_x: to_x, pos_y: to_y}, 2, {onComplete: dragToSlot.bind(drag_to, onDoneCallback), ease: FlxEase.cubeInOut});
	}

	public function dragToSlot(slot_pos:Int, onDoneCallback:Void->Void, tween:FlxTween)
	{
		var start_delay = 0;
		var movement_time = 1.5;
		var drag:DragableComponent = cast symbol_to_drag.getComponentByType("DragableComponent");
		// drag.setNextState(new DragStatePressed());
		rightmost = pattern_disp_obj.pattern_input_obj.symbols[slot_pos];
		rightmost.setOrigin(rightmost.pos_x + (rightmost.width / 2), rightmost.pos_y + (rightmost.height / 2));

		var to_x = rightmost.pos_x;
		var to_y = rightmost.pos_y;
		symbol_to_drag.setOrigin(symbol_to_drag.sprite.getMidpoint().x, symbol_to_drag.sprite.getMidpoint().y);
		initial_dragable_pos = FlxPoint.get(symbol_to_drag.getOrigin().x, symbol_to_drag.getOrigin().y);
		DragableComponent.currently_dragged_sprite = symbol_to_drag;

		FlxTween.tween(finger_obj, {pos_x: to_x, pos_y: to_y}, movement_time, {startDelay: start_delay, ease: FlxEase.cubeInOut});
		FlxTween.tween(symbol_to_drag, {pos_x: to_x, pos_y: to_y}, movement_time,
			{startDelay: start_delay, onComplete: releaseDrag.bind(onDoneCallback), ease: FlxEase.cubeInOut});
	}

	public function releaseDrag(onDoneCallback:Void->Void, tween:FlxTween)
	{
		var slot:SymbolSlotComponent = cast rightmost.getComponentByType("SymbolSlotComponent");
		slot.setNextState(new SymbolStateFilled(symbol_to_drag.getAssetPath()));
		symbol_to_drag.moveTo(initial_dragable_pos.x, initial_dragable_pos.y);
		initial_dragable_pos.put();

		onDoneCallback();
		return;
	}

	public function pressButton(tween:FlxTween)
	{
		var click_scale = 0.95;
		finger_obj.width *= click_scale;
		finger_obj.height *= click_scale;
		pattern_disp_obj.button_obj.setNextState(new ButtonStatePressed());

		var to_x = FlxG.stage.stageWidth * 2;
		var to_y = FlxG.stage.stageHeight * 2;

		var start_delay = 0;
		FlxTween.tween(finger_obj, {pos_x: to_x, pos_y: to_y}, 2, {startDelay: start_delay, onComplete: finishTutorial, ease: FlxEase.cubeInOut});
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
		pattern_disp_obj.button_obj.removeComponentByType("UserButtonComponent");

		finger_obj = cast this.getParent().getObjectByName(getNestedObjectName(finger));
		finger_obj.sprite.alpha = 0;
		pattern_disp_obj.setParams({
			pattern: [
				"assets/images/pattern_symbols/circle.PNG",
				"assets/images/pattern_symbols/rhombus.PNG",
				"assets/images/pattern_symbols/circle.PNG",
				"assets/images/pattern_symbols/rhombus.PNG",
				"assets/images/pattern_symbols/circle.PNG",
			],
			input: ["", "", "", "", ""],
			choices: [
				"assets/images/pattern_symbols/robotface.PNG",
				"assets/images/pattern_symbols/ArrowLeft.PNG",
				"assets/images/pattern_symbols/ArrowOverlay.PNG",
				"assets/images/pattern_symbols/ArrowRight.PNG"
			],
			solution: [
				"assets/images/pattern_symbols/circle.PNG",
				"assets/images/pattern_symbols/rhombus.PNG",
				"assets/images/pattern_symbols/circle.PNG",
				"assets/images/pattern_symbols/rhombus.PNG",
				""
			]
		});

		symbol_to_drag = pattern_disp_obj.dragables_obj[2].symbol_obj;
		super.onReady();
		pattern_disp_obj.disabled = true;
		action_init_obj.startQueue(after_init);
	}

	public var action_fin:String;
	public var action_init:String;
	public var pattern_disp:String;
	public var finger:String;

	public var action_fin_obj:ActionHandlerObject;
	public var action_init_obj:ActionHandlerObject;
	public var pattern_disp_obj:PatternGeneralizeObject;
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
