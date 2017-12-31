module logic.world.Hex;

import logic.Range;
import logic.world.Climate;
import logic.world.Coordinate;

/**
 * A single hexagonal tile in the world
 * Hexes are the units for the world map
 */
class Hex {

    Climate climate; ///Stores the tile's climate
    immutable Coordinate location; ///Stores the location of the hex
    Range!(0, 1) elevation; ///Stores the elevation of the hex as a percentage of the highest elevation in the world

    /**
     * Gets the linear distance to the nearest water tile
     * TODO
     */
    @property int proximityToWater() {
        return 0;
    }

    /**
     * The Hex constructor
     * Creates a hex based on its location and climate
     */
    this(Coordinate location, Climate climate) {
        this.location = location;
        this.climate = climate;
    }

}
