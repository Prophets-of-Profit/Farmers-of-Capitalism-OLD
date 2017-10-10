module world.World;

import std.algorithm;
import std.array;
import std.conv;
import std.random;

import core.exception;

import app;
import character.Character;
import government.Government;
import item.settlement.Settlement;
import world.event.Event;
import world.HexTile;
import world.Range;

/**
 * A struct that stores coordinates
 * Coordinates are stored as ringNum and pos:
 *  ringNum is the ring number or the number of rings from the center if the center was ring 0
 *  pos is how far clockwise along the ring the coordinate is
 * Coordinates are immutable
 */
struct Coordinate {

    int ringNum;        ///The ring number of the coordinate or how many rings from the center this coordinate is if the center ring is ring 0
    int pos;            ///The position of the coordinate within the ring or how far clockwise along the ring the coordinate is
    alias coords this;  ///Sets the struct to also be an int[2] of [ringNum, pos]

    /**
     * Returns a int[2] of the coordinate in the form of [ringNum, pos]
     * Just so that the Coordinate can be accessed and used like an array if needed
     */
    @property int[2] coords(){
        return [ringNum, pos];
    }

}

immutable Coordinate nullCoord = Coordinate(-1, -1);  ///A coordinate that signifies a "null" coordinate or the absence of a coordinate

/**
 * A general class that should only ever be instantiated once
 * Contains an array of tiles sorted by their ringNum (distance from the center) and pos (how far clockwise along the ring the tile is)
 */
class World {

    Settlement[] allSettlements;            ///The list of all the settlements in the world
    Government[] allGovernments;            ///The list of all the governments in the worls
    HexTile[] tiles;                        ///The storage array of all tiles; stored in order of ringNum and then pos
    public immutable int numRings;          ///The number of rings the hexmap (World) has

    /**
     * The constructor for a world
     * Fills itself with a bunch of tiles given how many rings to make
     * Params:
     *      numRings = the amount of rings to construct the world with
     */
    this(int numRings){
        this.numRings = numRings;
        foreach(i; 0..numRings){
            foreach(j; 0..getSizeOfRing(i)){
                tiles ~= new HexTile(Coordinate(i, j));
            }
        }

        //Climate generation
        Coordinate[] prevChosen = [this.getRandomCoords];
        foreach(tileStat; __traits(allMembers, TileStat)){
            TileStat stat = tileStat.to!TileStat;
            this.getTileAt(prevChosen[0]).climate[stat] = Range!double(0, 1, uniform(0.0, 1.0));
        }
        while(this.tiles.filter!(a => a.climate.values.length != __traits(allMembers, TileStat).length).array.length > 0){
            //While the list of tiles that doesn't have a climate from this.tiles has at least 1 element
            Coordinate chosen;
            Coordinate prev;
            do{
                prev = prevChosen[uniform(0, $)];
                chosen = this.getTileAt(prev).getAdjacentCoords(false).filter!(a => this.getTileAt(a) !is null).array[uniform(0, $)];
            }while(prevChosen.canFind(chosen));
            prevChosen ~= chosen;
            foreach(tileStat; __traits(allMembers, TileStat)){
                TileStat stat = tileStat.to!TileStat;
                this.getTileAt(chosen).climate[stat] = Range!double(0, 1, this.getTileAt(prev).climate[stat] + uniform!("[]")(-0.1, 0.1));
            }
        }

        //River generation
        void generateRiver(Coordinate start, Direction primaryDirection){
            int chanceToChangeDirection = 15;
            int chanceToForkRiver = this.getNumTiles;
            //Ensures that the coordinate can be made into a river; if the river generation runs into an edge and tries generating off the map, the river generation will end
            HexTile tile = this.getTileAt(start);
            if(tile is null){
                return;
            }
            //Makes a function that returns a direction that is either the same or adjacent to a given primary direction
            Direction delegate(Direction primaryDirection) makeNewDirection = (Direction primaryDirection) => ((primaryDirection + uniform!("[]")(-1, 1) + Direction.max) % Direction.max).to!Direction;
            //Gets a direction which will usually be the same direction, but possibly an adjacent direction and then sets the tile's water flow to that direction and then calls this method to continue generating a river in the direction
            Direction newDirection = uniform(0, chanceToChangeDirection + 1) == 0? makeNewDirection(primaryDirection) : primaryDirection;
            tile.waterFlow ~= newDirection;
            generateRiver(tile.getAdjacentCoordInDirection(newDirection, false), newDirection);
            //Makes a possible direction this river will fork; if the rng allows and the fork direction is a different direction, this method will be called with the fork direction as well
            Direction forkDirection = makeNewDirection(newDirection);
            if(forkDirection != newDirection && uniform(0, chanceToForkRiver + 1) == 0){
                tile.waterFlow ~= forkDirection;
                generateRiver(tile.getAdjacentCoordInDirection(forkDirection, false), forkDirection);
            }
        }
        HexTile[] shuffledCoords = this.tiles.dup;
        shuffledCoords.randomShuffle();
        Coordinate edgeCoordinate = shuffledCoords.filter!(a => a.coords[0] == numRings - 1).array[0].coords;
        //Takes the corner number, adds 3 (half of six sides) to get the opposite direction, makes sure that the opposite direction's corner num is in the range of directions with modulus, and turns that to a direction
        Direction opposite = ((((edgeCoordinate.coords[0] == 0)? 0 : edgeCoordinate.coords[1] / edgeCoordinate.coords[0]) + 3) % Direction.max).to!Direction;
        generateRiver(edgeCoordinate, opposite);

        //TODO make lake generation
    }

