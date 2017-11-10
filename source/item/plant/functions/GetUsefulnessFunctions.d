module item.plant.functions.GetUsefulnessFunctions;

import character.Character;
import item.plant.Plant;
import item.plant.PlantTraits;

/**
 * Determines plant usefulness based on how rare its expressed traits are
 */
double phenotypeQuality(Plant forWhom){
    double totalDistance = 0;
    foreach(Trait i; forWhom.usableTraits){
        totalDistance += distance(i.difficulty);
    }
    return totalDistance;
}

/**
 * Determines plant usefulness based on how rare its carried genes are
 */
double genotypeQuality(Plant forWhom){
    double totalDistance = 0;
    foreach(Trait i; forWhom.traits){
        totalDistance += distance(i.difficulty);
    }
    return totalDistance;
}
