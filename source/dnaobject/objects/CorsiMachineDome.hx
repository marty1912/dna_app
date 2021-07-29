package dnaobject.objects;

import dnaEvent.DnaEventManager;
import dnaEvent.DnaEventSubscriber;
import dnadata.DnaDataManager;
import dnadata.TrialBlock;
import dnaobject.components.ActionStateSwitchComponent;
import dnaobject.components.StateMachineComponent;
import dnaobject.interfaces.ILevelPreview;
import dnaobject.interfaces.IState;
import dnaobject.interfaces.IStateMachine;
import dnaobject.interfaces.IUnlockableItem;
import dnaobject.interfaces.TaskObject;
import flixel.FlxG;
import flixel.addons.plugin.taskManager.FlxTask;
import flixel.math.FlxPoint;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
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
		state_machine = cast DnaComponentFactory.create("StateMachineComponent");
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
		helix_obj = cast this.getParent().getObjectByName(getNestedObjectName(helix));
		ground_obj = cast this.getParent().getObjectByName(getNestedObjectName(ground));
		back_obj = cast this.getParent().getObjectByName(getNestedObjectName(back));
		front_obj = cast this.getParent().getObjectByName(getNestedObjectName(front));

		helix_obj.sprite.animation.add("rotate", [
			1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23
		], 25);
		helix_obj.sprite.animation.play("rotate");

		var tween = FlxTween.angle(helix_obj.sprite, 0, 360, 20, {type: LOOPING});
		this.state_machine.setNextState(new CorsiDomeDefault());
	}

	public var helix:String;
	public var ground:String;
	public var base:String;
	public var front:String;
	public var back:String;

	public var helix_obj:SpriteObject;
	public var ground_obj:SpriteObject;
	public var back_obj:SpriteObject;
	public var front_obj:SpriteObject;

	/**
	 * override so we can have parameters like random order and stuff.
	 * @param jsonFile 
	 */
	override public function fromFile(jsonFile:Dynamic)
	{
		super.fromFile(jsonFile);
		if (Reflect.hasField(jsonFile, "ground"))
		{
			this.ground = cast jsonFile.ground;
		}

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

	public override function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}

class CorsiDomeFalse implements IState
{
	public var corsi_dome:CorsiMachineDome;
	public var state_machine:IStateMachine;

	public var time_visible:Float = 1;

	public function new() {}

	public function setParent(parent:IStateMachine):Void
	{
		state_machine = parent;
		var comp:DnaComponent = cast parent;
		corsi_dome = cast comp.getParent();
	}

	public function update(elapsed:Float):Void {}

	public var old_x:Float = 0;
	public var old_y:Float = 0;
	public var screenCenterPos:FlxPoint = new FlxPoint(FlxG.width / 2, FlxG.height / 2);

	var tween:FlxTween;

	public function enter():Void
	{
		// FlxTween.tween(this.corsi_dome.back_obj.sprite, {alpha: 0.2}, 1, {type: PINGPONG, ease: FlxEase.cubeInOut});
		tween = FlxTween.color(this.corsi_dome.ground_obj.sprite, 0.5, FlxColor.WHITE, FlxColor.RED, {type: PINGPONG, ease: FlxEase.cubeInOut});

		// move the dna helix to the center of the screen and (hopefully) hide it behind the machine front

		old_x = this.corsi_dome.helix_obj.sprite.getPosition().x;
		old_y = this.corsi_dome.helix_obj.sprite.getPosition().y;
		trace("oldx: ", old_x);
		// FlxTween.tween(this.corsi_dome.helix_obj, {pos_x: screenCenterPos.x, pos_y: screenCenterPos.y}, 1, {type: ONESHOT, ease: FlxEase.cubeInOut});
	}

	public function exit():Void
	{
		FlxTween.tween(this.corsi_dome.helix_obj, {pos_x: old_x, pos_y: old_y}, 1, {type: ONESHOT, ease: FlxEase.cubeInOut});
		tween.cancel();
	}
}

class CorsiDomeCorrect implements IState
{
	public var corsi_dome:CorsiMachineDome;
	public var state_machine:IStateMachine;

	public var time_visible:Float = 1;

	public function new() {}

	public function setParent(parent:IStateMachine):Void
	{
		state_machine = parent;
		var comp:DnaComponent = cast parent;
		corsi_dome = cast comp.getParent();
	}

