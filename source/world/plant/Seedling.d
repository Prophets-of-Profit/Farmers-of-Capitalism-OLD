/**
* Contains Seedling class.
*/
module Seedling;

import Player;
import Plant;
import app;
import World;
import HexTile;
import std.random;

/**
* A class that holds information about its parents and is a result of plant breeding.
*/
class Seedling : Item{      //Seedling is an Item so that it can be contained in a HexTile inventory.

    public void delegate()[] incrementalActions;                 ///Stores actions taken every turn in the form of string method names.
    public void delegate(Player stepper)[] steppedOnActions;     ///Stores actions taken when stepped on in the form of string method names.
    public void delegate(Player player)[] mainActions;           ///Stores actions taken when interacted with in the form of string method names.
    public void delegate(Player destroyer)[] destroyedActions;   ///Stores actions taken when destroyed in the form of string method names.
    public void delegate(Player placer)[] placedActions;         ///Stores actions taken when placed in the form of string method names.
    public int[string] attributes;                               ///Stores passive (constantly applied) attributes in the form of strings, with levels from 1 to 5 in the form of ints.
    public double[][string] survivableClimate;                   ///Stores bounds of survivable temperature, water, soil, elevation.
    public Player placer;                                        ///The person who planted the plant.
    public Plant parent;                                         ///The parent plant from which the seedling was created.
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
    * Constructor for Seedling actually moves the seedling and deposits it on a random tile.
    */
    this( ){
        int[] coords = parent.source.coords;
        double depositChance = 0;
        bool deposited = false;
        while(!deposited){
            Direction direction = mainWorld.getTileAt(coords).direction;
            Direction oppositeDirection = (direction + 3)%6;
            int directionSelection = uniform(0, 41);
            Direction chosenDirection;

            if(directionSelection < 2){
                chosenDirection = oppositeDirection;
            }else if(directionSelection < 8){
                chosenDirection = (oppositeDirection + 2*(uniform(0, 2) - 0.5))%6;
            }else if(directionSelection < 20){
                chosenDirection = (direction + 2*(uniform(0, 2) - 0.5))%6;
            }else{
                chosenDirection = direction;
            }
            coords = mainWorld.getTileAt(coords).getAdjacentCoordInDirection(chosenDirection);
            if(uniform(0, 11 - depositChance) == 0){
                deposited = true;
            }else{
                depositChance++;
            }
        }
        if(!mainWorld.getTileAt(coords).contained.add(this)){ delete this; }
    }
}