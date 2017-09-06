module item.plant.CanBePlacedFunctions;

import std.conv;

import app;
import item.plant.Plant;
import world.HexTile;
import world.World;

/**
 * Bases whether the plant can be placed on if the climate of the tile is survivable
 * Doesn't take into account water or land, so unless the plant is terrain agnostic, this function must be combined with others in another function
 */
bool isSurvivableClimate(Coordinate location, Plant forWhom){
    foreach(tileStat; __traits(allMembers, TileStat)){
        TileStat stat = tileStat.to!TileStat;
        if(!forWhom.plantRequirements[stat].isInRange(game.mainWorld.getTileAt(location).climate[stat])){
            return false;
        }
    }
    return true;
}

/**
 * Bases whether the plant can be placed on the tile solely on whether the tile is land
 * Must be combined with other functions
 */
bool isLand(Coordinate location, Plant forWhom){
    return !isWater(location, forWhom);
}

/**
 * Bases whether the plant can be placed on the tile solely on whether the tile is water
 * Must be combined with other functions
 */
bool isWater(Coordinate location, Plant forWhom){
    return game.mainWorld.getTileAt(location).isWater;
}

/**
 * Returns whether the plant can be placed on the tile if the plant is aquatic
 */
bool isAquaticCompatible(Coordinate location, Plant forWhom){
    return isWater(location, forWhom) && isSurvivableClimate(location, forWhom);
}
