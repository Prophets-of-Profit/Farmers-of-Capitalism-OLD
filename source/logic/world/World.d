module logic.world.World;

import std.algorithm;
import std.array;
import std.math;
import std.random;
import graphics.Constants;
import logic.world.Coordinate;
import logic.world.Hex;

//A list of all biomes
immutable biomeImages = [Image.BiomePlains, Image.BiomeRedwood, Image.BiomeOak];

/**
 * The world
 * Represents the hexes in the game and actions that can be taken using them
 * Use GameWorld for game content
 */
class World {

    Hex[Coordinate] tiles; ///An array of all the hexes in the world
    ulong size; ///The size of the world

    /**
     * Generates a hexagonal world of a given radius (distance from center to corner)
     * TODO: add worldgen
     */
    this(ulong size) {
        this.size = size;
        for (long i = -1 * size; i <= cast(long)size; i++) {
            for (long j = -1 * size; j <= cast(long)size; j++) {
                if (abs(i + j) <= cast(long)size) {
                    this.tiles[new Coordinate(i, j)] = new Hex(new Coordinate(i, j), null, choice(biomeImages.dup));
                }
            }
        }
    }

    /**
     * Gets the Manhattan distance between two hexes by their coordinates
     * This is equivalent to the shortest path between them if each tile is equally passable
     */
    uint getDistance(Coordinate a, Coordinate b) {
        return cast(uint) (abs(a.q - b.q) + abs(a.r - b.r) + abs(a.s - b.s)) / 2;
    }

    /**
     * Implementation of Dijkstra's algorithm to associate each coordinate with the minimum move cost from a source tile
     */
    uint[Coordinate] getDistances(Coordinate s, uint maxDistance = 200) {
        uint[Coordinate] distances;
        assert(this.tiles.keys.canFind(s));
        uint[Coordinate] queue;
        Coordinate[] reachableTiles = this.tiles.keys.filter!(a => getDistance(s, a) <= maxDistance).array;
        foreach(tile; reachableTiles) {
            //Subtract 100 here to avoid overflow; be careful of having maps too long, though this shouldn't be an issue
            //because the map will be unusable long before distances reach levels this high (unless you're using unpassable tiles)
            queue[tile] = uint.max - 100;
            distances[tile] = uint.max - 100; 
        }
        queue[s] = 0;
        distances[s] = 0;
        while(queue.keys.length > 0) {
            uint minimumDistance = queue.values.reduce!(min);
            Coordinate toVisit = queue.keys.find!(a => queue[a] == minimumDistance).front;
            queue.remove(toVisit);
            foreach(coord; toVisit.adjacencies[0..$ - 1].filter!(a => reachableTiles.canFind(a)).array) {
                uint distance = min(distances[coord], distances[toVisit] + this.tiles[coord].movementCost);
                distances[coord] = distance;
                if(coord in queue) queue[coord] = distance;
            }
        }
        return distances;
    }

    /**
     * Gets the shortest path between two coordinates if getDistances has already been called
     * If distances are not input, this will find them (but this is not optimal)
     * Use this if performance is an issue and reachable tiles are already being displayed
     * distances should be from start - use getDistances[start]
     */
    Coordinate[] getShortestPath(Coordinate start, Coordinate end, uint[Coordinate] distances = null) {
        if(distances is null) distances = this.getDistances(start);
        Coordinate[] path = [end];
        while(path[0] != start) {
            uint minimumDistance = path[0].adjacencies
                                                    .filter!(a => a in distances)
                                                    .map!(a => distances[a])
                                                    .array
                                                    .reduce!(min);
            path = path[0].adjacencies.filter!(a => a in distances).find!(a => distances[a] == minimumDistance).front ~ path;
        }
        return path;
    }

}
