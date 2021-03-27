package dnaobject.components;

import dnaEvent.DnaEventManager;
import dnaobject.interfaces.Slideable;
import flixel.math.FlxPoint;

/**
 * this class will be used to set the slider position on slideable objects.
 */
class ActionSetSliderPosComponent implements DnaComponent extends DnaActionBase
{
	/**
	 * ctor
	 */
	public function new()
	{
		super("ActionSetSliderPosComponent");
	}

	private var m_pos_from_object:String = "";

	/**
	 * in here we read our params from a file..
	 * @param jsonFile - the jsonFile object to read from. should be the output of jsonParse.
	 */
	override public function fromFile(jsonFile:Dynamic):Void
	{
		if (Reflect.hasField(jsonFile, "pos_from_object"))
		{
			m_pos_from_object = jsonFile.pos_from_object;
		}
		super.fromFile(jsonFile);
	}

	private var m_pos:FlxPoint;

	override public function finishAction()
	{
		this.getParent().getParent().eventManager.broadcastEvent("EVENT_SLIDERPOS_SET");
		super.finishAction();
	}

	/**
	 * sets the position from the object origin.
	 */
	public function setPosFromObj()
	{
		var obj:DnaObject = getParent().getParent().getObjectByName(m_pos_from_object);
		setPosition(obj.getOrigin());
	}

	/**
	 * settter for the position where we want to move the slider to
	 */
	public function setPosition(pos:FlxPoint)
	{
		this.m_pos = pos;
	}

	/**
	 * in here we will set the slider position and make it visible (if not the case)
	 */
	override public function update(elapsed:Float)
	{
		if (m_pos_from_object != "")
		{
			this.setPosFromObj();
		}
		// trace("set slider pos.");
		var target:Slideable = cast getParent().getParent().getObjectByName(m_target_name);
		var slider = target.slider;

		slider.setPosition(m_pos.x - (slider.width / 2), cast(target, DnaObject).getOrigin().y - (slider.height / 2));
		// we do this so the slider is always on the foreground:
		var target_obj = cast(target, DnaObject);
		target_obj.removeChild(slider);

		target_obj.addChild(slider);

		slider.alpha = 1;

		this.finishAction();
	}
}
