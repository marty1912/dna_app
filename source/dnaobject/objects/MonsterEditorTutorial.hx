package dnaobject.objects;

import dnaobject.objects.MonsterObject.MontiStateIdle;
import dnaobject.objects.MonsterObject.MontiStateTalk;
import dnadata.DnaDataManager;
import dnaobject.components.UserButtonComponent;
import dnaEvent.DnaEventSubscriber;
import dnaobject.objects.DnaButtonObject.ButtonStatePressed;
import dnaobject.objects.DotsTaskObject.DotsObjectStateHidden;
import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

/**
 * this is the class that handles giving our trial parameters to the correct objects.
 */
class MonsterEditorTutorial implements DnaObject implements DnaEventSubscriber extends DnaObjectBase
{
	/**
	 * overwritten ctor.
	 */
	public function new()
	{
		super("MonsterEditorTutorial");
	}

	override public function onHaveParent() {}

	public function getNotified(event_name:String, ?params:Null<Any>) {}

	public function after_init()
	{
		trace("init done.");
		monster_obj.setNextState(new MontiStateIdle());
		enableButtons();
	}

	public function disableButtons() {

		for(button in buttons_obj){
			button.removeComponentByType("UserButtonComponent");
		}
	}

	public function enableButtons() {

		for(button in buttons_obj){
			var cmp:UserButtonComponent  = cast DnaComponentFactory.create("UserButtonComponent");
			button.addComponent(cmp);
		}

	}

	public final monsterEditorTutSeenKey = "MonsterEditorTutSeen";
	override public function onReady()
	{
		super.onReady();

		action_init_obj = cast this.getParent().getObjectByName(getNestedObjectName(action_init));
		action_fin_obj = cast this.getParent().getObjectByName(getNestedObjectName(action_fin));
		monster_obj = cast getParent().getObjectByName(monster);

		this.buttons_obj = new Array<DnaButtonObject>();
		for(button in buttons){
			buttons_obj.push(cast this.getParent().getObjectByName(button));
		}


		if(DnaDataManager.instance.retrieveData(monsterEditorTutSeenKey) == true){
			// the user has already seen the tutorial so we do nothing.
		}
		else{
			DnaDataManager.instance.storeData(monsterEditorTutSeenKey,true);
			monster_obj.setNextState(new MontiStateTalk());
			disableButtons();
			action_init_obj.startQueue(after_init);
		}
	}

	public var action_fin:String;
	public var action_init:String;
	public var monster:String;
	public var buttons:Array<String>;

	public var action_fin_obj:ActionHandlerObject;
	public var action_init_obj:ActionHandlerObject;
	public var buttons_obj:Array<DnaButtonObject>;
	public var monster_obj:MonsterObject;

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
		if (Reflect.hasField(jsonFile, "buttons"))
		{
			buttons = jsonFile.buttons;
		}

		if (Reflect.hasField(jsonFile, "monster"))
		{
			monster = jsonFile.monster;
		}

	}

	public override function update(elapsed:Float) {}
}
