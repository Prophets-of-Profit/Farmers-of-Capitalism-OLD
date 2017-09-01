module item.plant.PlantFunctions;

import character.Character;
import item.plant.Plant;
import world.World;

/**
 *
 * FOR: chanceToMutateActions
 *
 *      |
 *      ∨
 *
 */

int noMutability(Plant forWhom){
    return int.max;
}

int extremelyLowChanceToMutate(Plant forWhom){
    return 1000000;
}

int lowChanceToMutate(Plant forWhom){
    return 5000;
}

int mediumChanceToMutate(Plant forWhom){
    return 1000;
}

int highChanceToMutate(Plant forWhom){
    return 500;
}

int extremelyHighChanceToMutate(Plant forWhom){
    return 100;
}

int volatileMutability(Plant forWhom){
    return 10;
}

/**
 *
 *      ∧
 *      |
 *
 * FOR: chanceToMutateActions
 *
 */

/**
 *
 * FOR: locationAsSeedActions
 *
 *      |
 *      ∨
 *
 */

Coordinate getFirstHospitableByWind(Plant forWhom){
    return nullCoord;
}

Coordinate getFirstHospitableByWater(Plant forWhom){
    return nullCoord;
}

/**
 *
 *      ∧
 *      |
 *
 * FOR: locationAsSeedActions
 *
 */

/**
 *
 * FOR: getOwnerActions
 *
 *      |
 *      ∨
 *
 */

Character getOwnerBasedOnInventory(Plant forWhom){
    return forWhom.source.owner;
}

Character getOwnerBasedOnPlacer(Plant forWhom){
    return forWhom.placer;
}

/**
 *
 *      ∧
 *      |
 *
 * FOR: getOwnerActions
 *
 */
