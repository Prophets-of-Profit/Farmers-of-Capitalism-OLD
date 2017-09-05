module item.Road;

import std.algorithm;

import app;
import character.Character;
import item.Item;
import item.Inventory;
import world.World;

/**
 * A road is an item which speeds up those who walk upon it
 */
class Road : Item{

    double speedReduction;  ///How much the road speeds the player up

    /**
     * Makes a road with the given speed reduction
     * Params:
     *      speedReduction = how much the road speeds the player up
     */
    this(double speedReduction = 0.5){
        this.speedReduction = speedReduction;
    }

    /**
     * The owner of the road
     */
    override Character getOwner(){
        return this.source.owner;
    }

    /**
     * Returns whether a road can be placed at a given coordinate
     * Criterion is that the tile has enough space and that no other roads exist on the tile
     */
    override bool canBePlaced(Coordinate placementCandidateCoords){
        Inventory!Item newInv = game.mainWorld.getTileAt(placementCandidateCoords).contained;
        foreach(item; newInv){
            if(cast(Road) item){
                return false;
            }
        }
        return super.canBePlaced(placementCandidateCoords);
    }

    /**
     * Returns a negative movement cost so that this item will speed up those who walk on it
     */
    override double getMovementCost(Character stepper){
        return -this.speedReduction;
    }

    /**
     * Does nothing when stepped on by a character
     */
    override void getSteppedOn(Character stepper){}

    /**
     * Does nothing every turn
     */
    override void doIncrementalAction(){}

    /**
     * Does nothing when interacted with
     */
    override void doMainAction(Character player){}

    /**
     * Does nothing special when destroyed
     */
    override void getDestroyedBy(Character destroyer){
        this.die(true);
    }

    /**
     * Roads are always of size 1
     */
    override int getSize(){
        return 1;
    }

    /**
     * Gets the color of the road
     * Roads are black
     */
    override Color getColor(){
        return Color(255, 255, 255);
    }

    /**
     * Returns how much this road reduces movement cost as its usefulness
     */
    override double getUsefulness(){
        return this.speedReduction;
    }

    /**
     * Makes a copy of the road
     */
    override Item clone(){
        Road clone = new Road(this.speedReduction);
        clone.completion = this.completion;
        return clone;
    }

    /**
     * Roads will be represented with the string "Road"
     */
    override string toString(){
        return "Road";
    }

    /**
     * Roads are considered similar as long as they are roads, and not other items
     * Roads are only similar to roads
     */
    override bool isSimilarTo(Item otherItem){
        return (cast(Road) otherItem)? true : false;
    }

}
