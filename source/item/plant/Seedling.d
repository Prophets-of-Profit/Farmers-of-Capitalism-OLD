module item.plant.Seedling;

import character.Character;
import item.plant.Plant;
import app;
import world.World;
import world.HexTile;
import std.random;
import item.Item;
import std.conv;

/**
 * A class that holds information about its parents and is a result of plant breeding.
 */
class Seedling : Plant{

    public Plant parent;    ///The parent plant from which the seedling was created.

    /**
     * Constructor for Seedling actually moves the seedling and deposits it on a random tile.
     */
    this(){
        Coordinate coords = parent.source.coords;
        double depositChance = 0;
        while(true){
            Direction direction = game.mainWorld.getTileAt(coords).direction;
            Direction oppositeDirection = to!Direction((direction + 3) % 6);
            int directionSelection = uniform(0, 41);
            Direction chosenDirection;
            if(directionSelection < 2){
                chosenDirection = oppositeDirection;
            }else if(directionSelection < 8){
                chosenDirection = to!Direction((oppositeDirection + 2 * (uniform(0, 2) - 0.5)) % 6);
            }else if(directionSelection < 20){
                chosenDirection = to!Direction((direction + 2 * (uniform(0, 2) - 0.5)) % 6);
            }else{
                chosenDirection = direction;
            }
            coords = game.mainWorld.getTileAt(coords).getAdjacentCoordInDirection(chosenDirection);
            if(uniform(0, 11 - depositChance) == 0){
                break;
            }else{
                depositChance++;
            }
        }
        if(!this.getMovedTo(game.mainWorld.getTileAt(coords).contained)){
            this.die();
        }
    }
}
