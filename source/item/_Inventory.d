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
class Inventory(T) {

    T[] contained;                  ///All the items inside of the inventory
    public Character[] accessibleTo;///A list of characters who can access the inventory
    alias items this;               ///Sets the access of this object as the array of items it contains
    public int maxSize;             ///The maximum number of elements in the inventory; if is negative, the array can have infinite elements
    public Coordinate coords;       ///The location of the tile or the player or inventorycontainer with this inventory

    /**
     * Because arrays are passed by value, it returns a copy of the array of what this inventory contains
     * Allows for easy item viewing but makes it impossible to edit the underlying inventory without inventory methods
     */
    @property T[] items(){
        return this.contained;
    }

    /**
     * The character who owns this inventory
     * Is just the first character in the accessibleTo list
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
     *      maxSize = the maximum amount of Ts the inventory can hold; if it is negative, the inventory won't have a maximum size
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
    bool add(T itemToAdd){
        if(itemToAdd is null || this.countSpaceRemaining - getSize(itemToAdd) < 0){
            return false;
        }
        this.contained ~= itemToAdd;
        return true;
    }

    /**
     * Removes the given item from the inventory and sets its location in the items array to null
     * Returns whether the item given was successfully removed
     * Params:
     *      itemToRemove = the item to remove from the inventory
     */
    bool remove(T itemToRemove){
        if(this.items.canFind(itemToRemove)){
            this.contained = this.items.remove(this.items.countUntil(itemToRemove));
            return true;
        }
        return false;
    }

    /**
     * Returns the amount of space taken up in this inventory.
     */
    int countSpaceUsed(){
        int spaceUsed;
        foreach(item; this.items){
            spaceUsed += getSize(item);
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
     * Gets the size of the given object
     * Params:
     *      objectToGetSizeOf = the object to get the size of
     */
    int getSize(T objectToGetSizeOf){
        static if(__traits(hasMember, T, "getSize")){
            return objectToGetSizeOf.getSize();
        }else{
            return 1;
        }
    }

    /**
     * Returns a copy of this inventory
     * Changes in this inventory are not reflected in the copy
     * Changes in players are reflected in the copy, however
     */
    Inventory clone(){
        Inventory copy = new Inventory(this.maxSize);
        static if(__traits(hasMember, T, "clone")){
            foreach(i; 0..this.items.length){
                copy.items[i] = this.items[i].clone().to!T;
            }
        }else{
            copy.contained = this.items;
        }
        copy.accessibleTo = this.accessibleTo;
        copy.coords = this.coords;
        return copy;
    }

}

unittest{
    import std.stdio;

    writeln("\nRunning unittest of Inventory");

    Inventory!Item testInv = new Inventory!Item(1);
}
