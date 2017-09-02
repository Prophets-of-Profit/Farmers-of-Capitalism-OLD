module item.plant.functions.MutabilityFunctions;

import item.plant.Plant;

/**
 * A function that takes in a mutation chance and returns a function that returns that mutation chance
 * Is used so that traits can store the functions returned by this function
 */
auto getFunctionForInvertedChanceOf(int chance){
    return (Plant forWhom) => chance;
}
