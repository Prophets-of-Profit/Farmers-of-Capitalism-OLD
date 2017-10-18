module item.settlement.District;

import app;
import character.Character;
import government.Government;
import item.Inventory;
import item.Item;
import item.settlement.DistrictComponent;
import item.settlement.Settlement;
import world.World;

immutable maxSpaceForTile = 100;

/**
 * An item that represents a settlement for the purpose of being stored on a HexTile
 */
class District : Item {

    Settlement settlement;
    Coordinate location;                                                                        ///The location of this district
    Inventory!Character characters = new Inventory!Character(baseHousingPerSettlement);         ///An inventory of the characters
    Inventory!DistrictComponent buildings = new Inventory!DistrictComponent(maxSpaceForTile);

    void addComponent(DistrictComponent toAdd){

    }

    /**
     * Returns the settlement's leader
     */
    override Character getOwner(){
        return settlement.government.owner;
    }

    /**
     * Returns 0; settlements do not impede movement
     */
    override double getMovementCost(Character stepper){
        return 0;
    }

    override void getSteppedOn(Character stepper){}

    override void doIncrementalAction(){}

    /**
     * A player interacts with the settlement.
     */
    override void doMainAction(Character player){
        //TODO: Make it so the the player can interact with the settlement
    }

    override void getDestroyedBy(Character destroyer){
        //TODO: Make refugees happen when settlement is destroyed
    }

    /**
     * Settlements take up all of the space in a tile's inventory; improvements can be added to the settlement's buildings
     */
    override int getSize(){
        return 1;
    }

    /**
     * Districts are white
     * TODO?
     */
    override Color getColor(){
        return Color(0, 0, 0);
    }

    /**
     * Districts have 0 usefulness because you can't sell districts anyways; TODO: Make this not that
     */
    override double getUsefulness(){
        return 0;
    }

    /**
     * Returns a copy of settlement settlement
     */
    override Item clone(){
        District cloned = new District();
        cloned.settlement = this.settlement;    //TODO: clone settlement
        return cloned;
    }

    /**
     * Returns a string representing the settlement
     */
    override string toString(){
        return ""; //TODO: Implement toString
    }

    /**
     * Districts are always unique, but comparison isn't really implemented becase it can't/won't be used because districts cannot be sold
     */
    override bool isSimilarTo(Item otherItem){
        return false;
    }

    /**
     * Places a central district. Creates a settlement centered around a district.
     */
    override bool getPlaced(Character placer, Coordinate newLocation){
        if(this.canBePlaced(newLocation) && this.getMovedTo(game.mainWorld.getTileAt(newLocation).contained)){
            this.settlement = new Settlement();
            this.settlement.tiles.add(this);
            placer.government.settlements.add(this.settlement);
            game.mainWorld.allSettlements ~= this.settlement;
            this.location = newLocation;
            return true;
        }
        return false;
    }

}
