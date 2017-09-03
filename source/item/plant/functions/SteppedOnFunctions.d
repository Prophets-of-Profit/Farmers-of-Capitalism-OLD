module item.plant.functions.SteppedOnFunctions;

import std.random;

import character.Character;
import item.plant.Plant;

/**
 * Damages whoever steps on the plant
 */
auto getDamagingPlant(int damage){
    return (Character stepper, Plant forWhom) => {stepper.health -= damage;};
}

/**
 * Possibly dies when stepped on
 */
auto getPossiblyDeadAction(int invertedChanceToDie){
    return (Character stepper, Plant forWhom) => {
        if(uniform(0, invertedChanceToDie) == 0){
            forWhom.die();
        }};
}

/**
 * Does nothing when stepped on
 */
void nothing(Character stepper, Plant forWhom){}
