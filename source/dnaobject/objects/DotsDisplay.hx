package dnaobject.objects;

import constants.DnaConstants;
import dnaEvent.DnaEventManager;
import dnaEvent.DnaEventSubscriber;
import dnadata.DnaDataManager;
import dnadata.TaskTrials;
import dnadata.TrialBlock;
import dnaobject.components.ActionStateSwitchComponent;
import dnaobject.components.StateMachineComponent;
import dnaobject.components.SymbolSlotComponent;
import dnaobject.interfaces.ILevelPreview;
import dnaobject.interfaces.IState;
import dnaobject.interfaces.IStateMachine;
import dnaobject.interfaces.IUnlockableItem;
import dnaobject.interfaces.TaskObject;
import flixel.addons.plugin.taskManager.FlxTask;
import flixel.tweens.FlxTween;
import haxe.Json;

/**
 * this is the class that handles giving our trial parameters to the correct objects.
 */
class DotsDisplay implements DnaObject extends DnaObjectBase
{
	/**
	 * overwritten ctor.
	 */
	public function new()
	{
		super("DotsDisplay");
	}

	override public function onHaveParent() {}

	public var state_machine:IStateMachine;

	override public function onReady()
	{
		super.onReady();

		this.dots_obj = cast getParent().getObjectByName(getNestedObjectName(dots));
		this.noise_obj = cast getParent().getObjectByName(getNestedObjectName(noise));
		this.background_obj = cast getParent().getObjectByName(getNestedObjectName(background));
		this.petri_dish_top_obj = cast getParent().getObjectByName(getNestedObjectName(petri_dish_top));
		this.area_obj = cast getParent().getObjectByName(getNestedObjectName(area));

		state_machine = cast DnaComponentFactory.create("StateMachineComponent");
		this.addComponent(cast state_machine);
		state_machine.setNextState(new DotsStateVisible());
	}

	/**
	 * returns the path to the dots file that we have in this display.
	 */
	public function getDots():String
	{
		if (this.dots_obj == null)
		{
			return null;
		}
		return this.dots_obj.getAssetPath();
	}

	/**
	 * in here we set our dots file.
	 * @param asset_list 
	 */
	public function setDots(asset_path:String)
	{
		if (setDotsCallback != null)
		{
			setDotsCallback(asset_path);
		}
		else
		{
			this.dots_obj.setAssetPath(asset_path);
		}
	}

	public var setDotsCallback:String->Void;

	public var dots:String;
	public var dots_obj:SpriteObject;

	public var area:String;
	public var area_obj:RoundedRectangleObject;

	public var noise:String;
	public var noise_obj:SpriteObject;

	public var background:String;
	public var background_obj:SpriteObject;

	public var petri_dish_top:String;
	public var petri_dish_top_obj:SpriteObject;

	/**
	 * override so we can have parameters like random order and stuff.
	 * @param jsonFile 
	 */
	override public function fromFile(jsonFile:Dynamic)
	{
		super.fromFile(jsonFile);

		if (Reflect.hasField(jsonFile, "dots"))
		{
			this.dots = cast jsonFile.dots;
		}

		if (Reflect.hasField(jsonFile, "noise"))
		{
			this.noise = cast jsonFile.noise;
		}
		if (Reflect.hasField(jsonFile, "background"))
		{
			this.background = cast jsonFile.background;
		}
		if (Reflect.hasField(jsonFile, "petri_dish_top"))
		{
			this.petri_dish_top = cast jsonFile.petri_dish_top;
		}
		if (Reflect.hasField(jsonFile, "area"))
		{
			this.area = cast jsonFile.area;
		}
	}
}

class DotsStateHidden implements IState
{
	public var dots_disp:DotsDisplay;
	public var state_machine:IStateMachine;

	public function new() {}

	public function setParent(parent:IStateMachine):Void
	{
		state_machine = parent;
		var comp:DnaComponent = cast parent;
		dots_disp = cast comp.getParent();
	}

	public function update(elapsed:Float):Void {}

	public function setDots(path:String)
	{
		dots_disp.dots_obj.setAssetPath(path);
		dots_disp.dots_obj.sprite.alpha = 0;
	}

	public function enter():Void
	{
		dots_disp.setDotsCallback = this.setDots;
		dots_disp.background_obj.sprite.alpha = 0;
		dots_disp.petri_dish_top_obj.sprite.alpha = 0;
		dots_disp.dots_obj.sprite.alpha = 0;
		dots_disp.noise_obj.sprite.alpha = 0;
		dots_disp.area_obj.visible = false;
	}

