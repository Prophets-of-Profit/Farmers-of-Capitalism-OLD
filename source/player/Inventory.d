import Player;
import TilePiece;

/**
 * A class for an object that holds other objects
 */
class Inventory{

    public Player[] visibleTo;  ///A list of players who can see the inventory
    public TilePiece[] items;   ///All the items inside of the inventory
    private int size;           ///The size of the inventory; if less than 0, the inventory has infinite size

    /**
     * A constructor for an inventory
     * Usually for players, but may also be needed for improvements/plants
     * Takes in a size, but if the inventory size is negative, the inventory has infinite size
     */
    this(int size){
        this.size = size;
        items = (size < 0)? null : new TilePiece[size];
    }

}

unittest{
    //TODO add implementation
}