package dnaobject.components;

/**
 * this class will make an object appear based on an event.
 */
class ActionMoveToAndPressComponent implements DnaComponent extends DnaActionGroup
{
	public var delay_press_time:ActionDelayComponent;
	public var delay_before_press:ActionDelayComponent;
	public var action_move:ActionMoveToComponent;
	public var action_press:ActionSetButtonStateComponent;
	public var action_release:ActionSetButtonStateComponent;
	public var action_do_shrink:ActionShrinkComponent;
	public var action_undo_shrink:ActionShrinkComponent;

	/**
	 * ctor
	 */
	public function new()
	{
		super("ActionMoveToAndPressComponent");
		delay_press_time = cast DnaComponentFactory.create("ActionDelayComponent");
		delay_before_press = cast DnaComponentFactory.create("ActionDelayComponent");
		action_move = cast DnaComponentFactory.create("ActionMoveToComponent");
		action_press = cast DnaComponentFactory.create("ActionSetButtonStateComponent");
		action_release = cast DnaComponentFactory.create("ActionSetButtonStateComponent");
		action_do_shrink = cast DnaComponentFactory.create("ActionShrinkComponent");
		action_undo_shrink = cast DnaComponentFactory.create("ActionShrinkComponent");

		this.addActionToQueue(action_move);
		this.addActionToQueue(delay_before_press);
		this.addActionToQueue(action_do_shrink);
		this.addActionToQueue(action_press);
		this.addActionToQueue(delay_press_time);
		this.addActionToQueue(action_undo_shrink);
		this.addActionToQueue(action_release);
	}

	public var m_target_button:String;
	public var m_delay:String;

	/**
	 * [Description]
	 */
	public function setupActions()
	{
		// trace("setting taget name: ", this.m_target_name);
		this.action_move.setTarget(this.m_target_name);
		action_move.m_to_object = this.m_target_button;
		action_move.m_speed = speed;
		action_move.m_to_x = 50;

		action_press.setTarget(m_target_button);
		action_press.state = "PRESSED";
		action_release.setTarget(m_target_button);
		action_release.state = "NORMAL";
		delay_before_press.m_delay_time = this.delay_before;
		delay_press_time.m_delay_time = this.press_time;

		action_do_shrink.m_to_x = 0.95;
		action_do_shrink.m_to_y = 0.95;
		action_do_shrink.setTarget(this.m_target_name);
		action_undo_shrink.m_to_x = 1;
		action_undo_shrink.m_to_y = 1;
		action_undo_shrink.setTarget(this.m_target_name);
	}

	public var delay_before:Float = 0.1;
	public var press_time:Float = 0.5;
	public var speed:Float = 400;

	/**
	 * in here we read our params from a file..
	 * @param jsonFile - the jsonFile object to read from. should be the output of jsonParse.
	 */
	override public function fromFile(jsonFile:Dynamic):Void
	{
		if (Reflect.hasField(jsonFile, "target_button"))
		{
			this.m_target_button = jsonFile.target_button;
		}
		if (Reflect.hasField(jsonFile, "delay_before"))
		{
			this.delay_before = jsonFile.delay_before;
		}
		if (Reflect.hasField(jsonFile, "press_time"))
		{
			this.press_time = jsonFile.press_time;
		}
		// TODO:
		// 1. create a new actionhandler with unique name and add it to the state
		// 2. create the first action we need with on_event = some unique id.
		// 3. create the other actions with on_event = seq
		// 4. register as listener for unique end id
		// 5. add actionFireEvent as last action  with unique end id.
		// 6. fire unique start event.
		// 7. on unique end event do the following:
		// - remove the actionhandler with unique name from the state
		// - finishAction()
		// for  doing all the overhead (everything except step 3) it would probably be nice to have a base class to inherit from.
		// call it ActionGroupComponent or something
		super.fromFile(jsonFile);
		setupActions();
	}

	/**
	 * in this function we will make the object appear..
	 * @param elapsed
	 */
	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
