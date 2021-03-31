package dnaobject.interfaces;

import dnaEvent.DnaEventSubscriber;

/**
 * this interface is for our data save and load stuff for our different trial objects
 * like numline, dotcompare and so on..
 */
interface TaskObject
{
	public var obj_name:String;

	/**
	 * each task must know how to adjust its own parameters.
	 * @param params
	 */
	public function setParams(params:Dynamic):Void;

	/**
	 * each Task should know how to collect its own data.
	 * @return Dynamic
	 */
	public function getData():Dynamic;

	/**
	 * returns wheter or not the task was answered correctly (should be possible to say for most taskObjects.)
	 * 
	 * @return String. either 
	 * DnaConstants.TASK_CORRECT
	 * DnaConstants.TASK_INCORRECT
	 * DnaConstants.TASK_TIMEDOUT_FEEDBACK
	 */
	public function isCorrect():String;
}
