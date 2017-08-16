module item.plant.PlantTraits;

import std.algorithm;
import std.array;
import std.conv;

import character.Character;
import item.plant.Plant;

/**
 * A struct that contains a function or an action that takes in a character and returns void
 * Is in such a format because most of the slottable functions a plant (or even an item) has will conform to that format
 * Is in a struct because whether the action is natural or not should be stored with the actual action itself
 * TODO store actionType in here and then just store arrays of actions instead of associative arrays of arrays of actions
 */
struct PlantAction{

    void delegate(Character actor) action;  ///The actual function or action this will do; returns nothing and takes in a character like most of the functions an item or plant requires
    alias action this;                      ///Makes it so that the plant action can be accessed as the actual function or action
    bool isNatural;                         ///Whether the action is natural; default is false

}

/**
* Enums for the types of stats that a plant can have
* Growth: Rate of growth.
* Resilience: Resistance to invasive species and being stepped on.
* Yield: Amount of products produced when destroyed.
* Seed Quantity: Amount of seeds produced when naturally reproducing.
* Seed Strength: Distance seeds can go before settling.
*/
enum PlantReq{
    GROWTH, RESILIENCE, YIELD, SEED_QUANTITY, SEED_STRENGTH
}

/**
 * Types of actions a plant has
 * Almost directly correlates to the types of actions any item would have
 */
enum ActionType{
    STEPPED, MAIN, DESTROYED, PLACED, INCREMENTAL
}

/**
 * Attributes a plant can have
 *     *Patent: Ownership based on creator rather than tile owner.
 *         Level 1: Ownership determined based on immediate creator or creator of parents.
 *     *Moveable: Can be replanted after being planted, passing growth cycles, and being harvested.
 *         Level 1: Can be moved if maturity <= 20%.
 *         Level 2: Can be moved if maturity <= 40%.
 *         Level 3: Can be moved if maturity <= 60%.
 *         Level 4: Can be moved if maturity <= 80%.
 *         Level 5: Can be moved.
 *     *Invasive: Inhibits other plants on the same tile. Slowed by Resilience of other plants. TODO: Implement Resilience
 *         Level 1: Slows growth for all other plants on tile by 25%.
 *         Level 2: Slows growth for all other plants on tile by 50%.
 *         Level 3: Slows growth for all other plants on tile by 75%.
 *         Level 4: Stops growth for all other plants on tile.
 *         Level 5: All other plants on tile wither by 25% of growth rate instead of growing.
 *     *Aquatic: Can be planted on water tiles.
 *     *Slowing: Increases movement cost for a tile.
 *         Movement cost increase is equal to level.
 */
enum PlantAttribute{
    PATENT, MOVABLE, INVASIVE, AQUATIC, SLOWING, SPEEDING, SYMBIOTIC, MUTABLE
}

PlantAttribute[] naturalAttributes;                             ///A list of all natural attributes in the game
PlantAttribute[][] mutuallyExclusiveAttributes;                 ///A list of mutually exclusive attributes (eg. a plant cannot have 2 mutually exclusive attributes)
PlantAction[][ActionType] allActions;                           ///A list of all possible natural actions in the game sorted by ActionType

/**
 * Returns an associative array of list of actions similar to allActions, but only containing natural actions from allActions
 */
PlantAction[][ActionType] getNaturalActions(){
    PlantAction[][ActionType] natural;
    foreach(type; __traits(allMembers, ActionType)){
        ActionType actionType = type.to!ActionType;
        natural[actionType] = allActions[actionType].filter!(a => a.isNatural).array;
    }
    return natural;
}
