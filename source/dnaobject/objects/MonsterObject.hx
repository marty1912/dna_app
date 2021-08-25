package dnaobject.objects;

import Assertion.assert;
import dnaEvent.DnaEventManager;
import dnadata.DnaDataManager;
import dnaobject.interfaces.IState;
import dnaobject.interfaces.IStateMachine;
import dragonBones.animation.WorldClock;
import dragonBones.events.EventObject;
import dragonBones.flixel.FlixelArmatureCollider;
import dragonBones.flixel.FlixelArmatureDisplay;
import dragonBones.flixel.FlixelEvent;
import dragonBones.flixel.FlixelFactory;
import dragonBones.flixel.FlixelTextureAtlasData;
import dragonBones.objects.DragonBonesData;
import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxPoint;
import flixel.math.FlxRandom;
import flixel.system.FlxAssets.FlxGraphicAsset;
import haxe.Json;
import openfl.Assets;

/**
 * class MonsterObject -
 * this class represents MONTI the monster, the main character of the game.
 *
 */
class MonsterObject implements DnaObject implements IStateMachine extends DnaObjectBase
{
	private final slotMap:Map<String, Int> = [
		"hand6" => 0, "hand5" => 1, "hand4" => 2, "hand3" => 3, "hand2" => 4, "hand1" => 5, "leg3" => 6, "leg2" => 7, "leg1" => 8, "leg6" => 9, "leg5" => 10,
		"leg4" => 11, "body" => 12, "head" => 13, "mouth1" => 14, "mouth2" => 15, "hand7" => 16
	];

	/*
		[
			"foot_l" => 0, "foot_r" => 1, "leg_r" => 2, "leg_l" => 3, "mouth_closed" => 4, "mouth_open" => 5, "eyes_closed" => 6, "body" => 7, "hand_l" => 8,
			"hand_r" => 9, "head" => 10, "arm_r" => 11, "arm_l" => 12, "hat" => 13, "eyes_normal" => 14, "mouth_normal" => 15, "nose" => 16
		];
	 */
	/**
	 * ctor.
	 */
	public function new()
	{
		super("MonsterObject");

		setupDragonBones();
		getPartsFromData();
		setNextState(new MontiStateIdle());
		// scale * my_height == FlxG.height/2
		var scl = (FlxG.height / 2) / my_height;
		scale.x = scl;
		scale.y = scl;
	}

	public final my_height = 1024;

	private var _factory:FlixelFactory = new FlixelFactory();
	private var armatureGroup:FlxTypedGroup<FlixelArmatureDisplay>;
	private var arm_collider:FlixelArmatureCollider;

	public var scale:FlxPoint = FlxPoint.get(1, 1);

	/**
	 * setupDragonBones
	 * in this function we setup our dragonbones skeletal animation model.
	 * the paths are hardcoded but that is okay as we will most likely only have this one monti
	 */
	public function setupDragonBones()
	{
		var dragonBonesData:DragonBonesData = _factory.parseDragonBonesData(Json.parse(Assets.getText("assets/dragonbones/Dna_Project_ske.json")));

		_factory.parseTextureAtlasData(Json.parse(Assets.getText("assets/dragonbones/Dna_Project_tex.json")),
			Assets.getBitmapData("assets/dragonbones/Dna_Project_tex.png"));
		arm_collider = new FlixelArmatureCollider(250, 250, 27, 25, 0, 0);

		armatureGroup = _factory.buildArmatureDisplay(arm_collider, dragonBonesData.armatureNames[0]);

		armatureGroup.members[0].addEvent(EventObject.START, _animationHandler);
		// addAllSprites();
	}

	/**
	 * setParent - sets the parent state of the current object.
	 * @param parent - the state to set as parent.
	 */
	override public function setParent(parent:DnaState):Void
	{
		// //trace("set Parent of monti");
		// if we have a new parent. we have to remove all of our children from the old one.
		if (this.m_parent_state != null)
		{
			// //trace(this.m_parent_state);
			removeAllSprites();
			/*
				in base class:
					for (child in this.m_children_list)
					{
						this.m_parent_state.remove(child);
					}
			 */
		}
		this.m_parent_state = parent;
		if (parent != null)
		{
			addAllSprites();
			/*
				in base class:
					for (child in this.m_children_list)
					{
						parent.add(child);
					}
			 */
		}
	}

	/**
	 * this function adds all the sprites from the armaturegroup to our dnaobject
	 */
	public function removeAllSprites()
	{
		if (this.getParent() == null)
		{
			// //trace("no parent set yet..");
			return;
		}
		armatureGroup.forEach(function(display:FlixelArmatureDisplay)
		{
			var sprite:FlxBasic = cast(display, FlxBasic);
			this.getParent().remove(sprite);
		});
	}

