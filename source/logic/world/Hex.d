module logic.world.Hex;

import logic.world.Coordinate;

/**
 * A single hexagonal tile in the world
 * Hexes are the units for the world map
 */
class Hex { 

    immutable Coordinate location; ///Stores the location of the hex

    /**
     * The Hex constructor
     * Creates a hex based on its location
     */
    this(Coordinate location) {
        this.location = location;
    }

}