    /**
     *  Gets the tile at given coordinates of [ringNum, pos]
     *  If the given coordinates don't exist, null will be returned
     *  If the pos is too large for the amount of tiles in the given ringNum, the pos will wrap around the ringNum
     *  Params:
     *      location = the coordinates of the tile to get as [ringNum, pos]
     */
    HexTile getTileAt(Coordinate location){
        try{
            location[1] = location[1] % getSizeOfRing(location[0]);
            int previousTiles;
            foreach(i; 0..location[0]){
                previousTiles += getSizeOfRing(i);
            }
            return this.tiles[previousTiles + location[1]];
        }catch(RangeError e){
            return null;
        }
    }

    /**
     * Returns the coordinates of a random tile
     */
	Coordinate getRandomCoords(){
        return this.tiles[uniform(0, $)].coords;
    }

    /**
     *  Returns the amount of tiles that exists within the world
     *  Isn't probably going to be used for much
     */
    int getNumTiles(){
        return this.tiles.length.to!int;
    }

    /**
     * Gives the distance between two coordinates given as [ringNum, pos]
     * Params:
     *      firstLocation = the coordinates of the first point
     *      secondLocation = the coordinates of the second point
     */
    int getDistanceBetween(Coordinate firstLocation, Coordinate secondLocation){
        assert(this.getTileAt(firstLocation) !is null && this.getTileAt(secondLocation) !is null);
        int distance = 0;
        Coordinate[] checked = [firstLocation];
        while(!checked.canFind(secondLocation)){
            Coordinate[] prevChecked = checked.dup;
            checked = null;
            distance++;
            foreach(coord; prevChecked){
                if(coord != nullCoord){
                    checked ~= this.getTileAt(coord).getAdjacentCoords();
                }
            }
        }
        return distance;
    }

