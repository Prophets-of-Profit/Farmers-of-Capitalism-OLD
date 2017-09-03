module item.plant.functions.MoveCostFunctions;

import app;
import character.Character;
import item.plant.Plant;
import world.HexTile;

/**
 * Makes a function that has a flat cost of the given cost
 */
auto getFunctionForFlatCostOf(double cost){
    return (Character stepper, Plant forWhom) => cost;
}

/**
 * Returns a movement cost that is scaled with temperature
 */
double slowWithHeat(Character stepper, Plant forWhom){
    return game.mainWorld.getTileAt(forWhom.coords).climate[TileStat.TEMPERATURE] / 0.333;
}
