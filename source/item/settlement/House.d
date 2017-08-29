module item.settlement.House;

import std.algoritm;
import std.array;
import std.random;

import item.settlement.Settlement;
import item.Item;
import item.Inventory;

class House : Item{

    Settlement settlement;          ///The settlement this house is in
    int livingSpace;                ///The amount of characters that can live in this house
    int landUsed;                   ///The amount of land this house takes up

    /*
     * Constructs a new House object
     *  Params:
     *      settlement = the settlement this house is being built in
     *      space = the number of characters that can live in this house
     *      land = the amount of land that this house takes up
     **/
    this(Settlement settlement, int space, int land){
        this.settlement = settlement;
        this.livingSpace = space;
        this.landUsed = land;
    }

    /*
     * Returns the leader of the settlement this house is in
     **/
    @Override Character getOwner(){
        return this.settlement.leader;
    }

    /*
     * Returns whether or not the tile at the coordinate is a settlement
     **/
    @Override bool canBePlaced(Coordinate placementCandidateCoords){
            //TODO: if settlement is on tile, return true
    }

    /*
     * Adds zero to the movement cost (houses do not affect movement cost)
     **/
    @Override double getMovementCost(Character stepper);
        return 0;
    }

    /*
     * Adds a new house to the settlement, adding extra population space
     **/
    @Override bool getPlaced(Character placer, Coordinate newLocation){
        this.settlement.characters.maxSize += this.livingSpace;
    }

    /*
     * Does nothing when stepped on
     **/
    @Override void getSteppedOn(Character stepper){}

    /*
     * Has no incremental action
     **/
    @Override void doIncrementalAction(){}

    /*
     * A player can choose to stay in the house.
     **/
    @Override void doMainAction(Character player){
        if(this.settlement.characters.countSpaceRemaining > 0){
            this.settlement.characters.add(player);
        }
    }

    /*
     * When the house is destroyed, reduce the amount of space available to characters.
     **/
    @Override void getDestroyed(Character destroyer){
        this.getMovedTo(null);
        this.settlement.characters.maxSize -= this.livingSpace;
    }

    /*
     * Returns the amount of land this house uses in the city
     **/
    @Override int getSize(){
        return this.landUsed;
    }

    /*
     * Returns a copy of this house.
     **/
    @Override Item clone(){
        return new House(this.settlement, this.livingSpace, this.landUsed);
    }

}
