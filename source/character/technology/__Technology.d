module character.technology.Technology;

import std.algorithm;
import std.conv;

import character.Player;

/**
 * A list of names of the technologies
 * Once added here, the technology will automatically get imported and added to allTechnologies
 */
enum TechnologyName{
    Agriculture
}

///A list of all of the technologies in the game
Technology[TechnologyName] allTechnologies;

/**
 * A class that defines a technology
 * A technology is a gate for some feature of the game
 * Not all technologies can be immediately available
 */
abstract class Technology {

    TechnologyName name;                ///The name of this technology
    TechnologyName[] dependencies;      ///The technology(ies) that immediately lead to this one

    /**
     * Returns a list of technologies that would be helped eventually by acquiring this technology
     * TODO actually look through and test this method; it may infinitely run :(
     */
    TechnologyName[] leadsTo(){
        TechnologyName[] leadsTo;
        foreach(dependant; this.immediatelyLeadsTo()){
            foreach(tech; dependant ~ allTechnologies[dependant].leadsTo()){
                if(!leadsTo.canFind(tech)){
                    leadsTo ~= tech;
                }
            }
        }
        return leadsTo;
    }

    /**
     * Returns a list of technologies that would be helped immediately by acquiring this technology
     */
    TechnologyName[] immediatelyLeadsTo(){
        TechnologyName[] leadsTo;
        foreach(tech; allTechnologies.byValue){
            if(tech.dependencies.canFind(this.name) && !leadsTo.canFind(tech.name)){
                leadsTo ~= tech.name;
            }
        }
        return leadsTo;
    }

    /**
     * An action that happens when a player unlocks a technology
     */
    void onUnlock(Player player){
        player.researched ~= this.name;
    }

    bool canBeUnlockedBy(Player player); ///Returns whether a certain player can unlock the current technology

}
