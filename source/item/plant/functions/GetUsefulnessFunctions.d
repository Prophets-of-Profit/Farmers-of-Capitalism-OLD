module item.plant.functions.GetUsefulnessFunctions;

import character.Character;
import item.plant.Plant;

/**
 * Determines plant usefulness based on how rare its expressed traits are
 */
double phenotypeQuality(Plant forWhom){
    totalDistance = 0
    foreach(i; forWhom.usableTraits){
        totalDistance += distance(forWhom.usableTraits[i].difficulty)
    }
    return totalDistance;
}

/**
 * Determines plant usefulness based on how rare its carried genes are
 */
double genotypeQuality(Plant forWhom){
    totalDistance = 0
    foreach(i; forWhom.traits){
        totalDistance += distance(forWhom.traits[i].difficulty)
    }
    return totalDistance;
}
