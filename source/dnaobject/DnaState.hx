package dnaobject;

import Assertion.assert;
import constants.DnaConstants;
import dnaEvent.DnaEventManager;
import dnaobject.DnaObject;
import dnaobject.objects.TrialHandlerObject;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.util.FlxDestroyUtil.IFlxDestroyable;
import haxe.Json;
import haxe.Timer;
import openfl.utils.Assets;

/**
 * this is the DnaState class. it is the only Dna something that is not defined as an interface.
 * this is the case because we want to be able to use this in the same manner as the FlxStates.
 * The DnaState does some things differently from the FlxState.
 * For example we will add DnaObjects instead of FlxObjects.
 * Also each DnaObject will have a reference to its parent state so we can add stuff like sprites from our components and objects at runtime
 */
class DnaState extends FlxSubState implements IFlxDestroyable
{
	public var m_json_file:String;
	public var keep_alive:Bool = false;

	public var eventManager:DnaEventManager = new DnaEventManager();

	/**
	 * list of objects in this state.
	 */
	private var m_objects_list:Array<DnaObject>;

	/**
	 * this is the function that will be called whenever we call the close function on this substate.
	 */
	public var onCloseCalled:Void->Void = null;

	/**
	 * this thing will be used by almost all of our states so we put it here.
	 */
	// private var trial_handler:TrialHandlerObject;
	public final state_type:String;

	/**
	 * in the ctor we create this DnaState from a file
	 * @param jsonFile - the dynamic object where we get all of our stuff.
	 */
	public function new(type:String)
	{
		#if cpp
		// run garbage collection on cpp targets.
		cpp.vm.Gc.run(true);
		cpp.vm.Gc.compact();
		#end

		super();
		// this.persistentUpdate = true;
		m_objects_list = new Array<DnaObject>();
		this.state_type = type;
	}

	/**
	 * in here we fire the onCreate event.
	 */
	override public function create()
	{
		var t_start = Timer.stamp();
		// eventManager.clearEvents();
		// this.fromFile(this.m_json_file);
		for (obj in this.getObjectList())
		{
			if (!obj.ready)
			{
				obj.onReady();
			}
		}
		eventManager.broadcastEvent("onCreate");
		var t_end = Timer.stamp();
	}

	/**
	 * destructor. in here we destroy all of our objects.
	 */
	override public function destroy():Void
	{
		if (this.keep_alive)
		{
			return;
		}

		super.destroy();
		for (obj in this.getObjectList())
		{
			obj.destroy();
		}
	}

	/**
	 * addObject - adds an object to the objects list and to the state.
	 * @param object
	 */
	public function addObject(object:DnaObject)
	{
		this.m_objects_list.push(object);
		object.setParent(this);
		/*
			for (child in object.getChildren())
			{
				this.add(child);
			}
		 */
	}

	public function printAllObjectNames()
	{
		trace("---------------------------------------");
		var index = 0;
		for (name in getAllObjectNames())
		{
			trace(index, "name:", name);
			index++;
		}

		trace("---------------------------------------");
	}

	public function getAllObjectNames():Array<String>
	{
		var all_names = new Array<String>();
		var all_children:Array<DnaObject> = getObjectList();

		for (obj in all_children)
		{
			all_names.push(obj.obj_name);
		}
		return all_names;
	}

	/**
	 * getObjectFromParentByName - helper function to find an object by name
	 * @param name
	 */
	public function getObjectByName(name:String)
	{
		var all_children:Array<DnaObject> = getObjectList();

		for (obj in all_children)
		{
			if (obj.obj_name == name)
			{
				return obj;
			}
		}
		return null;
	}

	/**
	 * getter function for our object list.
	 */
	public function getObjectList()
	{
		return this.m_objects_list;
	}

	/**
	 * removeObject - removes an DnaObject from the object list and from the state.
	 * @param id - the object id of the object
	 */
	public function removeObject(id:Int)
	{
		for (object in this.m_objects_list)
		{
			if (object.id == id)
			{
				object.setParent(null);
				this.m_objects_list.remove(object);
				return;
			}
		}
		// if we are here the object was not even in the list..
		assert(false);
	}

	/**
	 * removes all Objects from our state..
	 */
	public function removeAllObjects()
	{
		while (this.m_objects_list.length != 0)
		{
			var obj = this.m_objects_list.pop();
			obj.setParent(null);
			obj.destroy();
		}
	}

	override public function close()
	{
		super.close();

		if (this.onCloseCalled != null)
		{
			this.onCloseCalled();
		}
	}

	/**
	 * implementation of fromFile for states.
	 * @param jsonFile - dynamic object with all the infos we need.
	 * for states this should be of the form
	 * type: yourtypehere,
	 * objects: [{yourobjectshere}]
	 * etc
	 *
	 */
	public function fromFile(jsonString:String):Array<DnaObject>
	{
		var jsonFile = Json.parse(jsonString);

		// assert(jsonFile.type == this.state_type);
		var created_objects = new Array<DnaObject>();
		var objects:Array<Dynamic> = jsonFile.objects;
		for (obj in objects)
		{
			created_objects = created_objects.concat(objectFromFile(obj));
		}
		return created_objects;
	}

	/**
	 * adds a object group from file
	 * @param path 
	 */
	public function objectFromFile(obj:Dynamic):Array<DnaObject>
	{
		var created_objects = new Array<DnaObject>();
		if (obj.type == DnaConstants.OBJECT_GROUP)
		{
			created_objects = created_objects.concat(fromFile(Assets.getText(obj.path)));
		}
		else
		{
			var to_add = DnaObjectFactory.create(obj.type);
			this.addObject(to_add);
			to_add.fromFile(obj);
			created_objects.push(to_add);
		}
		return created_objects;
	}

	private var m_onload_fired:Bool = false;

	/**
	 * our overwritten update method calls the update method of all objects that were added to this class.
	 * @param elapsed
	 */
	override public function update(elapsed:Float)
	{
		var start = haxe.Timer.stamp();
		if (!m_onload_fired)
		{
			eventManager.broadcastEvent("onStart");
			m_onload_fired = true;
		}
		// super.update(elapsed);
		for (obj in this.m_objects_list)
		{
			obj.update(elapsed);
		}
		super.update(elapsed);
		var end = haxe.Timer.stamp();
	}
}
