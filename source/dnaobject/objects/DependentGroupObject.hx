package dnaobject.objects;

import Assertion.assert;
import constants.DnaConstants;
import dnaEvent.DnaEventManager;
import dnaEvent.DnaEventSubscriber;
import dnadata.DnaDataManager;
import dnadata.TaskTrials;
import dnaobject.DnaObject;
import dnaobject.interfaces.ITextBox;
import dnaobject.interfaces.Slideable;
import dnaobject.interfaces.TaskObject;
import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import haxe.DynamicAccess;

/**
 * class DependentGroupObject
 * this class represents our ArithmeticTaskHandler.
 * it is used to set and get parameters of the objects used in the arithmetic task
 *
 */
class DependentGroupObject implements DnaObject extends DnaObjectBase
{
	/**
	 * ctor - in here we set the members like our type, position etc.
	 */
	public function new()
	{
		super('DependentGroupObject');
	}

	public function addConditionalsToParent()
	{
		for (cond in this.conditionals)
		{
			// trace("condition:", cond, "check:", cond.check());
			if (cond.check())
			{
				getParent().objectFromFile(cond.obj);
			}
		}
	}

	public var conditionals:Array<Condition> = new Array<Condition>();

	/**
		* fromFile()
		*
		* @param jsonFile - Dynamic Object with params.

		*
	 */
	override public function fromFile(jsonFile:Dynamic):Void
	{
		if (Reflect.hasField(jsonFile, "conditions"))
		{
			var conds:Array<Dynamic> = jsonFile.conditions;
			// trace("conditions:", conds);
			for (cond in conds)
			{
				// trace("cond:", cond);
				var condition:Condition = null;
				if (cond.condition == "web")
				{
					condition = new ConditionWEB(cond.obj);
				}
				else if (cond.condition == "android")
				{
					condition = new ConditionANDROID(cond.obj);
				}
				else if (cond.condition == "desktop")
				{
					condition = new ConditionDESKTOP(cond.obj);
				}
				else if (cond.condition == "ORDINAL_LEFT")
				{
					condition = new ConditionORDINAL_LEFT(cond.obj);
				}
				else if (cond.condition == "ORDINAL_RIGHT")
				{
					condition = new ConditionORDINAL_RIGHT(cond.obj);
				}

				// trace("condition:", condition);
				assert(condition != null);

				conditionals.push(condition);
			}
			addConditionalsToParent();
		}

		super.fromFile(jsonFile);
		return;
	}
}

/**
 *  This class will be used as a abstract class for creating conditional object groups
 */
class Condition
{
	public var obj:Dynamic;

	public function new(obj_:Dynamic)
	{
		obj = obj_;
	}

	/**
	 * checks wheter this condition is true. 
	 * if yes we will add this 
	 */
	public function check():Bool
		throw "override me!";
}

class ConditionWEB extends Condition
{
	override public function check()
	{
		#if web
		return true;
		#end

		return false;
	}
}

class ConditionANDROID extends Condition
{
	override public function check()
	{
		#if android
		return true;
		#end

		return false;
	}
}

class ConditionDESKTOP extends Condition
{
	override public function check()
	{
		#if desktop
		return true;
		#end

		return false;
	}
}

class ConditionORDINAL_LEFT extends Condition
{
	override public function check()
	{
		return !DnaDataManager.instance.retrieveData(DnaDataManager.ORD_TASK_COND);
	}
}

class ConditionORDINAL_RIGHT extends Condition
{
	override public function check()
	{
		return DnaDataManager.instance.retrieveData(DnaDataManager.ORD_TASK_COND);
	}
}
