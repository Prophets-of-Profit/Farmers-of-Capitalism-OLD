module logic.world.World;

import std.math;
import logic.world.Coordinate;
import logic.world.Hex;

/**
 * The world
 * Represents the hexes in the game and actions that can be taken using them
 * Use GameWorld for game content
 */
class World(int size) {

    Hex[Coordinate] tiles; ///An array of all the hexes in the world

    /**
     * Generates a hexagonal world of a given radius (distance from center to corner)
     * TODO: add worldgen
     */
    this() {
        for (int i = -size; i <= size; i++) {
            for (int j = -size; j <= size; j++) {
                if (abs(i + j) <= size) {
                    this.tiles[Coordinate(i, j)] = new Hex(Coordinate(i, j));
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
        return [Coordinate(location.q + 1, location.r), Coordinate(location.q,
                location.r + 1), Coordinate(location.q - 1, location.r + 1),
            Coordinate(location.q - 1, location.r), Coordinate(location.q,
                    location.r - 1), Coordinate(location.q + 1, location.r - 1), location];
    }

    /**
     * Gets the Manhattan distance between two hexes by their coordinates
     * This is equivalent to the shortest path between them if each tile is equally passable
     */
    int getDistance(Coordinate a, Coordinate b) {
        return (abs(a.q - b.q) + abs(a.r - b.r) + abs(a.s - b.s)) / 2;
    }

}
