package dnaobject;

import dnaobject.DnaObject;
import flixel.util.FlxDestroyUtil.IFlxDestroyable;

/**
 * this is the interface for a DnaComponent.
 * A DnaComponent is used to encapsulate the behaviour of objects.
 * the dnacomponents update function will be run during the parent objects update function
 * we will create them using a Dnafactory.
 * in the fromFile function we will read all hardcoded values from a file
 * (not really from file because we cannot do that on web but from a definition in archtypes etc.)
 *
 */
interface DnaComponent extends IFlxDestroyable
{
	/**
	 * destructor.
	 */
	public function destroy():Void;

	/**
	 * fromFile(path:String):
	 * each DnaComponent is able to get its own parameters from a file.
	 * TODO: refactor!
	 * reading from files is not possible for web target.
	 * we will use dynamic objects that we define in the proto folder instead.
	 * @param jsonFile - the jsonFile object to read from. should be the output of jsonParse.
	 */
	public function fromFile(jsonFile:Dynamic):Void;

	/**
	 * update - this function will be called every frame by the parent object.
	 * in here we will change the parent objects variables etc..
	 *
	 * @param elapsed
	 */
	public function update(elapsed:Float):Void;

	/**
	 * getter for parent object.
	 */
	public function getParent():DnaObject;

	/**
	 * setter for Parent object
	 */
	public function setParent(parent:DnaObject):Void;

	private var active:Bool;

	/**
	 * setter for active property. will be used to disable stuff
	 * @param value
	 */
	public function setActive(value:Bool):Void;

	/**
	 * this is the dna object that this component is a part of.
	 */
	private var m_parent_obj:DnaObject;

	/**
	 * unique id for each component
	 */
	public final id:Int;

	/**
	 * this member will be the component type. it should be set when the component is created.
	 * as a type cant change during runtime it is final.
	 */
	public final comp_type:String;

	public function onHaveParent():Void;
}
