module logic.world.World;

import logic.world.Coordinate;
import logic.world.Hex;

/**
 * The world
 * Represents the hexes in the game and actions that can be taken using them
 * Use GameWorld for game content
 */
class World(uint size) {

    Hex[Coordinate] tiles; ///An array of all the hexes in the world

    /**
     * Generates a hexagonal world of a given radius (distance from center to corner)
     * TODO: add worldgen
     */
    this() {
        foreach (i; 0 .. 2 * size + 1) {
            foreach (j; 0 .. 2 * size + 1) {
                if(abs(i + j) <= 3) {
                    this.tiles[Coordinate(i, j)] = new HexTile(Coordinate(i, j));
                }
            }
        }
    }

    /** 
     * Returns coordinates adjacent to a given location
     * Coordinates are returned in the following order:
     * EAST, SOUTHEAST, SOUTHWEST, WEST, NORTHWEST, NORTHEAST,
     * Followed by the passed coordinates in the last spot
     */
    Coordinate[] getAdjacencies(Coordinate location) {
        return [
            Coordinate(location.q + 1, location.r), 
            Coordinate(location.q, location.r + 1),
            Coordinate(location.q - 1, location.r + 1),
            Coordinate(location.q - 1, location.r),
            Coordinate(location.q, location.r - 1),
            Coordinate(location.q + 1, location.r - 1),
            location
        ];
    }

}
