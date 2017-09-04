module item.settlement.House;

import std.algorithm;
import std.array;
import std.conv;
import std.random;

import character.Character;
import item.Inventory;
import item.Item;
import item.settlement.Settlement;
import world.World;

class House : Item{

    Settlement settlement;          ///The settlement this house is in
    int livingSpace;                ///The amount of characters that can live in this house
    int landUsed;                   ///The amount of land this house takes up

    /**
     * Constructs a new House object
     *  Params:
     *      settlement = the settlement this house is being built in
     *      space = the number of characters that can live in this house
     *      land = the amount of land that this house takes up
     */
    this(Settlement settlement, int space, int land){
        this.settlement = settlement;
        this.livingSpace = space;
        this.landUsed = land;
    }

    /**
     * Returns the leader of the settlement this house is in
     */
    override Character getOwner(){
        return this.settlement.leader;
    }

    /**
     * Adds zero to the movement cost (houses do not affect movement cost)
     */
    override double getMovementCost(Character stepper){
        return 0;
    }

    /**
     * Adds a new house to the settlement, adding extra population space
     */
    override bool getPlaced(Character placer, Coordinate newLocation){
        if(super.getPlaced(placer, newLocation)){
            this.settlement.characters.maxSize += this.livingSpace;
            return true;
        }
        return false;
    }

    /**
     * Does nothing when stepped on
     */
    override void getSteppedOn(Character stepper){}

    /**
     * Has no incremental action
     */
    override void doIncrementalAction(){}

    /**
     * A player can choose to stay in the house.
     */
    override void doMainAction(Character player){
        if(this.settlement.characters.countSpaceRemaining > 0){
            this.settlement.characters.add(player);
        }
    }

    /**
     * When the house is destroyed, reduce the amount of space available to characters.
     */
    override void getDestroyedBy(Character destroyer){
        this.getMovedTo(null);
        this.settlement.characters.maxSize -= this.livingSpace;
    }

    /**
     * Returns the amount of land this house uses in the city
     */
    override int getSize(){
        return this.landUsed;
    }

    /**
     * Returns a copy of this house
     */
    override Item clone(){
        return new House(this.settlement, this.livingSpace, this.landUsed);
    }

    /**
     * Returns a string representing the house
     */
    override string toString(){
        return "House with "~livingSpace.to!string~" living space and "~landUsed.to!string~" land used.";
    }

}
