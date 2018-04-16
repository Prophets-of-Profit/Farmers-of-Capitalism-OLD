module logic.Market;

import std.traits;
import logic.item;

/**
 * The class for markets; markets are the economic engine of the game
 * TODO: item depositing, item buying, item selling
 */
class Market {

    long[Quality] qualityValues; ///How much value the market gives to each quality
    private Item[] containedItems; ///What items the market has

    /**
     * Creates a market and initializes values for qualities
     */
    this() {
        foreach(quality; EnumMembers!Quality) {
            this.qualityValues[quality] = quality.baseValue;
        }
    }

    /**
     * What happens to the market every turn
     * Every turn, prices will slightly change and supply will slowly but passively grow
     */
    void incrementalAction() {
        //TODO: change prices
    }

    /**
     * Gets how valuable the given item is to the market
     */
    long valuate(Item item) {
        //TODO:
        return 0;
    }

}
