module item.plant.functions.GetSizeFunctions;

import std.conv;

import app;
import item.plant.Plant;
import world.HexTile;

/**
 * Makes the item have a flat cost
 */
auto flatCostOf(int cost){
    return (Plant forWhom) => cost;
}

/**
 * The plant takes up more space the higher it is
 */
int growWithElevation(Plant forWhom){
    return (game.mainWorld.getTileAt(forWhom.coords).climate[TileStat.ELEVATION] / 0.333).to!int;
}
