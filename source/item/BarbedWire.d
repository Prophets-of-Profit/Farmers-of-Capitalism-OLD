module item.BarbedWire;

import std.conv;

import character.Character;
import item.Item;
import world.Range;

/**
 * Barbed wire is an item that slows down and hurts other players
 */
class BarbedWire : Item{

    double strength;    ///How much this barbed wire should hurt/slow down

    /**
     * Makes a barbed wire with the given strength
     * Params:
     *      strength = how effective this barbed wire is
     */
    this(double strength = 0.5){
        this.strength = strength;
    }

    /**
     * Gets the owner of the barbed wire as the owner of the tile
     */
    override Character getOwner(){
        return this.source.owner;
    }

    /**
     * How much the barbed wire impedes movement
     * Is derived from the barbed wire strength
     */
    override double getMovementCost(Character stepper){
        return this.strength;
    }

    /**
     * Characters get damaged when stepping on barbed wire
     * Is derived from 10x the strength of the barbed wire
     */
    override void getSteppedOn(Character stepper){
        stepper.health = (this.strength * 10).to!int;
    }

    /**
     * Barbed wire does nothing every turn
     */
    override void doIncrementalAction(){}

    /**
     * The main action does nothing when interacted with
     */
    override void doMainAction(Character player){}

    /**
     * Destroys the barbed wire
     */
    override void getDestroyedBy(Character destroyer){
        this.die(true);
    }

    /**
     * The size of the barbed wire is as big as its strength
     */
    override int getSize(){
        return (10 * this.strength).to!int;
    }

    /**
     * Returns a gray color
     */
    override Color getColor(){
        return Color(120, 100, 100);
    }

    /**
     * The usefulness of the barbed wire is its strength;
     */
    override double getUsefulness(){
        return this.strength;
    }

    /**
     * Clones the barbed wire
     */
    override Item clone(){
        return new BarbedWire(this.strength);
    }

    /**
     * The text form of BarbedWire is Barbed Wire
     */
    override string toString(){
        return "Barbed Wire";
    }

    /**
     * Barbed wire is similar to barbed wire
     */
    override bool isSimilarTo(Item otherItem){
        return (cast(BarbedWire) otherItem)? true : false;
    }

}
