module item.plant.Plant;

import std.algorithm;
import std.conv;
import std.math;
import std.random;

import app;
import character.Character;
import item.Item;
import item.plant.PlantTraits;
import item.plant.Seedling;
import world.HexTile;
import world.Range;
import world.World;

/**
 * A parent class for all plant objects.
 * Contains basic (non-functional) traits and methods shared between all plants.
 */
class Plant : Item{

    public void delegate()[] incrementalActions;                    ///Actions taken every turn
    public void delegate(Character stepper)[] steppedOnActions;     ///Actions taken when stepped on
    public void delegate(Character player)[] mainActions;           ///Actions taken when interacted with
    public void delegate(Character destroyer)[] destroyedActions;   ///Actions taken when destroyed
    public void delegate(Character placer)[] placedActions;         ///Actions taken when placed
    public int[Attribute] attributes;                               ///Passive (constantly applied) attributes with levels from (usually) 1 to 5 in the form of ints.
    public Range!(double)[TileStat] survivableClimate;              ///Bounds of survivable temperature, water, soil, elevation.
    protected Character placer;                                     ///The person who planted the plant.
    public int[PlantReq] stats;                                     ///Contains base stats of plant.

    /**
    * The constructor for a plant.
    * Adds actions, attributes, and stats to object.
    */
    this(){
        foreach(req; __traits(allMembers, PlantReq)){
            this.stats[req.to!PlantReq] = 1;
        }
    }

    /**
    * Returns owner of HexTile if not patented. Returns placer of plant if patented.
    */
    override Character getOwner(){
        return (Attribute.PATENT in this.attributes)? this.placer : game.mainWorld.getTileAt(this.source.coords).owner;
    }

    /**
    * Checks whether the plant can be placed at a certain tile.
    * Params:
    *     placementCandidateCoords = the location of where to check if this plant can be placed
    */
    override bool canBePlaced(Coordinate placementCandidateCoords){
        HexTile tile = game.mainWorld.getTileAt(placementCandidateCoords);
        foreach(statType; tile.climate.byKey()){
            if(!this.survivableClimate[statType].isInRange(tile.climate[statType])){
                return false;
            }
        }
        if(tile.isWater != ((Attribute.AQUATIC in this.attributes) !is null)){
            return false;
        }else if(Attribute.MOVABLE in this.attributes){
            return this.completion <= this.attributes[Attribute.MOVABLE]/5.0;
        }
        return this.completion == 0;
    }

    /**
    * Returns the influence the plant has on the tile's movement cost; inherited from Item.
    */
    override double getMovementCost(){
        if(Attribute.SLOWING in this.attributes){
            return this.attributes[Attribute.SLOWING];
        }else if(Attribute.SPEEDING in this.attributes){
            return this.attributes[Attribute.SPEEDING];
        }
        return 0;
    }

    /**
    * Dictates what the plant does when placed.
    * Iterates through the plant's placedActions, executing each one.
    * Params:
    *   placer = the person who is attempting to place this plant
    *   newLocation = the location of where this plant should be placed
    */
    override bool getPlaced(Character placer, Coordinate newLocation){
        if(!this.isPlaced && this.canBePlaced(newLocation)){
            foreach(action; this.placedActions){
                action(placer);
            }
            this.isPlaced = true;
            return true;
        }
        this.placer = placer;
        return false;
    }

    /**
    * Dictates what the plant does when stepped on.
    * Iterates through the plant's steppedOnActions, executing each one.
    * Params:
    *   stepper = the person who stepped on the plant
    */
    override void getSteppedOn(Character stepper){
        if(this.isPlaced){
            foreach(action; this.steppedOnActions){
                action(stepper);
            }
            if(uniform(0, this.stats[PlantReq.RESILIENCE]) == 0){
                this.die();
            }
        }
    }

    /**
    * Dictates what the plant does each turn.
    * Iterates through the plant's incrementalActions, executing each one. Also grows.
    */
    override void doIncrementalAction(){
        if(this.isPlaced){
            foreach(action; this.incrementalActions){
                action();
            }
            if(uniform(0, getClimateFavorability()) == 0){
                grow();
            }
        }
    }