	/**
	 * this function adds all the sprites from the armaturegroup to our dnaobject
	 */
	public function addAllSprites()
	{
		if (this.getParent() == null)
		{
			// //trace("no parent set yet..");
			return;
		}
		armatureGroup.forEach(function(display:FlixelArmatureDisplay)
		{
			display.scaleX = scale.x;
			display.scaleY = scale.y;
			var sprite:FlxBasic = cast(display, FlxBasic);

			this.getParent().add(sprite);
		});
	}

	/**
	 * starts running the animation with the name specified in the string param.
	 * @param name
	 */
	public function startAnimation(name:String, times:Int)
	{
		// //trace("starting animation:", name);
		armatureGroup.forEach(_setAnimationProps);
		armatureGroup.forEach(function(display:FlixelArmatureDisplay)
		{
			display.animation.play(name, times);
		});
		var pos_comp:DnaComponent = this.getComponentByType("PositionComponent");
		if (pos_comp != null)
		{
			pos_comp.update(0);
		}
	}

	/**
	 * this function gets all the parts from the DnaDataManager and "puts them on"
	 */
	public function getPartsFromData()
	{
		var part_list:Array<Dynamic> = DnaDataManager.instance.getMontiPartData();
		for (part in part_list)
		{
			var comp:DnaComponent = DnaComponentFactory.create(part.type);
			comp.fromFile(part);

			addComponent(comp);
		}
	}

	/**
	 * sets the asset to use for the right arm.
	 * @param asset
	 */
	public function setAsset(name:String, asset:FlxGraphicAsset)
	{
		var index = slotMap.get(name);
		this.removeAllSprites();
		armatureGroup.members[index].loadGraphic(asset);
		this.addAllSprites();
	}

	private function _setAnimationProps(display:FlixelArmatureDisplay):Void
	{
		display.antialiasing = true;
		display.x = 0;
		display.y = 0;
		// display.scaleX = 0.7;
		// display.scaleY = 0.7;
	}

	private function _animationHandler(event:FlixelEvent):Void
	{
		var eventObject:EventObject = event.eventObject;
	}

	/**
	 * in the fromFile function we simply read the asset path from the file.
	 *
	 * @param jsonFile
	 */
	override public function fromFile(jsonFile:Dynamic):Void
	{
		super.fromFile(jsonFile);
	}

	/**
	 * we override this function because the ArmatureDisplay objects wont behave and we get errors otherwise.
	 * in here we kind of hard code the dimensions of monti.
	 * @return Array<Float> with max left right up down from the origin.
	 * this is used to be able to center the object.
	 */
	override public function getMaxLeftRightUpDownFromOrigin():Array<Float>
	{
		var max_left_from_origin = Math.POSITIVE_INFINITY;

		var max_up_from_origin = Math.POSITIVE_INFINITY;
		var max_down_from_origin = Math.NEGATIVE_INFINITY;
		var max_right_from_origin = Math.NEGATIVE_INFINITY;

		// hardcoded values because the nice version does not work here..
		max_left_from_origin = -(350 / 0.7) * scale.x;
		max_up_from_origin = -(450 / 0.7) * scale.y;
		max_down_from_origin = (450 / 0.7) * scale.y;
		max_right_from_origin = (350 / 0.7) * scale.x;
		return [
			max_left_from_origin,
			max_right_from_origin,
			max_up_from_origin,
			max_down_from_origin
		];
	}

	/**
	 * this function moves the object (with all the children) to the new position.
	 * we override this because special care is needed for our monti object.
	 * @param position - the target position to move to.
	 */
	override public function moveTo(x:Float, y:Float):Void
	{
		arm_collider.x = x;
		arm_collider.y = y;
		armatureGroup.forEach(function(armature_display)
		{
			armature_display.x = x;
		});
		armatureGroup.forEach(function(armature_display)
		{
			armature_display.y = y;
		});

		var offset_x = x - this.getOrigin().x;
		var offset_y = y - this.getOrigin().y;

		this.setOrigin(x, y);
	}

	/**
	 * part of the statemachine interface. in here we set our next state.
	 * @param next_state
	 */
	public function setNextState(next_state:IState)
	{
		if (m_current_state != null)
		{
			m_current_state.exit();
			m_current_state.setParent(null);
		}
		m_current_state = next_state;
		m_current_state.setParent(this);
		m_current_state.enter();
	}

	public var m_current_state(default, null):IState;

