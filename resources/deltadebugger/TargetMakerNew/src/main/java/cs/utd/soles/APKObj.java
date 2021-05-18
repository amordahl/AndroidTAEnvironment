package cs.utd.soles;

import com.utdallas.cs.alps.flows.Flow;

import java.util.ArrayList;

public class APKObj {

    String name;
    ArrayList<ClassifiedFlow> flows;


    public APKObj(String name){
        this.name=name;
        flows = new ArrayList<>();
    }

    public void addFlow(ClassifiedFlow f){
        flows.add(f);
    }

    public ClassifiedFlow classifyFlow(Flow f){

        int i=0;
        for(ClassifiedFlow x: flows){
            //when this returns not null, this flow is found;
            if(x.compareUnclassifiedFlow(f)!=null){
                return flows.get(i);
            }
            i++;
        }
        return null;
    }

    //two apks are the same if they have the same name;
    @Override
    public boolean equals(Object o){
        if(!(o instanceof APKObj))
            return false;
        APKObj comp = (APKObj)o;
        return this.name.equals(comp.name);
    }

    @Override
    public String toString() {
        return "APKObj{" +
                "name='" + name + '\'' +
                ", flows=" + flows +
                '}';
    }
}
