package dnaobject;

import dnaobject.DnaComponent;
import flixel.FlxObject;
import flixel.FlxObject;
import flixel.FlxObject;
import flixel.group.FlxGroup;
import flixel.math.FlxPoint;
import flixel.util.FlxDestroyUtil.IFlxDestroyable;
import flixel.util.FlxDestroyUtil;

/**
 * this is the Base implementation for a DnaObject.
 * A Dnaobject will be a collectoin of the objects used in a trial.
 * so for example a single button or a complete calculator might be implemented as an Dnaobject.
 * we will create them using a Dnafactory.
 * in the fromFile function we will read all hardcoded values (position etc.)
 * from a file.
 */
class DnaObjectBase implements IFlxDestroyable
{
	/**
	 * this is the name of the object. it is used so we are able to find it
	 * in case we need to do something with it
	 */
	public var obj_name:String;

	/**
	 * static variable used to get a unique id count.
	 */
	static var s_obj_id:Int = 0;

	/**
	 * private constructor so nobody can create an actual instance of this class.
	 *
	 */
	private function new(obj_type:String)
	{
		this.obj_type = obj_type;
		this.id = s_obj_id++;
	}

	/**
	 * destructor. - note that this is not really a destructor but something similar as haxe does not have destructors..
	 * in here we remove all our components and destroy them as well
	 */
	public function destroy():Void
	{
		this.removeAllComponents();
		this.removeAllChildren();
		this.origin.put();
	}

	/**
	 * fromFile(path:String):
	 * each DnaObject is able to get its own parameters from a file.
	 * TODO: refactor!
	 * reading from files is not possible for web target.
	 * we will use dynamic objects that we define in the proto folder instead.
	 * @param jsonFile - the jsonFile object to read from. should be the output of jsonParse.
	 */
	public function fromFile(jsonFile:Dynamic):Void
	{
		if (jsonFile == null)
		{
			return;
		}

		if (Reflect.hasField(jsonFile, "name"))
		{
			this.obj_name = jsonFile.name;
		}
		if (Reflect.hasField(jsonFile, "active"))
		{
			this.setActive(jsonFile.active);
		}
		if (Reflect.hasField(jsonFile, "components"))
		{
			var components:Array<Dynamic> = jsonFile.components;

			for (comp in components)
			{
				var to_add = DnaComponentFactory.create(comp.type);
				to_add.fromFile(comp);
				addComponent(to_add);
			}
		}
	};

	/**
	 * removes a component by component type.
	 * @param type - the type to remove.
	 */
	public function removeComponentByType(type:String):Void
	{
		for (comp in this.m_component_list)
		{
			if (comp.comp_type == type)
			{
				this.removeComponent(comp.id);
			}
		}
	}

	/**
	 * gets the first component by component type.
	 * @param type - the type to get.
	 */
	public function getComponentByType(type:String):DnaComponent
	{
		for (comp in this.m_component_list)
		{
			if (comp.comp_type == type)
			{
				return comp;
			}
		}
		return null;
	}

	/**
	 * update - in this function we will call all of our components update functions.
	 * @param elapsed
	 */
	public function update(elapsed:Float):Void
	{
		/* this is done by the state.
			for (child in this.m_children_list)
			{
				if (child.active)
				{
					child.update(elapsed);
				}
			}
		 */
		for (component in this.m_component_list)
		{
			component.update(elapsed);
		}
	};

	/**
	 * this member will be the object type. it should be set when the object is created.
	 * as a type cant change during runtime it is final.
	 */
	public final obj_type:String;

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
	public function getMaxLeftRightUpDownFromOrigin():Array<Float>
	{
		var max_left_from_origin = Math.POSITIVE_INFINITY;

		var max_up_from_origin = Math.POSITIVE_INFINITY;
		var max_down_from_origin = Math.NEGATIVE_INFINITY;
		var max_right_from_origin = Math.NEGATIVE_INFINITY;

		for (child_b in getChildren())
		{
			var child:FlxObject = cast child_b;
			var offset_left = child.x - getOrigin().x;
			var offset_up = child.y - getOrigin().y;
			var offset_down = (child.y + child.height) - getOrigin().y;
			var offset_right = (child.x + child.width) - getOrigin().x;

			if (offset_left < max_left_from_origin)
			{
				max_left_from_origin = offset_left;
			}
			if (offset_up < max_up_from_origin)
			{
				max_up_from_origin = offset_up;
			}
			if (offset_down > max_down_from_origin)
			{
				max_down_from_origin = offset_down;
			}
			if (offset_right > max_right_from_origin)
			{
				max_right_from_origin = offset_right;
			}
		}
		return [
			max_left_from_origin,
			max_right_from_origin,
			max_up_from_origin,
			max_down_from_origin
		];
	}

	/**
	 * calculates the height of all the children in the curent configuration
	 * @return Float
	 */
	public function getHeight():Int
	{
		var leftrightupdown = getMaxLeftRightUpDownFromOrigin();

		return Std.int(Math.floor((-leftrightupdown[2]) + leftrightupdown[3]));
	}

	/**
	 * calculates the width of all the children in the curent configuration
	 * @return Float
	 */
	public function getWidth():Int
	{
		var leftrightupdown = getMaxLeftRightUpDownFromOrigin();

		return Std.int(Math.floor((-leftrightupdown[0]) + leftrightupdown[1]));
	}

	private var active:Bool = true;

	/**
	 * setter for active property. will be used to disable stuff
	 * @param value
	 */
	public function setActive(value:Bool):Void
	{
		this.active = value;
		for (child in this.getChildren())
		{
			child.active = this.active;
		}
		for (component in m_component_list)
		{
			component.setActive(this.active);
		}

		return;
	}

