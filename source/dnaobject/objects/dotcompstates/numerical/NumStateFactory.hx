package dnaobject.objects.dotcompstates.numerical;

import dnaobject.interfaces.IStateFactory;

class NumStateFactory implements IStateFactory{

    
    public function new(){}

    public function create(){
        trace("numerical factory create");
        return new NumInitialState();
    }

}