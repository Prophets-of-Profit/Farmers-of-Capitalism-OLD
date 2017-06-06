import Inventory;
import Player;
import app;

/**
 * An abstract class defining what objects that belong to a tile must do
 * This is a contract ensuring that all objects tiles have certain functionalities
 */
abstract class TilePiece{

    public double completion;       ///How close the tilepiece is towards being complete: once it won't function until it has reached completion
    private Inventory source;       ///The source inventory for where the item is/came from
    public int movementCost;        ///How much the tilepiece would impair movement were it placed
    public bool canBePlaced = true; ///Whether this tilepiece is just an item or it can be placed
    public bool isPlaced = false;   ///Whether the tilepiece is in a hextile or not

    /**
     * What the tilepiece should do when moved to a different inventory: has a default implementation
     * Params:
     *      newSource = the new inventory to be moved to
     */
    public bool getMovedTo(Inventory newSource){
        Inventory oldSource = this.source;
        this.source.remove(this);
        if(newSource.addItem(this)){
            this.source = newSource;
            return true;
        }else{
            getMovedTo(oldSource);
            return false;
        }
    }
    public abstract Player getOwner();                      ///Gets the owner of the tilepiece
    public abstract void getPlaced(Player placer);          ///What the tile piece should do when created
    public abstract void getSteppedOn(Player stepper);      ///What the tile piece should do when stepped on
    public abstract void doIncrementalAction();             ///What the tile piece should do every turn
    public abstract void doMainAction(Player player);       ///What the tile piece should do when the player interacts with it; should do different actions based on whether it isPlaced
    public abstract void getDestroyed(Player destroyer);    ///What/how the tile piece gets destroyed and what it will do when destroyed

}