	/**
	 * TODO: maybe define this as static function somewhere so we can use it in our fromFile functions without
	 * having to write it 100 times..
	 * addComponent - this function adds a component to the component list.
	 * @param component
	 */
	public function addComponent(component:DnaComponent):Void
	{
		this.m_component_list.push(component);
		component.setParent(cast this);
	};

	/**
	 * removeComponent - this function removes component with a specified id from the list.
	 */
	public function removeComponent(component_id:Int):Void
	{
		for (component in this.m_component_list)
		{
			if (component.id == component_id)
			{
				component.setParent(null);
				this.m_component_list.remove(component);
				return;
			}
		}
	};

	/**
	 * removes all the children (FlxObjects) from this DnaObject.
	 */
	public function removeAllChildren():Void
	{
		while (this.m_children_list.length != 0)
		{
			var child = this.m_children_list.pop();
			this.getParent().remove(child);
			FlxDestroyUtil.destroy(child);
		}
	}

	/**
	 * removes all components. used in dtor.
	 */
	public function removeAllComponents():Void
	{
		while (this.m_component_list.length != 0)
		{
			var comp = this.m_component_list.pop();
			comp.setParent(null);
			FlxDestroyUtil.destroy(comp);
		}
	}

	/**
	 * returns the children as a FlxGroup object that we can add to our scenes etc.
	 */
	public function getFlxGroup()
	{
		var group = new FlxTypedGroup<FlxObject>();
		for (child in this.getChildren())
		{
			group.add(child);
		}
		return group;
	}

	/**
	 * gets all the children in the m_children array.
	 * @return FlxGroup<FlxObject>
	 */
	public function getChildren():Array<FlxObject>
	{
		return this.m_children_list;
	}

	/**
	 * unique ID for dnaObjects
	 */
	public final id:Int;

	/**
	 * setter for origin
	 */
	public function setOrigin(x:Float, y:Float):Void
	{
		this.origin.set(x, y);
	}

	/**
	 * getter for origin
	 * @return FlxPoint
	 */
	public function getOrigin():FlxPoint
	{
		return this.origin;
	}

	/**
	 * this function adds a FlxObject to the DnaObjects childrens list.
	 * @param child - the FlxObject to add.
	 */
	public function addChild(child:FlxObject):Void
	{
		this.m_children_list.push(child);
		if (this.getParent() != null)
		{
			// adds the child
			// this.getParent().add(child);
			// always adds object as topmost for this object.
			var top_most_pos = 0;
			var parent_members = this.getParent().members;
			for (child in this.getChildren())
			{
				var index = parent_members.indexOf(child);
				if (index > top_most_pos)
				{
					top_most_pos = index;
				}
			}
			this.getParent().insert(top_most_pos + 1, child);
		}
	}

	/**
	 * this function adds a FlxObject to the DnaObjects childrens list.
	 * @param child - the FlxObject to add.
	 */
	public function insertChild(child:FlxObject, position:Int):Void
	{
		this.m_children_list.push(child);
		if (this.getParent() != null)
		{
			// adds the child on a certain position in the parents list.
			this.getParent().insert(position, child);
		}
	}

	/**
	 * this function removes a FlxObject to the DnaObjects childrens list.
	 * @param child - the FlxObject to add.
	 */
	public function removeChild(child:FlxObject):Void
	{
		this.m_children_list.remove(child);

		if (this.getParent() != null)
		{
			this.getParent().remove(child);
		}
	}

	/**
	 * this function moves the object (with all the children) to the new position.
	 * @param position - the target position to move to.
	 */
	public function moveTo(x:Float, y:Float):Void
	{
		var offset_x = x - this.getOrigin().x;
		var offset_y = y - this.getOrigin().y;
		for (child in this.getChildren())
		{
			var child_ob:FlxObject = cast child;
			var old_pos = child_ob.getPosition();
			child_ob.setPosition(offset_x + old_pos.x, old_pos.y + offset_y);
		}
		this.setOrigin(x, y);
	}

	/**
	 * this is the origin point or anchor point for this object.
	 */
	private var origin:FlxPoint = FlxPoint.get();

	/**
	 * the component list.
	 * here we will add all our components we use
	 */
	private var m_component_list:Array<DnaComponent> = [];

	/**
	 * these are the children of our object.
	 * for example sprites etc..
	 */
	private var m_children_list:Array<FlxObject> = [];

	/**
	 * setParent - sets the parent state of the current object.
	 * @param parent - the state to set as parent.
	 */
	public function setParent(parent:DnaState):Void
	{
		trace("set parent to:", parent);
		if (this.m_parent_state == parent)
		{
			return;
		}
		// if we have a new parent. we have to remove all of our children from the old one.
		if (this.m_parent_state != null)
		{
			for (child in this.m_children_list)
			{
				this.m_parent_state.remove(child);
			}
		}
		if (parent != null)
		{
			for (child in this.m_children_list)
			{
				parent.add(child);
			}
		}
		this.m_parent_state = parent;

		if (this.m_parent_state != null)
		{
			registerEvents();
		}
	}

	/**
	 * getParent - getter for parent state.
	 * @return DnaState - the parent state.
	 */
	public function getParent():DnaState
	{
		return this.m_parent_state;
	}

	/**
	 * the parent state of this object.
	 */
	private var m_parent_state:DnaState;

	/**
	 * register events in here
	 */
	public function registerEvents():Void {}
}
