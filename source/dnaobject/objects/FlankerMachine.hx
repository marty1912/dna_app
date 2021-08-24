package dnaobject.objects;

import Assertion.assert;
import dnaEvent.DnaEventManager;
import dnaEvent.DnaEventSubscriber;
import dnadata.DnaDataManager;
import dnadata.TrialBlock;
import dnaobject.components.ActionStateSwitchComponent;
import dnaobject.components.StateMachineComponent;
import dnaobject.components.TutorialFingerComponent;
import dnaobject.components.UserButtonComponent;
import dnaobject.interfaces.ILevelPreview;
import dnaobject.interfaces.IState;
import dnaobject.interfaces.IStateMachine;
import dnaobject.interfaces.IUnlockableItem;
import dnaobject.interfaces.TaskObject;
import dnaobject.objects.CorsiMachineDome.CorsiDomeStopped;
import flixel.FlxSprite;
import flixel.addons.plugin.taskManager.FlxTask;
import flixel.math.FlxPoint;
import flixel.math.FlxRandom;
import flixel.math.FlxRect;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import haxe.Json;

/**
 * this is the class that handles giving our trial parameters to the correct objects.
 */
class FlankerMachine implements DnaObject implements DnaEventSubscriber extends DnaObjectBase
{
	/**
	 * overwritten ctor.
	 */
	public function new()
	{
		super("FlankerMachine");
		this.state_machine = cast DnaComponentFactory.create("StateMachineComponent");
		this.addComponent(state_machine);
	}

	public var state_machine:StateMachineComponent;

	/**
	 * this is the function that gets called everytime an event we subscribed for is fired
	 * @param event_name
	 */
	public function getNotified(event_name:String, params:Any = null) {}

	override public function onHaveParent() {}

	override public function onReady()
	{
		super.onReady();
		dome_obj = cast this.getParent().getObjectByName(getNestedObjectName(dome));
		front_obj = cast this.getParent().getObjectByName(getNestedObjectName(front));
		fixation_obj = cast this.getParent().getObjectByName(getNestedObjectName(fixation));
		pattern_display_obj = cast this.getParent().getObjectByName(getNestedObjectName(pattern_display));
		this.dome_obj.state_machine.setNextState(new CorsiDomeStopped());

		// add buttons for cosmetic reasons.
		button_left = cast DnaObjectFactory.create("EmptyButtonObject");
		this.getParent().addObject(button_left);
		button_left.button.setGraphicSize(Math.floor(pattern_display_obj.getWidth() * 0.1));
		button_left.button.updateHitbox();
		button_left.removeChild(button_left.button);
		button_left.addChild(button_left.button);
		button_left.moveTo(pattern_display_obj.pattern_area_obj.sprite.x - (button_left.button.width * 2),
			fixation_obj.sprite.getMidpoint().y - (button_left.getHeight() / 2));

		button_right = cast DnaObjectFactory.create("EmptyButtonObject");
		this.getParent().addObject(button_right);
		button_right.button.setGraphicSize(Math.floor(pattern_display_obj.getWidth() * 0.1));
		button_right.button.updateHitbox();
		button_right.moveTo(pattern_display_obj.pattern_area_obj.sprite.x
			+ pattern_display_obj.pattern_area_obj.sprite.width
			+ (button_right.button.width),
			fixation_obj.sprite.getMidpoint().y
			- (button_right.getHeight() / 2));

		button_right.removeChild(button_right.button);
		button_right.addChild(button_right.button);

		// very hacky but we need to have the area on the front so no buttons are placed outside the box..
		var buttons_pos_x:Float = front_obj.sprite.x + (front_obj.width * 0.05);
		var buttons_pos_y:Float = front_obj.sprite.y + (front_obj.height * 0.2);
		var button_area_width:Float = front_obj.width * 0.85;
		var button_area_height:Float = front_obj.height * 0.7;
		button_area = FlxRect.get(Std.int(buttons_pos_x), Std.int(buttons_pos_y), Std.int(button_area_width), Std.int(button_area_height));
		this.state_machine.setNextState(new FlankerMachineFixation());
	}

	public var test:FlxSprite;
	public var buttons:Array<DnaButtonObject> = new Array<DnaButtonObject>();
	public var button_left:DnaButtonObject;
	public var button_right:DnaButtonObject;

	public var dome:String;
	public var base:String;
	public var front:String;
	public var fixation:String;
	public var pattern_display:String;
	public var back:String;

	public var dome_obj:CorsiMachineDome;
	public var front_obj:SpriteObject;
	public var fixation_obj:SpriteObject;
	public var pattern_display_obj:PatternDisplay;

	public var button_area:FlxRect;

	/**
	 * override so we can have parameters like random order and stuff.
	 * @param jsonFile 
	 */
	override public function fromFile(jsonFile:Dynamic)
	{
		super.fromFile(jsonFile);

		if (Reflect.hasField(jsonFile, "dome"))
		{
			this.dome = cast jsonFile.dome;
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
		if (Reflect.hasField(jsonFile, "pattern_display"))
		{
			this.pattern_display = cast jsonFile.pattern_display;
		}
		if (Reflect.hasField(jsonFile, "fixation"))
		{
			this.fixation = cast jsonFile.fixation;
		}
	}

	var total_time:Float = 0;
	var first = true;

	public override function update(elapsed:Float) {}
}

class FlankerMachineFixation implements IState
{
	public var flanker_machine:FlankerMachine;
	public var state_machine:IStateMachine;

	public var time_visible:Float = 1;

	public function new() {}

	public function setParent(parent:IStateMachine):Void
	{
		state_machine = parent;
		var comp:DnaComponent = cast parent;
		flanker_machine = cast comp.getParent();
	}

	var hue:Float = 0;

	public function update(elapsed:Float):Void {}

	var tween:FlxTween;

	public function enter():Void
	{
		this.flanker_machine.pattern_display_obj.setVisible(false);
		this.flanker_machine.fixation_obj.setVisible(true);
		this.flanker_machine.dome_obj.state_machine.setNextState(new CorsiDomeStopped());
	}

	public function exit():Void {}
}

class FlankerMachineEmpty implements IState
{
	public var flanker_machine:FlankerMachine;
	public var state_machine:IStateMachine;

	public var time_visible:Float = 1;

	public function new() {}

	public function setParent(parent:IStateMachine):Void
	{
		state_machine = parent;
		var comp:DnaComponent = cast parent;
		flanker_machine = cast comp.getParent();
	}

	var hue:Float = 0;

	public function update(elapsed:Float):Void {}

	var tween:FlxTween;

	public function enter():Void
	{
		this.flanker_machine.pattern_display_obj.setVisible(false);
		this.flanker_machine.fixation_obj.setVisible(false);
		// this.flanker_machine.dome_obj.state_machine.setNextState(new CorsiDomeStopped());
	}

	public function exit():Void {}
}

class FlankerMachinePresent implements IState
{
	public var flanker_machine:FlankerMachine;
	public var state_machine:IStateMachine;

	public var time_visible:Float = 1;

	public function new() {}

	public function setParent(parent:IStateMachine):Void
	{
		state_machine = parent;
		var comp:DnaComponent = cast parent;
		flanker_machine = cast comp.getParent();
	}

	var hue:Float = 0;

	public function update(elapsed:Float):Void {}

	var tween:FlxTween;

	public function enter():Void
	{
		this.flanker_machine.pattern_display_obj.setVisible(true);
		this.flanker_machine.fixation_obj.setVisible(false);
		this.flanker_machine.dome_obj.state_machine.setNextState(new CorsiDomeStopped());
	}

	public function exit():Void {}
}
