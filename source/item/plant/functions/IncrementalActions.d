module item.plant.IncrementalActions;

import app;
import item.plant.Plant;
import world.HexTile;

/**
 * Returns a function that will erode soil quality each turn by the given amount
 */
auto erodeQualityAction(double erodeAmount){
    return (Plant forWhom) => game.mainWorld.getTileAt(forWhom.coords).climate[TileStat.SOIL] -= erodeAmount;
}

/**
 * Does nothing every turn
 */
void nothing(Plant forWhom){}
