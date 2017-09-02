module item.plant.functions.GetOwnerFunctions;

import character.Character;
import item.plant.Plant;

/**
 * Gets the owner as who placed the plant
 */
Character getPlacer(Plant forWhom){
    return forWhom.placer;
}

/**
 * Gets the owner as to whom the plant's inventory belongs to
 */
Character getSourceOwner(Plant forWhom){
    return forWhom.source.owner;
}
