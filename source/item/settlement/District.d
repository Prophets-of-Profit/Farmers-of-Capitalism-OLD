module item.settlement.District;

import app;
import character.Character;
import item.Inventory;
import item.Item;
import item.settlement.Settlement;
import world.World;

/**
 * An item that represents a settlement for the purpose of being stored on a HexTile
 */
class District : Item{

    Settlement settlement;
    Inventory!Item buildings;

    /**
     * Returns the settlement's leader
     */
    override Character getOwner(){
        return settlement.leader;
    }

    /**
     * Settlements can be placed on any tile that does not already have a settlement
     */
    override bool canBePlaced(Coordinate placementCandidateCoords){
        return true;
    }

    /**
     * Returns false
     */
    override bool getPlaced(Character placer, Coordinate newLocation){
        return false;
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

}
