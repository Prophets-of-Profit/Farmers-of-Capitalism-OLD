module item.plant.functions.MainActions;

import character.Character;
import item.plant.Plant;

/**
 * Returns a function that makes the plant grow when interacted with
 */
auto makeGrowWithLoveAction(double growthAmount){
    return (Character actor, Plant forWhom) => forWhom.completion += growthAmount;
}

/**
 * Does nothing when interacted with
 */
void doNothing(Character actor, Plant forWhom){}

/**
 * Gives the player all of the fruits or other items this plant has born
 */
void givePlayerCreatedItems(Character actor, Plant forWhom){
    //TODO
}
