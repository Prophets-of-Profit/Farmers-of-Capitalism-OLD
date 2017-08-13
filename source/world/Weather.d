module world.Weather;

import world.HexTile;
import world.World;

public double season;       ///The amount of temperature change based on the season. TODO make this an enum?

class Weather {

    HexTile tile;           ///The tile of where the weather is
    double cloudCover;      ///TODO
    double relativeHumidity;///TODO

    /**
     * Constructor for the Weather object.
     * Params:
     *      tile: The tile that this weather object is bound to.
     */
    this(HexTile tile){
        this.tile = tile;
    }

    /**
     * TODO
     * Params:
     *      world = ?
     */
    void generateClouds(World world){

    }

}
