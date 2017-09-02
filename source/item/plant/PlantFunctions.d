module item.plant.PlantFunctions;

import app;
import character.Character;
import item.plant.Plant;
import world.World;

/**
 * Where all the functions that a plant can have are stored
 * In a plant, they are kept in the plant's attributeset which stores a trait which stores a function
 * TODO split into multiple files?
 */

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

/**
 *
 * FOR: canBePlacedActions
 *
 *      |
 *      ∨
 *
 */

bool canBePlacedOnAnyLand(Coordinate where, Plant forWhom){
    return !canBePlacedOnAnyWater(where, forWhom);
}

bool canBePlacedOnAnyWater(Coordinate where, Plant forWhom){
    return game.mainWorld.getTileAt(where).isWater;
}

/**
 *
 *      ∧
 *      |
 *
 * FOR: canBePlacedActions
 *
 */

/**
 *
 * FOR: getMovementCostActions
 *
 *      |
 *      ∨
 *
 */

double noCost(Character stepper, Plant forWhom){
    return 0;
}

double impassable(Character stepper, Plant forWhom){
    return 15;
}

/**
 *
 *      ∧
 *      |
 *
 * FOR: getMovementCostActions
 *
 */

/**
 *
 * FOR: steppedOnActions
 *
 *      |
 *      ∨
 *
 */

void nothing(Character stepper, Plant forWhom){}

void healing(Character stepper, Plant forWhom){
    stepper.health += stepper.health.maximum / 20;
}

void damaging(Character stepper, Plant forWhom){
    stepper.health -= stepper.health.maximum / 20;
}

/**
 *
 *      ∧
 *      |
 *
 * FOR: steppedOnActions
 *
 */
