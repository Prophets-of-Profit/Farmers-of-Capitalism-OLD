module logic.item.Inventory;

import std.algorithm;
import std.conv;
import core.exception;
import logic.item.Item;

/**
 * A class for an object that holds items
 */
class Inventory {

    Item[] contained; ///All the items inside of the inventory
    alias items this; ///Sets the access of this object as the array of items it contains
    public int maxSize; ///The maximum number of elements in the inventory; if is negative, the array can have infinite elements

    /**
     * Because arrays are passed by value, it returns a copy of the array of what this inventory contains
     * Allows for easy item viewing but makes it impossible to edit the underlying inventory without inventory methods
     */
    @property Item[] items() {
        return this.contained;
    }

    /**
     * Returns the amount of space taken up in this inventory.
     */
    @property int spaceUsed() {
        int spaceUsed;
        this.items.each!(item => spaceUsed += item.size);
        assert(spaceUsed <= this.maxSize || this.maxSize < 0);
        return spaceUsed;
    }

    /**
     * Returns the space remaining in this inventory
     * A negative value means there is infinite space remaining
     */
    @property int spaceRemaining() {
        immutable spaceRemaining = this.maxSize - this.spaceUsed();
        assert(this.maxSize >= 0 && spaceRemaining >= 0 || this.maxSize < 0 && spaceRemaining < 0);
        return spaceRemaining;
    }

    /**
     * A constructor for an inventory
     * Takes in a size, but if the inventory size is negative, the inventory has infinite size
     */
    this(int maxSize = -1) {
        this.maxSize = maxSize;
    }

    /**
     * Adds the given item to the inventory
     * Returns whether the item was successfully added to inventory
     */
    bool add(Item itemToAdd) {
        if (maxSize > 0 && (itemToAdd is null || this.spaceRemaining - itemToAdd.size < 0)) {
            return false;
        }
        this.contained ~= itemToAdd;
        return true;
    }

    /**
     * Removes the given item from the inventory
     * Returns whether the item given was successfully removed
     */
    bool remove(Item itemToRemove) {
        if (this.items.canFind(itemToRemove)) {
            this.contained = this.items.remove(this.items.countUntil(itemToRemove));
            return true;
        }
        return false;
    }

}
