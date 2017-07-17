import Player;
import TilePiece;
import core.exception;

/**
 * A class for an object that holds other objects
 * TODO add iterator for a foreach loop
 */
class Inventory{

    public Player[] accessibleTo;   ///A list of players who can access the inventory
    public TilePiece[] items;       ///All the items inside of the inventory
    public int maxSize;             ///The maximum number of elements in the inventory; if is negative, the array can have infinite elements
    public int[] coords;            ///The location of the tile or the player or inventorycontainer with this inventory

    /**
     * A constructor for an inventory
     * Usually for players, but may also be needed for improvements/plants
     * Takes in a size, but if the inventory size is negative, the inventory has infinite size
     */
    this(int maxSize = -1){
        this.maxSize = maxSize;
        items = (maxSize < 0)? null : new TilePiece[maxSize];
    }

    /**
     * Adds the given tile piece to the inventory
     * Returns whether the tile piece was successfully added to inventory
     * Params:
     *      itemToAdd = the item to add to the inventory
     */
    public bool add(TilePiece itemToAdd){
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
     * Removes the given tile piece to the inventory and sets its location in the items array to null
     * Returns the tile piece given it was successfully removed, otherwise returns null
     * Params:
     *      itemToRemove = the item to remove from the inventory
     */
    public TilePiece remove(TilePiece itemToRemove){
        for(int i = 0; i < this.items.length; i++){
            if(this.items[i] == itemToRemove){
                this.items[i] = null;
                return itemToRemove;
            }
        }
        return null;
    }

    /**
     * Gets the movement cost of all of the items in the inventory
     */
    public double getCollectiveMovementCost(){
        double moveCost = 0;
        foreach(TilePiece item ; this.items){
           if(item !is null && item.isPlaced){
                moveCost += item.getMovementCost();
           }
        }
        return moveCost;
    }

    /**
     * Gets the collective value of all of the items in the inventory
     * TODO
     */
    public int getCollectiveValue(){
        return 0;
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
    Inventory testInv = new Inventory(1);
    assert(testInv.add(null));
    assert(testInv.add(null));
    //TODO assert(testInv.add(someTilePiece));
    //TODO assert(!testInv.add(someTilePiece));
}