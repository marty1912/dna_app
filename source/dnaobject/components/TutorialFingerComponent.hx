package dnaobject.components;

import dnaobject.objects.DnaButtonObject;
import dnaobject.objects.SpriteObject;
import flixel.math.FlxPoint;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

/**
 * this class is used so we can read events from a file.
 */
class TutorialFingerComponent implements DnaComponent extends DnaActionBase
{
	/**
	 * ctor
	 */
	public function new()
	{
		super("TutorialFingerComponent");
	}

	public var finger:SpriteObject;

	public override function onHaveParent()
	{
		super.onHaveParent();
		this.finger = cast this.getParent();
	}

	public function moveToButtonAndPress(btn:DnaButtonObject, onFinished:Void->Void, ?duration:Float = 2)
	{
		var to = btn.button.getMidpoint();
		FlxTween.tween(finger, {pos_x: to.x, pos_y: to.y}, duration, {
			startDelay: 0,
			ease: FlxEase.cubeInOut,
			onComplete: function(tween:FlxTween)
			{
				pressButton(btn, onFinished);
			}
		});
	}

	public function pressButton(btn:DnaButtonObject, onFinished:Void->Void, ?duration:Float = 0.5)
	{
		btn.setNextState(new ButtonStatePressed());
		var to = btn.button.getMidpoint();
		FlxTween.tween(finger, {pos_x: to.x, pos_y: to.y}, duration, {
			startDelay: 0,
			ease: FlxEase.cubeInOut,
			onComplete: function(tween:FlxTween)
			{
				btn.setNextState(new ButtonStateNormal());
				onFinished();
			}
		});
	}

	public function moveToPos(to:FlxPoint, onFinished:Void->Void, ?duration:Float = 2)
	{
		FlxTween.tween(finger, {pos_x: to.x, pos_y: to.y}, duration, {
			startDelay: 0,
			ease: FlxEase.cubeInOut,
			onComplete: function(tween:FlxTween)
			{
				onFinished();
			}
		});
	}

	/**
	 * in here we read our params from a file..
	 * @param jsonFile - the jsonFile object to read from. should be the output of jsonParse.
	 */
	override public function fromFile(jsonFile:Dynamic):Void
	{
		super.fromFile(jsonFile);
	}

	/**
	 * @param elapsed
	 */
	override public function update(elapsed:Float) {}
}
