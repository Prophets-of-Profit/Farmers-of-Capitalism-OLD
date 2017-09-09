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

    District district;              ///The district this component is in
    int landUsed;                   ///The amount of land this component takes up

    /**
     * Constructs a new House object
     *  Params:
     *      district = the district this component is in
     *      land = the amount of land that this component takes up
     */
    this(District district, int land){
        this.district = district;
        this.landUsed = land;
    }

    /**
     * Returns the leader of the settlement this component is in.
     */
    override Character getOwner(){
        return this.district.settlement.leader;
    }

    /**
     * When the component is destroyed, move it to null inventory.
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
     * See item documentation for abstract methods
     */
    override bool isSimilarTo(Item otherItem);
    override Color getColor();
    override double getUsefulness();
    override void doIncrementalAction();
    override void doMainAction(Character player);
    override double getMovementCost(Character stepper);
    override void getSteppedOn(Character stepper);
    override Item clone();

}
