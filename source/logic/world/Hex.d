module logic.world.Hex;

import graphics.Constants;
import logic.world.Coordinate;

import std.math;

import d2d;

/**
 * The different factors which affect a climate
 */
enum ClimateFactor {
    TEMPERATURE,
    HUMIDITY,
    SUNLIGHT,
    ATMOSPHERE,
    SOIL
}

/**
 * A single hexagonal tile in the world
 * Hexes are the units for the world map
 * TODO: use std.algorithm.comparison.clamp to keep climate, weather, and elevation values between 0 and 1
 */
class Hex {

    immutable Coordinate location; ///The unchangable location of the hex
    double elevation; ///Stores the elevation of the hex as a percentage of the highest elevation in the world
    double[ClimateFactor] baseClimate; ///The base values that exemplify the overall climate
    Direction waterFlow; ///How the water on the tile flows; if the tile isn't a river, is Direction.NONE
    Direction windFlow; ///How the wind on the tile flows; all tiles have a wind direction, but it can vary over time

    /**
     * Gets the linear distance to the nearest water tile
     * TODO:
     */
    @property int proximityToWater() {
        return 0;
    }

    /**
     * The current instantaneous weather
     * Dependent on the baseClimate, elevation, and proximityToWater
     * TODO:
     */
    @property double[ClimateFactor] weather() {
        return null;
    }

    /**
     * The Hex constructor
     * Creates a hex based on its location and climate
     */
    this(Coordinate location, double[ClimateFactor] climate = null) {
        this.location = location;
        this.baseClimate = climate;
    }

    //TODO: make polygon a property based on center location and hex width

}

/**
 * Returns an array of 6 points which form a hexagon
 * Based on the center of the center hexagon and the side length of each hexagon; found in graphics.Constants
 */
iVector[6] getCenterHexagonVertices(iVector hexCenter, int sideLength) {
    return [
            new iVector(hexCenter.x, hexCenter.y + sideLength), //Bottom
            new iVector(hexCenter.x + cast(int)(sideLength * hexBase.x / 2), hexCenter.y + sideLength / 2), //Lower right
            new iVector(hexCenter.x + cast(int)(sideLength * hexBase.x / 2), hexCenter.y - sideLength / 2), //Upper right
            new iVector(hexCenter.x, hexCenter.y - sideLength), //Top
            new iVector(hexCenter.x - cast(int)(sideLength * hexBase.x / 2), hexCenter.y - sideLength / 2), //Lower left
            new iVector(hexCenter.x - cast(int)(sideLength * hexBase.x / 2), hexCenter.y + sideLength / 2), //Upper left
        ];
}