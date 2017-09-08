module item.Silo;

import character.Character;
import item.Inventory;
import item.Item;

/**
 * A silo is a storage item that has an inventory that can store items
 */
class Silo : Item{

    Inventory!Item contents;    ///What the silo contains

    /**
     * Constructs a silo of the given size
     * Params:
     *      size = the size of the inventory and silo
     */
    this(int size){
        //TODO override inventory owner property to be the same as this item's owner
        this.contents = new Inventory!Item(size);
    }

    /**
     * The owner of the silo is the owner of the source inventory
     */
    override Character getOwner(){
        return this.source.owner;
    }

    /**
     * Silos don't affect movement speed
     */
    override double getMovementCost(Character stepper){
        return 0;
    }

    /**
     * Silos don't do anything special when stepped on
     */
    override void getSteppedOn(Character stepper){}

    /**
     * Silos don't have any repeated per-turn actions
     */
    override void doIncrementalAction(){}

    /**
     * What the silo does when interacted with
     * Opens up the inventory to the player's screen
     */
    override void doMainAction(Character player){/*TODO*/}

    /**
     * What the silo does when destroyed
     */
    override void getDestroyedBy(Character destroyer){
        this.die(true);
    }

    /**
     * The size of the silo
     * Silos can store 3 times their size
     */
    override int getSize(){
        return this.contents.maxSize / 3;
    }

    /**
     * All Silos are //TODO
     */
    override Color getColor(){
        return Color();
    }

    /**
     * How useful this item is
     * Is directly correlated to how many spaces this silo can hold
     */
    override double getUsefulness(){
        return this.contents.maxSize;
    }

    /**
     * Returns a clone of the silo
     * //TODO
     */
    override Item clone(){
        return null;
    }

    /**
     * The name of the silo
     * Is always "Silo"
     */
    override string toString(){
        return "Silo";
    }

    /**
     * Returns whether two silos are similar
     * Silos are similar when two items are both silos
     */
    override bool isSimilarTo(Item otherItem){
        return (cast(Silo) otherItem)? true : false;
    }

}
