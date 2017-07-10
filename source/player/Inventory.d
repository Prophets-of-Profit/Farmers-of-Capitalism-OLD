import Player;
import TilePiece;
import core.exception;

/**
 * A class for an object that holds other objects
 */
class Inventory{

    public Player[] accessibleTo;   ///A list of players who can access the inventory
    private TilePiece[] items;      ///All the items inside of the inventory
    public int maxSize;             ///The maximum number of elements in the inventory; if is negative, the array can have infinite elements
    public int[] coords;            ///The location of the tile or the player or inventorycontainer with this inventory

    /**
     * A constructor for an inventory
     * Usually for players, but may also be needed for improvements/plants
     * Takes in a size, but if the inventory size is negative, the inventory has infinite size
     */
    this(int maxSize){
        items = (maxSize < 0)? null : new TilePiece[maxSize];
    }

    /**
     * Attempts to add an item to the inventory, and returns whether the operation was successful or not
     * Params:
     *      toAdd = the item to add to the inventory
     */
    public bool addItem(TilePiece toAdd){
        try{
            this.items ~= toAdd;
            return true;
        }catch(RangeError e){
            return false;
        }
    }

    /**
     * Gets the number of tile pieces in the inventory
     */
    public int getSize(){
        if(this.maxSize < 0){
            return this.items.length;
        }
        int size = 0;
        foreach(TilePiece item ; this.items){
            if(item !is null){
                size++;
            }else{
                return size;
            }
        }
        return 0;
    }

    public int getCollectiveMovementCost(){
        return 0;
    }

    public int getCollectiveValue(){
        return 0;
    }

    public TilePiece get(int index){
        return null;
    }

    public TilePiece remove(int index){
        return null;
    }

    public TilePiece remove(TilePiece toRemove){
        return null;
    }

    public bool doesExist(TilePiece item){
        return false;
    }

}

unittest{
    //TODO add implementation
}