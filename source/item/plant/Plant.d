module item.plant.Plant;

import std.algorithm;
import std.conv;
import std.math;
import std.random;

import app;
import character.Character;
import item.Inventory;
import item.Item;
import item.plant.PlantTraits;
import item.plant.Seedling;
import world.HexTile;
import world.Range;
import world.World;

enum ActionType{
    STEPPED, MAIN, DESTROYED, PLACED, INCREMENTAL
}

/**
 * A parent class for all plant objects.
 * Contains basic (non-functional) traits and methods shared between all plants.
 */
class Plant : Item{

    public void delegate(Character actor)[][ActionType] actions;    ///All the actions the plant does
    public int[PlantAttribute] plantAttributes;                     ///Passive (constantly applied) plantAttributes with levels from (usually) 1 to 5 in the form of ints.
    public Range!double[TileStat] survivableClimate;                ///Bounds of survivable temperature, water, soil, elevation.
    protected Character placer;                                     ///The person who planted the plant.
    public Range!int[PlantReq] stats;                               ///Contains base stats of plant.

    /**
     * The constructor for a plant.
     * Adds actions, plantAttributes, and stats to object.
     */
    this(Inventory source){
        this.getMovedTo(source);
        foreach(req; __traits(allMembers, PlantReq)){
            this.stats[req.to!PlantReq] = Range!int(0, 5, 1);
        }
        HexTile tile = game.mainWorld.getTileAt(this.source.coords);
        foreach(statType; __traits(allMembers, TileStat)){
            TileStat stat = statType.to!TileStat;
            this.survivableClimate[stat] = Range!(double)(tile.climate[stat] - uniform(0.0, 0.1), tile.climate[stat] + uniform(0.0, 0.1));
        }
        if(tile.isWater){
            this.plantAttributes[PlantAttribute.AQUATIC] = 1;
        }
        double chanceBound = 1.0;
        void possiblyDoActionBasedOnChanceBound(void delegate() action){
            if(uniform(0.0, chanceBound) > 0.8){
                action();
                chanceBound -= 0.4;
            }
        }
        foreach(possibleAttribute; naturalAttributes){
            possiblyDoActionBasedOnChanceBound({
                if(this.canGetTrait(possibleAttribute)){
                    this.plantAttributes[possibleAttribute] = uniform(1,3);
                }
            });
        }
        foreach(actionType; __traits(allMembers, ActionType)){
            ActionType type = actionType.to!ActionType;
            foreach(possibleAttribute; naturalActions[type]){
                possiblyDoActionBasedOnChanceBound({this.actions[type] ~= possibleAttribute;});
            }
        }
        int statsToGive = 5;
        foreach(i; 0..statsToGive){
            this.stats[uniform(0, PlantReq.max).to!PlantReq] += 1;
        }
    }

    /**
    * Returns owner of HexTile if not patented. Returns placer of plant if patented.
    */
    override Character getOwner(){
        return (PlantAttribute.PATENT in this.plantAttributes)? this.placer : game.mainWorld.getTileAt(this.source.coords).owner;
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
        if(tile.isWater != ((PlantAttribute.AQUATIC in this.plantAttributes) !is null)){
            return false;
        }else if(PlantAttribute.MOVABLE in this.plantAttributes){
            return this.completion <= this.plantAttributes[PlantAttribute.MOVABLE]/5.0;
        }
        return this.completion == 0;
    }

    /**
    * Returns the influence the plant has on the tile's movement cost; inherited from Item.
    */
    override double getMovementCost(){
        if(PlantAttribute.SLOWING in this.plantAttributes){
            return this.plantAttributes[PlantAttribute.SLOWING];
        }else if(PlantAttribute.SPEEDING in this.plantAttributes){
            return this.plantAttributes[PlantAttribute.SPEEDING];
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
            foreach(action; this.actions[ActionType.PLACED]){
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
            foreach(action; this.actions[ActionType.STEPPED]){
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
            foreach(action; this.actions[ActionType.INCREMENTAL]){
                action(null);
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
           foreach(action; this.actions[ActionType.MAIN]){
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
            foreach(action; this.actions[ActionType.DESTROYED]){
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
        Plant copy = new Plant(this.source.clone());
        copy.actions = this.actions;
        copy.stats = this.stats;
        copy.survivableClimate = this.survivableClimate;
        copy.placer = this.placer;
        return copy;
    }

    /**
     * Creates a seedling
     */
    Seedling createSeedling(){
        Seedling child = new Seedling(this);
        child.actions = this.actions;
        child.plantAttributes = this.plantAttributes;
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
        int[] invasiveLevels = checkOtherPlants(PlantAttribute.INVASIVE);
        int[] symbioticLevels = (PlantAttribute.INVASIVE in this.plantAttributes)? null : checkOtherPlants(PlantAttribute.SYMBIOTIC);
        double growthModifier = 0;
        foreach(level; invasiveLevels){
            growthModifier -= level * 0.05 - this.stats[PlantReq.RESILIENCE] / 2;
        }
        foreach(level; symbioticLevels){
            growthModifier += level * 0.05;
        }
        double growth = this.stats[PlantReq.GROWTH] * growthModifier / 10;
        this.completion += growth;

    }

    /**
     * Checks all other plants in the tile for an PlantAttribute.
     * Params:
     *      PlantAttribute = the PlantAttribute to check the other plants for
     */
    int[] checkOtherPlants(PlantAttribute PlantAttribute){
        int[] levels;
        Item[] sourceItems = this.source.items;
        foreach(item; sourceItems){
            if(cast(Plant) item){
                Plant plant = cast(Plant) item;
                if(PlantAttribute in plant.plantAttributes){
                    levels ~= plant.plantAttributes[PlantAttribute];
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
    bool canGetTrait(PlantAttribute trait){
        foreach(exclusivity; mutuallyExclusiveAttributes){
            if(exclusivity.canFind(trait)){
                foreach(PlantAttribute; exclusivity){
                    if(PlantAttribute in this.plantAttributes){
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
    
    int worldSize = 5;
    game.mainWorld = new World(worldSize);
    int numRuns = 10;
    foreach(i; 0..numRuns){
        Coordinate coords = game.mainWorld.getRandomCoords();
        int statsToGive = uniform(6, 15);
        Plant seedling = new Plant(game.mainWorld.getTileAt(coords).contained);
        writeln("Conditions at ", coords, " are");
        foreach(tileStat; __traits(allMembers, TileStat)){
            writeln(tileStat, ": ", game.mainWorld.getTileAt(coords).climate[tileStat.to!TileStat]);
        }
        writeln("Seedling strength (statsToGive):", statsToGive);
        writeln("Seedling stats:", seedling.stats);
        writeln("Seedling Survivable Climate:", seedling.survivableClimate);
    }
}