    /**
    * Dictates what the plant does when interacted with.
    * Iterates through the plant's mainActions, executing each one.
    * Params:
    *   player = the player who triggered the main action of the plant
    */
    override void doMainAction(Character player){
       if(this.isPlaced){
           foreach(action; this.mainActions){
               action(player);
           }
       }else{
           this.getPlaced(player, player.coords);
       }
    }

    /**
    * Dictates what the plant does when destroyed.
    * Iterates through the plant's destroyedActions, executing each one, and then removing the plant from the inventory
    * Params:
    *   destroyer = the player who destroyed the plant
    */
    override void getDestroyed(Character destroyer){
        if(this.isPlaced){
            foreach(action; this.destroyedActions){
                action(destroyer);
            }
            this.isPlaced = false;
        }
        this.die();
    }

    /**
     * Creates a clone of the plant
     * Is almost a deep copy where the clone is unaffected by the original
     * Only changes in player will be reflected in this clone
     */
    override Plant clone(){
        Plant copy = new Plant();
        copy.incrementalActions = this.incrementalActions;
        copy.steppedOnActions = this.steppedOnActions;
        copy.mainActions = this.mainActions;
        copy.destroyedActions = this.destroyedActions;
        copy.placedActions = this.placedActions;
        copy.attributes = this.attributes;
        copy.stats = this.stats;
        copy.survivableClimate = this.survivableClimate;
        copy.placer = this.placer;
        return copy;
    }

    /**
     * Creates a seedling
     */
    Seedling createSeedling(){
        Seedling child = new Seedling();
        child.incrementalActions = this.incrementalActions;
        child.steppedOnActions = this.steppedOnActions;
        child.mainActions = this.mainActions;
        child.destroyedActions = this.destroyedActions;
        child.placedActions = this.placedActions;
        child.attributes = this.attributes;
        child.stats = this.stats;
        child.survivableClimate = this.survivableClimate;
        child.placer = this.placer;
        child.parent = this;
        return child;
    }

    /**
     * Returns a double that represents the overall climate quality for the plant. This value is used in various functions by plant. The closer the result is to 0, the better the climate.
     */
    double getClimateFavorability(){
        //TODO remake this method so it works
        return 0;
    }

    /**
     * Increases the plant's growth based on climate favorability and other factors.
     */
    void grow(){
        int[] invasiveLevels = checkOtherPlants(Attribute.INVASIVE);
        int[] symbioticLevels = (Attribute.INVASIVE in this.attributes)? null : checkOtherPlants(Attribute.SYMBIOTIC);
        double growthModifier = 0;
        foreach(level; invasiveLevels){
            growthModifier -= cast(double)(level * 0.05 - this.stats[PlantReq.RESILIENCE] / 2);
        }
        foreach(level; symbioticLevels){
            growthModifier += cast(double)(level*0.05);
        }
        double growth = this.stats[PlantReq.GROWTH]*growthModifier/10;
        this.completion += growth;

    }

    /**
     * Checks all other plants in the tile for an attribute.
     * Params:
     *      attribute = the attribute to check the other plants for
     */
    int[] checkOtherPlants(Attribute attribute){
        int[] levels;
        Item[] sourceItems = this.source.items;
        foreach(item; sourceItems){
            if(cast(Plant) item){
                Plant plant = cast(Plant) item;
                if(attribute in plant.attributes){
                    levels ~= plant.attributes[attribute];
                }
            }
        }
        return levels;
    }

    /**
     * Makes sure that a given trait will be able to be added to the seedling without conflicting with another trait
     * Params:
     *      trait = the trait to check for whether the plant can receive it
     */
    bool canGetTrait(Attribute trait){
        foreach(exclusivity; mutuallyExclusiveAttributes){
            if(exclusivity.canFind(trait)){
                foreach(attribute; exclusivity){
                    if(attribute in this.attributes){
                        return false;
                    }
                }
            }
        }
        return true;
    }
}

unittest{
    import std.stdio;

    writeln("\nRunning unittest of Plant");

    //TODO make plant unittest
}