    /**
     * Gets a list of coordinates that will take any player from firstLocation to secondLocation with the smallest
     * movement cost: the returned coordinates will contain the second given location as the last element, but will not
     * contain the first given location
     * Params:
     *      firstLocation = the initial starting location of where to get the cheapest path
     *      secondLocation = where the cheapest path should end
     *      cheapestFor = the character for whom the path shall be cheapest for
     */
    Coordinate[] getCheapestPathBetween(Coordinate firstLocation, Coordinate secondLocation, Character cheapestFor){
        Coordinate[] recursiveCheapest(Coordinate firstLocation, Coordinate secondLocation, Character cheapestFor, double maxAllowablePathCost){
            if(maxAllowablePathCost < 0){
                return null;
            }
            if(firstLocation == secondLocation){
                return [secondLocation];
            }
            Coordinate[][] candidates = null;
            foreach(coord ; this.getTileAt(firstLocation).getAdjacentCoords()){
                Coordinate[] pathCandidate = recursiveCheapest(coord, secondLocation, cheapestFor, maxAllowablePathCost = cheapestFor.getMovementCostAt(coord));
                if(pathCandidate !is null){
                    candidates ~= [coord] ~ pathCandidate;
                }
            }
            double smallestCost = double.max;
            Coordinate[] path = null;
            foreach(Coordinate[] pathCandidate ; candidates){
                double currentPathCost = 0;
                foreach(Coordinate coord ; pathCandidate){
                    currentPathCost += cheapestFor.getMovementCostAt(coord);
                }
                if(currentPathCost < smallestCost){
                    path = pathCandidate;
                }
            }
            if(path !is null && path.length >= 2){
                assert(this.isContiguous(path));
            }
            return path;
        }
        return recursiveCheapest(firstLocation, secondLocation, cheapestFor, cheapestFor.maxTravellableDistance);
    }

    /**
     * Returns whether the given path is contiguous
     * Params:
     *      path = the list of coordinates to check for contiguity
     */
    bool isContiguous(Coordinate[] path){
        assert(path.length >= 2);
        foreach(i; 0..path.length - 1){
            if(!this.getTileAt(path[i]).getAdjacentCoords().canFind(path[i + 1])){
                return false;
            }
        }
        return true;
    }

    /**
     * Returns a copy of the world
     * The returned copy is a mostly-deep copy, meaning that all of its contained tiles are separate from this's contained tiles
     * If a change were to happen to one of this world's tiles, it wouldn't be reflected in the copy's tiles
     * This does not hold for the owner for each tile, as the stored owner of a tile would reflect changes in that player
     */
    World clone(){
        World copy = new World(this.numRings);
        foreach(i; 0..this.getNumTiles){
            copy.tiles[i] = this.tiles[i].clone();
        }
        return copy;
    }

    /**
     * Updates all aspects of the world including tiles and contained items
     */
    void update(){
        foreach(tile; this.tiles){
            foreach(item; tile.contained){
                item.doIncrementalAction();
            }
        }
        foreach(event; allEvents){
            if(event.isInProgress){
                event.turnAction();
            }else if(uniform(0, event.getInverseChanceToHappen()) == 0){
                event.startAction();
            }
        }
    }

}

unittest{
    import std.stdio;

    writeln("\nRunning unittest of World");

    int maxWorldRingsToCheck = 5;
    foreach(i; 1..maxWorldRingsToCheck + 1){
        game = new Main(0, i);
        writeln("A world with ", i, " rings has ", game.mainWorld.getNumTiles(), " tiles with an outer ring of ", getSizeOfRing(i-1), " tiles");
    }
    int runNumForGettingLocations = 3;
    foreach(i; 0..runNumForGettingLocations){
        Coordinate coords = game.mainWorld.getRandomCoords();
        writeln("The position of a tile at ", coords, " is ", game.mainWorld.getTileAt(coords).coords);
        assert(coords == game.mainWorld.getTileAt(coords).coords);
    }
    assert(game.mainWorld.getDistanceBetween(Coordinate(0, 0), Coordinate(1, 1)) == 1);
    int runNumForGettingDistances = 5;
    foreach(i; 0..runNumForGettingDistances){
        Coordinate[] coords = [game.mainWorld.getRandomCoords(), game.mainWorld.getRandomCoords()];
        writeln("The distance between ", coords[0], " and ", coords[1], " is ", game.mainWorld.getDistanceBetween(coords[0], coords[1]));
    }
}

/**
 * Gives how many tiles can exist within a given ring
 * Params:
 *      ringNum = the ring for which the number of tiles will be ascertained
 */
int getSizeOfRing(int ringNum){
    return (ringNum == 0)? 1 : 6 * ringNum;
}
