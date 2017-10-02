module item.Item;

import app;
import character.Character;
import item.Inventory;
import world.Range;
import world.World;

/**
 * Represents a color in an easily used struct
 * Color is in RGB
 */
struct Color {
    private Range!int r = Range!int(0, 255);
    private Range!int g = Range!int(0, 255);
    private Range!int b = Range!int(0, 255);

    alias rgb this;

    this(int r, int g, int b){
        this.red = r;
        this.green = g;
        this.blue = b;
    }

    @property int red(int newRed){
        this.r.current = newRed;
        return newRed;
    }

    @property int red(){
        return this.r.current;
    }

    @property int green(int newGreen){
        this.g.current = newGreen;
        return newGreen;
    }

    @property int green(){
        return this.g.current;
    }

    @property int blue(int newBlue){
        this.b.current = newBlue;
        return newBlue;
    }

    @property int blue(){
        return this.b.current;
    }

    @property int[] rgb(){
        return [this.red, this.blue, this.green];
    }
}

/**
 * An abstract class defining what objects that belong to a tile must do
 * This is a contract ensuring that all objects tiles have certain functionalities
 */
abstract class Item {

    public Range!double completion = Range!double(0, 1, 0);         ///How close the Item is towards being complete: once it won't function until it has reached completion
    public Inventory!Item source;                                   ///The source inventory for where the item is/came from

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
    void die(bool isBeingCalledFromGetDestroyed = false){
        if(!isBeingCalledFromGetDestroyed){
            this.getDestroyedBy(null);
        }
        if(this.source !is null){
            this.source.remove(this);
        }
    }

    /**
     * What the Item should do when moved to a different inventory: has a default implementation
     * Params:
     *      newSource = the new inventory to be moved to
     */
    bool getMovedTo(Inventory!Item newSource){
        if(newSource is null){
            return false;
        }
        if(this.source !is null){
            Inventory!Item oldSource = this.source;
            this.source.remove(this);
            if(!newSource.add(this)){
                return this.getMovedTo(oldSource);
            }
        }
        this.source = newSource;
        return newSource.add(this);
    }

    /**
     * Can be overriden
     * Returns whether the location to be placed has enough space
     */
    bool canBePlaced(Coordinate placementCandidateCoords){
        return game.mainWorld.getTileAt(placementCandidateCoords).contained.countSpaceRemaining >= this.getSize();
    }

    /**
     * Can be overriden
     * What the item does when placed
     * This is a default implementation
     */
    bool getPlaced(Character placer, Coordinate newLocation){
        return this.canBePlaced(newLocation) && this.getMovedTo(game.mainWorld.getTileAt(newLocation).contained);
    }

    Character getOwner();                                    ///Gets the owner of the Item
    double getMovementCost(Character stepper);               ///Returns the movement cost of the Item (how much the Item would affect movement were it placed)
    void getSteppedOn(Character stepper);                    ///What the Item should do when stepped on
    void doIncrementalAction();                              ///What the Item should do every turn
    void doMainAction(Character player);                     ///What the Item should do when the player interacts with it; should do different actions based on whether it isPlaced
    void getDestroyedBy(Character destroyer);                ///What/how the Item gets destroyed and what it will do when destroyed
    int getSize();                                           ///Gets the amount of space this item takes up in an inventory
    Color getColor();                                        ///Returns the color of the item
    double getUsefulness();                                  ///Returns the usefulness of the item
    Item clone();                                            ///Returns a copy of the Item
    override string toString();                              ///The item's name as a string
    bool isSimilarTo(Item otherItem);                        ///Checks if an item is similar to another

}
