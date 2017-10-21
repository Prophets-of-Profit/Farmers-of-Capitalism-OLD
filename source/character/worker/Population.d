module character.worker.Population;

import item.Inventory;

immutable int baseRoomPerPopulation = 5;

/**
 * An inventory that holds characters
 */
class Population : Inventory(Character) {

    /**
     * Constructs a new population.
     * Populations have a base size determined by an immutable variable.
     */
    this(){
        super(baseRoomPerPopulation);
    }
}
