module item.plant.functions.DestroyedActions;

import character.Character;
import item.plant.Plant;

/**
 * Damages the destroyer by the given amount
 */
auto damageBy(int damageAmt){
    return (Character destroyer, Plant forWhom) => destroyer.health -= damageAmt;
}

/**
 * Does nothing when destroyed
 */
void nothing(Character destroyer, Plant forWhom){}
