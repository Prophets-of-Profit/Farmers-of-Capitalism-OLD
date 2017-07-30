module player.technology.Technology;

static Technology[] allTechnologies;

abstract class Technology {

    Technology[] dependencies;          ///The technology(ies) required to research this one
    string name;                        ///The name of this technology

    this(){
        allTechnologies ~= this;
    }

    /**
    * Returns a list of technologies that require this one to be researched.
    */
    Technology[] leadsTo(){
        Technology[] leads;
        foreach(tech; allTechnologies){
            if(tech.dependencies.canFind(this)){
                foreach(candidate; tech ~ tech.leadsTo()){
                    if(!leads.contains(candidate)){
                        leads ~= candidate;
                    }
                }
            }
        }
        return leads;
    }

    abstract bool canBeUnlockedBy(Player player);

    abstract void onUnlock(Player player);

}