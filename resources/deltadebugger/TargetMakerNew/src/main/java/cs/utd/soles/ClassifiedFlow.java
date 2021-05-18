package cs.utd.soles;

import com.utdallas.cs.alps.flows.Flow;

public class ClassifiedFlow {
    Flow f;
    boolean type;

    public ClassifiedFlow(Flow f, boolean type){
        this.f=f;
        this.type=type;
    }

    @Override
    public boolean equals(Object o){
        if(!(o instanceof ClassifiedFlow)){
            return false;
        }
        ClassifiedFlow comp =(ClassifiedFlow) o;
        return this.type==comp.type&&this.f.equals(comp.f);
    }

    public ClassifiedFlow compareUnclassifiedFlow(Flow f){

        if(this.f.equals(f)){
            return this;
        }
        return null;

    }

    @Override
    public String toString() {
        return "ClassifiedFlow{" +
                "f=" + f.getSink().getStatement() +" " +f.getSource().getStatement() +
                ", type=" + type +
                '}';
    }
}
