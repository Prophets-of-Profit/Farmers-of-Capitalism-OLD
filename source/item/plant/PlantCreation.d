/**
* Contains methods for creating, breeding, and genetically modifying plants.
*/
/**
module item.plant.PlantCreation;

import world.plant.Plant;
import world.HexTile;
import world.plant.PlantTraits;
import std.random;
import app;
import world.World;
import std.stdio;


/**
 * Generates a random plant on the specified coordinates.
 * Should be used during worldgen.
 TODO rework all of this into world or plant constructor and delete this file
 */
Plant createPlant(int[] creationCoords, int statsToGive){
    HexTile tile = mainWorld.getTileAt(creationCoords);
    Plant plant = new Plant();
    plant.survivableClimate["Temperature:"] = [min(tile.temperature - uniform(0, 0.1), 0), max(tile.temperature + uniform(0, 0.1), 1)];
    plant.survivableClimate["Water:"] = [min(tile.water - uniform(0, 0.1), 0), max(tile.water + uniform(0, 0.1), 1)];
    plant.survivableClimate["Soil:"] = [min(tile.soil - uniform(0, 0.1), 0), max(tile.soil + uniform(0, 0.1), 1)];
    plant.survivableClimate["Elevation:"] = [min(tile.elevation - uniform(0, 0.1), 0), max(tile.elevation + uniform(0, 0.1), 1)];
    if(tile.isWater){ plant.attributes["Aquatic"] = 1; }
    double chanceBound = 1.0;
    foreach(possibleAttribute; naturallyPossibleAttributes){
        if(uniform(0.0, chanceBound) >= 0.8){
            if(plant.canGetTrait(possibleAttribute)){ plant.attributes[possibleAttribute] = uniform(1,3); }
            chanceBound -= 0.04;
        }
    }
    foreach(possibleAttribute; naturallyPossibleIncrementalActions){
        if(uniform(0.0, chanceBound) >= 0.8){
            plant.incrementalActions ~= possibleAttribute;
            chanceBound -= 0.04;
        }
    }
    foreach(possibleAttribute; naturallyPossibleSteppedOnActions){
        if(uniform(0.0, chanceBound) >= 0.8){
            plant.steppedOnActions ~= possibleAttribute;
            chanceBound -= 0.04;
        }
    }
    foreach(possibleAttribute; naturallyPossiblePlacedActions){
        if(uniform(0.0, chanceBound) >= 0.8){
            plant.placedActions ~= possibleAttribute;
            chanceBound -= 0.04;
        }
    }
    foreach(possibleAttribute; naturallyPossibleDestroyedActions){
        if(uniform(0.0, chanceBound) >= 0.8){
            plant.destroyedActions ~= possibleAttribute;
            chanceBound -= 0.04;
        }
    }
    foreach(possibleAttribute; naturallyPossibleMainActions){
        if(uniform(0.0, chanceBound) >= 0.8){
            plant.mainActions ~= possibleAttribute;
            chanceBound -= 0.04;
        }
    }
    string[] statTypes = ["Growth", "Resilience", "Yield", "Seed Strength", "Seed Quantity"];
    for(int i = 0; i< statsToGive; i++){
        plant.stats[statTypes[uniform(0, $)]] += 1;
    }
    return plant;
}



unittest{
    for(int i = 0; i < 10; i++){
        HexTile tile = mainWorld.tiles[uniform(0, $)];
        int[] coords = tile.coords.dup;
        int statsToGive = uniform(6, 15);
        Plant seedling = createPlant(coords, statsToGive);
        writeln("Conditions at", coords, "are");
        writeln("Temperature:", tile.temperature);
        writeln("Water", tile.water);
        writeln("Elevation", tile.elevation);
        writeln("Soil", tile.soil);
        writeln("Seedling strength (statsToGive):", statsToGive);
        writeln("Seedling stats:", seedling.stats);
        writeln("Seedling Survivable Climate:", seedling.survivableClimate);
    }
}
