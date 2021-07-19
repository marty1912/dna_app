package dnaobject.objects.dotcompstates.no_time;
import dnaobject.interfaces.IStateFactory;

class DotCompTutorialFactory implements IStateFactory{

    public function new(){}
    public function create(){
        return new Initial();
    }

}