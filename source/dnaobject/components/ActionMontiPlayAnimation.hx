package dnaobject.components;

import dnaobject.objects.MonsterObject;

/**
 * this class will make an object MontiPlayAnimation based on an event.
 */
class ActionMontiPlayAnimationComponent implements DnaComponent extends DnaActionBase
{
	/**
	 * ctor
	 */
	public function new()
	{
		super("ActionMontiPlayAnimationComponent");
	}

	public var animation:String = "";
	public var times:Int = -1;

	/**
	 * in here we read our params from a file..
	 * @param jsonFile - the jsonFile object to read from. should be the output of jsonParse.
	 */
	override public function fromFile(jsonFile:Dynamic):Void
	{
		if (Reflect.hasField(jsonFile, "animation"))
		{
			animation = jsonFile.animation;
		}
		if (Reflect.hasField(jsonFile, "times"))
		{
			times = jsonFile.times;
		}
		super.fromFile(jsonFile);
	}

	/**
	 * in this function we will make the object MontiPlayAnimation..
	 * @param elapsed
	 */
	override public function update(elapsed:Float)
	{
		// might look confusing at first.
		// with the first getParent we get the object. and with the 2nd the state.
		var target:MonsterObject = cast getParent().getParent().getObjectByName(m_target_name);
		// very hacky indeed..
		if (animation == "talk")
		{
			target.setNextState(new MontiStateTalk());
		}
		else
		{
			target.setNextState(new MontiStateIdle());
		}
		target.startAnimation(animation, times);
		// TODO: find a way to wait for this animation to finish..
		this.finishAction();
	}
}
