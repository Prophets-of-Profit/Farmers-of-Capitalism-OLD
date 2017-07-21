/**
* Contains the class for plant objects.
*/
module Plant;

import Item;
import Player;
import std.random;
import HexTile;
import World;
import app;

/**
* A parent class for all plant objects.
* Contains basic (non-functional) traits and methods shared between all plants.
*/
class Plant : Item{

    public void delegate()[] incrementalActions;                 ///Stores actions taken every turn in the form of string method names.
    public void delegate(Player stepper)[] steppedOnActions;     ///Stores actions taken when stepped on in the form of string method names.
    public void delegate(Player player)[] mainActions;           ///Stores actions taken when interacted with in the form of string method names.
    public void delegate(Player destroyer)[] destroyedActions;   ///Stores actions taken when destroyed in the form of string method names.
    public void delegate(Player placer)[] placedActions;         ///Stores actions taken when placed in the form of string method names.
    public int[string] attributes;                               ///Stores passive (constantly applied) attributes in the form of strings, with levels from 1 to 5 in the form of ints.
    public double[][string] survivableClimate;                      ///Stores bounds of survivable templerature, water, soil, elevation.
    private Player placer;                                        ///The person who planted the plant.

    /**
    * Contains base stats of plant.
    * Stats:
    *     *Growth: Rate of growth.
    *     *Resilience: Resistance to invasive species and being stepped on.
    *     *Yield: Amount of products produced when destroyed.
    *     *Seed Quantity: Amount of seeds produced when naturally reproducing.
    *     *Seed Strength: Distance seeds can go before settling.
    */
    public int[string] stats;


    /**
    * The constructor for a plant.
    *
    */

    this( ){
        //Add actions, attributes, and stats to object.
        this.stats["Growth"] = 1;
        this.stats["Resilience"] = 1;
        this.stats["Yield"] = 1;
        this.stats["Seed Strength"] = 1;
        this.stats["Seed Quantity"] = 1;
    }

    /**
    * Returns owner of HexTile if not patented. Returns placer of plant if patented.
    */
    override Player getOwner(){
        if(("Patent" in this.attributes) !is null){
            return this.placer;
        }else{
            return mainWorld.getTileAt(this.source.coords).owner;
        }
    }

    /**
    * Checks whether the plant can be placed at a certain tile.
    */
    override bool canBePlaced(int[] placementCandidateCoords){
        HexTile tile = mainWorld.getTileAt(placementCandidateCoords);
        //Check if tile conditions are appropriate.
        if((tile.isWater && (("Aquatic" in this.attributes) is null)) || (!tile.isWater && (("Aquatic" in this.attributes) !is null)) || !(this.survivableClimate["Temperature"][0] <= tile.temperature  && tile.temperature <= this.survivableClimate["Temperature"][1]) || !(this.survivableClimate["Water"][0] <= tile.water && tile.water <= this.survivableClimate["Water"][1]) || !(this.survivableClimate["Soil"][0] <= tile.soil && tile.soil <= this.survivableClimate["Soil"][1]) || !(this.survivableClimate["Elevation"][0] <= tile.elevation && tile.elevation <= this.survivableClimate["Elevation"][1])){
            return false;
        //Check if plant can be moved.
        }else if(("Moveable" in this.attributes) !is null){
            return this.completion <= this.attributes["Moveable"]/5;
        //Check if plant is a seed.
        }else if(this.completion == 0){
            return true;
        }else{
            return false;
        }

    }

    override double getMovementCost(){
        if(("Slowing" in this.attributes) !is null){
            return this.attributes["Slowing"];
        }
        return 0;
    }

    /**
    * Dictates what the plant does when placed.
    * Iterates through the plant's placedActions, executing each one.
    */
    override void getPlaced(Player placer, int[] newLocation){
        if(!this.isPlaced && this.canBePlaced(newLocation)){
            for(int i = 0; i < this.placedActions.length; i++){
                this.placedActions[i](placer);
            }
            this.isPlaced = true;
        }
        this.placer = placer;
    }

    /**
    * Dictates what the plant does when stepped on.
    * Iterates through the plant's steppedOnActions, executing each one.
    */
    override void getSteppedOn(Player stepper){
        if(this.isPlaced){
            for(int i = 0; i < this.steppedOnActions.length; i++){
                this.steppedOnActions[i](stepper);
            }
        }
    }

    /**
    * Dictates what the plant does each turn.
    * Iterates through the plant's incrementalActions, executing each one.
    */
    override void doIncrementalAction(){
        if(this.isPlaced){
            for(int i = 0; i < this.incrementalActions.length; i++){
                this.incrementalActions[i]();
            }
        }
    }

    /**
    * Dictates what the plant does when interacted with.
    * Iterates through the plant's mainActions, executing each one.
    */
    override void doMainAction(Player player){
       if(this.isPlaced){
           for(int i = 0; i < this.mainActions.length; i++){
               this.mainActions[i](player);
           }
       }
    }

    /**
    * Dictates what the plant does when destroyed.
    * Iterates through the plant's destroyedActions, executing each one.
    */
    override void getDestroyed(Player destroyer){
        if(this.isPlaced){
            for(int i = 0; i < this.destroyedActions.length; i++){
                this.destroyedActions[i](destroyer);
            }
            this.isPlaced = false;
        }
    }


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


