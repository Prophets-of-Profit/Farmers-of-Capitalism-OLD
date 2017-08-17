module item.plant.Seedling;

import std.algorithm.comparison;
import std.conv;
import std.random;

import app;
import character.Character;
import item.Item;
import item.plant.Plant;
import item.plant.PlantTraits;
import world.HexTile;
import world.World;

/**
 * A class that holds information about its parents and is a result of plant breeding.
 */
class Seedling : Plant{

    public Plant parent;    ///The parent plant from which the seedling was created.

    /**
     * Constructor for Seedling moves the seedling and deposits it on a random tile.
     */
    this(Plant parent){
        super(parent.source.coords);
        this.parent = parent;
        this.source.remove(this);
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

    /**
     * Dictates what the seedling does each turn.
     * Checks for other seedlings in the tile and attempts to crossbreed.
     * If alone, grow into a clone of the parent.
     */
    override void doIncrementalAction(){
        Seedling[] otherSeedlings;
        foreach(item; this.source){
            if(cast(Seedling) item){
                otherSeedlings ~= item.to!Seedling;
            }
        }
        Plant child;
        if(otherSeedlings !is null){
            Seedling mate = otherSeedlings[uniform(0, otherSeedlings.length)];
            this.source.remove(mate);
            child = this.crossBreed(mate);

        }else{
            child = this.clone();
        }
        this.source.remove(this);
        this.source.add(child);
    }

    /**
     * Generates a child plant based on traits from this and mate.
     */
    Plant crossBreed(Seedling mate){
        Plant child = new Plant(this.source.coords);
        //The base stats are the average of the parents' stats plus some variance. TODO: add MUTABILE trait to calculation.
        foreach(req; __traits(allMembers, PlantReq)){
            child.stats[req.to!PlantReq] = max(min((this.stats[req.to!PlantReq] + mate.stats[req.to!PlantReq] + uniform(-1, 2))/2, 5), 1);
        }
        //The attributes are randomly chosen, with a 50% chance to be taken for each attribute for each parent. TODO: Add MUTABLE trait into calculation.
        foreach(attribute; this.plantAttributes.keys ~ mate.plantAttributes.keys){
            if(uniform(0, 1) == 0){
                child.plantAttributes[attribute] += (this.plantAttributes.keys ~ mate.plantAttributes.keys)[attribute];
            }
        }
        //TODO: get inheritance for actions.
        return child;
    }
}
