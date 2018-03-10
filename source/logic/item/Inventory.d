module logic.item.Inventory;

import std.algorithm;
import std.array;
import std.range;
import logic.item.Item;
import logic.world.Coordinate;

/**
 * A class that handles storing and transferring items
 */
class Inventory {

    int maxItems = -1; ///The maximum amount of items the inventory can have; a negative amount means infinite items
    private Item[] items; ///The items of the inventory
    Coordinate location; ///Where the inventory is situated
    immutable bool isPlaced; ///Whether the inventory is placed or not (eg. any items in this inventory are counted as down on the board)

    /**
     * Gives how many items
     */
    @property uint length() {
        return cast(uint) this.items.length;
    }

    /**
     * Creates an inventory from a list of items
     */
    this(bool isPlaced, Coordinate location, Item[] contained...) {
        this.isPlaced = isPlaced;
        this.location = location;
        foreach (item; contained) {
            this.addItem(item);
        }
    }

    /**
     * Adds the given item
     */
    void addItem(Item itemToAdd) {
        if (this.maxItems < 0 || this.length + 1 < this.maxItems) {
            this.items ~= itemToAdd;
            itemToAdd.container = this;
        } else {
            throw new Error("Cannot add item " ~ itemToAdd.toString ~ " to full inventory!");
        }
    }

    /**
     * Removes the given item
     */
    void removeItem(Item itemToRemove) {
        this.items.filter!(item => item == itemToRemove).each!(item => item.container = null);
        this.items = this.items.filter!(item => item != itemToRemove).array;
    }

    /**
     * Removes the item at the given index
     */
    void removeItem(uint index) {
        this.items[index].container = null;
        this.items.remove(index);
    }

    Item[] opIndex() { return this.items; }
    Item opIndex(uint index) { return this.items[index]; }
    Item[] opIndex(uint[] indices...) { return indices.map!(index => this[index]).array; }
    void opIndexAssign(Item newItem, uint[] indices...) { foreach(index; indices) { this.items[index] = newItem; } }
    uint[] opSlice(uint first, uint second) { return iota(first, second).array; }
    uint opDollar(uint position)() {return this.length; }

}
