module world.Weather;

import world.HexTile;
import world.World;

public double season;       ///The amount of temperature change based on the season.

class Weather {

    Hextile tile;
    double cloudCover;
    double relativeHumidity;

    /**
     * Constructor for the Weather object.
     * Params:
     *      tile: The tile that this weather object is bound to.
     */
    this(HexTile tile){
        this.tile = tile;
    }

    void generateClouds(World world){
        
    }

}
