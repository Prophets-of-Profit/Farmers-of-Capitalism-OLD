module character.worker.Tool;

import character.Character;
import character.worker.Worker;
import item.Item;
import world.World;

/**
 * A tool for a worker to carry and use
 * Unused code
 */
class Tool : Item {

    int strength;           ///The effectiveness of the tool
    int size;               ///The size of the tool
    Character owner;           ///The user of this tool

    /**
     * Constructs a new Tool object
     */
    this(int strength, int size, Character owner){
        this.strength = strenth;
        this.size = size;
        this.owner = owner;
    }

    /**
     * Tools cannot be placed
     */
    override bool canBePlaced(Coordinate placementCandidateCoords){
        return false;
    }

    Character getOwner(){
        return this.owner;
    }
    double getMovementCost(Character stepper){
        return 0;
    }
    void getSteppedOn(Character stepper){}                    ///What the Item should do when stepped on
    void doIncrementalAction(){}                              ///What the Item should do every turn
    void doMainAction(Character player){}                     ///What the Item should do when the player interacts with it; should do different actions based on whether it isPlaced
    void getDestroyedBy(Character destroyer){}                ///What/how the Item gets destroyed and what it will do when destroyed
    int getSize(){
        return this.size;
    }                                           ///Gets the amount of space this item takes up in an inventory
    Color getColor();                                        ///Returns the color of the item
    double getUsefulness(){
        return 1;
    }                                  ///Returns the usefulness of the item
    Item clone(){
        return new Tool(this.strength, this.size, this.owner);
    }                                            ///Returns a copy of the Item
    override string toString(){
        return "";
    }                              ///The item's name as a string
    bool isSimilarTo(Item otherItem){
        return false;
    }                        ///Checks if an item is similar to another
}
