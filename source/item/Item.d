module item.Item;

import app;
import character.Character;
import item.Inventory;
import world.Range;
import world.World;

/**
 * An abstract class defining what objects that belong to a tile must do
 * This is a contract ensuring that all objects tiles have certain functionalities
 */
abstract class Item{

    public Range!double completion = Range!double(0, 1, 0);         ///How close the Item is towards being complete: once it won't function until it has reached completion
    public Inventory source;                                        ///The source inventory for where the item is/came from
    public bool isPlaced = false;                                   ///Whether the Item is in a hextile or not

    /**
     * A convenient property methods for items to access their coordinates based on their inventory
     */
    @property Coordinate coords(){
        return this.source.coords;
    }

    /**
     * Kills the current item
     * Just removes the item from the source inventory if it exists
     */
    void die(){
        this.getDestroyedBy(null);
        if(this.source !is null){
            this.source.remove(this);
        }
    }

    /**
     * What the Item should do when moved to a different inventory: has a default implementation
     * Params:
     *      newSource = the new inventory to be moved to
     */
    bool getMovedTo(Inventory newSource){
        if(newSource is null){
            return false;
        }
        if(this.source !is null){
            Inventory oldSource = this.source;
            this.source.remove(this);
            if(!newSource.add(this)){
                return this.getMovedTo(oldSource);
            }
        }
        this.source = newSource;
        return newSource.add(this);
    }

    Character getOwner();                                    ///Gets the owner of the Item
    bool canBePlaced(Coordinate placementCandidateCoords);   ///Returns whether the Item can be placed
    bool getPlaced(Character placer, Coordinate newLocation);///What the Item should do when created
    double getMovementCost(Character stepper);               ///Returns the movement cost of the Item (how much the Item would affect movement were it placed)
    void getSteppedOn(Character stepper);                    ///What the Item should do when stepped on
    void doIncrementalAction();                              ///What the Item should do every turn
    void doMainAction(Character player);                     ///What the Item should do when the player interacts with it; should do different actions based on whether it isPlaced
    void getDestroyedBy(Character destroyer);                ///What/how the Item gets destroyed and what it will do when destroyed
    int getSize();                                           ///Gets the amount of space this item takes up in an inventory
    Item clone();                                            ///Returns a copy of the Item

}
