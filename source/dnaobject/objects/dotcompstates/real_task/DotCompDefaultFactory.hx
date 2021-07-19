package dnaobject.objects.dotcompstates.real_task;

import dnaobject.interfaces.IStateFactory;

class DotCompDefaultFactory implements IStateFactory{

    
    public function new(){}
    public function create(){
        trace("default factory create.");
        return new InitialState();
    }

}