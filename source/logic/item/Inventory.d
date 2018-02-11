module logic.item.Inventory;

import logic.item.Item;

/**
 * A class that handles storing and transferring items
 */
class Inventory {

    Item[] items; ///The items of the inventory

    /**
     * Creates an inventory from a list of items
     */
    this(Item[] contained...) {
        this.items = contained;
    }

}
