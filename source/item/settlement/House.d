module item.settlement.House;

import std.algorithm;
import std.array;
import std.conv;
import std.random;

import character.Character;
import item.settlement.District;
import item.settlement.DistrictComponent;
import item.Inventory;
import item.Item;
import item.settlement.Settlement;
import world.World;


class House : DistrictComponent {

    int livingSpace;                ///The amount of characters that can live in this house

    /**
     * Constructs a new House object
     *  Params:
     *      district = the district this house is being built in
     *      space = the number of characters that can live in this house
     *      land = the amount of land that this house takes up
     */
    this(District district, int land, int space){
        super(district, land);
        this.livingSpace = space;
    }

    /**
     * Returns the leader of the settlement this house is in
     */
    override Character getOwner(){
        return this.district.settlement.leader;
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
            this.district.characters.maxSize += this.livingSpace;
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
        if(this.district.characters.countSpaceRemaining > 0){
            this.district.characters.add(player);
        }
    }

    /**
     * When the house is destroyed, reduce the amount of space available to characters.
     */
    override void getDestroyedBy(Character destroyer){
        this.getMovedTo(null);
        this.district.characters.maxSize -= this.livingSpace;
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
        return new House(this.district, this.livingSpace, this.landUsed);
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
