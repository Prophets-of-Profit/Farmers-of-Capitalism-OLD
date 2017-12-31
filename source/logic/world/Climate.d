module logic.world.Climate;

import logic.Range;

/**
 * A struct containing factors useful for plant growth as fractions of the maximum value in the world
 */
struct Climate {

    Range!(0, 1) baseTemperature; ///The base temperature of a tile
    Range!(0, 1) baseHumidity; ///The base humidity of a tile
    Range!(0, 1) baseSunlight; ///The base radiant energy of a tile
    Range!(0, 1) baseAtmosphere; ///The base atmospheric quality of a tile
    Range!(0, 1) baseSoil; ///The base soil quality of a tile

    /**
     * Gets the instantaneous temperature of a tile
     * Instantaneous temperature can vary from base temperature based on external factors
     * TODO:
     */
    @property Range!(0, 1) temperature() {
        return Range!(0, 1)(0);
    }

    /**
     * Gets the instantaneous humidity of a tile
     * Instantaneous humidity can vary from base temperature based on external factors
     * TODO:
     */
    @property Range!(0, 1) humidity() {
        return Range!(0, 1)(0);
    }

    /**
     * Gets the instantaneous radiant energy of a tile
     * Instantaneous radiant energy can vary from base temperature based on external factors
     * TODO:
     */
    @property Range!(0, 1) sunlight() {
        return Range!(0, 1)(0);
    }

    /**
     * Gets the instantaneous air density or atmospheric quality of a tile
     * Instantaneous atmospheric quality can vary from base temperature based on external factors
     * TODO:
     */
    @property Range!(0, 1) atmosphere() {
        return Range!(0, 1)(0);
    }

    /**
     * Gets the instantaneous soil quality of a tile
     * Instantaneous soil quality can vary from base temperature based on external factors
     * TODO:
     */
    @property Range!(0, 1) soil() {
        return Range!(0, 1)(0);
    }

}
