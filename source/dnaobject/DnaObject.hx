package dnaobject;

import dnaobject.DnaComponent;
import flixel.FlxObject;
import flixel.group.FlxGroup;
import flixel.math.FlxPoint;
import flixel.util.FlxDestroyUtil.IFlxDestroyable;

/**
 * this is the interface for a DnaObject.
 * A Dnaobject will be a collectoin of the objects used in a trial.
 * so for example a single button or a complete calculator might be implemented as an Dnaobject.
 * we will create them using a Dnafactory.
 * in the fromFile function we will read all hardcoded values (position etc.)
 * from a file.
 */
interface DnaObject extends IFlxDestroyable
{
	private var active:Bool;

	/**
	 * destructor.
	 */
	public function destroy():Void;

	/**
	 * this is the name of the object. can be used for identification within a state or something..
	 */
	public var obj_name:String;

	/**
	 * fromFile(path:String):
	 * each DnaObject is able to get its own parameters from a file.
	 * TODO: refactor!
	 * reading from files is not possible for web target.
	 * we will use dynamic objects that we define in the proto folder instead.
	 * @param jsonFile - the jsonFile object to read from. should be the output of jsonParse.
	 */
	public function fromFile(jsonFile:Dynamic):Void;

	/**
	 * update - in this function we will call all of our components update functions.
	 * @param elapsed
	 */
	public function update(elapsed:Float):Void;

	/**
	 * this member will be the object type. it should be set when the object is created.
	 * as a type cant change during runtime it is final.
	 */
	public final obj_type:String;

	/**
	 * removes a component by component type.
	 * @param type - the type to remove.
	 */
	public function removeComponentByType(type:String):Void;

	/**
	 * gets the first component by component type.
	 * @param type - the type to get.
	 */
	public function getComponentByType(type:String):DnaComponent;

	/**
	 * this function removes a FlxObject to the DnaObjects childrens list.
	 * @param child - the FlxObject to remove.
	 */
	public function removeChild(child:FlxObject):Void;

	/**
	 * this function adds a FlxObject to the DnaObjects childrens list.
	 * @param child - the FlxObject to add.
	 * @param position - the position where to add the child on the parent state.
	 */
	public function insertChild(child:FlxObject, position:Int):Void;

	/**
	 * TODO: maybe define this as static function somewhere so we can use it in our fromFile functions without
	 * having to write it 100 times..
	 * addComponent - this function adds a component to the component list.
	 * @param component
	 */
	public function addComponent(component:DnaComponent):Void;

	/**
	 * removeComponent - this function removes component with a specified id from the list.
	 */
	public function removeComponent(component_id:Int):Void;

	/**
	 * removes all components. used in dtor.
	 */
	public function removeAllComponents():Void;

	/**
	 * gets all the children in the m_children array.
	 * @return FlxGroup<FlxObject>
	 */
	public function getChildren():Array<FlxObject>;

	/**
	 * this function moves the object (with all the children) to the new position.
	 * @param position - the target position to move to.
	 */
	public function moveTo(x:Float, y:Float):Void;

	/**
	 * this function adds a FlxObject to the DnaObjects childrens list.
	 * @param child - the FlxObject to add.
	 */
	public function addChild(child:FlxObject):Void;

	/**
	 * returns children as a FlxtypedGroup so we can easily add it to our scenes.
	 * @return FlxTypedGroup<FlxObject>
	 */
	public function getFlxGroup():FlxTypedGroup<FlxObject>;

	/**
	 * the component list.
	 * here we will add all our components we use
	 */
	private var m_component_list:Array<DnaComponent>;

	/**
	 * setter for origin
	 */
	public function setOrigin(x:Float, y:Float):Void;

	/**
	 * getter for origin
	 * @return FlxPoint
	 */
	public function getOrigin():FlxPoint;

	/**
	 * this is the origin point or anchor point for this object.
	 */
	private var origin:FlxPoint;

	/**
	 * these are the children of our object.
	 * for example sprites etc..
	 */
	private var m_children_list:Array<FlxObject>;

	/**
	 * unique ID for dnaObjects
	 */
	public final id:Int;

	/**
	 * setParent - sets the parent state of the current object.
	 * @param parent - the state to set as parent.
	 */
	public function setParent(parent:DnaState):Void;

	/**
	 * getParent - getter for parent state.
	 * @return DnaState - the parent state.
	 */
	public function getParent():DnaState;

	/**
	 * calculates the height of all the children in the curent configuration
	 * @return Float
	 */
	public function getHeight():Int;

	/**
	 * setter for active property. will be used to disable stuff
	 * @param value
	 */
	public function setActive(value:Bool):Void;

	/**
	 * calculates the width of all the children in the curent configuration
	 * @return Float
	 */
	public function getWidth():Int;

	/**
	 * in here we get 4 max distances from our origin.
	 * we want to view our DnaObject as a rectangle to position it
	 * nicely.
	 * therefore we have to get the max distances from its origin
	 * because there can be many objects in a DnaObject that are at different positions.
	 *
	 * here is a small drawing of what we do here:
	 * max_left | max_rigt
	 * ________________
	 * |               |= max_up_from_origin
	 * |      .origin  |
	 * |               | max_down_from_origin
	 * -----------------
	 *
	 * the max_left and max_up will be negative values. this is why we use
	 * Negative infinity and compare using <.
	 *
	 * @return array - An array with the values max_left max_right max up and max_down in this order.
	 */
	public function getMaxLeftRightUpDownFromOrigin():Array<Float>;

	/**
	 * the parent state of this object.
	 */
	private var m_parent_state:DnaState;

	/**
	 * register events in here
	 */
	public function registerEvents():Void;
}
