module logic.world.World;

import logic.world.Coordinate;
import logic.world.Hex;

/**
 * The world
 * Represents the hexes in the game and actions that can be taken
 */
class World(uint size) {

    Hex[size][size] tiles; ///An array of all the hexes in the world

    /**
     * Generates a hexagonal world of a given radius (distance from center to corner)
     * TODO: add worldgen
     */
    this() {
        foreach (i; 0..size) {
            foreach (j; 0..size) {
                this.tiles[i][j] = new Hex(Coordinate(i, j));
            }
        }
    }

}
