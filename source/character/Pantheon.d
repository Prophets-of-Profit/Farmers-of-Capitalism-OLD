module character.Pantheon;

import std.algorithm;
import std.array;

import character.Character;

class Pantheon{

    double[Character] gods;     ///An associative array of the gods and their relative importance on a scale from 0 to 1

    /**
     * Adds a god with a given weight to gods
     * Weight is normalized so that the total weight in gods stays the same
     * Params:
     *     god = Character to be added to gods
     *     weight = desired weight
     */
    void addGod(Character god, double weight){
        gods[god] = (gods.keys.canFind(god))? gods[god] + weight : weight;
        double lostWeight;
        while(gods.values.filter!(a => a < 0).array.length > 0){
            foreach(key; gods.keys){
                gods[key] = gods[key] - (key == god)? 0 : weight / (gods.keys.length - 1);
                if(gods[key] <= 0){
                    lostWeight += gods[key];
                    gods.remove(key);
                }
            }
        }
    }

    /**
     * Removes a god from gods
     * Weight is normalized so that the total weight in gods stays the same
     * Params:
     *     god = god to be removed
     */
    void removeGod(Character god){
        if(gods.keys.canFind(god)){
            addGod(god, -1.0 * gods[god]);
        }
    }
}
