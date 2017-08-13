module item.Inventory;

import std.algorithm;
import std.conv;

import core.exception;

import character.Character;
import item.Item;
import world.World;

/**
 * A class for an object that holds other objects
 */
class Inventory{

    public Character[] accessibleTo;///A list of characters who can access the inventory
    public Item[] items;            ///All the items inside of the inventory
    alias items this;               ///Sets the access of this object as the array of items it contains
    public int maxSize;             ///The maximum number of elements in the inventory; if is negative, the array can have infinite elements
    public Coordinate coords;       ///The location of the tile or the player or inventorycontainer with this inventory

    /**
     * The player who owns this inventory
     * Is just the first player in the accessibleTo list
     */
    @property Character owner(){
        return this.accessibleTo[0];
    }

    /**
     * A property method that sets the owner of this inventory by making it the first element in the list of
     * Characters who can access this inventory
     */
    @property Character owner(Character newOwner){
        if(this.accessibleTo.canFind(newOwner)){
            this.accessibleTo.remove(this.accessibleTo.countUntil(newOwner));
        }
        this.accessibleTo = newOwner ~ this.accessibleTo;
        return newOwner;
    }

    /**
     * A constructor for an inventory
     * Takes in a size, but if the inventory size is negative, the inventory has infinite size
     * Params:
     *      maxSize = the maximum amount of items the inventory can hold; if it is negative, the inventory won't have a maximum size
     */
    this(int maxSize = -1){
        this.maxSize = maxSize;
    }

    /**
     * Adds the given item to the inventory
     * Returns whether the item was successfully added to inventory
     * Params:
     *      itemToAdd = the item to add to the inventory
     */
    bool add(Item itemToAdd){
        if(itemToAdd is null || this.countSpaceRemaining - itemToAdd.getSize() < 0){
            return false;
        }
        this.items ~= itemToAdd;
        return true;
    }

    /**
     * Removes the given item from the inventory and sets its location in the items array to null
     * Returns whether the item given was successfully removed
     * Params:
     *      itemToRemove = the item to remove from the inventory
     */
    bool remove(Item itemToRemove){
        if(this.items.canFind(itemToRemove)){
            this.items = this.items.remove(this.items.countUntil(itemToRemove));
            return true;
        }
        return false;
    }

    /**
     * Gets the movement cost of all of the items in the inventory
     */
    double getCollectiveMovementCost(){
        double moveCost = 0;
        foreach(item; this.items){
           if(item !is null && item.isPlaced){
                moveCost += item.getMovementCost();
           }
        }
        return moveCost;
    }

    /**
     * Returns the amount of space taken up in this inventory.
     */
    int countSpaceUsed(){
        int spaceUsed;
        foreach(item; this.items){
            spaceUsed += item.getSize;
        }
        assert(spaceUsed <= this.maxSize || this.maxSize < 0);
        return spaceUsed;
    }

    /**
     * Returns the space remaining in this inventory
     * A negative value means there is infinite space remaining
     */
    int countSpaceRemaining(){
        int spaceRemaining = maxSize - countSpaceUsed();
        assert(this.maxSize >= 0 && spaceRemaining >= 0 || this.maxSize < 0 && spaceRemaining < 0);
        return spaceRemaining;
    }

    /**
     * Returns a copy of this inventory
     * Changes in this inventory are not reflected in the copy
     * Changes in players are reflected in the copy, however
     */
    Inventory clone(){
        Inventory copy = new Inventory(this.maxSize);
        foreach(i; 0..this.items.length){
            copy.items[i] = this.items[i].clone();
        }
        copy.accessibleTo = this.accessibleTo;
        copy.coords = this.coords;
        return copy;
    }

}

unittest{
    import std.stdio;

    writeln("\nRunning unittest of Inventory");

    Inventory testInv = new Inventory(1);
}