	public function update(elapsed:Float):Void {}

	var tween:FlxTween;

	public var old_x:Float = 0;
	public var old_y:Float = 0;
	public var screenCenterPos:FlxPoint = new FlxPoint(FlxG.width / 2, FlxG.height / 2);

	public function enter():Void
	{
		// FlxTween.tween(this.corsi_dome.back_obj.sprite, {alpha: 0.2}, 1, {type: PINGPONG, ease: FlxEase.cubeInOut});
		tween = FlxTween.color(this.corsi_dome.ground_obj.sprite, 0.5, FlxColor.WHITE, FlxColor.GREEN, {type: PINGPONG, ease: FlxEase.cubeInOut});

		old_x = this.corsi_dome.helix_obj.sprite.getPosition().x;
		old_y = this.corsi_dome.helix_obj.sprite.getPosition().y;
		// FlxTween.tween(this.corsi_dome.helix_obj, {pos_x: screenCenterPos.x, pos_y: screenCenterPos.y}, 1, {type: ONESHOT, ease: FlxEase.cubeInOut});
	}

	public function exit():Void
	{
		FlxTween.tween(this.corsi_dome.helix_obj, {pos_x: old_x, pos_y: old_y}, 1, {type: ONESHOT, ease: FlxEase.cubeInOut});
		tween.cancel();
	}
}

class CorsiDomeDefault implements IState
{
	public var corsi_dome:CorsiMachineDome;
	public var state_machine:IStateMachine;

	public var time_visible:Float = 1;

	public function new() {}

	public function setParent(parent:IStateMachine):Void
	{
		state_machine = parent;
		var comp:DnaComponent = cast parent;
		corsi_dome = cast comp.getParent();
	}

	var hue:Float = 0;

	public function update(elapsed:Float):Void {}

	var tween:FlxTween;

	public function enter():Void
	{
		// FlxTween.tween(this.corsi_dome.back_obj.sprite, {alpha: 0.2}, 1, {type: PINGPONG, ease: FlxEase.cubeInOut});
		//		tween = FlxTween.color(this.corsi_dome.ground_obj.sprite, 0.5, FlxColor.WHITE, FlxColor.GREEN, {type: PINGPONG, ease: FlxEase.cubeInOut});
	}

	public function exit():Void
	{
		this.corsi_dome.ground_obj.sprite.color = FlxColor.WHITE;
	}
}

class CorsiDomeRainbow implements IState
{
	public var corsi_dome:CorsiMachineDome;
	public var state_machine:IStateMachine;

	public var time_visible:Float = 1;

	public function new() {}

	public function setParent(parent:IStateMachine):Void
	{
		state_machine = parent;
		var comp:DnaComponent = cast parent;
		corsi_dome = cast comp.getParent();
	}

	var hue:Float = 0;

	public function update(elapsed:Float):Void
	{
		hue += elapsed * 500;
		while (hue > 360)
		{
			hue -= 360;
		}

		var color = FlxColor.fromHSB(Std.int(hue), 1, 1);
		this.corsi_dome.ground_obj.sprite.color = color;
	}

	var tween:FlxTween;

	public var oldHelixPos:FlxPoint = new FlxPoint();
	public var screenCenterPos:FlxPoint = new FlxPoint(FlxG.width / 2, FlxG.height / 2);

	public function enter():Void
	{
		FlxTween.tween(this.corsi_dome.helix_obj.sprite, {alpha: 0.5}, 1, {type: PINGPONG, ease: FlxEase.cubeInOut});
		//		tween = FlxTween.color(this.corsi_dome.ground_obj.sprite, 0.5, FlxColor.WHITE, FlxColor.GREEN, {type: PINGPONG, ease: FlxEase.cubeInOut});
		oldHelixPos.x = this.corsi_dome.helix_obj.pos_x;
		oldHelixPos.x = this.corsi_dome.helix_obj.pos_y;
		// FlxTween.tween(this.corsi_dome.helix_obj, {pos_x: screenCenterPos.x, pos_y: screenCenterPos.y}, 1, {type: ONESHOT, ease: FlxEase.cubeInOut});
	}

	public function exit():Void
	{
		this.corsi_dome.ground_obj.sprite.color = FlxColor.WHITE;
	}
}
