module character.technology.Technology;

import character.Player;
import std.algorithm;

static Technology[] allTechnologies;

/**
 * A class that defines a technology
 * A technology is a gate for some feature of the game
 * Not all technologies can be immediately available
 */
abstract class Technology {

    Technology[] dependencies;          ///The technology(ies) required to research this one
    string name;                        ///The name of this technology
    //TODO add some requirement field here?

    /**
     * Constructor for any technology
     * Will add the technology to a list of all technologies
     */
    this(){
        allTechnologies ~= this;
    }

    /**
    * Returns a list of technologies that would be helped by acquiring this technology
    */
    Technology[] leadsTo(){
        Technology[] leads;
        foreach(tech; allTechnologies){
            if(tech.dependencies.canFind(this)){
                foreach(candidate; tech ~ tech.leadsTo()){
                    if(!leads.canFind(candidate)){
                        leads ~= candidate;
                    }
                }
            }
        }
        return leads;
    }

    abstract bool canBeUnlockedBy(Player player); ///Returns whether a certain player can unlock the current technology

    /**
     * An action that happens when a player unlocks a technology
     */
    abstract void onUnlock(Player player){
        player.researched ~= this;
    }

}
