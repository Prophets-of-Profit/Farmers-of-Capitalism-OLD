module item.settlement.DistrictComponent;

import std.algorithm;
import std.array;
import std.conv;
import std.random;

import character.Character;
import item.settlement.District;
import item.Inventory;
import item.Item;
import item.settlement.Settlement;
import world.World;

abstract class DistrictComponent : Item{

    Settlement settlement;          ///The settlement this component is in
    District district;              ///The settlement this component is in
    int landUsed;                   ///The amount of land this component takes up

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

    override bool getPlaced(Character placer, Coordinate newLocation);

    /**
     * Does nothing when stepped on
     */
    override void getSteppedOn(Character stepper){}

    override void doIncrementalAction();

    /**
     * A player can choose to stay in the house.
     */
    override void doMainAction(Character player);

    /**
     * When the house is destroyed, reduce the amount of space available to characters.
     */
    override void getDestroyedBy(Character destroyer){
        this.getMovedTo(null);
    }

    /**
     * Returns the amount of land this house uses in the city
     */
    override int getSize(){
        return this.landUsed;
    }

    /**
     * Houses are white
     * Color doesn't matter because you can't sell houses
     */
    override Color getColor(){
        return Color(0, 0, 0);
    }

    /**
     * Houses have 0 usefulness because you won't be selling them
     */
    override double getUsefulness(){
        return 0;
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

    /**
     * Because houses cannot be sold, this method isn't really implemented and just returns false: all houses are unique
     */
    override bool isSimilarTo(Item otherItem){
        return false;
    }

}
