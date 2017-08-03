module item.Inventory;

import character.Player;
import item.Item;
import core.exception;
import std.algorithm;
import std.conv;

/**
 * A class for an object that holds other objects
 */
class Inventory{

    public Player[] accessibleTo;   ///A list of players who can access the inventory
    public Item[] items;            ///All the items inside of the inventory
    alias items this;               ///Sets the access of this object as the array of items it contains
    public int maxSize;             ///The maximum number of elements in the inventory; if is negative, the array can have infinite elements
    public int[] coords;            ///The location of the tile or the player or inventorycontainer with this inventory

    /**
     * A constructor for an inventory
     * Usually for players, but may also be needed for improvements/plants
     * Takes in a size, but if the inventory size is negative, the inventory has infinite size
     * Params:
     *      maxSize = the maximum amount of items the inventory can hold; if it is negative, the inventory won't have a maximum size
     */
    this(int maxSize = -1){
        this.maxSize = maxSize;
        items = (maxSize < 0)? null : new Item[maxSize];
    }

    /**
     * Adds the given item to the inventory
     * Returns whether the item was successfully added to inventory
     * Params:
     *      itemToAdd = the item to add to the inventory
     */
    public bool add(Item itemToAdd){
        if(this.maxSize < 0){
            this.items ~= itemToAdd;
            return true;
        }
        for(int i = 0; i < this.items.length; i++){
            if(this.items[i] is null){
                this.items[i] = itemToAdd;
                return true;
            }
        }
        return false;
    }

    /**
     * Removes the given item from the inventory and sets its location in the items array to null
     * Returns whether the item given was successfully removed
     * Params:
     *      itemToRemove = the item to remove from the inventory
     */
    public bool remove(Item itemToRemove){
        int index = this.items.countUntil(itemToRemove).to!int;
        if(index >= 0){
            this.items[index] = null;
            return true;
        }
        return false;
    }

    /**
     * Gets the movement cost of all of the items in the inventory
     */
    public double getCollectiveMovementCost(){
        double moveCost = 0;
        foreach(item; this.items){
           if(item !is null && item.isPlaced){
                moveCost += item.getMovementCost();
           }
        }
        return moveCost;
    }

    /**
     * Returns a copy of this inventory
     * Changes in this inventory are not reflected in the copy
     * Changes in players are reflected in the copy, however
     */
    public Inventory clone(){
        Inventory copy = new Inventory(this.maxSize);
        for(int i = 0; i < this.items.length; i++){
            copy.items[i] = this.items[i].clone();
        }
        copy.accessibleTo = this.accessibleTo;
        copy.coords = this.coords;
        return copy;
    }

}

unittest{
    import std.stdio;

    writeln("Running unittest of Inventory");

    Inventory testInv = new Inventory(1);
    assert(testInv.add(null));
    assert(testInv.add(null));
    //TODO assert(testInv.add(someItem));
    //assert(!testInv.add(someItem));
}