	public function exit():Void
	{
		dots_disp.setDotsCallback = null;
		dots_disp.background_obj.sprite.alpha = 1;
		dots_disp.petri_dish_top_obj.sprite.alpha = 1;
		dots_disp.dots_obj.sprite.alpha = 1;
		dots_disp.noise_obj.sprite.alpha = 1;
	}
}

class DotsStateVisible implements IState
{
	public var dots_disp:DotsDisplay;
	public var state_machine:IStateMachine;

	public var time_visible:Float = 1;

	public function new() {}

	public function setParent(parent:IStateMachine):Void
	{
		state_machine = parent;
		var comp:DnaComponent = cast parent;
		dots_disp = cast comp.getParent();
	}

	private var elapsed_total:Float = 0;

	public function update(elapsed:Float):Void {}

	public function setDots(path:String)
	{
		dots_disp.dots_obj.setAssetPath(path);
		dots_disp.dots_obj.sprite.alpha = 1;
	}

	public function enter():Void
	{
		dots_disp.setDotsCallback = this.setDots;
		dots_disp.background_obj.sprite.alpha = 1;
		dots_disp.petri_dish_top_obj.sprite.alpha = 1;
		dots_disp.dots_obj.sprite.alpha = 1;
		dots_disp.noise_obj.sprite.alpha = 0;
		dots_disp.area_obj.visible = true;
	}

	public function exit():Void
	{
		dots_disp.setDotsCallback = null;
		dots_disp.background_obj.sprite.alpha = 1;
		dots_disp.petri_dish_top_obj.sprite.alpha = 1;
		dots_disp.dots_obj.sprite.alpha = 1;
		dots_disp.noise_obj.sprite.alpha = 1;
	}
}

class DotsStateNoise implements IState
{
	public var dots_disp:DotsDisplay;
	public var state_machine:IStateMachine;

	public var time_visible:Float = 0.5;

	public function new() {}

	public function setParent(parent:IStateMachine):Void
	{
		state_machine = parent;
		var comp:DnaComponent = cast parent;
		dots_disp = cast comp.getParent();
	}

	public function setDots(path:String)
	{
		dots_disp.dots_obj.setAssetPath(path);
		dots_disp.dots_obj.sprite.alpha = 0;
	}

	private var elapsed_total:Float = 0;

	public function update(elapsed:Float):Void {}

	public function enter():Void
	{
		dots_disp.setDotsCallback = this.setDots;
		dots_disp.background_obj.sprite.alpha = 0;
		dots_disp.petri_dish_top_obj.sprite.alpha = 0;
		dots_disp.dots_obj.sprite.alpha = 0;
		dots_disp.noise_obj.sprite.alpha = 1;
		dots_disp.area_obj.visible = true;
	}

	public function exit():Void
	{
		dots_disp.setDotsCallback = null;
		dots_disp.background_obj.sprite.alpha = 1;
		dots_disp.petri_dish_top_obj.sprite.alpha = 1;
		dots_disp.dots_obj.sprite.alpha = 1;
		dots_disp.noise_obj.sprite.alpha = 1;
	}
}

class DotsStateAfterNoise implements IState
{
	public var dots_disp:DotsDisplay;
	public var state_machine:IStateMachine;

	public var time_visible:Float = 0.5;

	public function new() {}

	public function setParent(parent:IStateMachine):Void
	{
		state_machine = parent;
		var comp:DnaComponent = cast parent;
		dots_disp = cast comp.getParent();
	}

	public function setDots(path:String)
	{
		dots_disp.dots_obj.setAssetPath(path);
		dots_disp.dots_obj.sprite.alpha = 0;
	}

	private var elapsed_total:Float = 0;

	public function update(elapsed:Float):Void {}

	public function enter():Void
	{
		dots_disp.setDotsCallback = this.setDots;
		dots_disp.background_obj.sprite.alpha = 0;
		dots_disp.petri_dish_top_obj.sprite.alpha = 0;
		dots_disp.dots_obj.sprite.alpha = 0;
		dots_disp.noise_obj.sprite.alpha = 0;
		dots_disp.area_obj.visible = true;
	}

	public function exit():Void
	{
		dots_disp.setDotsCallback = null;
		dots_disp.background_obj.sprite.alpha = 1;
		dots_disp.petri_dish_top_obj.sprite.alpha = 1;
		dots_disp.dots_obj.sprite.alpha = 1;
		dots_disp.noise_obj.sprite.alpha = 1;
	}
}
