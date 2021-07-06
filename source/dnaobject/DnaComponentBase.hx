package dnaobject;

import dnaobject.DnaObject;

/**
 * this is the base class for a DnaComponent.
 * A DnaComponent is used to encapsulate the behaviour of objects.
 * the dnacomponents update function will be run during the parent objects update function
 * we will create them using a Dnafactory.
 * in the fromFile function we will read all hardcoded values from a file
 * (not really from file because we cannot do that on web but from a definition in archtypes etc.)
 *
 */
class DnaComponentBase
{
	/**
	 * we use this static variable to get a unique id for each component.
	 */
	static var s_comp_id:Int = 0;

	/**
	 * called when the state is done with creating
	 */
	public function onReady():Void {}

	/**
	 * private ctor so nobody can instantate this class directly.
	 * @param comp_type
	 */
	private function new(comp_type:String)
	{
		this.comp_type = comp_type;
		this.id = s_comp_id++;
	}

	/**
	 * destructor. override this to delete everything you use in the specific component classes..
	 */
	public function destroy():Void
	{
		if (this.getParent() != null)
		{
			this.setParent(null);
		}
	};

	/**
	 * fromFile(path:String):
	 * each DnaComponent is able to get its own parameters from a file.
	 * TODO: refactor!
	 * reading from files is not possible for web target.
	 * we will use dynamic objects that we define in the proto folder instead.
	 * @param jsonFile - the jsonFile object to read from. should be the output of jsonParse.
	 */
	public function fromFile(jsonFile:Dynamic):Void
		throw "Override this function!!";

	/**
	 * update - this function will be called every frame by the parent object.
	 * in here we can change the parent objects variables etc..
	 *
	 * @param elapsed
	 */
	public function update(elapsed:Float):Void {}

	// throw "Override this function!!";

	/**
	 * getter for parent object.
	 */
	public function getParent():DnaObject
	{
		return this.m_parent_obj;
	}

	private var active:Bool = true;

	/**
	 * setter for active property. will be used to disable stuff
	 * it is up to the component if we still will run or if we stop doing anything
	 * @param value
	 */
	public function setActive(value:Bool):Void
	{
		this.active = value;
	}

	/**
	 * setter for Parent object.
	 */
	public function setParent(parent:DnaObject):Void
	{
		this.m_parent_obj = parent;

		if (this.m_parent_obj != null)
		{
			onHaveParent();
		}
	}

	/**
	 * onHaveParent() - this function is called when we have a valid state reference.
	 * this is the function you want to override if you need to do stuff with the state.
	 */
	public function onHaveParent():Void {}

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
}