	public function setState(state:StateEnum):Void
	{
		switch (state)
		{
			case StateEnum.NORMAL:
			// setNextState(new MontiStateIdle());
			case StateEnum.HIGHLIGHT:
			// setNextState(new ButtonStateHighlight());
			case StateEnum.PRESSED:
				setNextState(new MontiStateWalk());
			default:
				assert(false);
		}
	}

	/**
	 * loads the saved state of the monti object from data.
	 */
	public function loadFromData() {}

	public var first = true;

	override public function update(elapsed:Float)
	{
		if (first)
		{
			first = false;
			// debug test on replacing bodyparts..
			// this.setAsset("leg_l", Assets.getBitmapData("assets/images/monsterparts/monster_arm_r_01.png"));
			// this.setAsset("foot_l", Assets.getBitmapData("assets/images/monsterparts/monster_hand_r_01.png"));
		}
		// this done in order to play our animation.
		FlixelFactory._clock.advanceTime(-1);
		this.m_current_state.update(elapsed);
		super.update(elapsed);
	}
}

/**
 * the normal state for a button. here the first
 */
class MontiStateIdle implements IState
{
	public function new() {};

	public var parent:MonsterObject = null;

	public function setParent(parent:IStateMachine):Void
	{
		this.parent = cast(parent);
	}

	public function update(elapsed:Float):Void {}

	public function enter():Void
	{
		parent.startAnimation("idle", -1);
	}

	public function exit():Void {}
}

/**
 * the normal state for a button. here the first
 */
class MontiStateWave implements IState
{
	public function new() {};

	public var parent:MonsterObject = null;

	public function setParent(parent:IStateMachine):Void
	{
		this.parent = cast(parent);
	}

	public final duration:Float = 2;

	public var time:Float = 0;

	/**
	 * this is kind of a hack.. i do not know how to tell if the animation endet (yet)..
	 * so we do it with timing..
	 * @param elapsed
	 */
	public function update(elapsed:Float):Void
	{
		time += elapsed;

		if (time > duration)
		{
			// parent.setNextState(new MontiStateIdle());
		}
	}

	public function enter():Void
	{
		parent.startAnimation("wave", 1);
	}

	public function exit():Void
	{
		// this.getParent().eventManager.broadcastEvent("MONTI_EXIT_STATE");
	}
}

/**
 * the normal state for a button. here the first
 */
class MontiStateWalk implements IState
{
	public function new() {};

	public var parent:MonsterObject = null;

	public function setParent(parent:IStateMachine):Void
	{
		this.parent = cast(parent);
	}

	public final duration:Float = 2;

	public var time:Float = 0;

	/**
	 * this is kind of a hack.. i do not know how to tell if the animation endet (yet)..
	 * so we do it with timing..
	 * @param elapsed
	 */
	public function update(elapsed:Float):Void
	{
		time += elapsed;

		if (time > duration)
		{
			// parent.setNextState(new MontiStateIdle());
		}
	}

	public function enter():Void
	{
		parent.startAnimation("walk", -1);
	}

	public function exit():Void
	{
		// this.getParent().eventManager.broadcastEvent("MONTI_EXIT_STATE");
	}
}

/**
 * the normal state for a button. here the first
 */
class MontiStateTalk implements IState
{
	public function new() {};

	public var parent:MonsterObject = null;

	public function setParent(parent:IStateMachine):Void
	{
		this.parent = cast(parent);
	}

	public var duration:Float = 0;
	public var rand = new FlxRandom();

	public var time:Float = 0;

	/**
	 * this is kind of a hack.. i do not know how to tell if the animation endet (yet)..
	 * so we do it with timing..
	 * @param elapsed
	 */
	public function update(elapsed:Float):Void
	{
		time += elapsed;

		if (time > duration)
		{
			if (current_animation == "talk_open")
			{
				current_animation = "talk_closed";
			}
			else
			{
				current_animation = "talk_open";
			}

			parent.startAnimation(current_animation, -1);
			duration = rand.float(0.01, 0.3);
			time = 0;
			// parent.setNextState(new MontiStateIdle());
		}
	}

	public var current_animation = "talk_open";

	public function enter():Void
	{
		parent.startAnimation(current_animation, -1);
		duration = rand.float(0, 0.5);
		// TODO: find a way to maybe get the slots names in the armaturegroup

		// TODO: use something like in setASset()!!
		//		parent.armatureGroup.forEach(function(display:FlixelArmatureDisplay) {});
	}

	public function exit():Void
	{
		// this.getParent().eventManager.broadcastEvent("MONTI_EXIT_STATE");
	}
}
