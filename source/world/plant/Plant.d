module world.plant.Plant;

import world.improvement.Item;
import world.plant.PlantTraits;
import player.Player;
import std.random;
import world.HexTile;
import world.World;
import app;

/**
* A parent class for all plant objects.
* Contains basic (non-functional) traits and methods shared between all plants.
*/
class Plant : Item{

    public void delegate()[] incrementalActions;                 ///Actions taken every turn
    public void delegate(Player stepper)[] steppedOnActions;     ///Actions taken when stepped on
    public void delegate(Player player)[] mainActions;           ///Actions taken when interacted with
    public void delegate(Player destroyer)[] destroyedActions;   ///Actions taken when destroyed
    public void delegate(Player placer)[] placedActions;         ///Actions taken when placed
    public int[Attribute] attributes;                            ///Passive (constantly applied) attributes with levels from (usually) 1 to 5 in the form of ints.
    public double[][TileStat] survivableClimate;                 ///Bounds of survivable temperature, water, soil, elevation.
    private Player placer;                                       ///The person who planted the plant.
    public int[PlantReq] stats;                                  ///Contains base stats of plant.

    /**
    * The constructor for a plant.
    * Adds actions, attributes, and stats to object.
    */
    this(){
        this.stats[PlantReq.GROWTH] = 1;
        this.stats[PlantReq.RESILIENCE] = 1;
        this.stats[PlantReq.YIELD] = 1;
        this.stats[PlantReq.SEED_QUANTITY] = 1;
        this.stats[PlantReq.SEED_STRENGTH] = 1;
    }

    /**
    * Returns owner of HexTile if not patented. Returns placer of plant if patented.
    */
    override Player getOwner(){
        return (Attribute.PATENT in this.attributes)? this.placer : mainWorld.getTileAt(this.source.coords).owner;
    }

    /**
    * Checks whether the plant can be placed at a certain tile.
    * Params:
    *   placementCandidateCoords = the location of where to check if this plant can be placed
    */
    override bool canBePlaced(int[] placementCandidateCoords){
        HexTile tile = mainWorld.getTileAt(placementCandidateCoords);
        foreach(statType; tile.climate.byKey()){
            if(tile.climate[statType] < this.survivableClimate[statType][0] || tile.climate[statType] > this.survivableClimate[statType][1]){
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
     * Returns the movement cost of this plant based on whether the plant is made to slow down others
     */
    override double getMovementCost(){
        return (Attribute.SLOWING in this.attributes)? this.attributes[Attribute.SLOWING] : 0;
    }

    /**
    * Dictates what the plant does when placed.
    * Iterates through the plant's placedActions, executing each one.
    * Params:
    *   placer = the person who is attempting to place this plant
    *   newLocation = the location of where this plant should be placed
    */
    override bool getPlaced(Player placer, int[] newLocation){
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
    override void getSteppedOn(Player stepper){
        if(this.isPlaced){
            foreach(action; this.steppedOnActions){
                action(stepper);
            }
        }
    }

    /**
    * Dictates what the plant does each turn.
    * Iterates through the plant's incrementalActions, executing each one.
    */
    override void doIncrementalAction(){
        if(this.isPlaced){
            foreach(action; this.incrementalActions){
                action();
            }
        }
    }

    /**
    * Dictates what the plant does when interacted with.
    * Iterates through the plant's mainActions, executing each one.
    * Params:
    *   player = the player who triggered the main action of the plant
    */
    override void doMainAction(Player player){
       if(this.isPlaced){
           foreach(action; this.mainActions){
               action(player);
           }
       }
    }

    /**
    * Dictates what the plant does when destroyed.
    * Iterates through the plant's destroyedActions, executing each one, and then removing the plant from the inventory
    * Params:
    *   destroyer = the player who destroyed the plant
    */
    override void getDestroyed(Player destroyer){
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
}

unittest{
    //TODO
}
