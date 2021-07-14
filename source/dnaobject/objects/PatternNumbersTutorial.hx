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
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import haxe.Json;

/**
 * this is the class that handles giving our trial parameters to the correct objects.
 */
class PatternNumbersTutorial implements DnaObject implements DnaEventSubscriber extends DnaObjectBase
{
	/**
	 * overwritten ctor.
	 */
	public function new()
	{
		super("PatternNumbersTutorial");
	}

	override public function onHaveParent() {}

	public function getNotified(event_name:String, ?params:Null<Any>) {}

	public function after_init()
	{
		trace("init done.");
		finger_obj.sprite.alpha = 1;
		finger_obj.removeChild(finger_obj.sprite);
		finger_obj.addChild(finger_obj.sprite);

		// obj 2 will be our circle that we need.
		var to_x = symbol_to_drag.sprite.getMidpoint().x;
		var to_y = symbol_to_drag.sprite.getMidpoint().y;
		FlxTween.tween(finger_obj, {pos_x: to_x, pos_y: to_y}, 3, {onComplete: dragToSlot, ease: FlxEase.cubeInOut});
	}

	public function dragToSlot(tween:FlxTween)
	{
		var start_delay = 1.0;
		var drag:DragableComponent = cast symbol_to_drag.getComponentByType("DragableComponent");
		// drag.setNextState(new DragStatePressed());
		rightmost = pattern_disp_obj.pattern_display_obj.symbols[pattern_disp_obj.pattern_display_obj.symbols.length - 1];
		rightmost.setOrigin(rightmost.pos_x + (rightmost.width / 2), rightmost.pos_y + (rightmost.height / 2));

		var to_x = rightmost.pos_x;
		var to_y = rightmost.pos_y;
		FlxTween.tween(finger_obj, {pos_x: to_x, pos_y: to_y}, 3, {startDelay: start_delay, ease: FlxEase.cubeInOut});
		symbol_to_drag.setOrigin(symbol_to_drag.pos_x + (symbol_to_drag.width / 2), symbol_to_drag.pos_y + (symbol_to_drag.height / 2));
		initial_dragable_pos = FlxPoint.get(symbol_to_drag.getOrigin().x, symbol_to_drag.getOrigin().y);
		DragableComponent.currently_dragged_sprite = symbol_to_drag;
		FlxTween.tween(symbol_to_drag, {pos_x: to_x, pos_y: to_y}, 3, {startDelay: start_delay, onComplete: releaseDrag, ease: FlxEase.cubeInOut});
	}

	public function releaseDrag(tween:FlxTween)
	{
		var slot:SymbolSlotComponent = cast rightmost.getComponentByType("SymbolSlotComponent");
		slot.setNextState(new SymbolStateFilled(symbol_to_drag.getAssetPath()));
		symbol_to_drag.moveTo(initial_dragable_pos.x, initial_dragable_pos.y);
		initial_dragable_pos.put();

		var button_obj:DnaButtonObject = pattern_disp_obj.button_obj;

		var to_x = button_obj.button.getMidpoint().x;
		var to_y = button_obj.button.getMidpoint().y;

		FlxTween.tween(finger_obj, {pos_x: to_x, pos_y: to_y}, 2, {onComplete: pressButton, ease: FlxEase.cubeInOut});
	}

	public function pressButton(tween:FlxTween)
	{
		var click_scale = 0.95;
		finger_obj.width *= click_scale;
		finger_obj.height *= click_scale;
		pattern_disp_obj.button_obj.setNextState(new ButtonStatePressed());

		var to_x = FlxG.stage.stageWidth * 2;
		var to_y = FlxG.stage.stageHeight * 2;

		var start_delay = 1.0;
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
				"assets/images/pattern_numbers/1.PNG",
				"assets/images/pattern_numbers/2.PNG",
				"assets/images/pattern_numbers/3.PNG",
				"assets/images/pattern_numbers/4.PNG",
				""
			],
			solution: [
				"assets/images/pattern_numbers/1.PNG",
				"assets/images/pattern_numbers/2.PNG",
				"assets/images/pattern_numbers/3.PNG",
				"assets/images/pattern_numbers/4.PNG",
				"assets/images/pattern_numbers/5.PNG"
			],
			choices: [
				"assets/images/pattern_numbers/6.PNG",
				"assets/images/pattern_numbers/3.PNG",
				"assets/images/pattern_numbers/4.PNG",
				"assets/images/pattern_numbers/5.PNG",
			]
		});

		symbol_to_drag = pattern_disp_obj.dragables_obj[3].symbol_obj;
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
	public var pattern_disp_obj:PatternExtendObject;
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
