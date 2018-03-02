module logic.item.Inventory;

import logic.item.Item;
import logic.world.Coordinate;

/**
 * A class that handles storing and transferring items
 */
class Inventory {

    Item[] items; ///The items of the inventory
    Coordinate location; ///Where the inventory is situated
    immutable bool isPlaced; ///Whether the inventory is placed or not (eg. any items in this inventory are counted as down on the board)

    /**
     * Creates an inventory from a list of items
     */
    this(bool isPlaced, Coordinate location, Item[] contained...) {
        this.isPlaced = isPlaced;
        this.location = location;
        this.items = contained;
    }

}
