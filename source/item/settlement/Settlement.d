module item.settlement.Settlement;

import std.algorithm;

import character.Character;
import item.Inventory;
import item.Item;
import item.plant.Plant;
import world.World;

immutable maxSpaceForTile = 100;
immutable baseHousingPerTile = 5;

/*
 * Returns the nearest settlement to the origin
 * Params:
 *      origin = the origin from which to find the nearest settlement
 *      blacklist = a list of settlements that should not be returned by this function
 **/
Settlement findNearestSettlement(Coordinate origin, Settlement[] blacklist = []){
    //TODO: implement this function
}

class Settlement{

    Coordinate location;                     ///The location of this settlement
    Inventory!Character characters;          ///An inventory of the characters
    Inventory!Item buildings;                ///An inventory of the buildings
    Character leader;                        ///The leader of the settlement

    /*
     * Constructs a new settlement.
     * Params:
     *      leader = the character that leads this settlement
     *      location = the location this settlement is at
     **/
    this(){
        workers = new Inventory!Character(baseHouseingPerTile);
        buildings = new Inventory!Item(maxSpaceForTile);
    }

    /*
     * Adds a building to this settlement. Plants cannot be added to settlements.
     **/
    void addBuilding(Item building){
        if(building.canBePlaced(this.location)){
            this.buildings.add(building);
        }
    }

    /*
     * Returns the settlement's leader
     **/
    @Override Character getOwner(){
        return this.leader;
    }

    /*
     * Settlements can be placed on any tile that does not already have a settlement
     **/
    @Override bool canBePlaced(Coordinate placementCandidateCoords){
        return true;
    }

    /*
     * Add a new settlement to the tile's inventory when it is created, assign the leader to be the one that placed it.
     **/
    @Override bool getPlaced(Character placer, Coordinate newLocation){
        mainWorld.getTileAt(newLocation).contained.add(this);
        this.leader = placer;
    }

    /*
     * Returns 0; settlements do not impede movement.
     **/
    @Override double getMovementCost(Character stepper){
        return 0;
    }

    @Override void getSteppedOn(Character stepper){}

    @Override void doIncrementalAction(){}

    /*
     * A player interacts with the settlement.
     **/
    @Override void doMainAction(Character player){
        //TODO: Make it so the the player can interact with the settlement
    }

    @Override void getDestroyed(Character destroyer){
        //TODO: Make refugees happen when settlement is destroyed
    }

    /*
     * Settlements take up all of the space in a tile's inventory; improvements can be added to the settlement's buildings
     **/
    @Override int getSize(){
        return 1;
    }

    /*
     * Returns a copy of this settlement
     **/
    @Override Item clone(){
        Settlement cloned = new Settlement();
        cloned.leader = this.leader;
        cloned.location = this.location;
        cloned.characters = this.characters.clone();
        cloned.buildings = this.buildings.clone();
        return cloned;
    }

}
