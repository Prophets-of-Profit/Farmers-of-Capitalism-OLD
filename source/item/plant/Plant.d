module item.plant.Plant;

import std.algorithm;
import std.conv;

import app;
import character.Character;
import item.Inventory;
import item.Item;
import item.plant.PlantTraits;
import world.HexTile;
import world.Range;
import world.World;

/**
 * A parent class for all plant objects.
 * Contains basic (non-functional) traits and methods shared between all plants.
 */
class Plant : Item{

    /**
     * A collection of ranges
     * The first range is the survival range for the plant
     * The second range is the optimal range for the plant
     */
    struct Conditions{
        Range!double survival;    ///The conditions which need to be met for the plant to live
        Range!double optimal;     ///The conditions at which the plant thrives
    }

    AttributeSet attributes;                    ///All the attributes this plant has and can pass down
    AttributeSet usableAttributes;              ///The attributes that the plant can actually use
    Conditions[TileStat] plantRequirements;     ///The survivable and optimal conditions for a plant

    /**
     * A constructor for a plant for all types of plant generation
     * Ensures that attributes are set
     * All other plant constructors call this one
     * Params:
     *      source = the source inventory this plant will go to
     *      allAttributes = the attributes this plant will have
     */
    this(Inventory source, AttributeSet allAttributes){
        this.attributes = allAttributes;
        this.usableAttributes = this.attributes.getVisibleAttributes();
        this.getMovedTo(source);
        HexTile tileOfCreation = game.mainWorld.getTileAt(this.coords);
        foreach(tileStat; __traits(allMembers, TileStat)){
            TileStat stat = tileStat.to!TileStat;
            double survivableDeviation = 0.25;
            double optimalDeviation = 0.075;
            Range!double survivable = Range!double(Range!double(0, 1, tileOfCreation.climate[stat] - survivableDeviation), Range!double(0, 1, tileOfCreation.climate[stat] + survivableDeviation));
            Range!double optimal = Range!double(Range!double(0, 1, tileOfCreation.climate[stat] - optimalDeviation), Range!double(0, 1, tileOfCreation.climate[stat] + optimalDeviation));
            plantRequirements[stat] = Conditions(survivable, optimal);
        }
    }

    /**
     * A constructor for a plant if generated naturally
     * Natural plants are placed in the world and must be modeled after an existing DefaultPlant as natural plants shouldn't be anything new or unique
     * Params:
     *      location = where this natural plant will be generated
     *      base = the DefaultPlant from which to model this plant
     */
    this(Coordinate location, DefaultPlant base){
        this(game.mainWorld.getTileAt(location).contained, base.defaultAttributes);
    }

    /**
     * The constructor for a plant if generated from another plant
     * Only works if the plant can have a single parent
     * The plant will place itself
     * Params:
     *      parent = the plant's parent
     */
    this(Plant parent){
        //TODO
    }

    /**
     * The constructor for a plant if generated from two other parents
     * Works when the plant can be bred from two other plants
     * Params:
     *      firstParent = one of this plant's parents
     *      secondParent = one of this plant's other parents
     */
    this(Plant firstParent, Plant secondParent){
        //TODO
    }

    /**
     * Gets the plant's owner
     * Is slottable
     */
    override Character getOwner(){
        return usableAttributes.getOwnerActions[0](this);   //Doesn't iterate through the actions in the category because there can only be one owner
    }

    /**
     * Whether the plant can be placed at the given coordinates
     * Is slottable; all of the attributes for determining plant placement must have their conditions met for the plant to be placed at a certain coordinate
     * Params:
     *      placementCandidateCoords = the location to check of whether the plant can be placed there
     */
    override bool canBePlaced(Coordinate placementCandidateCoords){
        foreach(action; usableAttributes.canBePlacedActions){
            if(!action(placementCandidateCoords, this)){
                return false;
            }
        }
        return true;
    }

    /**
     * Places the plant at a certain location
     * Is not slottable and this is generic and true for all plants
     * Returns whether the placement was successful or not
     * Params:
     *      placer = the character that placed the plant; is unused for plant, but may be used for other items
     *      newLocation = the location for the plant to be placed
     */
    override bool getPlaced(Character placer, Coordinate newLocation){
        return canBePlaced(newLocation) && this.getMovedTo(game.mainWorld.getTileAt(newLocation).contained);
    }

    /**
     * Gets how much this plant affects movement cost
     * Is slottable; all attributes that return a movement cost are summed and then returned
     * Params:
     *      stepper = the character that stepped on the plant
     */
    override double getMovementCost(Character stepper){
        return usableAttributes.getMovementCostActions.map!(a => a(stepper, this)).reduce!((a, b) => a + b);
    }

    /**
     * The action for what the plant should do when stepped on
     * Is slottable
     * Params:
     *      stepper = the character that has stepped on the plant
     */
    override void getSteppedOn(Character stepper){
        foreach(action; usableAttributes.steppedOnActions){
            action(stepper, this);
        }
    }

    /**
     * What the plant does every turn
     * Is slottable
     */
    override void doIncrementalAction(){
        foreach(action; usableAttributes.incrementalActions){
            action(this);
        }
    }

    /**
     * What the plant should do when the player interacts with it
     * Is slottable
     * Params:
     *      player = the character interacting with the plant
     */
    override void doMainAction(Character player){
        foreach(action; usableAttributes.mainActions){
            action(player, this);
        }
    }

    /**
     * What the plant should do when destroyed by a player
     * Is slottable
     * Params:
     *      destroyer = the player who is destroying the plant
     */
    override void getDestroyedBy(Character destroyer){
        foreach(action; usableAttributes.destroyedActions){
            action(destroyer, this);
        }
    }

    /**
     * The amount of inventory space this plant takes up
     * Is slottable
     */
    override int getSize(){
        return usableAttributes.getSizeActions.map!(a => a(this)).reduce!((a, b) => a + b);
    }

    /**
     * Makes a copy of this plant
     */
    override Plant clone(){
        Plant clone = new Plant(null, this.attributes);
        clone.usableAttributes = this.usableAttributes; //is called again because sometimes getVisibleAttributes() determines the visible attributes randomly as a tie breaker
        clone.source = this.source.clone; //clone isn't .getMovedTo the inventory clone because the clone already contains a copy of this plant
        clone.plantRequirements = this.plantRequirements;
        return clone;
    }

}

unittest{
    import std.stdio;

    writeln("\nRunning unittest of Plant");

    int worldSize = 5;
    game.mainWorld = new World(worldSize);
    int numRuns = 5;
    foreach(i; 0..numRuns){
        //TODO
    }
}
