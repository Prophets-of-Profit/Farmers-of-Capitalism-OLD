module item.Item;

import item.Inventory;
import character.Character;
import app;

/**
 * An abstract class defining what objects that belong to a tile must do
 * This is a contract ensuring that all objects tiles have certain functionalities
 */
abstract class Item{

    public double completion;       ///How close the Item is towards being complete: once it won't function until it has reached completion
    public Inventory source;     ///The source inventory for where the item is/came from
    public bool isPlaced = false;   ///Whether the Item is in a hextile or not

    /**
     * Kills the current item
     * Just removes the item from the source inventory if it exists
     */
    public void die(){
        this.getDestroyed(null);
        if(this.source !is null){
            this.source.remove(this);
        }
    }

    /**
     * What the Item should do when moved to a different inventory: has a default implementation
     * Params:
     *      newSource = the new inventory to be moved to
     */
    public bool getMovedTo(Inventory newSource){
        Inventory oldSource = this.source;
        this.source.remove(this);
        if(newSource.add(this)){
            this.source = newSource;
            return true;
        }else{
            getMovedTo(oldSource);
            return false;
        }
    }

    public abstract Character getOwner();                               ///Gets the owner of the Item
    public abstract bool canBePlaced(int[] placementCandidateCoords);   ///Returns whether the Item can be placed
    public abstract bool getPlaced(Character placer, int[] newLocation);///What the Item should do when created
    public abstract double getMovementCost();                           ///Returns the movement cost of the Item (how much the Item would affect movement were it placed)
    public abstract void getSteppedOn(Character stepper);               ///What the Item should do when stepped on
    public abstract void doIncrementalAction();                         ///What the Item should do every turn
    public abstract void doMainAction(Character player);                ///What the Item should do when the player interacts with it; should do different actions based on whether it isPlaced
    public abstract void getDestroyed(Character destroyer);             ///What/how the Item gets destroyed and what it will do when destroyed
    public abstract Item clone();                                       ///Returns a copy of the Item

}
